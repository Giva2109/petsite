"""Parse Purina price PDF and compare with products.json."""
from __future__ import annotations

import json
import re
import unicodedata
from difflib import SequenceMatcher
from pathlib import Path

import pdfplumber

PDF_PATH = Path(
    r"C:\Users\givan\OneDrive\Desktop\GIVA\Mercado Livre\Purina\Tabela de valores Purina 16-07.pdf"
)
PRODUCTS_PATH = Path(__file__).parent.parent.parent / "src" / "data" / "products.json"
OUT_DIR = Path(__file__).parent
PRICES_PATH = OUT_DIR / "purina_prices.json"
MISSING_PATH = OUT_DIR / "purina_missing.json"

BRAND_PAGES: dict[str, tuple[int, int]] = {
    "PRO PLAN": (5, 9),
    "PROPLAN": (5, 9),
    "PPVD": (5, 9),
    "PURINA ONE": (11, 13),
    "ONE CAT": (11, 13),
    "ONE DOG": (11, 13),
    "DENTALIFE": (15, 15),
    "FANCY FEAST": (17, 17),
    "DOGUITOS": (19, 19),
    "CAT CHOW": (21, 21),
    "DOG CHOW": (23, 25),
    "FRISKIES": (27, 29),
    "ALPO": (31, 31),
    "GATSY": (31, 31),
}

BRAND_SLUG: dict[str, str] = {
    "PRO PLAN": "proplan",
    "PURINA ONE": "purinaone",
    "DENTALIFE": "dentalife",
    "FANCY FEAST": "fancy-feast",
    "DOGUITOS": "doguitos",
    "CAT CHOW": "catchow",
    "DOG CHOW": "dogchow",
    "FRISKIES": "friskies",
    "ALPO": "alpo",
}


def norm(s: str) -> str:
    s = unicodedata.normalize("NFKD", s).encode("ascii", "ignore").decode("ascii")
    s = s.upper().strip()
    return re.sub(r"\s+", " ", s)


LINE_RE = re.compile(r"^(\d{3,4})\s+(.+?)\s+([\d]+(?:[.,]\d+)?)\s*$")


def parse_pdf() -> list[dict]:
    items: list[dict] = []
    with pdfplumber.open(PDF_PATH) as pdf:
        for page in pdf.pages:
            text = page.extract_text() or ""
            for ln in text.split("\n"):
                ln = ln.strip()
                if not ln or ln.startswith("TABELA") or ln.startswith("CÓDIGO") or ln.startswith("CODIGO"):
                    continue
                m = LINE_RE.match(ln)
                if not m:
                    continue
                code = int(m.group(1))
                desc = m.group(2).strip()
                price = float(m.group(3).replace(",", "."))
                items.append({"code": code, "desc": desc, "price": price})
    return items


def extract_weight_from_desc(desc: str) -> str:
    desc_u = desc.upper()
    m = re.search(r"(\d+)\s*X\s*(\d+(?:[.,]\d+)?)\s*G\b", desc_u)
    if m:
        return f"{m.group(1)}x{m.group(2).replace(',', '.')}g"
    m = re.search(r"(\d+(?:[.,]\d+)?)\s*KG\b", desc_u)
    if m:
        return f"{m.group(1).replace(',', '.')}kg"
    m = re.search(r"(\d+(?:[.,]\d+)?)\s*G\b", desc_u)
    if m:
        return f"{m.group(1).replace(',', '.')}g"
    return ""


def detect_brand(desc: str) -> str:
    d = norm(desc)
    if d.startswith("PPVD") or d.startswith("PP "):
        return "PRO PLAN"
    if "ONE CAT" in d or "ONE DOG" in d:
        return "PURINA ONE"
    for key in sorted(BRAND_PAGES, key=len, reverse=True):
        if key in d:
            return key.replace("PROPLAN", "PRO PLAN")
    return "UNKNOWN"


def catalog_page_for(desc: str) -> int | None:
    d = norm(desc)
    for key, (lo, _hi) in sorted(BRAND_PAGES.items(), key=lambda x: -len(x[0])):
        if key in d:
            return lo
    return None


def category_for(desc: str) -> str:
    d = norm(desc)
    if any(k in d for k in ("DOG CHOW", "DOGUITOS", "ALPO", "ONE DOG", "PPVD CANINE")):
        return "caes"
    if any(k in d for k in ("CAT CHOW", "FRISKIES", "FANCY FEAST", "ONE CAT", "PPVD FELINE", "GATSY")):
        return "gatos"
    if "DENTALIFE" in d:
        return "caes" if "CAES" in d or "CAO" in d else "gatos"
    if "PRO PLAN" in d or "PROPLAN" in d or d.startswith("PP "):
        if any(k in d for k in ("CAT", "KITTEN", "FELINE", "GATO")):
            return "gatos"
        if any(k in d for k in ("CANINE", "PUPPY", "DOG", "CAES", "CAO")):
            return "caes"
    if "ONE " in d:
        return "gatos" if "CAT" in d else "caes"
    return "gatos" if "GATO" in d or "CAT" in d else "caes"


def slugify(desc: str) -> str:
    brand = detect_brand(desc)
    prefix = BRAND_SLUG.get(brand, brand.lower().replace(" ", "-"))
    d = norm(desc).lower()
    d = re.sub(r"[^a-z0-9]+", "-", d)
    d = re.sub(r"-+", "-", d).strip("-")
    if prefix != "unknown":
        for strip in (prefix, prefix.replace("-", " "), "cat-chow", "dog-chow", "fancy-feast", "pro-plan"):
            d = re.sub(rf"^{re.escape(strip)}-", "", d)
    slug = f"purina-{prefix}-{d}" if prefix != "unknown" and d else f"purina-{prefix}" if prefix != "unknown" else f"purina-{d}"
    return re.sub(r"-+", "-", slug).strip("-")[:90]


SYNONYMS = {
    "ADULTOS": {"ADULT", "ADULTOS", "ADULTO", "7+", "7 PLUS", "LONGEVIDADE"},
    "FILHOTES": {"FILHOTE", "FILHOTES", "KITTEN", "PUPPY", "PAPITA"},
    "CASTRADOS": {"CASTRADO", "CASTRADOS", "STERILIZED", "STERILISED"},
    "FRANGO": {"FRANGO", "FRAN", "CHICKEN"},
    "CARNE": {"CARNE", "MEAT", "CARN"},
    "PEIXE": {"PEIXE", "FISH", "SALMAO", "SALMON", "ATUM", "TUNA"},
    "MINI": {"MINI", "MINIS", "PEQUENO", "PEQUENOS", "PEQ", "MINI&PEQ", "MINI E PEQ"},
    "MEDIO": {"MEDIO", "MEDIOS", "MED", "GRANDE", "GRANDES", "GDE", "MED&GDE", "MEDIOS E GRANDES"},
    "URINARIO": {"URINARIO", "URINARY", "TRATO URINARIO"},
    "REDUZIDA": {"REDUZIDA", "REDUCED", "CALORIE", "CALORIAS", "CONTROLE PESO", "PESO"},
    "LIVECLEAR": {"LIVECLEAR", "LIVE CLEAR", "ALERGENO", "ALERGENOS"},
    "ACTIVE": {"ACTIVE", "MENTE ATIVA", "ACTIVE MIND"},
    "ORAL": {"ORAL", "SAUDE ORAL"},
    "SACHET": {"SACHET", "SACHE", "SACHEt"},
    "PETISCO": {"PETISCO", "PETISCOS", "BISCOITO", "BIFINHO"},
    "MIX": {"MIX", "MEGAMIX", "MULTI"},
    "GRANJA": {"GRANJA", "DELICIAS DA GRANJA"},
    "MAR": {"MAR DE SABORES", "MAR"},
}


def normalize_weight(w: str) -> str:
    w = norm(w).replace(" ", "").replace(",", ".")
    m = re.match(r"(\d+)X(\d+(?:\.\d+)?)G", w)
    if m:
        return f"{m.group(1)}x{m.group(2)}g"
    m = re.match(r"(\d+(?:\.\d+)?)KG", w)
    if m:
        val = m.group(1)
        if val.endswith(".0"):
            val = val[:-2]
        return f"{val}kg"
    m = re.match(r"(\d+(?:\.\d+)?)G", w)
    if m:
        return f"{m.group(1)}g"
    return w.lower()


def canonical_tokens(text: str) -> set[str]:
    t = norm(text)
    tokens: set[str] = set()
    for canonical, variants in SYNONYMS.items():
        if any(v in t for v in variants):
            tokens.add(canonical)
    for flavor in ("FRANGO", "CARNE", "PEIXE", "CORDEIRO", "PERU", "ATUM", "SALMAO", "ARROZ"):
        if flavor in t or (flavor == "FRANGO" and "FRAN" in t.split()):
            tokens.add(flavor if flavor != "FRANGO" else "FRANGO")
    for brand in (
        "PRO PLAN",
        "CAT CHOW",
        "DOG CHOW",
        "FRISKIES",
        "FANCY FEAST",
        "DENTALIFE",
        "DOGUITOS",
        "ALPO",
        "PURINA ONE",
        "PPVD",
        "GATSY",
    ):
        key = brand.replace(" ", "_")
        if brand in t or (brand == "PRO PLAN" and ("PRO PLAN" in t or "PP " in t)):
            tokens.add(key)
        if brand == "PURINA ONE" and ("ONE CAT" in t or "ONE DOG" in t):
            tokens.add(key)
    return tokens


def product_match_key(p: dict) -> tuple[set[str], str]:
    text = p.get("name", "") + " " + p.get("description", "")
    return canonical_tokens(text), normalize_weight(p.get("weight", ""))


def pdf_match_key(item: dict) -> tuple[set[str], str]:
    return canonical_tokens(item["desc"]), normalize_weight(extract_weight_from_desc(item["desc"]))


def fuzzy_score(pdf_item: dict, product: dict) -> float:
    pt, pw = product_match_key(product)
    dt, dw = pdf_match_key(pdf_item)

    p_brands = {t for t in pt if t in {
        "PRO_PLAN", "CAT_CHOW", "DOG_CHOW", "FRISKIES", "FANCY_FEAST",
        "DENTALIFE", "DOGUITOS", "ALPO", "PURINA_ONE", "PPVD", "GATSY",
    }}
    d_brands = {t for t in dt if t in p_brands or t.replace("_", " ") in BRAND_PAGES}
    if p_brands and d_brands and not (p_brands & d_brands):
        # PRO PLAN vs PPVD are different
        return 0.0

    overlap = len(pt & dt) / max(len(pt | dt), 1)
    weight_score = 1.0 if pw and dw and pw == dw else (0.0 if pw and dw and pw != dw else 0.4)
    ratio = SequenceMatcher(None, norm(product.get("name", "")), norm(pdf_item["desc"])).ratio()
    return overlap * 0.55 + weight_score * 0.35 + ratio * 0.10


def find_match(pdf_item: dict, products: list[dict], threshold: float = 0.48):
    best = None
    best_score = 0.0
    for p in products:
        s = fuzzy_score(pdf_item, p)
        if s > best_score:
            best_score = s
            best = p
    if best_score >= threshold:
        return best, best_score
    return None, best_score


def main() -> None:
    products = json.loads(PRODUCTS_PATH.read_text(encoding="utf-8"))
    purina = [p for p in products if p.get("line") == "Purina"]

    prices = parse_pdf()
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    PRICES_PATH.write_text(json.dumps(prices, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    missing: list[dict] = []
    matched: list[dict] = []
    for item in prices:
        match, score = find_match(item, purina)
        if match:
            matched.append(
                {
                    **item,
                    "matched_id": match["id"],
                    "matched_name": match["name"],
                    "score": round(score, 3),
                }
            )
        else:
            w = extract_weight_from_desc(item["desc"])
            missing.append(
                {
                    "code": item["code"],
                    "desc": item["desc"],
                    "price": item["price"],
                    "suggested": {
                        "slug": slugify(item["desc"]),
                        "catalogPage": catalog_page_for(item["desc"]),
                        "category": category_for(item["desc"]),
                        "weight": w,
                    },
                    "best_partial_score": round(score, 3),
                }
            )

    MISSING_PATH.write_text(json.dumps(missing, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    print(f"EXISTING_PURINA={len(purina)}")
    print(f"PRICE_TABLE={len(prices)}")
    print(f"MATCHED={len(matched)}")
    print(f"MISSING={len(missing)}")
    print("---EXISTING---")
    for p in sorted(purina, key=lambda x: x["id"]):
        print(f"{p['id']}\t{p['weight']}\t{p['name']}")
    print("---TOP30_MISSING---")
    for m in missing[:30]:
        s = m["suggested"]
        print(
            f"{m['code']}\t{m['desc']}\t{m['price']}\t"
            f"{s['slug']}\t{s['catalogPage']}\t{s['category']}\t{s['weight']}"
        )


if __name__ == "__main__":
    main()
