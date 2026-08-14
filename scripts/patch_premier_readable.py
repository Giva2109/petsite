"""Corrige pesos PremieR só onde o valor impresso está legível e diverge do SKU."""
from __future__ import annotations

import json
import re
from pathlib import Path

from fix_bag_weight_on_images import (
    PRODUCTS_PATH,
    SEED_PATH,
    SQL_PATH,
    STEM_W,
    TENANT_ID,
    original_filename,
    patch_weight,
)

ROOT = Path(__file__).parent.parent
CATALOG = ROOT / "public" / "assets" / "products" / "catalog"


def rect(x0, y0, x1, y1):
    return [[x0, y0], [x1, y0], [x1, y1], [x0, y1]]


# Só casos com peso visível e diferente do SKU. Originais não são alterados.
PATCHES = [
    {
        "src": "page-33-img-01.webp",
        "dest": "page-33-img-01-w500g.webp",
        "label": "500g",
        "box": [
            [61.8, 811.1],
            [133.6, 812.6],
            [132.9, 856.1],
            [61.1, 855.1],
        ],
        "force_fg": (255, 255, 255),
        "ids": [148],
    },
    {
        "src": "page-30-img-01.webp",
        "dest": "page-30-img-01-w70g.webp",
        "label": "70g",
        "box": rect(60, 672, 112, 710),
        "force_fg": (255, 255, 255),
        "ids": [142],
    },
    {
        "src": "page-46-img-01.webp",
        "dest": "page-46-img-01-w70g.webp",
        "label": "70g",
        "box": rect(445, 705, 508, 738),
        "force_fg": (255, 255, 255),
        "ids": [162],
    },
    {
        "src": "page-41-img-02.webp",
        "dest": "page-41-img-02-w50g.webp",
        "label": "50g",
        "box": rect(430, 598, 522, 635),
        "force_fg": (36, 36, 34),
        "force_bg": (248, 247, 244),
        "ids": [127, 128],
    },
    {
        "src": "page-41-img-03.webp",
        "dest": "page-41-img-03-w40g.webp",
        "label": "40g",
        "box": rect(430, 598, 520, 635),
        "force_fg": (36, 36, 34),
        "force_bg": (248, 247, 244),
        "ids": [129],
    },
]


def write_sql(products: list[dict]) -> None:
    changed = [
        p
        for p in products
        if p.get("image") and STEM_W.search(Path(p["image"]).stem)
    ]
    changed.sort(key=lambda p: p["id"])
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
    print(f"sql ids={len(changed)} -> {SQL_PATH}")


def main() -> None:
    products = json.loads(PRODUCTS_PATH.read_text(encoding="utf-8"))
    by_id = {p["id"]: p for p in products}

    for item in PATCHES:
        src = CATALOG / item["src"]
        dest = CATALOG / item["dest"]
        if not src.exists():
            raise FileNotFoundError(src)
        patch_weight(
            src,
            dest,
            item["box"],
            item["label"],
            force_fg=item.get("force_fg"),
            force_bg=item.get("force_bg"),
        )
        new_rel = f"/assets/products/catalog/{item['dest']}"
        for pid in item["ids"]:
            by_id[pid]["image"] = new_rel
            print(f"  id={pid} {item['src']} -> {item['dest']} ({item['label']})")

    payload = json.dumps(products, ensure_ascii=False, indent=2) + "\n"
    PRODUCTS_PATH.write_text(payload, encoding="utf-8")
    if SEED_PATH.parent.exists():
        SEED_PATH.write_text(payload, encoding="utf-8")
    write_sql(products)


if __name__ == "__main__":
    main()
