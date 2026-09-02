"""Cadastra todos os SKUs Purina da tabela 16-07 ainda não presentes no catálogo."""
from __future__ import annotations

import importlib.util
import io
import json
import re
import unicodedata
from pathlib import Path

import fitz
from PIL import Image

BASE = Path(__file__).parent
MISSING_PATH = BASE / "_pdf_tmp" / "purina_missing.json"
PDF_PATH = Path(
    r"C:\Users\givan\OneDrive\Desktop\GIVA\Mercado Livre\Purina\CATALAGO PURINA.pdf"
)
OUT_DIR = BASE.parent / "public" / "assets" / "products" / "catalog"
PRODUCTS_PATH = BASE.parent / "src" / "data" / "products.json"
SEED_PATH = (
    BASE.parent.parent / "petsite-api" / "src" / "main" / "resources" / "seed" / "products.json"
)
TENANT_ID = "a0000000-0000-4000-8000-000000000001"

RENDER_DPI = 400
MAX_LONG_EDGE = 1500
WEBP_QUALITY = 88
PAD_PT = 8

# Reaproveita crops já validados no lote anterior.
from add_purina import (  # noqa: E402
    CROPS,
    NEW_SLUGS,
    add_products,
    best_embedded,
    expand,
    optimize,
    render_crop,
    sku,
    sql_literal,
)

# Famílias de imagem: mesma arte do catálogo para vários pesos/SKUs.
FAMILY_CROPS: list[tuple[str, str]] = [
    ("CAT CHOW FILHOTES", "catchow-kitten"),
    ("CAT CHOW ADULTOS CARNE", "catchow-adult-carne"),
    ("CAT CHOW ADULTOS PEIXE", "catchow-adult-peixe"),
    ("CAT CHOW ADULTOS CASTRADOS FRANGO", "catchow-cast-frango"),
    ("CAT CHOW ADULTOS CASTRADOS PEIXE", "catchow-cast-peixe"),
    ("CAT CHOW SACHET FILHOTES", "catchow-sachet-kitten"),
    ("CAT CHOW SACHET ADULTOS 15X85G - CARNE", "catchow-sachet-adult-carne"),
    ("CAT CHOW SACHET ADULTOS 15X85G - FRANGO", "catchow-sachet-adult-carne"),
    ("CAT CHOW SACHET ADULTOS CASTRADOS 15X85G - CARNE", "catchow-sachet-adult-carne"),
    ("CAT CHOW SACHET ADULTOS CASTRADOS 15X85", "catchow-sachet-adult-carne"),
    ("DOG CHOW EXTRA LIFE ADULTOS LONGEVIDADE", "dogchow-7plus"),
    ("DOG CHOW EXTRA LIFE PAPITA", "dogchow-papita"),
    ("DOG CHOW EXTRA LIFE FILHOTES MINIS", "dogchow-puppy-mini"),
    ("DOG CHOW EXTRA LIFE FILHOTES M", "dogchow-puppy-med"),
    ("DOG CHOW EXTRA LIFE ADULTOS MINIS", "dogchow-adult-mini"),
    ("DOG CHOW EXTRA LIFE ADULTOS M", "dogchow-adult-med-grande"),
    ("DOG CHOW ORAL MINI", "dogchow-oral-mini"),
    ("DOG CHOW ORAL M", "dogchow-oral-mini"),
    ("DOG CHOW BISCOITO FILHOTES", "dogchow-puppy-mini"),
    ("DOG CHOW BISCOITO ADULTO M", "dogchow-adult-med-grande"),
    ("DOG CHOW BISCOITO ADULTOS MINI", "dogchow-adult-mini"),
    ("DOG CHOW SACHET", "dogchow-adult-med-grande"),
    ("DOG CHOW SACHE FILHOTES", "dogchow-puppy-med"),
    ("DOG CHOW ADULTO", "dogchow-adult-med-grande"),
    ("DOG CHOW FILHOTE", "dogchow-puppy-med"),
    ("DOG CHOW ADULTOS MINIS E PEQUENOS", "dogchow-adult-mini"),
    ("DOG CHOW ADULTOS MEDIOS E GRANDES", "dogchow-adult-med-grande"),
    ("PRO PLAN CAT HIPOALERGENICO", "proplan-cat-liveclear"),
    ("PRO PLAN CAT STERILISED", "proplan-cat-sterilized"),
    ("PRO PLAN CAT FILHOTE", "proplan-cat-kitten"),
    ("PRO PLAN URINARY", "proplan-cat-urinary"),
    ("PRO PLAN ADULT MINI", "proplan-adult-mini"),
    ("PRO PLAN CONTROLE PESO MINI", "proplan-reduced-mini"),
    ("FRISKIES DELICIAS DA GRANJA", "friskies-granja"),
    ("FRISKIES MIX CARNE ADULTOS", "friskies-mix-carnes"),
    ("FRISKIES MIX CARNE CASTRADOS", "friskies-mix-cast"),
    ("FRISKIES MEGAMIX ADULTOS", "friskies-megamix"),
    ("FRISKIES MEGAMIX CASTRADOS", "friskies-megamix"),
    ("FRISKIES MAR DE SABORES", "friskies-mar"),
    ("FRISKIES FILHOTES FRANGO", "friskies-kitten"),
    ("FRISKIES PETISCOS FRANGO", "friskies-petisco-frango"),
    ("FRISKIES PETISCOS CARNE", "friskies-petisco-frango"),
    ("FRISKIES PETISCOS SALM", "friskies-petisco-frango"),
    ("FRISKIES SACHET", "friskies-mix-carnes"),
    ("PRO PLAN CAT ADULT FRANGO", "proplan-cat-adult-frango"),
    ("PRO PLAN CAT ADULT 7+", "proplan-cat-7plus"),
    ("PRO PLAN CAT KITTEN", "proplan-cat-kitten"),
    ("PRO PLAN CAT STERILIZED", "proplan-cat-sterilized"),
    ("PRO PLAN CAT URINARY", "proplan-cat-urinary"),
    ("PRO PLAN CAT ADULT LIVECLEAR", "proplan-cat-liveclear"),
    ("PRO PLAN CAT SACHET ADULT FRANGO", "proplan-sachet-adult-frango"),
    ("PRO PLAN CAT SACHET KITTEN", "proplan-sachet-adult-frango"),
    ("PRO PLAN CAT SACHET CASTRADO", "proplan-sachet-adult-frango"),
    ("PRO PLAN PUPPY MINI", "proplan-puppy-mini"),
    ("PRO PLAN PUPPY", "proplan-puppy-grande"),
    ("PRO PLAN ADULT R. MINI", "proplan-adult-mini"),
    ("PRO PLAN ADULT R. GRANDE", "proplan-adult-grande"),
    ("PRO PLAN ADULT R. MED", "proplan-adult-medio"),
    ("PRO PLAN CONTROLE PESO R. MINI", "proplan-reduced-mini"),
    ("PRO PLAN REDUCED CALORIE MINI", "proplan-reduced-mini"),
    ("PRO PLAN CONTROLE PESO R. MED", "proplan-reduced-med"),
    ("PRO PLAN REDUCED CALORIE M", "proplan-reduced-med"),
    ("PRO PLAN ACTIVE MIND", "proplan-activemind"),
    ("PRO PLAN DES EXCP", "proplan-puppy-grande"),
    ("PRO PLAN FILH. DESEMPENHO", "proplan-puppy-grande"),
    ("PRO PLAN FILH. R. MINI", "proplan-puppy-mini"),
    ("PRO PLAN LONGEVIDADE", "proplan-activemind"),
    ("PRO PLAN PALADAR", "proplan-adult-mini"),
    ("PRO PLAN ALTA VITALIDADE", "proplan-adult-grande"),
    ("PRO PLAN HIPOALERGENICO", "proplan-adult-grande"),
    ("PRO PLAN SENSITIVE SKIN", "proplan-reduced-mini"),
    ("PRO PLAN SACHET ADULTO", "proplan-sachet-adult-frango"),
    ("PPVD FELINE", "proplan-cat-urinary"),
    ("PPVD CANINE", "proplan-puppy-grande"),
    ("PRPN STERILISED", "proplan-cat-sterilized"),
    ("PRPN ADULT 7+", "proplan-cat-7plus"),
    ("PRPN DES EXCP GATO FILHOTE", "proplan-cat-kitten"),
    ("ONE CAT SACHET", "catchow-sachet-adult-carne"),
    ("ONE DOG SACHET", "dogchow-adult-med-grande"),
    ("DENTALIFE CAES RACAS GRANDES", "dentalife-grande"),
    ("DENTALIFE CAES RACAS MEDIAS", "dentalife-media"),
    ("DENTALIFE CAES RACAS PEQUENAS", "dentalife-pequena"),
    ("DENTALIFE GATOS", "dentalife-gatos"),
    ("FANCY FEAST CASSEROLE ATUM", "fancy-casserole-atum"),
    ("FANCY FEAST CASSEROLE FRANGO", "fancy-casserole-frango"),
    ("FANCY FEAST DEMI GLACE CARNE", "fancy-demi-carne"),
    ("FANCY FEAST DEMI GLACE FRANGO", "fancy-demi-frango"),
    ("FANCY FEAST GOULASH ATUM", "fancy-goulash-atum"),
    ("FANCY FEAST GOULASH PERU", "fancy-goulash-peru"),
    ("FANCY FEAST PETIT FILET CARNE", "fancy-petit-carne"),
    ("FANCY FEAST PETIT FILET SALMAO", "fancy-petit-salmao"),
    ("FANCY FEAST SUPREMO BACALHAU", "fancy-supremo-bacalhau"),
    ("FANCY FEAST SUPREMO CARNE", "fancy-supremo-carne"),
    ("FANCY FEAST SUPREMO PEIXEBRANCO", "fancy-supremo-peixe"),
    ("DOGUITOS BIFINHO CARNE", "doguitos-carne"),
    ("DOGUITOS BIFINHO FRANGO", "doguitos-frango"),
    ("DOGUITOS BIFINHO LINGUICINHA", "doguitos-linguica"),
    ("ALPO ADULTOS", "alpo-adulto"),
    ("ALPO FILHOTES", "alpo-filhote"),
    ("GATSY CARNE", "gatsy-carne"),
]

# Crops manuais para linhas novas (páginas com bbox conferidos no PDF).
EXTRA_CROPS: dict[str, tuple[int, float, float, float, float]] = {
    "proplan-adult-medio": (8, 100.4, 536.7, 158.2, 633.3),
    "dentalife-pequena": (15, 60.3, 246.1, 195.4, 381.1),
    "dentalife-media": (15, 236.7, 255.6, 357.9, 376.8),
    "dentalife-grande": (15, 396.3, 245.4, 537.3, 386.3),
    "dentalife-gatos": (15, 214.5, 559.7, 348.6, 693.8),
    "fancy-casserole-atum": (17, 319.7, 303.4, 417.2, 400.8),
    "fancy-casserole-frango": (17, 457.2, 303.4, 554.6, 400.8),
    "fancy-demi-carne": (17, 41.6, 542.6, 141.2, 642.3),
    "fancy-demi-frango": (17, 181.2, 546.0, 280.9, 645.7),
    "fancy-goulash-atum": (17, 318.6, 543.3, 418.3, 643.0),
    "fancy-goulash-peru": (17, 456.1, 542.6, 555.7, 642.2),
    "fancy-petit-carne": (17, 43.8, 304.5, 141.3, 402.0),
    "fancy-petit-salmao": (17, 182.3, 304.5, 279.7, 402.0),
    "fancy-supremo-bacalhau": (17, 318.6, 543.3, 418.3, 643.0),
    "fancy-supremo-carne": (17, 456.1, 542.6, 555.7, 642.2),
    "fancy-supremo-peixe": (17, 318.6, 543.3, 418.3, 643.0),
    "doguitos-carne": (19, 343.7, 206.7, 479.5, 379.3),
    "doguitos-frango": (19, 109.4, 206.7, 258.0, 378.3),
    "doguitos-linguica": (19, 238.9, 514.3, 366.1, 686.6),
    "alpo-adulto": (31, 304.2, 280.8, 566.9, 543.5),
    "alpo-filhote": (31, 12.8, 266.5, 304.2, 557.9),
    "gatsy-carne": (31, 304.2, 280.8, 566.9, 543.5),
    "friskies-sachet-atum": (28, 36.3, 48.0, 141.0, 152.0),
    "friskies-sachet-carne": (28, 173.0, 48.0, 278.0, 152.0),
    "friskies-sachet-cordeiro": (28, 310.0, 48.0, 415.0, 152.0),
    "friskies-sachet-frango": (28, 446.0, 48.0, 551.0, 152.0),
    "friskies-petisco-carne": (29, 378.2, 266.5, 437.7, 363.6),
    "friskies-petisco-salmao": (29, 273.9, 553.5, 333.3, 650.7),
    "friskies-mega-cast": (27, 377.7, 530.9, 491.1, 644.3),
    "ppvd-ha-cat": (5, 62.4, 252.9, 123.9, 349.5),
    "ppvd-ur-cat": (5, 185.5, 244.3, 267.1, 362.8),
    "ppvd-om-cat": (5, 321.9, 245.5, 404.8, 362.6),
    "ppvd-ha-dog": (5, 116.8, 534.2, 198.0, 654.1),
    "ppvd-nc-dog": (5, 251.0, 531.8, 337.1, 658.0),
    "ppvd-om-dog": (5, 391.5, 534.9, 468.7, 653.2),
    "ppvd-ur-dog": (5, 458.1, 244.5, 542.8, 363.4),
    "purinaone-dog": (11, 48.0, 48.0, 192.0, 192.0),
    "purinaone-cat": (12, 48.0, 48.0, 192.0, 192.0),
    "purinaone-sachet-dog": (13, 48.0, 268.0, 149.0, 369.0),
    "purinaone-sachet-cat": (13, 303.0, 268.0, 404.0, 369.0),
    "dogchow-oral-med": (25, 326.4, 449.6, 405.4, 549.5),
    "dogchow-oral-med-200": (25, 455.0, 461.7, 550.4, 550.7),
    "dogchow-oral-mini-105": (25, 261.8, 236.0, 332.6, 333.3),
    "dogchow-biscoito-med": (25, 179.9, 453.8, 278.9, 552.4),
    "dogchow-biscoito-mini": (25, 326.4, 449.6, 405.4, 549.5),
    "catchow-sachet-cast-peixe": (21, 370.4, 470.7, 455.5, 546.0),
    "catchow-sachet-cast-carne": (21, 258.7, 470.7, 343.8, 546.0),
    "catchow-sachet-adult-frango": (21, 146.4, 646.0, 231.8, 727.9),
    "catchow-sachet-adult-peixe": (21, 390.2, 656.2, 435.6, 721.4),
    "proplan-sachet-dog-carne": (9, 195.4, 544.1, 251.4, 633.4),
    "proplan-sachet-dog-frango": (9, 330.8, 548.4, 384.9, 634.1),
    "proplan-sens-mini": (9, 197.8, 270.4, 254.6, 366.9),
    "proplan-sens-med": (9, 303.4, 267.7, 404.5, 368.9),
}

ALL_CROPS = {**CROPS, **EXTRA_CROPS}


def norm(s: str) -> str:
    s = unicodedata.normalize("NFKD", s).encode("ascii", "ignore").decode("ascii")
    return re.sub(r"\s+", " ", s.upper().strip())


def title_pt(words: str) -> str:
    small = {"de", "da", "do", "e", "ao", "aos", "com", "para", "x"}
    parts = []
    for w in words.lower().split():
        parts.append(w if w in small else w.capitalize())
    return " ".join(parts)


def brand_label(desc: str) -> str:
    d = norm(desc)
    if d.startswith("PPVD") or d.startswith("PRPN") or "PRO PLAN" in d or d.startswith("PROPLAN"):
        return "Purina Pro Plan"
    if "ONE CAT" in d or "ONE DOG" in d or "PURINA ONE" in d:
        return "Purina One"
    if "CAT CHOW" in d:
        return "Purina Cat Chow"
    if "DOG CHOW" in d:
        return "Purina Dog Chow"
    if "FRISKIES" in d:
        return "Purina Friskies"
    if "FANCY FEAST" in d:
        return "Purina Fancy Feast"
    if "DENTALIFE" in d:
        return "Purina Dentalife"
    if "DOGUITOS" in d:
        return "Purina Doguitos"
    if "ALPO" in d:
        return "Purina Alpo"
    if "GATSY" in d:
        return "Purina Gatsy"
    return "Purina"


def build_name(desc: str, weight: str) -> tuple[str, str, str]:
    d = norm(desc)
    brand = brand_label(desc)
    category = "gatos" if any(k in d for k in ("CAT", "GATO", "KITTEN", "FELINE", "FRISKIES", "FANCY")) else "caes"
    if "DENTALIFE GATOS" in d:
        category = "gatos"
    if "ONE DOG" in d or "DOG CHOW" in d or "DOGUITOS" in d or "ALPO" in d or "PPVD CANINE" in d:
        category = "caes"
    if "ONE CAT" in d or "CAT CHOW" in d or "PPVD FELINE" in d or "PRPN" in d and "GATO" in d:
        category = "gatos"

    # Remove código/peso do final
    core = re.sub(r"\s*-\s*\d+(?:[.,]\d+)?\s*(KG|G)\s*$", "", d, flags=re.I)
    core = re.sub(r"\s+\d+X\d+.*$", "", core)

    audience = ""
    flavor = ""
    extra = ""

    if "FILHOTE" in core or "KITTEN" in core or "PUPPY" in core or "PAPITA" in core:
        audience = "Gatos Filhotes" if category == "gatos" else "Cães Filhotes"
    elif "CASTRAD" in core or "STERIL" in core:
        audience = "Gatos Castrados"
    elif "7+" in core or "7 PLUS" in core or "LONGEVIDADE" in core or "ACTIVE MIND" in core or "MENTE ATIVA" in core:
        audience = "Cães Adultos 7+" if category == "caes" else "Gatos Adultos 7+"
    elif "ADULT" in core or "ADULTO" in core:
        audience = "Gatos Adultos" if category == "gatos" else "Cães Adultos"
    else:
        audience = "Gatos" if category == "gatos" else "Cães"

    if "URIN" in core or "TRATO URIN" in core:
        extra = "Trato Urinário"
    elif "LIVECLEAR" in core or "ALERGEN" in core:
        extra = "LiveClear Redução de Alérgenos"
    elif "HIPOALER" in core or " HA " in f" {core} ":
        extra = "Hipoalergênico"
    elif "OBESIDADE" in core or "CONTROLE PESO" in core or "REDUCED" in core or "CALORIA" in core:
        extra = "Caloria Reduzida"
    elif "SENSITIVE" in core or "PELE SENS" in core:
        extra = "Pele Sensível"
    elif "ACTIVE MIND" in core or "MENTE ATIVA" in core:
        extra = "Mente Ativa"
    elif "ORAL" in core or "SAUDE ORAL" in core:
        extra = "Saúde Oral"
    elif "BISCOITO" in core:
        extra = "Biscoitos"
    elif "PETISCO" in core:
        extra = "Petiscos"
    elif "SACHET" in core or "SACHE" in core:
        extra = "Sachê"
    elif "NEURO" in core:
        extra = "Neurológico"
    elif "DES EXCP" in core or "DESEMPENHO" in core:
        extra = "Desempenho Excepcional"
    elif "PALADAR" in core:
        extra = "Paladar Exigente"
    elif "LONGEVIDADE" in core:
        extra = "Longevidade"
    elif "ALTA VITALIDADE" in core:
        extra = "Alta Vitalidade"

    if "MINI" in core and "PEQ" in core:
        audience += " - Porte Mini e Pequeno"
    elif "MED" in core and ("GRANDE" in core or "GDE" in core):
        audience += " - Porte Médio e Grande"
    elif "GRANDE" in core or "GDE" in core:
        audience += " - Porte Grande"
    elif "MINI" in core or "PEQ" in core:
        audience += " - Porte Mini e Pequeno"

    flavors = []
    # Sabores após hífen (ex.: "15X100G - FRANGO")
    if " - " in desc:
        tail = norm(desc.split(" - ", 1)[1])
        for key, label in [
            ("FRANGO", "Frango"),
            ("CARNE", "Carne"),
            ("CORDEIRO", "Cordeiro"),
            ("PEIXE", "Peixe"),
            ("SALMAO", "Salmão"),
            ("ATUM", "Atum"),
            ("PERU", "Peru"),
            ("BACALHAU", "Bacalhau"),
        ]:
            if key in tail and label not in flavors:
                flavors.append(label)

    variant = ""
    if "TRIPLOPROT SLM" in d:
        variant = "Triploproteína Salmão"
    elif "TRIPLOPROT" in d:
        variant = "Triploproteína"
    elif "MULTIPROTEINA" in d:
        variant = "Multiproteína"
    elif "ALTA PROTEINA" in d:
        variant = "Alta Proteína"
    elif "MULTI PROTEINAS" in d:
        variant = "Multiproteínas"
    elif "SUPER FOODS" in d:
        variant = "Super Foods"
    elif "SUPER NUTRIENTES" in d:
        variant = "Super Nutrientes"

    for pair in re.findall(r"([A-Z]+)&([A-Z]+)", d):
        for token in pair:
            label = {
                "FRANGO": "Frango",
                "CARNE": "Carne",
                "LEITE": "Leite",
                "ARROZ": "Arroz",
                "CORDEIRO": "Cordeiro",
            }.get(token)
            if label and label not in flavors:
                flavors.append(label)

    for key, label in [
        ("FRANGO", "Frango"),
        ("CARNE", "Carne"),
        ("PEIXE", "Peixe"),
        ("SALMAO", "Salmão"),
        ("ATUM", "Atum"),
        ("CORDEIRO", "Cordeiro"),
        ("PERU", "Peru"),
        ("BACALHAU", "Bacalhau"),
        ("ARROZ", "Arroz"),
        ("LEITE", "Leite"),
        ("CENOURA", "Cenoura"),
        ("MIX", "Mix de Carnes"),
        ("MEGAMIX", "Megamix"),
        ("MAR DE SABORES", "Mar de Sabores"),
        ("GRANJA", "Delícias da Granja"),
        ("LINGUICINHA", "Linguicinha"),
        ("MULTI PROTEINAS", "Multiproteínas"),
        ("SUPER FOODS", "Super Foods"),
        ("SUPER NUTRIENTES", "Super Nutrientes"),
    ]:
        if key in core and label not in flavors:
            flavors.append(label)
    if flavors:
        flavor = "Sabor " + ", ".join(flavors[:4])
    elif variant:
        flavor = variant

    if "PRPN STERILISED" in d:
        audience = "Gatos Castrados"
        extra = "Sterilised"
    elif "PRPN ADULT 7+" in d:
        audience = "Gatos Adultos 7+"
    elif "PRPN DES EXCP GATO FILHOTE" in d:
        audience = "Gatos Filhotes"
        extra = "Desempenho Excepcional"

    if "CASSEROLE" in core:
        extra = (extra + " Casserole").strip()
    if "DEMI GLACE" in core:
        extra = (extra + " Demi Glacé").strip()
    if "GOULASH" in core:
        extra = (extra + " Goulash").strip()
    if "PETIT FILET" in core:
        extra = (extra + " Petit Filet").strip()
    if "SUPREMO" in core:
        extra = (extra + " Supremo").strip()

    parts = [brand, audience]
    if extra:
        parts.append(extra)
    if flavor:
        parts.append(flavor)
    parts.append(f"Embalagem {weight}")

    name = " - ".join(parts)
    desc_short = ". ".join(
        [
            "Linha Purina",
            brand.replace("Purina ", ""),
            audience.replace("Gatos ", "").replace("Cães ", ""),
            *( [extra] if extra else [] ),
            *( [flavor.replace("Sabor ", "")] if flavor else [] ),
        ]
    ).strip(". ")
    return name, desc_short + ".", category


def pick_family_slug(desc: str) -> str | None:
    d = norm(desc)
    for pattern, slug in sorted(FAMILY_CROPS, key=lambda x: -len(x[0])):
        if pattern in d and slug in ALL_CROPS:
            return slug
    return None


def pick_family_slug_extra(desc: str) -> str | None:
    d = norm(desc)
    rules = [
        ("PPVD FELINE HA", "ppvd-ha-cat"),
        ("PPVD FELINE UR", "ppvd-ur-cat"),
        ("PPVD FELINE OM", "ppvd-om-cat"),
        ("PPVD CANINE HA", "ppvd-ha-dog"),
        ("PPVD CANINE NC", "ppvd-nc-dog"),
        ("PPVD CANINE OM", "ppvd-om-dog"),
        ("PPVD CANINE UR", "ppvd-ur-dog"),
        ("ONE DOG SACHET", "purinaone-sachet-dog"),
        ("ONE CAT SACHET", "purinaone-sachet-cat"),
        ("ONE DOG", "purinaone-dog"),
        ("ONE CAT", "purinaone-cat"),
        ("FRISKIES SACHET ATUM", "friskies-sachet-atum"),
        ("FRISKIES SACHET CARNE", "friskies-sachet-carne"),
        ("FRISKIES SACHET CORDEIRO", "friskies-sachet-cordeiro"),
        ("FRISKIES SACHET FRANGO", "friskies-sachet-frango"),
        ("FRISKIES SACHET MIX", "friskies-sachet-carne"),
        ("FRISKIES SACHET MAR", "friskies-sachet-atum"),
        ("FRISKIES SACHET MEGAMIX", "friskies-sachet-carne"),
        ("FRISKIES SACHET PEIXE", "friskies-sachet-atum"),
        ("FRISKIES SACHET PERU", "friskies-sachet-cordeiro"),
        ("FRISKIES SACHET SALMAO", "friskies-sachet-atum"),
        ("FRISKIES PETISCOS CARNE", "friskies-petisco-carne"),
        ("FRISKIES PETISCOS SALM", "friskies-petisco-salmao"),
        ("FRISKIES MEGAMIX CASTRADOS", "friskies-mega-cast"),
        ("DOG CHOW ORAL MINI", "dogchow-oral-mini-105"),
        ("DOG CHOW ORAL MINI", "dogchow-oral-mini"),
        ("DOG CHOW ORAL M", "dogchow-oral-med"),
        ("DOG CHOW ORAL", "dogchow-oral-med-200"),
        ("DOG CHOW BISCOITO ADULTOS MINI", "dogchow-biscoito-mini"),
        ("DOG CHOW BISCOITO ADULTO M", "dogchow-biscoito-med"),
        ("CAT CHOW SACHET ADULTOS CASTRADOS 15X85 - PEIXE", "catchow-sachet-cast-peixe"),
        ("CAT CHOW SACHET ADULTOS CASTRADOS", "catchow-sachet-cast-carne"),
        ("CAT CHOW SACHET ADULTOS 15X85G - FRANGO", "catchow-sachet-adult-frango"),
        ("CAT CHOW SACHET ADULTOS 15X85G - CARNE", "catchow-sachet-adult-carne"),
        ("PRO PLAN SACHET ADULTO CARNE", "proplan-sachet-dog-carne"),
        ("PRO PLAN SACHET ADULTO FRANGO", "proplan-sachet-dog-frango"),
        ("PRO PLAN SENSITIVE SKIN R. MINI", "proplan-sens-mini"),
        ("PRO PLAN SENSITIVE SKIN", "proplan-sens-med"),
        ("PRO PLAN ADULT R. MED", "proplan-adult-medio"),
    ]
    for pattern, slug in rules:
        if pattern in d and slug in ALL_CROPS:
            return slug
    return None


def slug_for_item(item: dict) -> str:
    suggested = item["suggested"]["slug"]
    if suggested.startswith("purina-"):
        return suggested[len("purina-") :]
    return suggested


def resolve_crop_slug(item: dict) -> str:
    desc = item["desc"]
    for fn in (pick_family_slug, pick_family_slug_extra):
        slug = fn(desc)
        if slug and slug in ALL_CROPS:
            return slug
    fallback = slug_for_item(item)
    if fallback in ALL_CROPS:
        return fallback
    d = norm(desc)
    if "DOG CHOW" in d:
        return "dogchow-adult-med-grande"
    if "PRO PLAN" in d or "PRPN" in d or "PPVD" in d:
        return "proplan-adult-grande"
    if "FRISKIES" in d:
        return "friskies-mix-carnes"
    if "CAT CHOW" in d:
        return "catchow-adult-carne"
    return fallback[:70]


def extract_images(slugs: tuple[str, ...]) -> dict[str, str]:
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    doc = fitz.open(PDF_PATH)
    mapping: dict[str, str] = {}
    for slug in slugs:
        if slug not in ALL_CROPS:
            print(f"skip missing crop {slug}")
            continue
        page_num, x0, y0, x1, y1 = ALL_CROPS[slug]
        page = doc[page_num - 1]
        pad = 2 if slug.startswith("catchow-") else PAD_PT
        bbox = expand((x0, y0, x1, y1), page.rect, pad=pad)
        rendered = render_crop(page, bbox)
        embedded = best_embedded(page, bbox)
        if embedded and (
            embedded.size[0] * embedded.size[1]
            > rendered.size[0] * rendered.size[1] * 1.2
        ):
            img = embedded
            source = "embedded"
        else:
            img = rendered
            source = "render"
        img = optimize(img)
        fname = f"purina-{slug}.webp"
        dest = OUT_DIR / fname
        img.save(dest, "WEBP", quality=WEBP_QUALITY, method=6)
        mapping[slug] = f"/assets/products/catalog/{fname}"
        print(f"{slug}: {source} {img.size} {dest.stat().st_size} bytes")
    doc.close()
    return mapping


def build_catalog(items: list[dict], images: dict[str, str]) -> list[dict]:
    line = "Purina"
    catalog: list[dict] = []
    for item in items:
        weight = item["suggested"]["weight"]
        if not weight:
            continue
        crop_slug = resolve_crop_slug(item)
        if crop_slug not in images:
            print("no image", crop_slug, item["desc"])
            continue
        name, description, category = build_name(item["desc"], weight)
        price = round(item["price"] * 1.3, 2)
        page = item["suggested"]["catalogPage"]
        if page is None:
            if "PRPN" in norm(item["desc"]) or "PPVD FELINE" in norm(item["desc"]):
                page = 7
            elif "PPVD CANINE" in norm(item["desc"]):
                page = 5
            else:
                page = 7
        catalog.append(
            sku(
                name=name,
                category=category,
                line=line,
                price=price,
                image=images[crop_slug],
                description=description,
                weight=weight,
                catalogPage=page,
            )
        )
    return catalog


def append_master_sql(inserted: list[dict]) -> None:
    master = BASE / "insert_purina.sql"
    text = master.read_text(encoding="utf-8")
    if "COMMIT;" not in text:
        raise RuntimeError("insert_purina.sql sem COMMIT")

    blocks = []
    for p in inserted:
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

    ids = ", ".join(str(p["id"]) for p in inserted)
    when_lines = [f"    WHEN {p['id']} THEN {p['price']:.2f}" for p in inserted]

    marker = "-- Se os SKUs já existirem, aplica os preços com +30% sobre a tabela 16-07."
    if marker not in text:
        raise RuntimeError("marcador UPDATE não encontrado em insert_purina.sql")

    before_update, after_marker = text.split(marker, 1)
    update_section, commit_tail = after_marker.rsplit("COMMIT;", 1)

    # Estende CASE e lista IN do UPDATE principal.
    update_section = update_section.replace(
        "  END,\n  updated_at = NOW()",
        "\n".join(when_lines) + "\n  END,\n  updated_at = NOW()",
        1,
    )
    update_section = re.sub(
        r"AND external_id IN \([^)]+\);",
        lambda m: m.group(0)[:-1] + f", {ids});",
        update_section,
        count=1,
    )

    text = (
        before_update
        + "\n".join(blocks)
        + "\n"
        + marker
        + update_section
        + "COMMIT;"
        + commit_tail
    )
    master.write_text(text, encoding="utf-8")


def main() -> None:
    missing = json.loads(MISSING_PATH.read_text(encoding="utf-8"))
    slugs = tuple(dict.fromkeys(resolve_crop_slug(item) for item in missing))
    print(f"Missing SKUs: {len(missing)} | unique image crops: {len(slugs)}")
    images = extract_images(slugs)
    catalog = build_catalog(missing, images)
    print(f"Catalog entries built: {len(catalog)}")
    inserted = add_products(catalog)
    if inserted:
        batch_path = BASE / "insert_purina_all_remaining.sql"
        batch_src = BASE / "insert_purina_batch7.sql"
        if batch_src.exists():
            batch_path.write_text(batch_src.read_text(encoding="utf-8"), encoding="utf-8")
        append_master_sql(inserted)
        print(f"Inserted {len(inserted)} new Purina SKUs")


if __name__ == "__main__":
    main()
