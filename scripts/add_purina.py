"""Cadastra 5 produtos Purina de teste (catálogo + tabela 16-07)."""
from __future__ import annotations

import io
import json
from pathlib import Path

import fitz
from PIL import Image

PDF_PATH = Path(
    r"C:\Users\givan\OneDrive\Desktop\GIVA\Mercado Livre\Purina\CATALAGO PURINA.pdf"
)
OUT_DIR = Path(__file__).parent.parent / "public" / "assets" / "products" / "catalog"
PRODUCTS_PATH = Path(__file__).parent.parent / "src" / "data" / "products.json"
SEED_PATH = (
    Path(__file__).parent.parent.parent
    / "petsite-api"
    / "src"
    / "main"
    / "resources"
    / "seed"
    / "products.json"
)
SQL_PATH = Path(__file__).parent / "insert_purina.sql"
TENANT_ID = "a0000000-0000-4000-8000-000000000001"

RENDER_DPI = 400
MAX_LONG_EDGE = 1500
WEBP_QUALITY = 88
PAD_PT = 8

# page, x0, y0, x1, y1 no espaço do PDF (embalagem visível no catálogo).
CROPS = {
    "proplan-cat-adult-frango": (7, 251.6, 154.2, 347.3, 247.2),
    "proplan-puppy-mini": (8, 80.2, 255.2, 180.9, 355.9),
    "catchow-adult-carne": (21, 137.8, 230.3, 242.6, 335.2),
    "dogchow-adult-med-grande": (23, 249.9, 524.2, 356.6, 632.4),
    "friskies-mix-carnes": (27, 173.6, 239.9, 286.7, 352.9),
    "proplan-cat-kitten": (7, 108.0, 157.7, 203.7, 248.8),
    "proplan-adult-mini": (8, 400.1, 256.8, 500.1, 356.4),
    "catchow-kitten": (21, 28.0, 232.0, 130.0, 335.2),
    "dogchow-puppy-med": (23, 243.7, 207.4, 362.7, 326.4),
    "friskies-granja": (27, 101.3, 534.3, 215.3, 648.3),
    "proplan-cat-7plus": (7, 392.0, 156.1, 487.0, 248.8),
    "proplan-adult-grande": (8, 232.5, 535.1, 332.8, 635.0),
    "catchow-adult-peixe": (21, 255.6, 236.6, 349.5, 330.5),
    "dogchow-adult-mini": (23, 109.6, 524.2, 217.8, 632.1),
    "friskies-mar": (27, 446.1, 237.9, 559.1, 350.9),
}

NEW_SLUGS = (
    "proplan-cat-7plus",
    "proplan-adult-grande",
    "catchow-adult-peixe",
    "dogchow-adult-mini",
    "friskies-mar",
)


def expand(bbox, page_rect, pad=PAD_PT):
    x0, y0, x1, y1 = bbox
    return (
        max(page_rect.x0, x0 - pad),
        max(page_rect.y0, y0 - pad),
        min(page_rect.x1, x1 + pad),
        min(page_rect.y1, y1 + pad),
    )


def best_embedded(page, bbox) -> Image.Image | None:
    clip = fitz.Rect(bbox)
    best = None
    best_area = 0
    for info in page.get_image_info(xrefs=True):
        rects = info.get("bboxes") or []
        xref = info.get("xref")
        if not xref or not rects:
            continue
        for rect in rects:
            inter = fitz.Rect(rect) & clip
            if inter.is_empty:
                continue
            cover = inter.get_area() / max(clip.get_area(), 1)
            if cover < 0.55:
                continue
            try:
                raw = page.parent.extract_image(xref)
            except Exception:
                continue
            img = Image.open(io.BytesIO(raw["image"])).convert("RGB")
            area = img.size[0] * img.size[1]
            if area > best_area:
                best = img
                best_area = area
    return best


def render_crop(page, bbox) -> Image.Image:
    mat = fitz.Matrix(RENDER_DPI / 72, RENDER_DPI / 72)
    pix = page.get_pixmap(matrix=mat, clip=fitz.Rect(bbox), alpha=False)
    return Image.open(io.BytesIO(pix.tobytes("png"))).convert("RGB")


def optimize(img: Image.Image) -> Image.Image:
    img = img.convert("RGB")
    w, h = img.size
    long_edge = max(w, h)
    if long_edge > MAX_LONG_EDGE:
        scale = MAX_LONG_EDGE / long_edge
        img = img.resize((int(w * scale), int(h * scale)), Image.Resampling.LANCZOS)
    return img


def extract_images(slugs: tuple[str, ...] | None = None) -> dict[str, str]:
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    doc = fitz.open(PDF_PATH)
    mapping: dict[str, str] = {}
    items = CROPS.items() if slugs is None else ((s, CROPS[s]) for s in slugs)
    for slug, (page_num, x0, y0, x1, y1) in items:
        page = doc[page_num - 1]
        pad = 2 if slug == "catchow-kitten" else PAD_PT
        bbox = expand((x0, y0, x1, y1), page.rect, pad=pad)
        rendered = render_crop(page, bbox)
        embedded = best_embedded(page, bbox)
        if embedded and (embedded.size[0] * embedded.size[1] > rendered.size[0] * rendered.size[1] * 1.2):
            img = embedded
            source = "embedded"
        else:
            img = rendered
            source = "render"
        img = optimize(img)
        fname = f"purina-{slug}.webp"
        dest = OUT_DIR / fname
        img.save(dest, "WEBP", quality=WEBP_QUALITY, method=6)
        mapping[slug] = f"/assets/products/catalog/{fname}"
        print(f"{slug}: {source} {img.size} {dest.stat().st_size} bytes")
    doc.close()
    return mapping


def sku(**kwargs) -> dict:
    return {
        "name": kwargs["name"],
        "category": kwargs["category"],
        "brand": "UniPet",
        "line": kwargs["line"],
        "price": kwargs["price"],
        "originalPrice": None,
        "image": kwargs["image"],
        "description": kwargs["description"],
        "weight": kwargs["weight"],
        "catalogPage": kwargs["catalogPage"],
        "stock": None,
    }


def build_catalog(images: dict[str, str]) -> list[dict]:
    line = "Purina"
    return [
        sku(
            name="Purina Pro Plan - Gatos Adultos - Sabor Frango e Arroz - Embalagem 1kg",
            category="gatos",
            line=line,
            price=71.70,
            image=images["proplan-cat-adult-frango"],
            description="Linha Purina. Pro Plan. Gatos Adultos. Sabor Frango e Arroz.",
            weight="1kg",
            catalogPage=7,
        ),
        sku(
            name="Purina Pro Plan - Cães Filhotes - Porte Mini e Pequeno - Sabor Frango - Embalagem 1kg",
            category="caes",
            line=line,
            price=53.13,
            image=images["proplan-puppy-mini"],
            description="Linha Purina. Pro Plan. Cães Filhotes. Porte Mini e Pequeno. Sabor Frango.",
            weight="1kg",
            catalogPage=8,
        ),
        sku(
            name="Purina Cat Chow - Gatos Adultos - Sabor Carne - Embalagem 10.1kg",
            category="gatos",
            line=line,
            price=190.07,
            image=images["catchow-adult-carne"],
            description="Linha Purina. Cat Chow. Gatos Adultos. Sabor Carne.",
            weight="10.1kg",
            catalogPage=21,
        ),
        sku(
            name="Purina Dog Chow - Cães Adultos - Porte Médio e Grande - Sabor Carne, Frango e Arroz - Embalagem 15kg",
            category="caes",
            line=line,
            price=170.00,
            image=images["dogchow-adult-med-grande"],
            description="Linha Purina. Dog Chow. Cães Adultos. Porte Médio e Grande. Sabor Carne, Frango e Arroz.",
            weight="15kg",
            catalogPage=23,
        ),
        sku(
            name="Purina Friskies - Gatos Adultos - Sabor Mix de Carnes - Embalagem 10.1kg",
            category="gatos",
            line=line,
            price=183.86,
            image=images["friskies-mix-carnes"],
            description="Linha Purina. Friskies. Gatos Adultos. Sabor Mix de Carnes.",
            weight="10.1kg",
            catalogPage=27,
        ),
    ]


def sql_literal(value) -> str:
    if value is None:
        return "NULL"
    if isinstance(value, str):
        return "'" + value.replace("'", "''") + "'"
    return str(value)


def build_new_batch(images: dict[str, str]) -> list[dict]:
    line = "Purina"
    return [
        sku(
            name="Purina Pro Plan - Gatos Adultos 7+ - Sabor Frango - Embalagem 1kg",
            category="gatos",
            line=line,
            price=71.70,
            image=images["proplan-cat-7plus"],
            description="Linha Purina. Pro Plan. Gatos Adultos 7+. Sabor Frango.",
            weight="1kg",
            catalogPage=7,
        ),
        sku(
            name="Purina Pro Plan - Cães Adultos - Porte Grande - Sabor Frango - Embalagem 2.5kg",
            category="caes",
            line=line,
            price=113.87,
            image=images["proplan-adult-grande"],
            description="Linha Purina. Pro Plan. Cães Adultos. Porte Grande. Sabor Frango.",
            weight="2.5kg",
            catalogPage=8,
        ),
        sku(
            name="Purina Cat Chow - Gatos Adultos - Sabor Peixe - Embalagem 10.1kg",
            category="gatos",
            line=line,
            price=190.07,
            image=images["catchow-adult-peixe"],
            description="Linha Purina. Cat Chow. Gatos Adultos. Sabor Peixe.",
            weight="10.1kg",
            catalogPage=21,
        ),
        sku(
            name="Purina Dog Chow - Cães Adultos - Porte Mini e Pequeno - Sabor Carne e Frango - Embalagem 15kg",
            category="caes",
            line=line,
            price=170.00,
            image=images["dogchow-adult-mini"],
            description="Linha Purina. Dog Chow. Cães Adultos. Porte Mini e Pequeno. Sabor Carne e Frango.",
            weight="15kg",
            catalogPage=23,
        ),
        sku(
            name="Purina Friskies - Gatos Adultos - Sabor Mar de Sabores - Embalagem 10.1kg",
            category="gatos",
            line=line,
            price=183.86,
            image=images["friskies-mar"],
            description="Linha Purina. Friskies. Gatos Adultos. Sabor Mar de Sabores.",
            weight="10.1kg",
            catalogPage=27,
        ),
    ]


def add_products(new_products: list[dict]) -> list[dict]:
    products = json.loads(PRODUCTS_PATH.read_text(encoding="utf-8"))
    existing = {(p.get("name"), p.get("weight"), p.get("line")) for p in products}
    next_id = max(p["id"] for p in products) + 1
    inserted: list[dict] = []
    for item in new_products:
        key = (item["name"], item["weight"], item["line"])
        if key in existing:
            print("skip existing", key)
            continue
        item = {"id": next_id, **item}
        products.append(item)
        inserted.append(item)
        next_id += 1

    payload = json.dumps(products, ensure_ascii=False, indent=2) + "\n"
    PRODUCTS_PATH.write_text(payload, encoding="utf-8")
    if SEED_PATH.parent.exists():
        SEED_PATH.write_text(payload, encoding="utf-8")

    if not inserted:
        print("Nenhum SKU novo")
        return inserted

    blocks = ["-- Insere mais 5 produtos Purina (catálogo + tabela 16-07 + 30%)", "BEGIN;"]
    for p in inserted:
        blocks.append(
            f"""
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT {sql_literal(TENANT_ID)}, {p['id']}, {sql_literal(p['name'])},
       {sql_literal(p['category'])}, {sql_literal(p['brand'])}, {sql_literal(p['line'])},
       {p['price']}, {sql_literal(p['image'])}, {sql_literal(p['description'])},
       {sql_literal(p['weight'])}, {p['catalogPage']}, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = {sql_literal(TENANT_ID)}
    AND name = {sql_literal(p['name'])}
    AND COALESCE(weight, '') = {sql_literal(p['weight'])}
    AND COALESCE(line, '') = {sql_literal(p['line'])}
);""".strip()
        )
    ids = ", ".join(str(p["id"]) for p in inserted)
    blocks.append("UPDATE products SET")
    blocks.append("  price = CASE external_id")
    for p in inserted:
        blocks.append(f"    WHEN {p['id']} THEN {p['price']:.2f}")
    blocks.append("  END,")
    blocks.append("  updated_at = NOW()")
    blocks.append(f"WHERE tenant_id = {sql_literal(TENANT_ID)}")
    blocks.append("  AND line = 'Purina'")
    blocks.append(f"  AND external_id IN ({ids});")
    blocks.append("COMMIT;")
    extra_sql = Path(__file__).parent / "insert_purina_batch3.sql"
    extra_sql.write_text("\n".join(blocks) + "\n", encoding="utf-8")
    print(f"Added {len(inserted)} SKUs -> {extra_sql}")
    return inserted


if __name__ == "__main__":
    images = extract_images(NEW_SLUGS)
    catalog = build_new_batch(images)
    add_products(catalog)
