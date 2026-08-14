"""Move o peso da descrição para o nome nas rações de cães e gatos."""
from __future__ import annotations

import json
import re
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
SQL_PATH = Path(__file__).parent / "update_feed_weight_in_name.sql"
TENANT_ID = "a0000000-0000-4000-8000-000000000001"

EMBALAGEM_TAIL = re.compile(r"\s*Embalagem\s+.*$", re.IGNORECASE)


def should_update(product: dict) -> bool:
    if product.get("category") not in {"caes", "gatos"}:
        return False
    weight = (product.get("weight") or "").strip()
    if not weight or weight == "Sob consulta":
        return False
    name = product.get("name") or ""
    return "Embalagem" not in name


def new_name(product: dict) -> str:
    return f"{product['name'].rstrip()} - Embalagem {product['weight']}"


def new_description(product: dict) -> str | None:
    description = product.get("description") or ""
    cleaned = EMBALAGEM_TAIL.sub("", description).rstrip(" .")
    if cleaned:
        return f"{cleaned}."
    return description or None


def main() -> None:
    products = json.loads(PRODUCTS_PATH.read_text(encoding="utf-8"))
    updated = 0
    for product in products:
        if not should_update(product):
            continue
        product["name"] = new_name(product)
        product["description"] = new_description(product)
        updated += 1

    payload = json.dumps(products, ensure_ascii=False, indent=2) + "\n"
    PRODUCTS_PATH.write_text(payload, encoding="utf-8")
    if SEED_PATH.parent.exists():
        SEED_PATH.write_text(payload, encoding="utf-8")

    sql = f"""-- Move o peso da descrição para o nome (rações cães/gatos).
-- Só produtos com peso, sem 'Embalagem' no nome. Acessórios não entram.
UPDATE products
SET
  name = name || ' - Embalagem ' || weight,
  description = regexp_replace(description, '\\s*Embalagem\\s+.*$', '', 'i'),
  updated_at = NOW()
WHERE tenant_id = '{TENANT_ID}'
  AND category IN ('caes', 'gatos')
  AND weight IS NOT NULL
  AND btrim(weight) <> ''
  AND weight <> 'Sob consulta'
  AND name NOT ILIKE '%Embalagem%';
"""
    SQL_PATH.write_text(sql, encoding="utf-8")
    print(f"updated {updated} products -> {SQL_PATH}")


if __name__ == "__main__":
    main()
