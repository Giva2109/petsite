"""Cadastra PremieR Nutrição Clínica (catálogo 2026 p. 56-59) com preços sugeridos ago/26."""
from __future__ import annotations

import io
import json
from pathlib import Path

import fitz
from PIL import Image

PDF_PATH = Path(r"c:\workspace_pet_shop\petsite\scripts\_pdf_tmp\catalogo_premier_2026.pdf")
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
SQL_PATH = Path(__file__).parent / "insert_nutricao_clinica.sql"
TENANT_ID = "a0000000-0000-4000-8000-000000000001"

RENDER_DPI = 400
MAX_LONG_EDGE = 1500
WEBP_QUALITY = 88

# Recortes das embalagens (page, x0, y0, x1, y1) no espaço do PDF.
BAG_CROPS: dict[str, tuple[int, float, float, float, float]] = {
    "caes-cardio": (56, 20, 350, 170, 530),
    "caes-diabetes": (56, 316, 354, 470, 534),
    "caes-gastro": (56, 22, 610, 175, 790),
    "caes-hipo-hidro": (56, 317, 613, 470, 790),
    "caes-hipo-cordeiro": (57, 10, 220, 165, 400),
    "caes-obesidade": (57, 312, 225, 480, 410),
    "caes-renal": (57, 14, 485, 185, 680),
    "gatos-obesidade": (58, 30, 230, 160, 420),
    "gatos-urinario": (58, 335, 228, 470, 415),
    "gatos-renal-iniciais": (58, 42, 530, 175, 720),
    "gatos-renal": (58, 334, 523, 470, 710),
    "umido-caes-diabetes": (59, 36, 140, 155, 330),
    "umido-caes-obesidade": (59, 332, 136, 455, 326),
    "umido-gatos-obesidade": (59, 36, 415, 155, 590),
    "umido-gatos-urinario": (59, 345, 412, 465, 587),
    "umido-recuperacao": (59, 38, 705, 157, 890),
}


def optimize_for_web(img: Image.Image) -> Image.Image:
    img = img.convert("RGB")
    w, h = img.size
    long_edge = max(w, h)
    if long_edge > MAX_LONG_EDGE:
        scale = MAX_LONG_EDGE / long_edge
        img = img.resize((int(w * scale), int(h * scale)), Image.Resampling.LANCZOS)
    return img


def extract_images() -> dict[str, str]:
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    doc = fitz.open(PDF_PATH)
    mapping: dict[str, str] = {}
    mat = fitz.Matrix(RENDER_DPI / 72, RENDER_DPI / 72)

    for slug, (page_num, x0, y0, x1, y1) in BAG_CROPS.items():
        page = doc[page_num - 1]
        clip = fitz.Rect(x0, y0, x1, y1)
        pix = page.get_pixmap(matrix=mat, clip=clip, alpha=False)
        img = Image.open(io.BytesIO(pix.tobytes("png")))
        img = optimize_for_web(img)
        fname = f"page-{page_num:02d}-{slug}.webp"
        dest = OUT_DIR / fname
        img.save(dest, "WEBP", quality=WEBP_QUALITY, method=6)
        mapping[slug] = f"/assets/products/catalog/{fname}"
        print(f"{slug}: {img.size} {dest.stat().st_size} bytes")

    doc.close()
    return mapping


def sku(
    *,
    name: str,
    category: str,
    line: str,
    price: float,
    weight: str,
    page: int,
    slug: str,
    description: str,
    images: dict[str, str],
) -> dict:
    return {
        "name": name,
        "category": category,
        "brand": "UniPet",
        "line": line,
        "price": price,
        "originalPrice": None,
        "image": images[slug],
        "description": description,
        "weight": weight,
        "catalogPage": page,
        "stock": None,
    }


def build_catalog(images: dict[str, str]) -> list[dict]:
    caes = "PremieR Nutrição Clínica Cães"
    gatos = "PremieR Nutrição Clínica Gatos"
    umidos = "PremieR Nutrição Clínica Úmidos"
    products: list[dict] = []

    # Secos cães: 2kg só porte pequeno; 10,1kg pequeno e médio/grande (tabela ago/26).
    dog_dry = [
        ("Cardio", 95.90, 379.90, "caes-cardio", 56),
        ("Diabetes", 95.90, 379.90, "caes-diabetes", 56),
        ("Gastrointestinal", 95.90, 379.90, "caes-gastro", 56),
        ("Hipoalergênico Proteína Hidrolisada", 99.90, 399.90, "caes-hipo-hidro", 56),
        ("Hipoalergênico Cordeiro e Arroz", 99.90, 399.90, "caes-hipo-cordeiro", 57),
        ("Obesidade", 99.90, 399.90, "caes-obesidade", 57),
        ("Renal", 95.90, 379.90, "caes-renal", 57),
    ]
    for indication, p2, p10, slug, page in dog_dry:
        for porte, weight, price in [
            ("Porte Pequeno", "2kg", p2),
            ("Porte Pequeno", "10.1kg", p10),
            ("Porte Médio/Grande", "10.1kg", p10),
        ]:
            products.append(
                sku(
                    name=f"{caes} - {indication} - {porte}",
                    category="caes",
                    line=caes,
                    price=price,
                    weight=weight,
                    page=page,
                    slug=slug,
                    description=(
                        f"Linha {caes}. {indication}. {porte}. Embalagem {weight}."
                    ),
                    images=images,
                )
            )

    cat_dry = [
        ("Obesidade", "1.5kg", 109.90, "gatos-obesidade", 58),
        ("Urinário", "500g", 49.90, "gatos-urinario", 58),
        ("Urinário", "1.5kg", 109.90, "gatos-urinario", 58),
        ("Renal Estágios Iniciais", "1.5kg", 109.90, "gatos-renal-iniciais", 58),
        ("Renal", "500g", 49.90, "gatos-renal", 58),
        ("Renal", "1.5kg", 109.90, "gatos-renal", 58),
    ]
    for indication, weight, price, slug, page in cat_dry:
        products.append(
            sku(
                name=f"{gatos} - {indication}",
                category="gatos",
                line=gatos,
                price=price,
                weight=weight,
                page=page,
                slug=slug,
                description=f"Linha {gatos}. {indication}. Embalagem {weight}.",
                images=images,
            )
        )

    # Úmidos: preço sugerido unitário x 20 (mesma regra das outras sachês do catálogo).
    wet = [
        ("Cães Diabetes", "caes", "85g", 12.90, 20, "umido-caes-diabetes", 59),
        ("Cães Obesidade", "caes", "85g", 12.90, 20, "umido-caes-obesidade", 59),
        ("Gatos Obesidade", "gatos", "70g", 11.90, 20, "umido-gatos-obesidade", 59),
        ("Gatos Urinário", "gatos", "70g", 11.90, 20, "umido-gatos-urinario", 59),
        ("Cães e Gatos Recuperação", "caes", "85g", 14.90, 20, "umido-recuperacao", 59),
    ]
    for indication, category, weight, unit, units, slug, page in wet:
        pack = round(unit * units, 2)
        products.append(
            sku(
                name=f"{umidos} - {indication}",
                category=category,
                line=umidos,
                price=pack,
                weight=weight,
                page=page,
                slug=slug,
                description=(
                    f"Linha {umidos}. {indication}. Embalagem {weight} "
                    f"(pacote com {units} un.)."
                ),
                images=images,
            )
        )

    return products


def sql_literal(value: str | None) -> str:
    if value is None:
        return "NULL"
    return "'" + value.replace("'", "''") + "'"


def add_products(new_products: list[dict]) -> list[dict]:
    products = json.loads(PRODUCTS_PATH.read_text(encoding="utf-8"))
    existing = {
        (p.get("name"), p.get("weight"), p.get("line"))
        for p in products
        if "Nutrição Clínica" in (p.get("line") or "")
        or "Nutricao Clinica" in (p.get("line") or "")
    }
    next_id = max(p["id"] for p in products) + 1
    inserted: list[dict] = []

    for item in new_products:
        key = (item["name"], item["weight"], item["line"])
        if key in existing:
            print("skip existing", key)
            continue
        item = {**item, "id": next_id}
        products.append(item)
        inserted.append(item)
        next_id += 1

    payload = json.dumps(products, ensure_ascii=False, indent=2) + "\n"
    PRODUCTS_PATH.write_text(payload, encoding="utf-8")
    if SEED_PATH.parent.exists():
        SEED_PATH.write_text(payload, encoding="utf-8")

    sql = ["-- Insere PremieR Nutrição Clínica (catálogo 2026 + preços sugeridos ago/26)", "BEGIN;"]
    for p in inserted:
        sql.append(
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
    sql.append("COMMIT;")
    SQL_PATH.write_text("\n".join(sql) + "\n", encoding="utf-8")
    print(f"Added {len(inserted)} SKUs -> {SQL_PATH}")
    return inserted


if __name__ == "__main__":
    images = extract_images()
    catalog = build_catalog(images)
    add_products(catalog)
