"""
Extrai produtos do Catálogo PremieRpet 2026 (PDF) para products.json.
Execute: python scripts/parse_catalog.py
"""
import json
import re
import unicodedata
from pathlib import Path

PDF_PATH = Path(
    r"C:\Users\givan\OneDrive\Desktop\GIVA\Mercado Livre\Pet_P2_P2p\Catálogo PremieRpet - 2026.pdf"
)
RAW_PATH = Path(__file__).parent / "catalog_raw.txt"
OUT_PATH = Path(__file__).parent.parent / "src" / "data" / "products.json"

PAGE_LINES = [
    (4, 5, "Vitta Natural"),
    (7, 15, "Golden"),
    (12, 13, "Golden Gourmet Cães"),
    (14, 15, "Golden Cookies Cães"),
    (16, 19, "Golden Gatos"),
    (20, 20, "Golden Gourmet Gatos"),
    (22, 24, "Golden Seleção Natural Cães"),
    (25, 25, "Golden Seleção Natural Gatos"),
    (27, 28, "PremieR Formula Cães"),
    (29, 29, "PremieR Formula Gatos"),
    (30, 30, "PremieR Formula Úmidos"),
    (31, 32, "PremieR Ambientes Internos"),
    (33, 34, "PremieR Gatos"),
    (35, 38, "PremieR Raças Específicas"),
    (39, 40, "PremieR Gourmet"),
    (41, 42, "PremieR Cookie"),
    (43, 45, "PremieR Seleção Natural"),
    (46, 46, "PremieR Orgânico"),
    (48, 51, "Nattu Cães"),
    (52, 53, "Nattu Gatos"),
    (54, 54, "Nattu Úmidos"),
    (55, 55, "Snacks"),
    (56, 57, "PremieR Nutrição Clínica Cães"),
    (58, 58, "PremieR Nutrição Clínica Gatos"),
    (59, 59, "PremieR Nutrição Clínica Úmidos"),
]

STAGE_PATTERNS = [
    r"PAPINHA\s+DESMAME",
    r"GOLDEN\s+SPECIAL",
    r"CÃES\s+SÊNIOR",
    r"CÃES\s+SENIOR",
    r"CÃES\s+FILHOTES",
    r"CÃES\s+ADULTOS",
    r"GATOS\s+CASTRADOS",
    r"GATOS\s+FILHOTES",
    r"GATOS\s+ADULTOS",
    r"GATOS\s+LIGHT",
    r"GATOS\s+SÊNIOR",
    r"ÚMIDOS?\s+CÃES",
    r"ÚMIDOS?\s+GATOS",
    r"CÃES\s+PORTE",
    r"GATOS\s+PORTE",
    r"FILHOTES",
    r"ADULTOS",
    r"SÊNIOR",
    r"SENIOR",
    r"LIGHT",
    r"CASTRADOS",
    r"DERMACARE",
    r"GRAIN\s+FREE",
    r"ÚMIDOS?",
]

SKIP_LINE_RE = re.compile(
    r"^(26\.01|Portfólio|PORTFÓLIO|\d+)$|\.{3,}|SUMÁRIO",
    re.IGNORECASE,
)


def normalize(text: str) -> str:
    text = unicodedata.normalize("NFC", text)
    return re.sub(r"\s+", " ", text).strip()


def get_line_for_page(page: int) -> str:
    for start, end, line in PAGE_LINES:
        if start <= page <= end:
            return line
    return "PremieRpet"


def infer_category(text: str, line: str) -> str:
    upper = text.upper()
    if "GATO" in upper:
        return "gatos"
    if "CÃO" in upper or "CÃES" in upper:
        return "caes"
    if "GATO" in line.upper():
        return "gatos"
    return "caes"


def extract_stage(context: str) -> str:
    upper = context.upper()
    found = []
    for pattern in STAGE_PATTERNS:
        for match in re.finditer(pattern, upper):
            found.append((match.start(), match.group()))
    if not found:
        return "Produto"
    found.sort(key=lambda x: x[0])
    return normalize(found[-1][1].title())


def fix_weight_text(text: str) -> str:
    text = text.replace(" e ", ", ")
    # "10,1 15kg" -> "10,1kg, 15kg"
    text = re.sub(r"(\d+,\d+)\s+(?=\d)", r"\1kg, ", text)
    # decimais sem unidade antes de vírgula ou fim
    text = re.sub(r"(\d+,\d+)(?!\s*(?:kg|g)\b)", r"\1kg", text, flags=re.IGNORECASE)
    # "15 kg" -> "15kg"
    text = re.sub(r"(\d+(?:[,.]\d+)?)\s+(kg|g)\b", r"\1\2", text, flags=re.IGNORECASE)
    return text


def parse_weights(text: str) -> list[str]:
    text = fix_weight_text(text)
    weights = []
    for match in re.finditer(r"(\d+(?:[,.]\d+)?)\s*(kg|g)\b", text, re.IGNORECASE):
        value = match.group(1).replace(",", ".")
        unit = match.group(2).lower()
        if unit == "kg":
            weight = f"{value}kg"
            weight = weight.replace(".0kg", "kg")
        else:
            weight = f"{value}g"
            weight = weight.replace(".0g", "g")
        if weight not in weights:
            weights.append(weight)
    return weights


def is_weight_line(line: str) -> bool:
    if not line or "sabor:" in line.lower():
        return False
    fixed = fix_weight_text(line)
    tokens = parse_weights(fixed)
    if not tokens:
        return False
    # Linha composta majoritariamente por pesos
    stripped = re.sub(r"[\d,.\s kg]+", "", fixed, flags=re.IGNORECASE)
    return len(stripped) < 8


def split_sabores_from_line(line: str) -> list[str]:
    if "sabor:" not in line.lower():
        return []

    parts = re.split(r"\bSabor:\s*", line, flags=re.IGNORECASE)
    sabores = []
    for part in parts:
        part = normalize(part)
        if not part:
            continue
        # Corta em palavras-chave de benefício / próximo produto
        part = re.split(
            r"\s+(?:NOBRE|NUTRITIVO|ENRIQUECIDO|DESENVOLVIMENTO|SAÚDE|INTESTINO|"
            r"NATURALMENTE|SEM CORANTES|BLEND|MAIOR|MÁXIMA|CRESCIMENTO|PELAGEM|"
            r"CONTROLE|SISTEMA|AUXILIA|COM |RICO EM)",
            part,
            maxsplit=1,
            flags=re.IGNORECASE,
        )[0]
        part = normalize(part.rstrip(".,;"))
        if len(part) >= 3:
            sabores.append(part)
    return sabores


def split_weight_groups(line: str) -> list[list[str]]:
    """Separa grupos de pesos em linhas multi-coluna."""
    if not is_weight_line(line):
        return []

    fixed = fix_weight_text(line)

    # Detecta clusters: sequências de pesos separados por espaço simples entre colunas
    clusters = re.findall(
        r"(?:(?:\d+(?:[,.]\d+)?\s*(?:kg|g)\s*,?\s*)+)",
        fixed,
        re.IGNORECASE,
    )

    groups = []
    for cluster in clusters:
        weights = parse_weights(cluster)
        if weights:
            groups.append(weights)

    if groups:
        return groups

    all_w = parse_weights(fixed)
    return [all_w] if all_w else []


def extract_porte(context: str) -> str:
    ctx = context.upper()
    if "PORTE PEQUENO" in ctx:
        return "Porte Pequeno"
    if "PORTE MÉDIO" in ctx or "PORTE MEDIO" in ctx:
        return "Porte Médio"
    if "PORTE GRANDE" in ctx or "GIGANTE" in ctx:
        return "Porte Grande"
    if "PELOS LONGOS" in ctx:
        return "Pelos Longos"
    if "GRAIN FREE" in ctx:
        return "Grain Free"
    return ""


def find_weights_near(lines: list[str], index: int) -> list[list[str]]:
    groups = []

    for offset in range(0, 12):
        if index + offset >= len(lines):
            break
        candidate = lines[index + offset]
        if "sabor:" in candidate.lower() and offset > 0:
            break
        if is_weight_line(candidate):
            groups = split_weight_groups(candidate)
            if groups:
                return groups

    # pesos na mesma linha após o último sabor
    line = lines[index]
    if "sabor:" in line.lower():
        tail = line.split(":")[-1]  # rough
        tail_weights = parse_weights(fix_weight_text(line))
        if tail_weights and len(line) < 120:
            return [tail_weights]

    return []


def parse_pages(pages: dict[int, str]) -> list[dict]:
    products = []
    seen = set()
    product_id = 1

    for page in sorted(pages.keys()):
        if page < 4 or page > 59:
            continue

        line_name = get_line_for_page(page)
        lines = [
            normalize(l)
            for l in pages[page].split("\n")
            if normalize(l) and not SKIP_LINE_RE.search(normalize(l))
        ]

        for i, line in enumerate(lines):
            sabores = split_sabores_from_line(line)
            if not sabores:
                continue

            context = " ".join(lines[max(0, i - 10) : i + 1])
            stage = extract_stage(context)
            category = infer_category(context + " " + line_name, line_name)
            porte = extract_porte(context)

            weight_groups = find_weights_near(lines, i)

            # Emparelha sabores com grupos de peso
            if len(weight_groups) == len(sabores):
                pairs = list(zip(sabores, weight_groups))
            elif len(weight_groups) == 1:
                pairs = [(s, weight_groups[0]) for s in sabores]
            elif weight_groups:
                pairs = []
                for idx, sabor in enumerate(sabores):
                    weights = (
                        weight_groups[idx]
                        if idx < len(weight_groups)
                        else weight_groups[-1]
                    )
                    pairs.append((sabor, weights))
            else:
                pairs = [(s, []) for s in sabores]

            for sabor, weights in pairs:
                if not weights:
                    weights = ["Sob consulta"]

                for weight in weights:
                    name_parts = [line_name, stage]
                    if porte:
                        name_parts.append(porte)
                    name = " - ".join(name_parts) + f" - Sabor {sabor}"
                    name = normalize(name)

                    key = (name, weight)
                    if key in seen:
                        continue
                    seen.add(key)

                    products.append(
                        {
                            "id": product_id,
                            "name": name,
                            "category": category,
                            "brand": "UniPet",
                            "line": line_name,
                            "price": None,
                            "originalPrice": None,
                            "image": f"/assets/products/placeholder-{category}.svg",
                            "description": (
                                f"Linha {line_name}. {stage}. "
                                f"Sabor {sabor}. Embalagem {weight}."
                            ),
                            "weight": weight,
                            "catalogPage": page,
                        }
                    )
                    product_id += 1

    return products


def load_pages_from_raw() -> dict[int, str]:
    pages = {}
    current_page = None
    buffer = []

    with open(RAW_PATH, encoding="utf-8") as f:
        for raw_line in f:
            line = raw_line.rstrip("\n")
            match = re.match(r"^===== PAGE (\d+) =====$", line)
            if match:
                if current_page is not None:
                    pages[current_page] = "\n".join(buffer)
                current_page = int(match.group(1))
                buffer = []
            else:
                buffer.append(line)

        if current_page is not None:
            pages[current_page] = "\n".join(buffer)

    return pages


def main():
    if not RAW_PATH.exists():
        import pdfplumber

        pages = {}
        with pdfplumber.open(PDF_PATH) as pdf:
            for i, page in enumerate(pdf.pages, start=1):
                pages[i] = page.extract_text() or ""
    else:
        pages = load_pages_from_raw()

    products = parse_pages(pages)
    products.sort(key=lambda p: (p["line"], p["category"], p["name"], p["weight"]))

    for i, p in enumerate(products, start=1):
        p["id"] = i

    OUT_PATH.parent.mkdir(parents=True, exist_ok=True)
    with open(OUT_PATH, "w", encoding="utf-8") as f:
        json.dump(products, f, ensure_ascii=False, indent=2)

    consulte = sum(1 for p in products if p["weight"] == "Sob consulta")
    print(f"OK: {len(products)} produtos -> {OUT_PATH}")
    print(f"Sem peso identificado: {consulte}")


if __name__ == "__main__":
    main()
