"""Corrige o peso impresso na foto da ração quando não bate com o SKU."""
from __future__ import annotations

import json
import re
from collections import defaultdict
from pathlib import Path

import cv2
import numpy as np
from PIL import Image, ImageDraw, ImageFont
from rapidocr_onnxruntime import RapidOCR

ROOT = Path(__file__).parent.parent
PRODUCTS_PATH = ROOT / "src" / "data" / "products.json"
SEED_PATH = (
    ROOT.parent / "petsite-api" / "src" / "main" / "resources" / "seed" / "products.json"
)
SQL_PATH = Path(__file__).parent / "update_image_weights.sql"
CACHE_PATH = Path(__file__).parent / "_pdf_tmp" / "weight_ocr_cache.json"
TENANT_ID = "a0000000-0000-4000-8000-000000000001"

STEM_W = re.compile(r"-w\d+p?\d*(?:kg|g)$", re.I)
WEIGHT_RE = re.compile(
    r"(?P<num>\d{1,2}(?:[.,]\d{1,2})?)\s*(?P<unit>kg)\b|(?P<gnum>\d{2,4})\s*(?P<gunit>g)\b",
    re.IGNORECASE,
)


def original_filename(name: str) -> str:
    path = Path(name)
    return STEM_W.sub("", path.stem) + path.suffix


def original_rel(rel: str) -> str:
    path = Path(rel.replace("\\", "/"))
    return str(path.with_name(original_filename(path.name))).replace("\\", "/")


def parse_weight(text: str) -> str | None:
    compact = re.sub(r"(\d+)\s+(\d)\s*kg", r"\1.\2kg", text.replace(" ", ""), flags=re.I)
    compact = compact.replace(" ", "")
    match = WEIGHT_RE.search(compact) or WEIGHT_RE.search(text)
    if not match:
        return None
    if match.group("unit"):
        raw = match.group("num").replace(",", ".")
        unit = "kg"
    else:
        raw = match.group("gnum")
        unit = "g"
    try:
        value = float(raw)
    except ValueError:
        return None
    if unit == "kg":
        if value < 0.2 or value > 25:
            return None
        if abs(value - round(value)) < 1e-6:
            return f"{int(round(value))}kg"
        return f"{value:.1f}kg".replace(".0kg", "kg")
    if value < 20 or value > 2000:
        return None
    return f"{int(round(value))}g"


def to_grams(weight: str) -> float | None:
    parsed = parse_weight(weight)
    if not parsed:
        return None
    match = WEIGHT_RE.search(parsed)
    if not match:
        return None
    if match.group("unit"):
        return float(match.group("num").replace(",", ".")) * 1000
    return float(match.group("gnum"))


def format_label(target: str, ocr_text: str) -> str:
    grams = to_grams(target)
    if grams is None:
        return target
    original_decimal = bool(re.search(r"\d+[.,]\d", ocr_text or ""))
    if grams >= 1000:
        kg = grams / 1000
        if abs(kg - round(kg)) < 1e-6:
            whole = int(round(kg))
            return f"{whole},0kg" if original_decimal or whole >= 10 else f"{whole}kg"
        return f"{kg:.1f}".replace(".", ",") + "kg"
    return f"{int(round(grams))}g"


def box_xyxy(box) -> tuple[int, int, int, int]:
    xs = [p[0] for p in box]
    ys = [p[1] for p in box]
    return int(min(xs)), int(min(ys)), int(max(xs)), int(max(ys))


def shift_box(box, dx: float, dy: float, scale: float = 1.0) -> list[list[float]]:
    return [[p[0] * scale + dx, p[1] * scale + dy] for p in box]


def load_font(size: int) -> ImageFont.FreeTypeFont | ImageFont.ImageFont:
    for name in ("arialbd.ttf", "segoeuib.ttf", "calibrib.ttf"):
        try:
            return ImageFont.truetype(name, size)
        except OSError:
            continue
    return ImageFont.load_default()


def sample_colors(arr: np.ndarray, box) -> tuple[tuple[int, int, int], tuple[int, int, int]]:
    x0, y0, x1, y1 = box_xyxy(box)
    h, w = arr.shape[:2]
    x0, y0 = max(0, x0), max(0, y0)
    x1, y1 = min(w, x1 + 1), min(h, y1 + 1)
    roi = arr[y0:y1, x0:x1]
    if roi.size == 0:
        return (255, 255, 255), (40, 40, 40)
    pixels = roi.reshape(-1, 3).astype(np.float32)
    if len(pixels) < 8:
        mean = pixels.mean(axis=0)
        lum = 0.299 * mean[0] + 0.587 * mean[1] + 0.114 * mean[2]
        fg = (255, 255, 255) if lum < 140 else (28, 28, 26)
        bg = tuple(int(v) for v in mean)
        return fg, bg
    criteria = (cv2.TERM_CRITERIA_EPS + cv2.TERM_CRITERIA_MAX_ITER, 12, 1.0)
    _, labels, centers = cv2.kmeans(pixels, 2, None, criteria, 3, cv2.KMEANS_PP_CENTERS)
    counts = np.bincount(labels.flatten(), minlength=2)
    bg_idx = int(np.argmax(counts))
    fg_idx = 1 - bg_idx
    bg = tuple(int(v) for v in centers[bg_idx])
    fg = tuple(int(v) for v in centers[fg_idx])
    return fg, bg


def patch_weight(src: Path, dest: Path, box, new_label: str) -> None:
    img = Image.open(src).convert("RGB")
    arr = np.array(img)
    fg, bg = sample_colors(arr, box)
    poly = np.array(box, dtype=np.int32)
    mask = np.zeros(arr.shape[:2], np.uint8)
    cv2.fillConvexPoly(mask, poly, 255)
    mask = cv2.dilate(mask, np.ones((7, 7), np.uint8), iterations=1)
    fill = arr.copy()
    fill[mask > 0] = bg
    out = Image.fromarray(fill)
    draw = ImageDraw.Draw(out)

    x0, y0, x1, y1 = box_xyxy(box)
    width, height = max(8, x1 - x0), max(8, y1 - y0)
    font = load_font(max(10, int(height * 0.95)))
    tb = draw.textbbox((0, 0), new_label, font=font)
    tw, th = tb[2] - tb[0], tb[3] - tb[1]
    while tw > width * 1.15 and getattr(font, "size", 12) > 8:
        font = load_font(font.size - 1)
        tb = draw.textbbox((0, 0), new_label, font=font)
        tw, th = tb[2] - tb[0], tb[3] - tb[1]
    tx = x0 + (width - tw) // 2 - tb[0]
    ty = y0 + (height - th) // 2 - tb[1]
    shadow = (20, 20, 18) if sum(fg) > 400 else (255, 255, 255)
    draw.text((tx + 1, ty + 1), new_label, font=font, fill=shadow)
    draw.text((tx, ty), new_label, font=font, fill=fg)
    dest.parent.mkdir(parents=True, exist_ok=True)
    out.save(dest, "WEBP", quality=90, method=6)


def parse_ocr_result(result, dx: float = 0, dy: float = 0, scale: float = 1.0) -> list[dict]:
    found: list[dict] = []
    if not result:
        return found
    for box, text, conf in result:
        parsed = parse_weight(text)
        if not parsed:
            continue
        found.append(
            {
                "weight": parsed,
                "raw": text,
                "box": shift_box(box, dx, dy, scale),
                "conf": float(conf),
            }
        )
    return found


def ocr_image(ocr: RapidOCR, image) -> list:
    result, _ = ocr(image)
    return result or []


def ocr_weights(ocr: RapidOCR, image_path: Path) -> list[dict]:
    bgr = cv2.imread(str(image_path))
    if bgr is None:
        return []
    h, w = bgr.shape[:2]
    found = parse_ocr_result(ocr_image(ocr, str(image_path)))

    crops = [
        (0, int(h * 0.68), int(w * 0.48), h, 2.8),
        (int(w * 0.52), int(h * 0.68), w, h, 2.8),
        (0, int(h * 0.78), int(w * 0.42), int(h * 0.98), 3.2),
        (int(w * 0.58), int(h * 0.78), w, int(h * 0.98), 3.2),
    ]
    for x0, y0, x1, y1, scale in crops:
        crop = bgr[y0:y1, x0:x1]
        if crop.size == 0 or crop.shape[0] < 20 or crop.shape[1] < 20:
            continue
        up = cv2.resize(crop, None, fx=scale, fy=scale, interpolation=cv2.INTER_CUBIC)
        hits = parse_ocr_result(ocr_image(ocr, up), dx=x0, dy=y0, scale=1 / scale)
        found.extend(hits)

    best: dict[str, dict] = {}
    for hit in found:
        key = hit["weight"]
        if key not in best or hit["conf"] > best[key]["conf"]:
            best[key] = hit
    return list(best.values())


def choose_printed(hits: list[dict], sku_weights: set[str]) -> dict | None:
    if not hits:
        return None
    unique = {hit["weight"] for hit in hits}
    if len(unique) > 1:
        matching = [hit for hit in hits if hit["weight"] in sku_weights]
        if matching and len({hit["weight"] for hit in matching}) == 1:
            return max(matching, key=lambda hit: hit["conf"])
        return None

    printed = max(hits, key=lambda hit: hit["conf"])
    parsed = printed["weight"]
    raw = printed.get("raw") or ""
    if parsed not in sku_weights:
        if parsed == "15kg" and "1.5kg" in sku_weights:
            printed = {**printed, "weight": "1.5kg"}
        elif parsed == "25kg" and "2.5kg" in sku_weights:
            printed = {**printed, "weight": "2.5kg"}
        elif parsed == "1kg" and "10.1kg" in sku_weights and re.search(r"10\s*[,.]?\s*1", raw):
            printed = {**printed, "weight": "10.1kg"}
    return printed


def is_composite(image_path: Path) -> bool:
    img = Image.open(image_path)
    w, h = img.size
    return w > h * 1.12


def main() -> None:
    products = json.loads(PRODUCTS_PATH.read_text(encoding="utf-8"))
    feed = [
        p
        for p in products
        if p.get("category") in {"caes", "gatos"}
        and p.get("image")
        and p.get("weight")
        and p["weight"] != "Sob consulta"
        and "/catalog/" in p["image"]
        and "kg" in p["weight"].lower()
        and "Cookie" not in (p.get("line") or "")
    ]

    for product in products:
        image = product.get("image") or ""
        if "/catalog/" in image and STEM_W.search(Path(image).stem):
            product["image"] = original_rel(image)
    for product in feed:
        product["image"] = original_rel(product["image"])

    CACHE_PATH.parent.mkdir(parents=True, exist_ok=True)
    cache: dict = {}

    ocr = RapidOCR()
    by_image: dict[str, list] = defaultdict(list)
    for product in feed:
        by_image[product["image"]].append(product)

    changed: list[dict] = []
    skipped_multi = 0
    skipped_none = 0
    kept = 0

    for rel, group in sorted(by_image.items()):
        filename = Path(rel).name
        src = ROOT / "public" / rel.lstrip("/")
        if not src.exists():
            skipped_none += 1
            continue
        if (
            is_composite(src)
            or filename.startswith("page-56-")
            or filename.startswith("page-57-")
            or filename.startswith("page-58-")
            or filename.startswith("page-59-")
        ):
            skipped_multi += 1
            print(f"SKIP composite {filename}")
            continue

        sku_weights = {p["weight"] for p in group}
        if filename not in cache:
            hits = ocr_weights(ocr, src)
            cache[filename] = [
                {
                    "weight": hit["weight"],
                    "raw": hit["raw"],
                    "box": hit["box"],
                    "conf": hit["conf"],
                }
                for hit in hits
            ]
            CACHE_PATH.write_text(json.dumps(cache, ensure_ascii=False, indent=2), encoding="utf-8")
            print(f"OCR {filename}: {[h['weight'] for h in cache[filename]]}")

        printed = choose_printed(cache[filename], sku_weights)
        if not printed:
            if len({h["weight"] for h in cache[filename]}) > 1:
                skipped_multi += 1
            else:
                skipped_none += 1
            continue

        printed_weight = printed["weight"]
        printed_grams = to_grams(printed_weight)
        for product in group:
            sku_grams = to_grams(product["weight"])
            if sku_grams is None or printed_grams is None:
                continue
            if abs(sku_grams - printed_grams) < 1:
                kept += 1
                continue

            label = format_label(product["weight"], printed["raw"])
            slug = product["weight"].replace(".", "p")
            new_name = f"{src.stem}-w{slug}{src.suffix}"
            dest = src.with_name(new_name)
            if not dest.exists():
                patch_weight(src, dest, printed["box"], label)
            new_rel = f"/assets/products/catalog/{new_name}"
            if product["image"] != new_rel:
                product["image"] = new_rel
                changed.append(product)
                print(f"  id={product['id']} {printed_weight} -> {product['weight']} ({label})")

    by_id = {p["id"]: p for p in products}
    for product in feed:
        by_id[product["id"]]["image"] = product["image"]

    payload = json.dumps(products, ensure_ascii=False, indent=2) + "\n"
    PRODUCTS_PATH.write_text(payload, encoding="utf-8")
    if SEED_PATH.parent.exists():
        SEED_PATH.write_text(payload, encoding="utf-8")

    if changed:
        sql = [
            "-- Atualiza o caminho da imagem só nos SKUs cujo peso da foto foi corrigido.",
            "UPDATE products SET",
            "  image = CASE external_id",
        ]
        for product in changed:
            sql.append(f"    WHEN {product['id']} THEN '{product['image']}'")
        sql.append("  END,")
        sql.append("  updated_at = NOW()")
        sql.append(f"WHERE tenant_id = '{TENANT_ID}'")
        ids = ", ".join(str(p["id"]) for p in changed)
        sql.append(f"  AND external_id IN ({ids});")
        SQL_PATH.write_text("\n".join(sql) + "\n", encoding="utf-8")
    else:
        SQL_PATH.write_text("-- Nenhuma imagem de peso divergente encontrada.\n", encoding="utf-8")

    print(
        f"changed={len(changed)} kept={kept} skip_none={skipped_none} "
        f"skip_multi={skipped_multi} sql={SQL_PATH}"
    )


if __name__ == "__main__":
    main()
