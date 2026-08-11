# -*- coding: utf-8 -*-
"""Deep audit: map each catalog image to nearby PDF text and cross-check products.json."""
from __future__ import annotations

import json
import re
import sys
from collections import defaultdict
from pathlib import Path

import fitz

PDF_PATH = Path(
    r"C:\Users\givan\OneDrive\Desktop\GIVA\Mercado Livre\Pet_P2_P2p\Catálogo PremieRpet - 2026.pdf"
)
PRODUCTS_PATH = Path(r"c:\workspace_pet_shop\petsite\src\data\products.json")
IMG_DIR = Path(r"c:\workspace_pet_shop\petsite\public\assets\products\catalog")
REPORT_PATH = Path(r"c:\workspace_pet_shop\petsite\scripts\image_audit_report.txt")
FIX_MAP_PATH = Path(r"c:\workspace_pet_shop\petsite\scripts\image_fix_map.json")

MIN_PRODUCT_AREA = 8000
MIN_WIDTH = 70
MIN_HEIGHT = 70


def norm(s: str) -> str:
    s = s.upper()
    for a, b in {
        "Á": "A", "À": "A", "Ã": "A", "Â": "A", "É": "E", "Ê": "E", "Í": "I",
        "Ó": "O", "Ô": "O", "Õ": "O", "Ú": "U", "Ç": "C", "ﬁ": "FI", "ﬂ": "FL",
    }.items():
        s = s.replace(a, b)
    return re.sub(r"\s+", " ", s).strip()


def get_product_images_on_page(page) -> list[dict]:
    images = []
    for block in page.get_text("dict")["blocks"]:
        if block["type"] != 1:
            continue
        x0, y0, x1, y1 = block["bbox"]
        w, h = x1 - x0, y1 - y0
        if w * h < MIN_PRODUCT_AREA or w < MIN_WIDTH or h < MIN_HEIGHT:
            continue
        if h < w * 0.65 or (w > 400 and h < 100):
            continue
        images.append({"bbox": (x0, y0, x1, y1), "y": y0, "x": x0})
    images.sort(key=lambda i: (round(i["y"] / 50), i["x"]))
    return images


def voronoi_text(page, bbox, all_bboxes) -> str:
    """Words closer to this image center than to any other image."""
    x0, y0, x1, y1 = bbox
    cx, cy = (x0 + x1) / 2, (y0 + y1) / 2
    # Prefer words to the right / below bag (catalog layout)
    words = page.get_text("words")
    picked = []
    for w in words:
        wx0, wy0, wx1, wy1, word = w[:5]
        wcx, wcy = (wx0 + wx1) / 2, (wy0 + wy1) / 2
        # spatial window around image
        if wcx < x0 - 40 or wcx > x1 + 220:
            continue
        if wcy < y0 - 40 or wcy > y1 + 130:
            continue
        own = abs(wcx - cx) + abs(wcy - cy) * 0.7
        # bias: words right of image slightly preferred as "owned"
        if wcx >= x0:
            own *= 0.9
        closer_other = False
        for ob in all_bboxes:
            if ob == bbox:
                continue
            ocx = (ob[0] + ob[2]) / 2
            ocy = (ob[1] + ob[3]) / 2
            od = abs(wcx - ocx) + abs(wcy - ocy) * 0.7
            if wcx >= ob[0]:
                od *= 0.9
            if od + 12 < own:
                closer_other = True
                break
        if not closer_other:
            picked.append((wy0, wx0, word))
    picked.sort()
    return " ".join(w for _, _, w in picked)


def infer_attrs(text: str, page_header: str = "") -> dict:
    t = norm(text + " " + page_header)
    stage = None
    # order matters: more specific first
    if re.search(r"\bPOWER\s*TRAINING\b", t) and re.search(r"\bFILHOTE", t):
        stage = "FILHOTES"
        subline = "POWER TRAINING"
    elif re.search(r"\bPOWER\s*TRAINING\b", t) and re.search(r"\bADULTO", t):
        stage = "ADULTOS"
        subline = "POWER TRAINING"
    else:
        subline = None
        if re.search(r"\bFILHOTE", t):
            stage = "FILHOTES"
        elif re.search(r"\bSENIOR\b|\bSENIOR\b", t) or "SENIOR" in t:
            stage = "SENIOR"
        elif re.search(r"\bCASTRAD", t):
            stage = "CASTRADOS"
        elif re.search(r"\bADULTO", t):
            stage = "ADULTOS"
        elif re.search(r"\bLIGHT\b", t):
            stage = "ADULTOS"
            subline = "LIGHT"

    if re.search(r"\bMEGA\b", t):
        subline = "MEGA"
    if re.search(r"\bLIGHT\b", t):
        subline = (subline + "+LIGHT") if subline and "LIGHT" not in subline else (subline or "LIGHT")
    if re.search(r"\bSPECIAL\b", t):
        subline = "SPECIAL"

    porte = None
    if re.search(r"PORTE\s+PEQUENO|PEQUENO\b", t) and not re.search(r"MEDIO E GRANDE|GRANDE E GIGANTE", t):
        # if both pequeno and medio/grande, look at phrase
        if re.search(r"PORTE\s+PEQUENO", t):
            porte = "PEQUENO"
        elif re.search(r"PORTE\s+MEDIO|MEDIO E GRANDE|PORTES?\s+GRANDE", t):
            porte = None  # resolve below
    if re.search(r"PORTE\s+PEQUENO", t):
        porte = "PEQUENO"
    if re.search(r"PORTE\s+MEDIO(?:\s+E\s+GRANDE)?", t) or re.search(r"PORTES?\s+MEDIO", t):
        if porte != "PEQUENO" or "PORTE PEQUENO" not in t:
            porte = "MEDIO" if "PORTE PEQUENO" not in t.split("PORTE MEDIO")[0][-20:] else porte
    if re.search(r"PORTE\s+GRANDE|PORTES?\s+GRANDE|GRANDE E GIGANTE|MEGA", t):
        if "PORTE PEQUENO" not in t or subline == "MEGA":
            porte = "GRANDE"

    # Weight hints for porte when label ambiguous
    weights = re.findall(r"\b(\d+(?:[.,]\d+)?\s*KG|\d+\s*G)\b", t)
    wjoin = " ".join(weights)
    if porte is None:
        if re.search(r"10[,.]1\s*KG", wjoin) and "20KG" not in wjoin.replace(" ", "") and "15KG" not in wjoin.replace(" ", ""):
            porte = "PEQUENO"
        elif re.search(r"15\s*KG|20\s*KG", wjoin) and not re.search(r"10[,.]1", wjoin):
            porte = "MEDIO"  # or grande

    sabores = []
    for token in [
        "FRANGO", "CARNE", "SALMAO", "PERU", "CORDEIRO", "BANANA", "AVEIA", "MEL",
        "BLEND", "PEIXE", "ATUM", "ARROZ", "QUINOA", "MACA", "ESPINAFRE", "CENOURA",
        "ABOBORA", "BATATA", "MANDIOCA", "ORIGINAL",
    ]:
        if token in t:
            sabores.append(token)

    species = "GATOS" if re.search(r"\bGATO", t) else ("CAES" if re.search(r"\bCAES?\b|\bCAO\b", t) else None)
    if species is None and "GATOS" in norm(page_header):
        species = "GATOS"

    line = None
    if "GOLDEN SPECIAL" in t or subline == "SPECIAL":
        line = "GOLDEN SPECIAL"
    elif species == "GATOS" or "GOLDEN GATOS" in t:
        line = "GOLDEN GATOS"
    elif "PREMIER" in t or "PREMIE" in t:
        line = "PREMIER"
    elif "GOLDEN" in t or "GOLDEN" in norm(page_header):
        line = "GOLDEN"

    summary_bits = []
    if line:
        summary_bits.append(line)
    if subline:
        summary_bits.append(subline)
    if species:
        summary_bits.append(species)
    if stage:
        summary_bits.append(stage)
    if porte:
        summary_bits.append("PORTE " + porte)
    if sabores:
        summary_bits.append("Sabor:" + ",".join(sabores[:5]))
    if weights:
        summary_bits.append("bags:" + ",".join(weights[:5]))

    return {
        "stage": stage,
        "porte": porte,
        "sabor": sabores,
        "line": line,
        "subline": subline,
        "species": species,
        "weights": weights,
        "summary": " | ".join(summary_bits) if summary_bits else t[:180],
        "text_norm": t[:600],
        "raw": text[:400],
    }


def parse_product(name: str, category: str = "") -> dict:
    n = norm(name)
    c = norm(category)
    stage = None
    if "FILHOTE" in n:
        stage = "FILHOTES"
    elif "SENIOR" in n:
        stage = "SENIOR"
    elif "CASTRAD" in n:
        stage = "CASTRADOS"
    elif "ADULTO" in n or "LIGHT" in n:
        stage = "ADULTOS"

    porte = None
    m = re.search(r"PORTE\s+(GRANDE|MEDIO|PEQUENO)", n)
    if m:
        porte = m.group(1)

    sabores = [t for t in [
        "FRANGO", "CARNE", "SALMAO", "PERU", "CORDEIRO", "BANANA", "AVEIA", "MEL",
        "BLEND", "PEIXE", "ATUM", "ARROZ", "QUINOA", "MACA", "ESPINAFRE", "CENOURA",
        "ABOBORA", "BATATA", "MANDIOCA", "ORIGINAL",
    ] if t in n]

    species = "GATOS" if ("GATO" in n or "GATO" in c) else "CAES"
    line = None
    subline = None
    if "GOLDEN SPECIAL" in n:
        line, subline = "GOLDEN SPECIAL", "SPECIAL"
    elif "GOLDEN GATOS" in n or "GOURMET GATOS" in n:
        line = "GOLDEN GATOS"
    elif "GOLDEN" in n:
        line = "GOLDEN"
    elif "PREMIER" in n or "PREMIE" in n:
        line = "PREMIER"

    if "POWER" in n:
        subline = "POWER TRAINING"
    if "MEGA" in n:
        subline = "MEGA"
    if "LIGHT" in n:
        subline = "LIGHT"

    return {
        "stage": stage,
        "porte": porte,
        "sabor": sabores,
        "line": line,
        "subline": subline,
        "species": species,
        "norm": n,
    }


def score(prod: dict, img: dict) -> tuple[int, list[str]]:
    reasons = []
    sc = 0

    # Species hard constraint
    if prod.get("species") and img.get("species") and prod["species"] != img["species"]:
        sc -= 40
        reasons.append(f"species: product={prod['species']} vs image={img['species']}")

    # Stage
    if prod.get("stage") and img.get("stage"):
        if prod["stage"] == img["stage"]:
            sc += 12
        else:
            sc -= 22
            reasons.append(f"stage: product={prod['stage']} vs image={img['stage']}")

    # Porte
    if prod.get("porte") and img.get("porte"):
        if prod["porte"] == img["porte"]:
            sc += 10
        else:
            # MEDIO product vs GRANDE image sometimes OK for "medio e grande" bags
            if {prod["porte"], img["porte"]} == {"MEDIO", "GRANDE"}:
                sc += 2
                reasons.append(f"porte soft: product={prod['porte']} vs image={img['porte']}")
            else:
                sc -= 16
                reasons.append(f"porte: product={prod['porte']} vs image={img['porte']}")

    # Subline (MEGA / LIGHT / POWER / SPECIAL)
    if prod.get("subline"):
        it = img.get("text_norm", "")
        if prod["subline"] == "LIGHT":
            if "LIGHT" in it or img.get("subline") and "LIGHT" in (img.get("subline") or ""):
                sc += 14
            else:
                sc -= 18
                reasons.append("subline: product LIGHT but image not Light")
        elif prod["subline"] == "MEGA":
            if "MEGA" in it:
                sc += 14
            else:
                sc -= 10
        elif prod["subline"] == "POWER TRAINING":
            if "POWER" in it:
                sc += 14
            else:
                sc -= 10
        elif prod["subline"] == "SPECIAL":
            if "SPECIAL" in it:
                sc += 8

    # Porte Grande without MEGA in name: prefer MEGA Adultos bag on page 11 style pages
    if prod.get("porte") == "GRANDE" and prod.get("stage") == "ADULTOS":
        it = img.get("text_norm", "")
        if "MEGA" in it and "ADULTO" in it:
            sc += 15
        if "POWER" in it and "FILHOTE" in it:
            sc -= 25
            if "Power Training Filhotes used for Adultos Grande" not in ";".join(reasons):
                reasons.append("Adultos Porte Grande mapped to Power Training Filhotes imagery")

    # Sabor
    ps = set(prod.get("sabor") or [])
    # ignore ARROZ alone as weak
    weak = {"ARROZ"}
    ps2 = ps - weak
    is2 = set(img.get("sabor") or []) - weak
    if ps2 and is2:
        if ps2 & is2:
            sc += 8
            # extra for distinctive
            for d in ["SALMAO", "ATUM", "BANANA", "QUINOA", "ORIGINAL", "CARNE", "FRANGO", "PERU"]:
                if d in ps2 and d in is2:
                    sc += 2
        else:
            sc -= 12
            reasons.append(f"sabor: product={sorted(ps2)} vs image={sorted(is2)}")

    # Line soft
    if prod.get("line") and img.get("line"):
        if prod["line"] == img["line"]:
            sc += 4
        elif "GATOS" in prod["line"] and "GATOS" not in (img.get("line") or ""):
            sc -= 20
            reasons.append(f"line: product={prod['line']} vs image={img['line']}")

    return sc, reasons


def greedy_assign(unique_prods: list[dict], images: list[dict]) -> dict[str, dict]:
    """Assign each unique product name to best available image on page."""
    # score matrix
    pairs = []
    for p in unique_prods:
        attrs = parse_product(p["name"], p.get("category", ""))
        for im in images:
            sc, reasons = score(attrs, im["attrs"])
            pairs.append((sc, p["name"], im, reasons, attrs))
    pairs.sort(key=lambda x: -x[0])
    assigned_names = set()
    assigned_paths = set()
    result = {}
    for sc, name, im, reasons, attrs in pairs:
        if name in assigned_names or im["path"] in assigned_paths:
            continue
        assigned_names.add(name)
        assigned_paths.add(im["path"])
        result[name] = {"image": im, "score": sc, "reasons": reasons, "attrs": attrs}
        if len(assigned_names) == len(unique_prods):
            break
    # leftover names: best image even if reused
    for p in unique_prods:
        if p["name"] in result:
            continue
        attrs = parse_product(p["name"], p.get("category", ""))
        best = None
        for im in images:
            sc, reasons = score(attrs, im["attrs"])
            if best is None or sc > best[0]:
                best = (sc, im, reasons, attrs)
        if best:
            result[p["name"]] = {
                "image": best[1],
                "score": best[0],
                "reasons": best[2],
                "attrs": best[3],
            }
    return result


def main():
    sys.stdout.reconfigure(encoding="utf-8")
    products = json.loads(PRODUCTS_PATH.read_text(encoding="utf-8"))
    doc = fitz.open(PDF_PATH)

    by_page: dict[int, list] = defaultdict(list)
    for p in products:
        by_page[p["catalogPage"]].append(p)

    inventory_lines = []
    page_images: dict[int, list] = {}
    page_assignments: dict[int, dict] = {}

    for page_num in sorted(by_page.keys()):
        if page_num < 1 or page_num > doc.page_count:
            continue
        page = doc[page_num - 1]
        header = page.get_text("text", clip=fitz.Rect(0, 0, page.rect.width, 140))
        imgs_raw = get_product_images_on_page(page)
        bboxes = [i["bbox"] for i in imgs_raw]
        images = []
        inventory_lines.append(f"\n{'=' * 80}")
        inventory_lines.append(f"PDF PAGE {page_num} — {len(imgs_raw)} product image region(s)")
        inventory_lines.append(f"Header: {norm(header)[:240]}")

        if not imgs_raw:
            fname = f"page-{page_num:02d}-full.webp"
            path = f"/assets/products/catalog/{fname}"
            exists = (IMG_DIR / fname).exists()
            attrs = infer_attrs(header, header)
            inventory_lines.append(f"  [full] {fname} exists={exists} | {attrs['summary']}")
            if exists:
                images.append({"idx": 0, "path": path, "attrs": attrs, "fname": fname})
        else:
            for i, im in enumerate(imgs_raw):
                raw = voronoi_text(page, im["bbox"], bboxes)
                attrs = infer_attrs(raw, header)
                fname = f"page-{page_num:02d}-img-{i + 1:02d}.webp"
                path = f"/assets/products/catalog/{fname}"
                exists = (IMG_DIR / fname).exists()
                inventory_lines.append(f"  img-{i + 1:02d} {fname} exists={exists}")
                inventory_lines.append(f"    INFERRED: {attrs['summary']}")
                inventory_lines.append(f"    NEAR: {raw[:260]}")
                if exists:
                    images.append({"idx": i + 1, "path": path, "attrs": attrs, "fname": fname})

        page_images[page_num] = images

        # unique products on page (by name, first id order)
        seen = set()
        uniques = []
        for p in sorted(by_page[page_num], key=lambda x: x["id"]):
            if p["name"] not in seen:
                seen.add(p["name"])
                uniques.append(p)
        page_assignments[page_num] = greedy_assign(uniques, images) if images else {}

    # Build report rows
    report_rows = []
    mismatches = []
    corrections = {}  # name -> path

    by_name = defaultdict(list)
    for p in products:
        by_name[p["name"]].append(p)

    for p in sorted(products, key=lambda x: (x["catalogPage"], x["id"])):
        page_num = p["catalogPage"]
        images = page_images.get(page_num, [])
        assign = page_assignments.get(page_num, {}).get(p["name"])

        current = p["image"]
        current_img = next((im for im in images if im["path"] == current), None)
        # also search all pages
        if current_img is None:
            for ims in page_images.values():
                for im in ims:
                    if im["path"] == current:
                        current_img = im
                        break

        prod_attrs = parse_product(p["name"], p.get("category", ""))
        if current_img:
            cur_score, cur_reasons = score(prod_attrs, current_img["attrs"])
            inferred = current_img["attrs"]["summary"]
        else:
            cur_score, cur_reasons = -99, ["current image file not in page inventory"]
            inferred = "(missing from inventory)"

        suggested = assign["image"]["path"] if assign else current
        sug_score = assign["score"] if assign else cur_score

        is_mismatch = False
        reason_parts = list(cur_reasons)

        if suggested != current and sug_score >= cur_score + 6:
            is_mismatch = True
            reason_parts.append(
                f"better match: {suggested} (score {sug_score} vs {cur_score}; "
                f"{assign['image']['attrs']['summary'] if assign else ''})"
            )
        if cur_reasons and any(
            k in r for r in cur_reasons for k in ("stage:", "porte:", "sabor:", "species:", "subline:", "Adultos Porte Grande")
        ):
            is_mismatch = True
        if cur_score <= -10:
            is_mismatch = True

        # If suggested equals current and no hard reasons, OK
        if not cur_reasons and suggested == current and cur_score >= 0:
            is_mismatch = False
            reason_parts = ["OK"]

        mismatch = "YES" if is_mismatch else "NO"
        reason = "; ".join(reason_parts) if reason_parts else "OK"

        if is_mismatch:
            corrections[p["name"]] = suggested
            mismatches.append(p["id"])

        report_rows.append({
            "id": p["id"],
            "name": p["name"],
            "weight": p["weight"],
            "catalogPage": page_num,
            "current_image": current,
            "inferred": inferred,
            "mismatch": mismatch,
            "reason": reason,
            "suggested": suggested,
            "score": cur_score,
            "sug_score": sug_score,
        })

    # Aggregate unique-name mismatches
    mismatch_rows = [r for r in report_rows if r["mismatch"] == "YES"]
    mismatch_names = sorted({r["name"] for r in mismatch_rows})

    # Worst offenders: unique names sorted by score
    worst = []
    seen = set()
    for r in sorted(mismatch_rows, key=lambda x: (x["score"], -x["sug_score"])):
        if r["name"] in seen:
            continue
        seen.add(r["name"])
        worst.append(r)

    lines = []
    lines.append("PRODUCT IMAGE AUDIT REPORT")
    lines.append(f"PDF: {PDF_PATH}")
    lines.append(f"Products: {len(products)}")
    lines.append(f"Unique names: {len(by_name)}")
    lines.append(f"Mismatch product rows: {len(mismatch_rows)}")
    lines.append(f"Mismatch unique names: {len(mismatch_names)}")
    lines.append("")
    lines.append("KNOWN BUG CHECKS:")
    for needle in [
        "Golden - Adultos - Porte Grande - Sabor Frango e Arroz",
        "Golden Gatos - Adultos - Sabor Frango",
    ]:
        rows = [r for r in report_rows if r["name"] == needle]
        if rows:
            r = rows[0]
            lines.append(
                f"  * {needle}: current={r['current_image']} inferred={r['inferred']} "
                f"mismatch={r['mismatch']} suggested={r['suggested']}"
            )
    lines.append("")
    lines.append("#" * 80)
    lines.append("SECTION A — PDF IMAGE INVENTORY (inferred content per on-disk image)")
    lines.append("#" * 80)
    lines.extend(inventory_lines)
    lines.append("")
    lines.append("#" * 80)
    lines.append("SECTION B — PER-PRODUCT CROSS-CHECK")
    lines.append("#" * 80)
    for r in report_rows:
        lines.append("-" * 70)
        lines.append(f"ID: {r['id']}")
        lines.append(f"Name: {r['name']}")
        lines.append(f"Weight: {r['weight']}")
        lines.append(f"CatalogPage: {r['catalogPage']}")
        lines.append(f"Current image: {r['current_image']}")
        lines.append(f"Inferred image content: {r['inferred']}")
        lines.append(f"Mismatch: {r['mismatch']}")
        lines.append(f"Reason: {r['reason']}")
        lines.append(f"Suggested image: {r['suggested']}")
        lines.append(f"Scores: current={r['score']} suggested={r['sug_score']}")

    lines.append("")
    lines.append("#" * 80)
    lines.append("SECTION C — MISMATCH SUMMARY (worst offenders)")
    lines.append("#" * 80)
    for r in worst:
        lines.append(
            f"* [cur={r['score']} sug={r['sug_score']}] p{r['catalogPage']} | {r['name']}"
        )
        lines.append(f"    {r['current_image']} -> {r['suggested']}")
        lines.append(f"    reason: {r['reason']}")
        lines.append(f"    inferred(current): {r['inferred']}")

    lines.append("")
    lines.append("#" * 80)
    lines.append("SECTION D — PAGE ASSIGNMENT TABLE (unique name -> suggested image)")
    lines.append("#" * 80)
    for page_num in sorted(page_assignments.keys()):
        lines.append(f"\nPage {page_num}:")
        for name, info in page_assignments[page_num].items():
            cur = next(p["image"] for p in by_name[name] if p["catalogPage"] == page_num)
            mark = "MISMATCH" if cur != info["image"]["path"] else "ok"
            lines.append(
                f"  [{mark}] {name[:70]} -> {info['image']['fname']} "
                f"(score={info['score']}) | {info['image']['attrs']['summary'][:100]}"
            )

    REPORT_PATH.write_text("\n".join(lines), encoding="utf-8")

    all_by_name = {}
    for name, group in by_name.items():
        all_by_name[name] = corrections.get(name, group[0]["image"])

    payload = {
        "_meta": {
            "description": "Map product name -> correct catalog image path. Weight variants share the same bag image.",
            "mismatch_product_rows": len(mismatch_rows),
            "mismatch_unique_names": len(mismatch_names),
            "total_products": len(products),
            "total_unique_names": len(by_name),
        },
        "corrections_only": corrections,
        "by_name": all_by_name,
    }
    FIX_MAP_PATH.write_text(json.dumps(payload, ensure_ascii=False, indent=2), encoding="utf-8")

    print(f"REPORT: {REPORT_PATH}")
    print(f"FIX_MAP: {FIX_MAP_PATH}")
    print(f"mismatch_rows={len(mismatch_rows)} mismatch_names={len(mismatch_names)}")
    print("KNOWN:")
    for needle in [
        "Golden - Adultos - Porte Grande - Sabor Frango e Arroz",
        "Golden Gatos - Adultos - Sabor Frango",
    ]:
        r = next(x for x in report_rows if x["name"] == needle)
        print(f"  {needle}")
        print(f"    {r['current_image']} -> {r['suggested']} | {r['inferred'][:120]}")
        print(f"    mismatch={r['mismatch']} reason={r['reason'][:180]}")
    print("WORST 12:")
    for r in worst[:12]:
        print(f"  p{r['catalogPage']} {r['score']}: {r['name'][:65]}")
        print(f"    {r['current_image'].split('/')[-1]} -> {r['suggested'].split('/')[-1]}")


if __name__ == "__main__":
    main()
