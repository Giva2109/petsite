"""
Corrige pesos "Sob consulta" em products.json usando o texto do catálogo (catalog_raw.txt).
Execute: python scripts/fix_weights.py
"""
import json
import re
import unicodedata
from pathlib import Path

RAW_PATH = Path(__file__).parent / "catalog_raw.txt"
PRODUCTS_PATH = Path(__file__).parent.parent / "src" / "data" / "products.json"


def normalize(text: str) -> str:
    text = unicodedata.normalize("NFC", text)
    return re.sub(r"\s+", " ", text).strip()


def fix_weight_text(text: str) -> str:
    text = text.replace(" e ", ", ")
    text = re.sub(r"(\d+,\d+)\s+(?=\d)", r"\1kg, ", text)
    text = re.sub(r"(\d+,\d+)(?!\s*(?:kg|g)\b)", r"\1kg", text, flags=re.IGNORECASE)
    text = re.sub(r"(\d+(?:[,.]\d+)?)\s+(kg|g)\b", r"\1\2", text, flags=re.IGNORECASE)
    return text


def parse_weights(text: str) -> list[str]:
    text = fix_weight_text(text)
    weights = []
    for match in re.finditer(r"(\d+(?:[,.]\d+)?)\s*(kg|g)\b", text, re.IGNORECASE):
        value = match.group(1).replace(",", ".")
        unit = match.group(2).lower()
        weight = f"{value}{unit}".replace(".0kg", "kg").replace(".0g", "g")
        if weight not in weights:
            weights.append(weight)
    return weights


def split_sabores_from_line(line: str) -> list[str]:
    if "sabor:" not in line.lower():
        return []

    parts = re.split(r"\bSabor:\s*", line, flags=re.IGNORECASE)
    sabores = []
    for part in parts:
        part = normalize(part)
        if not part:
            continue
        part = re.split(
            r"\s+(?:NOBRE|NUTRITIVO|ENRIQUECIDO|DESENVOLVIMENTO|SAÚDE|INTESTINO|"
            r"NATURALMENTE|SEM CORANTES|BLEND|MAIOR|MÁXIMA|CRESCIMENTO|PELAGEM|"
            r"CONTROLE|SISTEMA|AUXILIA|COM |RICO EM|SUPORTE|BALANCEADO|"
            r"EQUILÍBRIO|CONTRIBUI)",
            part,
            maxsplit=1,
            flags=re.IGNORECASE,
        )[0]
        part = normalize(part.rstrip(".,;"))
        if len(part) >= 3:
            sabores.append(part)
    return sabores


def sabor_key(text: str) -> str:
    return re.sub(r"[^a-z0-9]", "", normalize(text).lower())


def extract_product_sabor(name: str) -> str:
    match = re.search(r"\bSabor\s+(.+)$", name, re.IGNORECASE)
    return normalize(match.group(1)) if match else ""


def find_weights_near(lines: list[str], index: int) -> list[list[str]]:
    groups: list[list[str]] = []

    for offset in range(0, 15):
        if index + offset >= len(lines):
            break
        candidate = lines[index + offset]
        if "sabor:" in candidate.lower() and offset > 0:
            break

        weights = parse_weights(candidate)
        if not weights:
            continue

        # Linha com um ou mais pesos (aceita texto extra, ex.: "70g aromatizantes")
        groups.append(weights)
        return groups

    return groups


def build_page_weight_map(page_text: str) -> dict[str, list[str]]:
    """Mapeia sabor normalizado -> lista de pesos possíveis na página."""
    lines = [
        normalize(line)
        for line in page_text.split("\n")
        if normalize(line) and not re.match(r"^(26\.01|\d+)$", normalize(line))
    ]

    mapping: dict[str, list[str]] = {}

    for index, line in enumerate(lines):
        sabores = split_sabores_from_line(line)
        if not sabores:
            continue

        weight_groups = find_weights_near(lines, index)
        if not weight_groups:
            continue

        flat = weight_groups[0]
        if len(flat) == len(sabores):
            pairs = zip(sabores, flat)
        elif len(flat) == 1:
            pairs = ((sabor, flat[0]) for sabor in sabores)
        else:
            pairs = (
                (sabores[i], flat[i] if i < len(flat) else flat[-1])
                for i in range(len(sabores))
            )

        for sabor, weight in pairs:
            key = sabor_key(sabor)
            mapping.setdefault(key, [])
            if weight not in mapping[key]:
                mapping[key].append(weight)

    return mapping


def load_pages() -> dict[int, str]:
    pages: dict[int, str] = {}
    current_page = None
    buffer: list[str] = []

    with open(RAW_PATH, encoding="utf-8") as handle:
        for raw_line in handle:
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


MANUAL_OVERRIDES: dict[int, str] = {
    67: "3kg",
    91: "12kg",
    104: "2.5kg",
    118: "1kg",
    120: "1kg",
    164: "1kg",
    168: "1kg",
    175: "1kg",
    191: "3kg",
}

NAME_FIXES: dict[int, str] = {
    67: "Golden Seleção Natural Cães - Adultos - Porte Pequeno - Sabor Frango com Abóbora e Alecrim",
    91: "Nattu Cães - Adultos - Sabor Frango, abóbora, brócolis, quinoa e blueberry",
    175: "PremieR Seleção Natural - Adultos - Sabor Frango e Batata Doce",
    191: "Vitta Natural - Filhotes - Porte Pequeno - Sabor Frango e Arroz",
}

DESCRIPTION_FIXES: dict[int, str] = {
    67: "Linha Golden Seleção Natural Cães. Adultos. Sabor Frango com Abóbora e Alecrim. Embalagem 3kg.",
    91: "Linha Nattu Cães. Adultos. Sabor Frango, abóbora, brócolis, quinoa e blueberry. Embalagem 12kg.",
    104: "Linha Nattu Cães. Senior. Sabor Frango, mandioca, beterraba, linhaça e cranberry. Embalagem 2.5kg.",
    118: "Linha PremieR Ambientes Internos. Castrados. Sabor Salmão. Embalagem 1kg.",
    120: "Linha PremieR Ambientes Internos. Sênior. Sabor Frango e Salmão. Embalagem 1kg.",
    164: "Linha PremieR Raças Específicas. Adultos. Sabor Frango. Embalagem 1kg.",
    168: "Linha PremieR Raças Específicas. Filhotes. Sabor Frango. Embalagem 1kg.",
    175: "Linha PremieR Seleção Natural. Adultos. Sabor Frango e Batata Doce. Embalagem 1kg.",
    191: "Linha Vitta Natural. Filhotes. Sabor Frango e Arroz. Embalagem 3kg.",
}


def fuzzy_match_weights(key: str, page_map: dict[str, list[str]]) -> list[str]:
    if key in page_map:
        return page_map[key]

    best: list[str] = []
    best_len = 0
    for map_key, weights in page_map.items():
        if key.startswith(map_key) or map_key.startswith(key):
            overlap = min(len(key), len(map_key))
            if overlap > best_len and overlap >= 8:
                best = weights
                best_len = overlap

    return best


def infer_weight_from_page_peers(product: dict, products: list[dict]) -> str | None:
    page = product["catalogPage"]
    line = product["line"]
    peers = [
        peer
        for peer in products
        if peer["catalogPage"] == page
        and peer["line"] == line
        and peer["weight"] != "Sob consulta"
    ]
    if not peers:
        return None

    weights = sorted({peer["weight"] for peer in peers}, key=lambda w: w)
    if len(weights) == 1:
        return weights[0]

    product_sabor = sabor_key(extract_product_sabor(product["name"]))
    for peer in peers:
        peer_sabor = sabor_key(extract_product_sabor(peer["name"]))
        if product_sabor == peer_sabor:
            return peer["weight"]

    return None


def apply_product_fixes(product: dict) -> bool:
    product_id = product["id"]
    if product_id not in MANUAL_OVERRIDES:
        return False

    weight = MANUAL_OVERRIDES[product_id]
    product["weight"] = weight
    if product_id in NAME_FIXES:
        product["name"] = NAME_FIXES[product_id]
    if product_id in DESCRIPTION_FIXES:
        product["description"] = DESCRIPTION_FIXES[product_id]
    else:
        product["description"] = re.sub(
            r"Embalagem Sob consulta\.?",
            f"Embalagem {weight}.",
            product["description"],
        )
    return True


def main() -> None:
    pages = load_pages()
    page_maps = {page: build_page_weight_map(text) for page, text in pages.items()}

    with open(PRODUCTS_PATH, encoding="utf-8") as handle:
        products = json.load(handle)

    fixed = 0
    unresolved: list[str] = []

    for product in products:
        if product["weight"] != "Sob consulta":
            continue

        if apply_product_fixes(product):
            fixed += 1
            continue

        sabor = extract_product_sabor(product["name"])
        key = sabor_key(sabor)
        page_map = page_maps.get(product["catalogPage"], {})
        candidates = fuzzy_match_weights(key, page_map)

        weight = None
        if len(candidates) == 1:
            weight = candidates[0]
        elif len(candidates) > 1:
            peer_weight = infer_weight_from_page_peers(product, products)
            weight = peer_weight or candidates[0]
        else:
            weight = infer_weight_from_page_peers(product, products)

        if not weight:
            unresolved.append(product["name"])
            continue

        product["weight"] = weight
        product["description"] = re.sub(
            r"Embalagem Sob consulta\.?",
            f"Embalagem {weight}.",
            product["description"],
        )
        fixed += 1

    with open(PRODUCTS_PATH, "w", encoding="utf-8") as handle:
        json.dump(products, handle, ensure_ascii=False, indent=2)
        handle.write("\n")

    remaining = sum(1 for product in products if product["weight"] == "Sob consulta")
    print(f"Corrigidos: {fixed}")
    print(f"Ainda sem peso: {remaining}")
    if unresolved:
        print("Não resolvidos:")
        for name in unresolved:
            print(f"  - {name}")


if __name__ == "__main__":
    main()
