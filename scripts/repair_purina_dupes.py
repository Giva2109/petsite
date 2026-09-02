"""Remove duplicatas Purina e recadastra variantes com nomes únicos."""
from __future__ import annotations

import json
from pathlib import Path

from add_purina import PRODUCTS_PATH, SEED_PATH, add_products, sql_literal, TENANT_ID
from add_purina_all import build_catalog, build_name, resolve_crop_slug

BASE = Path(__file__).parent
MISSING_PATH = BASE / "_pdf_tmp" / "purina_missing.json"
MASTER_SQL = BASE / "insert_purina.sql"

REMOVE_IDS = {294, 295, 391, 392, 394}


def load_products() -> list[dict]:
    return json.loads(PRODUCTS_PATH.read_text(encoding="utf-8"))


def save_products(products: list[dict]) -> None:
    payload = json.dumps(products, ensure_ascii=False, indent=2) + "\n"
    PRODUCTS_PATH.write_text(payload, encoding="utf-8")
    if SEED_PATH.parent.exists():
        SEED_PATH.write_text(payload, encoding="utf-8")


def rebuild_sql(products: list[dict]) -> None:
    purina = [p for p in products if p.get("line") == "Purina"]
    purina.sort(key=lambda p: p["id"])
    blocks = [
        "-- Catálogo Purina completo (tabela 16-07 + 30%)",
        "BEGIN;",
    ]
    for p in purina:
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
    blocks.append("-- Se os SKUs já existirem, aplica os preços com +30% sobre a tabela 16-07.")
    blocks.append("UPDATE products SET")
    blocks.append("  price = CASE external_id")
    for p in purina:
        blocks.append(f"    WHEN {p['id']} THEN {p['price']:.2f}")
    ids = ", ".join(str(p["id"]) for p in purina)
    blocks.append("  END,")
    blocks.append("  updated_at = NOW()")
    blocks.append(f"WHERE tenant_id = {sql_literal(TENANT_ID)}")
    blocks.append("  AND line = 'Purina'")
    blocks.append(f"  AND external_id IN ({ids});")
    blocks.append("COMMIT;")
    MASTER_SQL.write_text("\n".join(blocks) + "\n", encoding="utf-8")


def main() -> None:
    products = load_products()
    before = len([p for p in products if p.get("line") == "Purina"])
    products = [p for p in products if p["id"] not in REMOVE_IDS]
    removed = before - len([p for p in products if p.get("line") == "Purina"])
    save_products(products)
    print(f"Removidos {removed} duplicados")

    missing = json.loads(MISSING_PATH.read_text(encoding="utf-8"))
    slugs = tuple(dict.fromkeys(resolve_crop_slug(i) for i in missing))
    images = {s: f"/assets/products/catalog/purina-{s}.webp" for s in slugs}
    catalog = build_catalog(missing, images)
    inserted = add_products(catalog)
    print(f"Novos SKUs inseridos: {len(inserted)}")

    products = load_products()
    rebuild_sql(products)
    purina_count = len([p for p in products if p.get("line") == "Purina"])
    print(f"Total Purina: {purina_count}")


if __name__ == "__main__":
    main()
