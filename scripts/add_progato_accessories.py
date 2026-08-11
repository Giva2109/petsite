"""Adiciona produtos Progato (areia de gato) ao products.json e gera SQL."""
import json
from pathlib import Path

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
SQL_PATH = Path(__file__).parent / "insert_progato_accessories.sql"

BASE = "/assets/products/accessories/progato"
ACCESSORY_LINE = "Areia de Gato"
BRAND = "Progato"
CATEGORY = "acessorios"

CATALOG = [
    ("Progato Clássica Multigrãos", "classica-multigraos", [
        ("4kg", 15.90),
        ("10kg", 38.50),
    ]),
    ("Progato Clássica Multigrãos Perfumada", "classica-multigraos-perfumada", [
        ("10kg", 45.90),
    ]),
    ("Progato Clássica Grãos Pequenos Perfumada", "classica-graos-pequenos-perfumada", [
        ("4kg", 18.50),
    ]),
    ("Progato Premium", "premium", [
        ("4kg", 49.90),
        ("10kg", 114.90),
    ]),
    ("Progato Super Premium", "super-premium", [
        ("4kg", 54.50),
    ]),
    ("Progato Branco", "branco", [
        ("1.8kg", 23.90),
        ("3.6kg", 45.60),
        ("10kg", 120.90),
    ]),
    ("Progato Vida Comfort", "vida-comfort", [
        ("3.6kg", 59.90),
    ]),
    ("Progato Vida Clean", "vida-clean", [
        ("3.6kg", 59.90),
    ]),
    ("Progato Ecorice", "ecorice", [
        ("4kg", 23.90),
    ]),
    ("Progato Sensitive", "sensitive", [
        ("1.8kg", 24.90),
    ]),
    ("Progato Light Weight", "light-weight", [
        ("4kg", 54.50),
    ]),
    ("Progato Pinus", "pinus", [
        ("5kg", 38.90),
        ("10kg", 72.90),
    ]),
    ("Progato Biobom", "biobom", [
        ("3kg", 41.90),
    ]),
]

TENANT_ID = "a0000000-0000-4000-8000-000000000001"


def main():
    products = json.loads(PRODUCTS_PATH.read_text(encoding="utf-8"))
    next_id = max(p["id"] for p in products) + 1
    new_products = []

    for name, slug, variants in CATALOG:
        image = f"{BASE}/{slug}.webp"
        for weight, price in variants:
            new_products.append(
                {
                    "id": next_id,
                    "name": name,
                    "category": CATEGORY,
                    "brand": BRAND,
                    "line": ACCESSORY_LINE,
                    "price": price,
                    "originalPrice": None,
                    "image": image,
                    "description": (
                        f"Areia sanitária {name.replace('Progato ', '')}. "
                        f"Embalagem {weight}."
                    ),
                    "weight": weight,
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

    sql = [
        "-- Insere areias Progato no catálogo UniPet",
        "BEGIN;",
    ]
    for p in new_products:
        name = p["name"].replace("'", "''")
        desc = p["description"].replace("'", "''")
        weight = p["weight"].replace("'", "''")
        image = p["image"].replace("'", "''")
        sql.append(
            f"""
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image, description, weight, active
)
SELECT '{TENANT_ID}', {p['id']}, '{name}', '{CATEGORY}', '{BRAND}', '{ACCESSORY_LINE}',
       {p['price']}, '{image}', '{desc}', '{weight}', TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = '{TENANT_ID}'
    AND name = '{name}'
    AND COALESCE(weight, '') = '{weight}'
);""".strip()
        )
    sql.append("COMMIT;")
    SQL_PATH.write_text("\n".join(sql) + "\n", encoding="utf-8")

    print(f"Added {len(new_products)} SKUs")
    print(f"SQL: {SQL_PATH}")


if __name__ == "__main__":
    main()
