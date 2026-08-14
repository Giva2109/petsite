"""Extrai imagens da fatura Ultimix e cadastra acessórios no catálogo."""
import io
import json
from pathlib import Path

import fitz
from PIL import Image

PDF = Path(
    r"C:\Users\givan\OneDrive\Desktop\GIVA\Mercado Livre"
    r"\Marketing Digital\Importadora Ultimix\Fatura-160995.pdf"
)
OUT = Path(__file__).parent.parent / "public" / "assets" / "products" / "accessories" / "ultimix"
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
SQL_PATH = Path(__file__).parent / "insert_ultimix_accessories.sql"
TENANT_ID = "a0000000-0000-4000-8000-000000000001"

TARGET = 1000
QUALITY = 88

# índice da imagem RGB no PDF (ordem da fatura, pulando fones)
CATALOG = [
    (4, "escova-secadora", "Escova Secadora",
     "Escova Secadora Pet Portatil Profissional 2 Em 1 Banho E Tosa Cachorro e Gato",
     48.99),
    (6, "bebedouro-pet", "Bebedouro Pet",
     "Bebedouro Pet Inteligente Fonte de Água Automático Com Filtro",
     58.99),
    (7, "garrafa-bebedouro", "Garrafa Bebedouro",
     "Garrafa Bebedouro Pet Portátil 2 em 1 Água e Ração",
     25.99),
    (9, "luvas-removedoras-pelos", "Luvas Removedoras de Pelos",
     "Luvas Removedoras de Pelos Dupla Face para Pets, Roupas e Sofás",
     4.99),
]


def extract_images():
    OUT.mkdir(parents=True, exist_ok=True)
    doc = fitz.open(PDF)
    page = doc[0]
    imgs = page.get_images(full=True)
    for idx, slug, *_rest in CATALOG:
        xref = imgs[idx][0]
        pix = fitz.Pixmap(doc, xref)
        if pix.n - pix.alpha >= 4:
            pix = fitz.Pixmap(fitz.csRGB, pix)
        img = Image.open(io.BytesIO(pix.tobytes("png"))).convert("RGB")
        img = img.resize((TARGET, TARGET), Image.Resampling.LANCZOS)
        dest = OUT / f"{slug}.webp"
        img.save(dest, "WEBP", quality=QUALITY, method=6)
        print(slug, img.size, dest.stat().st_size)
    doc.close()


def add_products():
    products = json.loads(PRODUCTS_PATH.read_text(encoding="utf-8"))
    existing_names = {p["name"] for p in products if p.get("category") == "acessorios"}
    next_id = max(p["id"] for p in products) + 1
    new_products = []

    for _idx, slug, line, description, price in CATALOG:
        if line in existing_names:
            print("skip existing", line)
            continue
        new_products.append(
            {
                "id": next_id,
                "name": line,
                "category": "acessorios",
                "brand": "Ultimix",
                "line": line,
                "price": price,
                "originalPrice": None,
                "image": f"/assets/products/accessories/ultimix/{slug}.webp",
                "description": description,
                "weight": None,
                "catalogPage": None,
                "stock": None,
            }
        )
        next_id += 1

    products.extend(new_products)
    payload = json.dumps(products, ensure_ascii=False, indent=2) + "\n"
    PRODUCTS_PATH.write_text(payload, encoding="utf-8")
    if SEED_PATH.parent.exists():
        SEED_PATH.write_text(payload, encoding="utf-8")

    sql = ["-- Insere acessórios Ultimix no catálogo UniPet", "BEGIN;"]
    for p in new_products:
        name = p["name"].replace("'", "''")
        desc = p["description"].replace("'", "''")
        image = p["image"].replace("'", "''")
        sql.append(
            f"""
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image, description, weight, active
)
SELECT '{TENANT_ID}', {p['id']}, '{name}', 'acessorios', 'Ultimix', '{name}',
       {p['price']}, '{image}', '{desc}', NULL, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = '{TENANT_ID}'
    AND name = '{name}'
    AND COALESCE(line, '') = '{name}'
);""".strip()
        )
    sql.append("COMMIT;")
    SQL_PATH.write_text("\n".join(sql) + "\n", encoding="utf-8")
    print(f"Added {len(new_products)} SKUs -> {SQL_PATH}")


if __name__ == "__main__":
    extract_images()
    add_products()
