"""
Remapeia imagens do catálogo usando layout do PDF (linhas/colunas)
e ordem dos sabores listados, evitando bleed entre colunas.
"""
from __future__ import annotations

import json
import re
import unicodedata
from pathlib import Path

import fitz

PDF_PATH = Path(
    r"C:\Users\givan\OneDrive\Desktop\GIVA\Mercado Livre\Pet_P2_P2p\Catálogo PremieRpet - 2026.pdf"
)
PRODUCTS_PATH = Path(__file__).parent.parent / "src" / "data" / "products.json"
API_SEED_PATH = (
    Path(__file__).parent.parent.parent
    / "petsite-api"
    / "src"
    / "main"
    / "resources"
    / "seed"
    / "products.json"
)
REPORT_PATH = Path(__file__).parent / "image_remap_report.txt"
MAP_PATH = Path(__file__).parent / "image_fix_map.json"
SQL_PATH = Path(__file__).parent / "update_product_images.sql"

MIN_PRODUCT_AREA = 8000
MIN_WIDTH = 70
MIN_HEIGHT = 70


def normalize(text: str) -> str:
    text = unicodedata.normalize("NFKD", text)
    text = "".join(c for c in text if not unicodedata.combining(c))
    text = text.upper()
    text = re.sub(r"[^A-Z0-9;,\s]+", " ", text)
    return re.sub(r"\s+", " ", text).strip()


def get_product_images_on_page(page) -> list[dict]:
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
        images.append({"bbox": (x0, y0, x1, y1), "y": y0, "x": x0, "cx": (x0 + x1) / 2})
    images.sort(key=lambda i: (round(i["y"] / 40), i["x"]))
    return images


def group_rows(images: list[dict], y_tol: float = 40) -> list[list[dict]]:
    if not images:
        return []
    rows: list[list[dict]] = []
    current = [images[0]]
    for img in images[1:]:
        if abs(img["y"] - current[0]["y"]) <= y_tol:
            current.append(img)
        else:
            rows.append(sorted(current, key=lambda i: i["x"]))
            current = [img]
    rows.append(sorted(current, key=lambda i: i["x"]))
    return rows


def page_words(page):
    return page.get_text("words")


def words_in_band(words, y0, y1, x0=None, x1=None):
    out = []
    for w in words:
        wx0, wy0, wx1, wy1, word = w[:5]
        if wy1 < y0 or wy0 > y1:
            continue
        if x0 is not None and wx1 < x0:
            continue
        if x1 is not None and wx0 > x1:
            continue
        out.append((wy0, wx0, word))
    out.sort()
    return " ".join(t[2] for t in out)


def extract_sabores(text: str) -> list[str]:
    """Extrai lista de sabores após 'Sabor:' preservando ordem."""
    m = re.search(r"Sabor:\s*(.+?)(?:Intestino|Saúde|Crescimento|Blend|Naturalmente|DESENVOLVIMENTO|NOBRE|SEM CORANTES|$)", text, re.I | re.S)
    if not m:
        # fallback: all after first Sabor:
        m = re.search(r"Sabor:\s*(.+)$", text, re.I | re.S)
    if not m:
        return []
    chunk = m.group(1)
    # cut marketing words
    chunk = re.split(
        r"\b(?:Intestino|Saúde|Crescimento|Blend|Naturalmente|SEM|Combinação|Máxima|Maior)\b",
        chunk,
        maxsplit=1,
        flags=re.I,
    )[0]
    parts = re.split(r"[;|/]| e (?=[A-ZÁÉÍÓÚÃÕ])", chunk)
    sabores = []
    for part in parts:
        part = normalize(part)
        part = re.sub(r"\b\d+(?:[.,]\d+)?\s*(?:KG|G)\b", "", part)
        part = re.sub(r"\s+", " ", part).strip(" ,;")
        if len(part) >= 3:
            sabores.append(part)
    # Deduplicate preserving order
    seen = set()
    ordered = []
    for s in sabores:
        if s not in seen:
            seen.add(s)
            ordered.append(s)
    return ordered


def detect_stage(text_n: str) -> str | None:
    # Order matters for exclusivity when both appear due to bleed
    checks = [
        ("POWER TRAINING", "POWER"),
        ("FILHOTES", "FILHOTES"),
        ("ADULTOS", "ADULTOS"),
        ("CASTRADOS", "CASTRADOS"),
        ("SENIOR", "SENIOR"),
        ("LIGHT", "LIGHT"),
    ]
    for key, label in checks:
        if key in text_n:
            # Prefer more specific: if both FILHOTES and ADULTOS, take first occurrence
            pass
    # first occurrence wins
    positions = []
    for key, label in [
        ("FILHOTES", "FILHOTES"),
        ("ADULTOS", "ADULTOS"),
        ("CASTRADOS", "CASTRADOS"),
        ("SENIOR", "SENIOR"),
        ("LIGHT", "LIGHT"),
    ]:
        idx = text_n.find(key)
        if idx >= 0:
            positions.append((idx, label))
    if not positions:
        return None
    positions.sort()
    return positions[0][1]


def detect_line_flags(text_n: str) -> set[str]:
    flags = set()
    if "MEGA" in text_n:
        flags.add("MEGA")
    if "POWER" in text_n or "TREINAMENTO" in text_n:
        flags.add("POWER")
    if "SPECIAL" in text_n:
        flags.add("SPECIAL")
    if "GOURMET" in text_n:
        flags.add("GOURMET")
    if "LIGHT" in text_n:
        flags.add("LIGHT")
    if "COOKIE" in text_n or "COOKIES" in text_n:
        flags.add("COOKIE")
    return flags


def detect_porte(text_n: str) -> str | None:
    if "PORTE PEQUENO" in text_n or "PORTES PEQUENO" in text_n:
        return "PEQUENO"
    if "PORTE MEDIO" in text_n or "PORTES MEDIO" in text_n:
        return "MEDIO"
    if "PORTE GRANDE" in text_n or "PORTES GRANDE" in text_n or "GIGANTE" in text_n:
        return "GRANDE"
    return None


def flavor_tokens(sabor: str) -> set[str]:
    n = normalize(sabor)
    tokens = set()
    mapping = {
        "FRANGO": "FRANGO",
        "CARNE": "CARNE",
        "SALMAO": "SALMAO",
        "ATUM": "ATUM",
        "PERU": "PERU",
        "CORDEIRO": "CORDEIRO",
        "BANANA": "BANANA",
        "MACA": "MACA",
        "ORIGINAL": "ORIGINAL",
        "ABOBORA": "ABOBORA",
        "QUINOA": "QUINOA",
        "ESPINAFRE": "ESPINAFRE",
        "CENOURA": "CENOURA",
        "BATATA": "BATATA",
        "MANDIOCA": "MANDIOCA",
        "AVEIA": "AVEIA",
        "MEL": "MEL",
        "COCO": "COCO",
        "ARROZ": "ARROZ",
    }
    for key, label in mapping.items():
        if key in n:
            tokens.add(label)
    return tokens


def product_profile(name: str, description: str = "") -> dict:
    n = normalize(f"{name} {description}")
    stage = detect_stage(normalize(name)) or detect_stage(n)
    porte = detect_porte(n)
    flags = detect_line_flags(n)
    # Porte Grande on Golden page without MEGA/POWER often is MEGA line
    if porte == "GRANDE" and "GOLDEN" in n and not (flags & {"POWER", "MEGA", "LIGHT"}):
        flags.add("MEGA")
    m = re.search(r"SABOR\s+(.+)$", normalize(name))
    sabor = m.group(1) if m else ""
    return {
        "stage": stage,
        "porte": porte,
        "flags": flags,
        "flavor": flavor_tokens(sabor),
        "name_n": normalize(name),
    }


def score_image(profile: dict, img_meta: dict) -> int:
    score = 0
    if profile["stage"] and img_meta["stage"]:
        if profile["stage"] == img_meta["stage"]:
            score += 50
        else:
            score -= 60
    if profile["porte"] and img_meta["porte"]:
        if profile["porte"] == img_meta["porte"]:
            score += 30
        else:
            score -= 25
    if profile["flags"] and img_meta["flags"]:
        inter = profile["flags"] & img_meta["flags"]
        if inter:
            score += 35 * len(inter)
        # hard conflict MEGA vs POWER
        if ("MEGA" in profile["flags"] and "POWER" in img_meta["flags"] and "MEGA" not in img_meta["flags"]):
            score -= 40
        if ("POWER" in profile["flags"] and "MEGA" in img_meta["flags"] and "POWER" not in img_meta["flags"]):
            score -= 40
    if profile["flavor"] and img_meta["flavor"]:
        inter = profile["flavor"] & img_meta["flavor"]
        distinctive = inter - {"ARROZ"}
        if distinctive:
            score += 40 + 8 * len(distinctive)
        elif inter:
            score += 10
        else:
            score -= 35
    elif profile["flavor"] and not img_meta["flavor"]:
        score -= 5
    return score


def build_image_metas(page, page_num: int, regions: list[dict]) -> list[dict]:
    words = page_words(page)
    rows = group_rows(regions)
    metas = []
    global_idx = 0
    for row in rows:
        row_y0 = min(r["y"] for r in row) - 90
        row_y1 = max(r["bbox"][3] for r in row) + 110
        row_x0 = min(r["bbox"][0] for r in row) - 20
        row_x1 = max(r["bbox"][2] for r in row) + 220
        row_text = words_in_band(words, row_y0, row_y1, row_x0, row_x1)
        row_n = normalize(row_text)
        row_stage = detect_stage(row_n)
        row_flags = detect_line_flags(row_n)
        row_porte = detect_porte(row_n)
        sabores = extract_sabores(row_text)

        for col_idx, region in enumerate(row):
            global_idx += 1
            # column-local text (tighter)
            x0, y0, x1, y1 = region["bbox"]
            col_text = words_in_band(words, y0 - 70, y1 + 120, x0 - 25, x1 + 90)
            # if column text weak, use row text
            use_text = col_text if len(col_text) > 20 else row_text
            use_n = normalize(use_text)
            stage = detect_stage(use_n) or row_stage
            flags = detect_line_flags(use_n) | row_flags
            porte = detect_porte(use_n) or row_porte

            # Assign sabor by column order when row lists multiple sabores
            if sabores and len(sabores) == len(row):
                sabor = sabores[col_idx]
            elif sabores and len(sabores) == 1:
                sabor = sabores[0]
            else:
                # try extract from column
                col_sabores = extract_sabores(col_text)
                sabor = col_sabores[0] if col_sabores else (sabores[col_idx] if col_idx < len(sabores) else "")

            path = f"/assets/products/catalog/page-{page_num:02d}-img-{global_idx:02d}.webp"
            metas.append(
                {
                    "path": path,
                    "text": use_text,
                    "stage": stage,
                    "porte": porte,
                    "flags": flags,
                    "flavor": flavor_tokens(sabor) if sabor else flavor_tokens(use_text),
                    "sabor": sabor,
                    "row_size": len(row),
                    "col": col_idx,
                }
            )
    return metas


# Curated overrides confirmed by visual inspection of bag artwork
CURATED_OVERRIDES = {
    "Golden - Adultos - Porte Grande - Sabor Frango e Arroz": "/assets/products/catalog/page-11-img-04.webp",
    "Golden Gatos - Adultos - Sabor Frango": "/assets/products/catalog/page-18-img-02.webp",
    "Golden Gatos - Filhotes - Sabor Frango": "/assets/products/catalog/page-18-img-01.webp",
}


def main():
    products = json.loads(PRODUCTS_PATH.read_text(encoding="utf-8"))
    doc = fitz.open(PDF_PATH)

    by_page: dict[int, list] = {}
    for p in products:
        by_page.setdefault(p["catalogPage"], []).append(p)

    page_metas: dict[int, list[dict]] = {}
    for page_num in sorted(by_page.keys()):
        if page_num < 1 or page_num > doc.page_count:
            continue
        page = doc[page_num - 1]
        regions = get_product_images_on_page(page)
        page_metas[page_num] = build_image_metas(page, page_num, regions)

    unique = {}
    for p in products:
        unique.setdefault(p["name"], p)

    name_to_image = {}
    report = []
    changed = []

    for name, sample in sorted(unique.items(), key=lambda x: x[1]["id"]):
        if name in CURATED_OVERRIDES:
            chosen = CURATED_OVERRIDES[name]
            name_to_image[name] = chosen
            if sample.get("image") != chosen:
                changed.append(name)
                report.append(f"CURATED | {name}\n  {sample.get('image')} -> {chosen}\n")
            continue

        metas = page_metas.get(sample["catalogPage"], [])
        current = sample.get("image")
        if not metas:
            name_to_image[name] = current
            continue

        profile = product_profile(name, sample.get("description") or "")
        scored = [(score_image(profile, meta), meta) for meta in metas]
        scored.sort(key=lambda x: x[0], reverse=True)
        best_score, best = scored[0]
        chosen = best["path"]

        # Keep current if scores are tied-ish and current is among top
        top = [m for s, m in scored if s == best_score]
        if current and any(m["path"] == current for m in top):
            chosen = current
        elif best_score < 20 and current:
            chosen = current

        name_to_image[name] = chosen
        if chosen != current:
            changed.append(name)
            report.append(
                f"FIX | {name} score={best_score}\n"
                f"  {current} -> {chosen}\n"
                f"  profile={profile}\n"
                f"  img_stage={best.get('stage')} porte={best.get('porte')} flags={best.get('flags')} sabor={best.get('sabor')} flavor={best.get('flavor')}\n"
                f"  near={best.get('text','')[:200]}\n"
            )

    updated_rows = 0
    for p in products:
        new_img = name_to_image[p["name"]]
        if p.get("image") != new_img:
            p["image"] = new_img
            updated_rows += 1

    payload = json.dumps(products, ensure_ascii=False, indent=2) + "\n"
    PRODUCTS_PATH.write_text(payload, encoding="utf-8")
    if API_SEED_PATH.parent.exists():
        API_SEED_PATH.write_text(payload, encoding="utf-8")

    MAP_PATH.write_text(
        json.dumps(
            {
                "_meta": {
                    "updated_rows": updated_rows,
                    "changed_unique_names": len(changed),
                    "curated_overrides": len(CURATED_OVERRIDES),
                },
                "by_name": name_to_image,
                "changed_names": changed,
                "curated_overrides": CURATED_OVERRIDES,
            },
            ensure_ascii=False,
            indent=2,
        )
        + "\n",
        encoding="utf-8",
    )

    # SQL to update live DB by external_id / name+weight
    sql_lines = [
        "-- Atualiza imagens dos produtos com base no remap do catálogo PremieRpet 2026",
        "-- Seguro para reexecutar.",
        "BEGIN;",
    ]
    for p in products:
        img = p["image"].replace("'", "''")
        name = p["name"].replace("'", "''")
        weight = str(p.get("weight") or "").replace("'", "''")
        sql_lines.append(
            "UPDATE products SET image = '{img}', updated_at = NOW() "
            "WHERE name = '{name}' AND COALESCE(weight,'') = '{weight}';".format(
                img=img, name=name, weight=weight
            )
        )
    sql_lines.append("COMMIT;")
    SQL_PATH.write_text("\n".join(sql_lines) + "\n", encoding="utf-8")

    checks = [
        "Golden - Adultos - Porte Grande - Sabor Frango e Arroz",
        "Golden Gatos - Adultos - Sabor Frango",
        "Golden Gatos - Filhotes - Sabor Frango",
    ]
    print(f"Updated rows: {updated_rows}")
    print(f"Changed names: {len(changed)}")
    for name in checks:
        rows = [p for p in products if p["name"] == name]
        print(name, "->", rows[0]["image"] if rows else "MISSING")

    REPORT_PATH.write_text(
        "\n".join(
            [f"Updated rows: {updated_rows}", f"Changed names: {len(changed)}", ""]
            + report
        ),
        encoding="utf-8",
    )


if __name__ == "__main__":
    main()
