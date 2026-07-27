"""Extrai imagens de produtos do PDF do catálogo PremieRpet em alta qualidade."""
import json
import re
from pathlib import Path

import fitz
from PIL import Image
import io

PDF_PATH = Path(
    r"C:\Users\givan\OneDrive\Desktop\GIVA\Mercado Livre\Pet_P2_P2p\Catálogo PremieRpet - 2026.pdf"
)
OUT_DIR = Path(__file__).parent.parent / "public" / "assets" / "products" / "catalog"
PRODUCTS_PATH = Path(__file__).parent.parent / "src" / "data" / "products.json"

# Renderização em alta DPI (vetorial do PDF → raster nítido)
RENDER_DPI = 400
# Limite do lado maior para web (evita arquivos gigantes sem ganho real)
MAX_LONG_EDGE = 1500
WEBP_QUALITY = 88
BBOX_PADDING_PT = 6

MIN_PRODUCT_AREA = 8000
MIN_WIDTH = 70
MIN_HEIGHT = 70


def get_product_images_on_page(page) -> list[dict]:
    """Retorna imagens de produto ordenadas por posição (top-left)."""
    blocks = page.get_text("dict")["blocks"]
    images = []

    for block in blocks:
        if block["type"] != 1:
            continue
        x0, y0, x1, y1 = block["bbox"]
        w, h = x1 - x0, y1 - y0
        area = w * h

        if area < MIN_PRODUCT_AREA or w < MIN_WIDTH or h < MIN_HEIGHT:
            continue

        if h < w * 0.65:
            continue

        if w > 400 and h < 100:
            continue

        images.append(
            {
                "bbox": (x0, y0, x1, y1),
                "y": y0,
                "x": x0,
            }
        )

    images.sort(key=lambda i: (round(i["y"] / 50), i["x"]))
    return images


def expand_bbox(bbox, page_rect, padding=BBOX_PADDING_PT):
    x0, y0, x1, y1 = bbox
    return (
        max(page_rect.x0, x0 - padding),
        max(page_rect.y0, y0 - padding),
        min(page_rect.x1, x1 + padding),
        min(page_rect.y1, y1 + padding),
    )


def render_crop(page, bbox, dpi=RENDER_DPI):
    """Renderiza recorte da página vetorial em alta resolução."""
    mat = fitz.Matrix(dpi / 72, dpi / 72)
    clip = fitz.Rect(bbox)
    pix = page.get_pixmap(matrix=mat, clip=clip, alpha=False)
    return Image.open(io.BytesIO(pix.tobytes("png")))


def optimize_for_web(img: Image.Image) -> Image.Image:
    """Redimensiona se necessário e converte para RGB (WebP)."""
    img = img.convert("RGB")
    w, h = img.size
    long_edge = max(w, h)

    if long_edge > MAX_LONG_EDGE:
        scale = MAX_LONG_EDGE / long_edge
        new_size = (int(w * scale), int(h * scale))
        img = img.resize(new_size, Image.Resampling.LANCZOS)

    return img


def save_webp(img: Image.Image, out_path: Path):
    optimized = optimize_for_web(img)
    optimized.save(out_path, "WEBP", quality=WEBP_QUALITY, method=6)


def cleanup_old_images():
    for pattern in ("*.png", "*.jpg", "*.jpeg"):
        for old in OUT_DIR.glob(pattern):
            old.unlink()


def main():
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    cleanup_old_images()

    with open(PRODUCTS_PATH, encoding="utf-8") as f:
        products = json.load(f)

    doc = fitz.open(PDF_PATH)
    page_rect = doc[0].rect

    by_page: dict[int, list] = {}
    for p in products:
        by_page.setdefault(p["catalogPage"], []).append(p)

    page_images_cache: dict[int, list[str]] = {}
    size_samples = []

    for page_num in sorted(by_page.keys()):
        if page_num < 1 or page_num > doc.page_count:
            continue

        page = doc[page_num - 1]
        img_regions = get_product_images_on_page(page)

        if not img_regions:
            rect = page.rect
            clip = expand_bbox(
                (rect.x0 + 20, rect.y0 + 60, rect.x1 - 20, rect.y1 - 40),
                rect,
                padding=0,
            )
            fname = f"page-{page_num:02d}-full.webp"
            out_path = OUT_DIR / fname
            save_webp(render_crop(page, clip), out_path)
            page_images_cache[page_num] = [f"/assets/products/catalog/{fname}"]
            size_samples.append(Image.open(out_path).size)
        else:
            paths = []
            for idx, region in enumerate(img_regions):
                fname = f"page-{page_num:02d}-img-{idx + 1:02d}.webp"
                out_path = OUT_DIR / fname
                bbox = expand_bbox(region["bbox"], page.rect)
                save_webp(render_crop(page, bbox), out_path)
                paths.append(f"/assets/products/catalog/{fname}")
                size_samples.append(Image.open(out_path).size)
            page_images_cache[page_num] = paths

    updated = 0
    for page_num, page_products in by_page.items():
        images = page_images_cache.get(page_num, [])
        if not images:
            continue

        unique_names = []
        seen_names = set()
        for product in sorted(page_products, key=lambda p: p["id"]):
            if product["name"] not in seen_names:
                seen_names.add(product["name"])
                unique_names.append(product["name"])

        name_to_image = {}
        for i, name in enumerate(unique_names):
            name_to_image[name] = images[0] if len(images) == 1 else images[i % len(images)]

        for product in page_products:
            product["image"] = name_to_image.get(product["name"], images[0])
            updated += 1

    with open(PRODUCTS_PATH, "w", encoding="utf-8") as f:
        json.dump(products, f, ensure_ascii=False, indent=2)

    webp_count = len(list(OUT_DIR.glob("*.webp")))
    avg_w = sum(s[0] for s in size_samples) // max(len(size_samples), 1)
    avg_h = sum(s[1] for s in size_samples) // max(len(size_samples), 1)

    print(f"OK: {updated} produtos atualizados")
    print(f"DPI: {RENDER_DPI} | Max lado: {MAX_LONG_EDGE}px | WebP q={WEBP_QUALITY}")
    print(f"Arquivos WebP: {webp_count}")
    print(f"Resolucao media: {avg_w}x{avg_h}px")
    print(f"Pasta: {OUT_DIR}")


if __name__ == "__main__":
    main()
