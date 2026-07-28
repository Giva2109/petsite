"""
Aplica preços sugeridos da Tabela 0525.pdf em products.json.
Para produtos com (N UN) ou (N UND), multiplica preço sugerido x quantidade.

Execute: python scripts/apply_prices.py
"""
from __future__ import annotations

import json
import re
import unicodedata
from dataclasses import dataclass, field
from pathlib import Path

import pdfplumber

PDF_PATH = Path(
    r"C:\Users\givan\OneDrive\Desktop\GIVA\Mercado Livre\Pet_P2_P2p\Tabela 0525.pdf"
)
PRODUCTS_PATH = Path(__file__).parent.parent / "src" / "data" / "products.json"
REPORT_PATH = Path(__file__).parent / "price_match_report.txt"

LINE_HINTS: dict[str, list[str]] = {
    "GOLDEN FORMULA": ["Golden"],
    "GOLDEN ESPECIAIS": ["Golden"],
    "GOLDEN COOKIES": ["Golden"],
    "GOLDEN GATOS": ["Golden Gatos"],
    "GOLDEN GOURMET GATOS": ["Golden Gourmet Gatos"],
    "GOLDEN SELECAO NATURAL CAES": ["Golden Seleção Natural Cães"],
    "GOLDEN SELECAO NATURAL GATOS": ["Golden Seleção Natural Gatos"],
    "NATTU CAES": ["Nattu Cães"],
    "NATTU GATOS": ["Nattu Gatos"],
    "PREMIER AMBIENTES INTERNOS CAES": ["PremieR Ambientes Internos"],
    "PREMIER AMBIENTES INTERNOS GATOS": ["PremieR Ambientes Internos"],
    "PREMIER COOKIES CAES": ["PremieR Cookie"],
    "PREMIER COOKIE GATOS": ["PremieR Cookie"],
    "PREMIER FORMULA CAES": ["PremieR Formula Cães"],
    "PREMIER FORMULA GATOS": ["PremieR Formula Gatos"],
    "PREMIER FORM UMIDOS CAES": ["PremieR Formula Úmidos"],
    "PREMIER FORM UMIDOS GATOS": ["PremieR Formula Úmidos"],
    "PREMIER GOURMET CAES": ["PremieR Gourmet"],
    "PREMIER GOURMET GATOS": ["PremieR Gourmet"],
    "PREMIER NATTU UMIDOS CAES": ["Nattu Úmidos", "Nattu Cães"],
    "PREMIER NATTU UMIDOS GATOS": ["Nattu Gatos"],
    "PREMIER NUTR CLIN UMIDOS CAES": ["PremieR Formula Úmidos"],
    "PREMIER NUTR CLIN UMIDOS GATOS": ["PremieR Formula Úmidos"],
    "PREMIER NUTR CLIN UMIDOS CAES GATOS": ["PremieR Formula Úmidos"],
    "PREMIER NUTRICAO CLINICA CAES": [],
    "PREMIER NUTRICAO CLINICA GATOS": [],
    "PREMIER RACAS ESPECIFICAS": ["PremieR Raças Específicas"],
    "PREMIER SELECAO NATURAL CAES": ["PremieR Seleção Natural"],
    "PREMIER SELECAO NATURAL GATOS": ["PremieR Seleção Natural"],
    "VITTA NATURAL CAES": ["Vitta Natural"],
    "VITTA NATURAL GATOS": ["Vitta Natural"],
}

PRODUCT_LINE_ALIASES: dict[str, list[str]] = {
    "PremieR Gatos": ["PREMIER AMBIENTES INTERNOS GATOS"],
}

BLOCKED_SUBFAMILIES: dict[str, set[str]] = {
    "PremieR Gatos": {"PREMIER NUTRICAO CLINICA GATOS"},
    "PremieR Formula Gatos": {"PREMIER NUTRICAO CLINICA GATOS"},
    "PremieR Orgânico": {"PREMIER GOURMET CAES", "PREMIER GOURMET GATOS", "GOLDEN GOURMET GATOS"},
    "Vitta Natural": {"PREMIER NUTRICAO CLINICA CAES", "PREMIER NUTRICAO CLINICA GATOS"},
}

# Preços finais por ID quando não há correspondência automática confiável.
MANUAL_PRICE_OVERRIDES: dict[int, float] = {
    13: 22.50,   # GOLDEN FORM CÃES AD CARNE MINI BITS 1 KG
    25: 23.90,   # GOLDEN FORM CÃES FIL CARNE MINI BITS 1 KG
    32: 144.90,  # GOLDEN FORM CÃES FIL CARNE MINI BITS 10,1 KG
    33: 23.90,   # GOLDEN FORM CÃES FIL CARNE MINI BITS 1 KG
    35: 144.90,  # GOLDEN FORM CÃES FIL FRANGO MINI BITS 10,1 KG
    45: 59.90,   # GOLDEN FORM CÃES AD SENIOR MINI BITS 3 KG
    62: 59.80,   # GOLDEN GOURMET GATOS AD CAST CARNE 70 G (20 UN) = 2,99 x 20
    68: 24.90,   # GOLDEN SELEÇÃO NATUR CÃES ADULT MINI BITS 1 KG
    73: 23.90,   # GOLDEN FORM CÃES FIL FRANGO 1 KG
    75: 23.90,   # GOLDEN FORM CÃES FIL FRANGO 1 KG
    102: 289.90, # NATTU GRAIN FREE 10,1 KG
    103: 114.90, # NATTU GRAIN FREE 2,5 KG
    108: 159.80, # NATTU ÚMIDOS FRAN/BAT DOCE 85 G (20 UN) = 7,99 x 20
    110: 149.80, # NATTU ÚMIDOS GATOS FIL FRAN/ABÓB 70 G (20 UN) = 7,49 x 20
    111: 149.80,
    127: 6.49,   # COOKIE FRUT VERM 50 G (referência mais próxima)
    128: 6.49,
    145: 82.90,  # AMB INT GATOS AD PELO LONG FRANG 1,5 KG
    146: 32.50,  # AMB INT GATOS AD CAST 0,5 KG (500 g)
    147: 89.90,  # AMB INT GATOS FIL FRANG 1,5 KG
    148: 32.50,  # AMB INT GATOS FIL FRANG 0,5 KG
    149: 221.90, # AMB INT GATOS FIL FRANG 7,5 KG
    150: 89.90,  # AMB INT GATOS AD LIGHT SALM 1,5 KG
    151: 221.90, # AMB INT GATOS AD LIGHT SALM 7,5 KG
    161: 170.80, # PREMIER GOURMET ORGAN FRAN 85 G (20 UN) = 8,54 x 20
    162: 159.80, # PREMIER GOURMET GATOS AD ORGAN FRAN 70 G (20 UN) = 7,99 x 20
    50: 179.90,  # GOLDEN FORM GATOS AD CAST 10,1 KG
    51: 32.90,   # GOLDEN FORM GATOS AD CAST 1 KG
    52: 75.90,   # GOLDEN FORM GATOS AD CAST 3 KG
    53: 179.90,  # GOLDEN FORM GATOS AD CAST CARNE 10,1 KG
    54: 75.90,   # GOLDEN FORM GATOS AD CAST CARNE 3 KG
    55: 75.90,   # GOLDEN FORM GATOS AD CAST CARNE 3 KG
}

FLAVOR_SYNONYMS = {
    "FRAN": "FRANGO",
    "FRANGO": "FRANGO",
    "ORGAN FRAN": "FRANGO",
    "ORGAN": "FRANGO",
    "ORIGINAL": "ORIGINAL",
    "CARNE": "CARNE",
    "SALM": "SALMAO",
    "SALMAO": "SALMAO",
    "ATUM": "ATUM",
    "PERU": "PERU",
    "ARROZ": "ARROZ",
    "CER": "CEREAL",
    "MANDIOCA": "MANDIOCA",
    "BATATA": "BATATA",
    "DOCE": "DOCE",
    "ABOB": "ABOBORA",
    "ABOBORA": "ABOBORA",
    "BROCOLIS": "BROCOLIS",
    "QUINOA": "QUINOA",
    "CHIA": "CHIA",
    "FRUT VERM": "FRUTAS VERMELHAS",
    "COCO E AVEIA": "COCO AVEIA",
    "COCO AVEIA": "COCO AVEIA",
    "MANDIOQUINHA": "MANDIOQUINHA",
    "ESPINAFRE": "ESPINAFRE",
    "CENOURA": "CENOURA",
    "CRANBERRY": "CRANBERRY",
    "ERVILHA": "ERVILHA",
    "BLUEBERRY": "BLUEBERRY",
    "BATATA DOCE": "BATATA DOCE",
    "BAT DOCE": "BATATA DOCE",
}


@dataclass
class PriceEntry:
    subfamily: str
    description: str
    weight: str
    units: int
    unit_price: float
    final_price: float
    lines: list[str]
    signals: "Signals"


@dataclass
class Signals:
    stage: str = ""
    porte: str = ""
    weight: str = ""
    species: str = ""
    flavors: set[str] = field(default_factory=set)
    flags: set[str] = field(default_factory=set)


def normalize_text(text: str) -> str:
    text = unicodedata.normalize("NFKD", text)
    text = text.encode("ascii", "ignore").decode("ascii")
    text = text.upper()
    text = re.sub(r"[^A-Z0-9]+", " ", text)
    return re.sub(r"\s+", " ", text).strip()


def normalize_subfamily(value: str) -> str:
    return normalize_text(value)


def parse_brl_number(value: str) -> float:
    return float(str(value).strip().replace(".", "").replace(",", "."))


def normalize_weight(value: str) -> str:
    match = re.search(r"(\d+(?:[,.]\d+)?)\s*(KG|G)\b", value.upper())
    if not match:
        return ""
    amount = match.group(1).replace(",", ".")
    unit = match.group(2).lower()
    weight = f"{amount}{unit}"
    return weight.replace(".0kg", "kg").replace(".0g", "g")


def canonical_flavors(text: str) -> set[str]:
    normalized = normalize_text(text)
    flavors: set[str] = set()

    for phrase, canonical in sorted(FLAVOR_SYNONYMS.items(), key=lambda x: -len(x[0])):
        if phrase in normalized:
            flavors.add(canonical)

    for part in re.split(r"[,;/&]+", normalized):
        part = part.strip()
        if part in FLAVOR_SYNONYMS:
            flavors.add(FLAVOR_SYNONYMS[part])

    if "FRANGO E ARROZ" in normalized or "FRAN CER" in normalized or "FRAN ARROZ" in normalized:
        flavors.update({"FRANGO", "ARROZ"})
    if "CARNE E ARROZ" in normalized or "CARNE ARROZ" in normalized:
        flavors.update({"CARNE", "ARROZ"})
    if "FRANGO E SALMAO" in normalized or "FRAN SALM" in normalized:
        flavors.update({"FRANGO", "SALMAO"})
    if "FRANGO E CARNE" in normalized or "FRAN CARNE" in normalized:
        flavors.update({"FRANGO", "CARNE"})
    if "PEITO DE FRANGO" in normalized or "PEITO FRANGO" in normalized:
        flavors.update({"FRANGO", "PEITO"})
    if "FRANGO MANDIOCA" in normalized or "FRAN MANDIOCA" in normalized:
        flavors.update({"FRANGO", "MANDIOCA"})
    if "ABOBORA BROCOLIS" in normalized or "ABOB BROCOLIS" in normalized:
        flavors.update({"ABOBORA", "BROCOLIS", "FRANGO"})

    return {flavor for flavor in flavors if flavor}


def parse_signals(text: str, age: str = "", category: str = "") -> Signals:
    normalized = normalize_text(f"{age} {text}")
    signals = Signals(weight=normalize_weight(text))

    if category == "gatos" or "GATOS" in normalized or " GATO" in normalized:
        signals.species = "GATOS"
    elif category == "caes" or "CAES" in normalized:
        signals.species = "CAES"

    if re.search(r"\b(FILHOTES|FILH|PAPINHA)\b", normalized):
        signals.stage = "FILHOTES"
    elif re.search(r"\bFIL\b", normalized) and not re.search(r"\bFRANG", normalized):
        signals.stage = "FILHOTES"
    elif re.search(r"\b(SENIOR|SENIOR|SEN)\b", normalized):
        signals.stage = "SENIOR"
    elif re.search(r"\b(CASTRADOS|CASTRAD|CAST)\b", normalized):
        signals.stage = "CASTRADOS"
    elif re.search(r"\bLIGHT\b", normalized):
        signals.stage = "LIGHT"
    elif re.search(r"\b(ADULTOS|ADULT|AD)\b", normalized):
        signals.stage = "ADULTOS"

    if re.search(r"(PEQ PORTE|RAÇAS PEQ|RAÇ PEQ|PORTE PEQUENO|PEQUENO)", normalized):
        signals.porte = "PEQUENO"
    elif re.search(r"(MED[/ ]?GRD|MEDIO[/ ]?GRANDE|MEDIO PORTE|MÉDIO)", normalized):
        signals.porte = "MEDIO"
    elif re.search(r"(PORTE GRANDE|GRD PORTE|GIGANTE)", normalized):
        signals.porte = "GRANDE"

    if "MINI BITS" in normalized or "MINI BIT" in normalized:
        signals.flags.add("MINIBITS")
    if "DERMACARE" in normalized:
        signals.flags.add("DERMACARE")
    if "GRAIN FREE" in normalized:
        signals.flags.add("GRAINFREE")
    if "BATATA DOCE" in normalized or "BAT DOCE" in normalized:
        signals.flags.add("BATATA")
    if "FIT" in normalized:
        signals.flags.add("FIT")
    if "ORGAN" in normalized:
        signals.flags.add("ORGANIC")
    if "PELO LONG" in normalized or "PELOS LONGOS" in normalized:
        signals.flags.add("PELOSLONGOS")
    if "DUII" in normalized:
        signals.flags.add("DUII")

    signals.flavors = canonical_flavors(normalized)
    return signals


def product_signals(product: dict) -> Signals:
    sabor_match = re.search(r"SABOR\s+(.+)$", normalize_text(product["name"]))
    sabor = sabor_match.group(1) if sabor_match else ""
    signals = parse_signals(
        f"{product['name']} {sabor}",
        category=product["category"],
    )
    signals.weight = normalize_weight(product["weight"])
    return signals


def resolve_lines(subfamily: str) -> list[str]:
    return LINE_HINTS.get(subfamily, [])


def entry_allowed_for_product(product: dict, entry: PriceEntry) -> bool:
    blocked = BLOCKED_SUBFAMILIES.get(product["line"], set())
    if entry.subfamily in blocked:
        return False

    aliases = PRODUCT_LINE_ALIASES.get(product["line"], [])
    if aliases and entry.subfamily in aliases:
        return True

    if entry.lines and product["line"] not in entry.lines:
        return False

    return True


def apply_grain_free_price(product: dict, entry: PriceEntry) -> float | None:
    if "GRAINFREE" not in entry.signals.flags:
        return None
    if not entry.weight:
        weight = normalize_weight(product["weight"])
        if weight == "2.5kg":
            return 114.90
        if weight == "10.1kg":
            return 289.90
    return None


def flavors_compatible(product_flavors: set[str], entry_flavors: set[str]) -> tuple[bool, float]:
    if not entry_flavors:
        if not product_flavors or product_flavors <= {"ORIGINAL"}:
            return True, 8
        if product_flavors <= {"FRANGO", "ARROZ"}:
            return True, 4
        if product_flavors <= {"FRANGO", "SALMAO"}:
            return True, 4
        return True, 2

    if not product_flavors:
        return False, 0

    overlap = product_flavors & entry_flavors
    if not overlap:
        return False, 0

    if product_flavors == entry_flavors:
        return True, 20
    if product_flavors.issubset(entry_flavors) or entry_flavors.issubset(product_flavors):
        return True, 14

    ratio = len(overlap) / max(len(product_flavors), 1)
    return ratio >= 0.5, len(overlap) * 8


def score_match(product: dict, entry: PriceEntry) -> float:
    if not entry_allowed_for_product(product, entry):
        return -1

    product_sig = product_signals(product)
    entry_sig = entry.signals

    if product_sig.weight != entry_sig.weight:
        grain_free_price = apply_grain_free_price(product, entry)
        if grain_free_price is None:
            return -1
    else:
        grain_free_price = None

    if product_sig.species and entry_sig.species and product_sig.species != entry_sig.species:
        return -1

    if product_sig.stage and entry_sig.stage and product_sig.stage != entry_sig.stage:
        # Gourmet gatos: tabela usa "CAST CARNE" para carne adulta
        if not (
            product["line"] == "Golden Gourmet Gatos"
            and product_sig.stage == "ADULTOS"
            and "CAST" in normalize_text(entry.description)
            and "CARNE" in entry_sig.flavors
        ):
            return -1

    if product_sig.porte and entry_sig.porte and product_sig.porte != entry_sig.porte:
        return -1

    score = 10

    compatible, flavor_score = flavors_compatible(product_sig.flavors, entry_sig.flavors)
    if not compatible:
        return -1
    score += flavor_score

    shared_flags = product_sig.flags & entry_sig.flags
    score += len(shared_flags) * 6

    if "MINIBITS" in entry_sig.flags and "MINIBITS" not in product_sig.flags:
        if not re.search(r"MINI|BITS", normalize_text(product["name"])):
            return -1

    if "MINIBITS" in product_sig.flags or re.search(r"MINI|BITS", normalize_text(product["name"])):
        if "MINIBITS" not in entry_sig.flags:
            score -= 8

    if "BATATA" in product_sig.flags and "BATATA" not in entry_sig.flags:
        score -= 10
    if "BATATA" in entry_sig.flags and "BATATA" not in product_sig.flags:
        score -= 10

    if "GRAINFREE" in product_sig.flags and "GRAINFREE" not in entry_sig.flags:
        score -= 12
    if "GRAINFREE" in entry_sig.flags and "GRAINFREE" not in product_sig.flags:
        score -= 12

    if "DERMACARE" in product_sig.flags and "DERMACARE" not in entry_sig.flags:
        score -= 12
    if "FIT" in product_sig.flags and "FIT" not in entry_sig.flags:
        score -= 8

    if product["line"] == "PremieR Orgânico":
        if "ORGANIC" not in entry_sig.flags and "ORGAN" not in normalize_text(entry.description):
            return -1

    if product["line"] == "PremieR Cookie" and product_sig.flavors <= {"ORIGINAL"}:
        desc = normalize_text(entry.description)
        if product_sig.stage == "FILHOTES" and "FILH" in desc and "FRUT" not in desc and "COCO" not in desc:
            score += 12
        if product_sig.stage == "ADULTOS" and "ADULT" in desc and "FRUT" not in desc and "COCO" not in desc and "FIT" not in desc:
            score += 10

    if product_sig.stage == "CASTRADOS" and "CAST" not in normalize_text(entry.description):
        if product["line"] == "PremieR Gourmet" and product_sig.weight in {"70g", "85g"}:
            score -= 5
        else:
            return -1

    if product_sig.stage == "FILHOTES" and re.search(r"\bCAST\b", normalize_text(entry.description)):
        return -1

    if grain_free_price is not None:
        score += 20

    return score


def load_price_entries() -> list[PriceEntry]:
    entries: list[PriceEntry] = []

    with pdfplumber.open(PDF_PATH) as document:
        for page in document.pages:
            for table in page.extract_tables() or []:
                for row in table:
                    if not row or len(row) < 7:
                        continue

                    description = row[3]
                    suggested = row[6]
                    if not description or not suggested:
                        continue
                    if "DESCRI" in normalize_text(description):
                        continue
                    if not re.search(r"\d", str(suggested)):
                        continue
                    if re.search(r"L\d+P\d+", description, re.IGNORECASE):
                        continue
                    if "PAGUE" in normalize_text(description) and "LEVE" in normalize_text(
                        description
                    ):
                        continue

                    units_match = re.search(r"\((\d+)\s*U", description, re.IGNORECASE)
                    units = int(units_match.group(1)) if units_match else 1
                    unit_price = parse_brl_number(suggested)
                    final_price = round(unit_price * units, 2)
                    subfamily = normalize_subfamily(row[1] or "")
                    age = row[2] or ""
                    species = "GATOS" if "GATOS" in subfamily else "CAES"
                    signals = parse_signals(description, age=age, category=species.lower())

                    entries.append(
                        PriceEntry(
                            subfamily=subfamily,
                            description=description,
                            weight=signals.weight,
                            units=units,
                            unit_price=unit_price,
                            final_price=final_price,
                            lines=resolve_lines(subfamily),
                            signals=signals,
                        )
                    )

    return entries


def find_best_match(product: dict, entries: list[PriceEntry]) -> tuple[PriceEntry | None, float, float | None]:
    best_entry = None
    best_score = 0.0
    best_custom_price = None

    for entry in entries:
        score = score_match(product, entry)
        if score > best_score:
            custom_price = apply_grain_free_price(product, entry)
            best_score = score
            best_entry = entry
            best_custom_price = custom_price

    return best_entry, best_score, best_custom_price


def main() -> None:
    if not PDF_PATH.exists():
        raise FileNotFoundError(f"PDF não encontrado: {PDF_PATH}")

    entries = load_price_entries()
    with open(PRODUCTS_PATH, encoding="utf-8") as handle:
        products = json.load(handle)

    matched = 0
    unmatched: list[str] = []
    report_lines = [f"Entradas no PDF: {len(entries)}", ""]

    for product in products:
        product_id = product["id"]

        if product_id in MANUAL_PRICE_OVERRIDES:
            price = MANUAL_PRICE_OVERRIDES[product_id]
            product["price"] = price
            matched += 1
            report_lines.append(
                f"OK manual [{product_id}] {product['name']} ({product['weight']}) = {price}"
            )
            continue

        entry, score, custom_price = find_best_match(product, entries)
        if not entry or score < 12:
            product["price"] = None
            unmatched.append(
                f"[{product['id']}] {product['line']} | {product['name']} | {product['weight']}"
            )
            continue

        final_price = custom_price if custom_price is not None else entry.final_price
        product["price"] = final_price
        matched += 1
        report_lines.append(
            f"OK score={score:.0f} [{product['id']}] {product['name']} ({product['weight']}) "
            f"<= {entry.description} | {entry.unit_price} x {entry.units} = {final_price}"
        )

    with open(PRODUCTS_PATH, "w", encoding="utf-8") as handle:
        json.dump(products, handle, ensure_ascii=False, indent=2)
        handle.write("\n")

    report_lines.extend(["", f"Correspondidos: {matched}/{len(products)}", "", "Sem preço:"])
    report_lines.extend(unmatched)
    REPORT_PATH.write_text("\n".join(report_lines), encoding="utf-8")

    print(f"Preços aplicados: {matched}/{len(products)}")
    print(f"Sem correspondência: {len(unmatched)}")
    print(f"Relatório: {REPORT_PATH}")


if __name__ == "__main__":
    main()
