"""Recorta só as embalagens da Nutrição Clínica Cães, no mesmo padrão das outras fotos."""
from __future__ import annotations

import io
import json
from pathlib import Path

import fitz
from PIL import Image, ImageDraw, ImageFont, ImageFilter, ImageEnhance

PDF_CANDIDATES = [
    Path(r"C:\Users\givan\OneDrive\Desktop\GIVA\Mercado Livre\Pet_P2_P2p")
    / "Catálogo PremieRpet - 2026.pdf",
    Path(r"c:\workspace_pet_shop\petsite\scripts\_pdf_tmp\catalogo_premier_2026.pdf"),
]
OUT_DIR = Path(__file__).parent.parent / "public" / "assets" / "products" / "catalog"
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
SQL_PATH = Path(__file__).parent / "update_nutricao_clinica_caes_images.sql"
TENANT_ID = "a0000000-0000-4000-8000-000000000001"

RENDER_DPI = 600
MAX_LONG_EDGE = 1600
WEBP_QUALITY = 90

# Só as embalagens (sem título da página e sem ícones).
BAG_WINDOWS: dict[str, tuple[int, float, float, float, float]] = {
    "caes-cardio": (56, 22, 366, 147, 536),
    "caes-diabetes": (56, 318, 368, 450, 540),
    "caes-gastro": (56, 22, 622, 148, 800),
    "caes-hipo-hidro": (56, 320, 624, 448, 798),
    "caes-hipo-cordeiro": (57, 10, 228, 146, 412),
    "caes-obesidade": (57, 312, 232, 458, 418),
    "caes-renal": (57, 14, 492, 165, 688),
}

TITLES: dict[str, tuple[str, str]] = {
    "caes-cardio": ("CARDIO", ""),
    "caes-diabetes": ("DIABETES", ""),
    "caes-gastro": ("GASTROINTESTINAL", ""),
    "caes-hipo-hidro": ("HIPOALERGÊNICO", "Proteína Hidrolisada"),
    "caes-hipo-cordeiro": ("HIPOALERGÊNICO", "Cordeiro e Arroz"),
    "caes-obesidade": ("OBESIDADE", ""),
    "caes-renal": ("RENAL", ""),
}

TITLE_COLOR = (26, 86, 168)
SUBTITLE_COLOR = (92, 58, 32)

BENEFITS: dict[str, str] = {
    "caes-cardio": "Sódio controlado; taurina, L-carnitina e EPA+DHA.",
    "caes-diabetes": "Baixo amido, fibras e alta proteína para controle glicêmico.",
    "caes-gastro": "Alta digestibilidade, prebióticos e vitaminas do complexo B.",
    "caes-hipo-hidro": "Proteína hidrolisada e mandioca; fonte restrita de proteínas.",
    "caes-hipo-cordeiro": "Cordeiro e arroz; fonte restrita de proteínas e cuidado da pele.",
    "caes-obesidade": "Baixa caloria, alto teor de fibras e suporte articular.",
    "caes-renal": "Fósforo e proteína reduzidos; EPA+DHA para suporte renal.",
}

SLUG_BY_HINT = [
    ("Cardio", "caes-cardio"),
    ("Diabetes", "caes-diabetes"),
    ("Gastrointestinal", "caes-gastro"),
    ("Hipoalergênico Proteína Hidrolisada", "caes-hipo-hidro"),
    ("Hipoalergênico Cordeiro", "caes-hipo-cordeiro"),
    ("Obesidade", "caes-obesidade"),
    ("Renal", "caes-renal"),
]


def find_pdf() -> Path:
    for path in PDF_CANDIDATES:
        if path.exists():
            return path
    desktop = Path(r"C:\Users\givan\OneDrive\Desktop\GIVA\Mercado Livre\Pet_P2_P2p")
    matches = list(desktop.glob("*PremieRpet*2026*.pdf"))
    if matches:
        return matches[0]
    raise FileNotFoundError("Catálogo PremieRpet 2026.pdf não encontrado")


def optimize(img: Image.Image) -> Image.Image:
    img = img.convert("RGB")
    # Leve nitidez para compensar o raster do PDF, no mesmo espírito das outras fotos.
    img = img.filter(ImageFilter.UnsharpMask(radius=0.8, percent=55, threshold=3))
    img = ImageEnhance.Contrast(img).enhance(1.03)
    w, h = img.size
    long_edge = max(w, h)
    if long_edge > MAX_LONG_EDGE:
        scale = MAX_LONG_EDGE / long_edge
        img = img.resize((int(w * scale), int(h * scale)), Image.Resampling.LANCZOS)
    return img


def load_font(size: int) -> ImageFont.FreeTypeFont | ImageFont.ImageFont:
    for name in ("segoeuib.ttf", "arialbd.ttf", "calibrib.ttf", "seguisb.ttf"):
        try:
            return ImageFont.truetype(name, size)
        except OSError:
            continue
    return ImageFont.load_default()


def compose_card(bag: Image.Image, title: str, subtitle: str) -> Image.Image:
    bag = bag.convert("RGB")
    bw, bh = bag.size
    pad_x = 48
    pad_top = 28
    gap = 10
    title_font = load_font(max(48, min(96, bw // 12)))
    sub_font = load_font(max(28, min(56, bw // 20)))

    dummy = ImageDraw.Draw(Image.new("RGB", (10, 10)))
    tb = dummy.textbbox((0, 0), title, font=title_font)
    tw, th = tb[2] - tb[0], tb[3] - tb[1]
    sb = (0, 0, 0, 0)
    sw = sh = 0
    if subtitle:
        sb = dummy.textbbox((0, 0), subtitle, font=sub_font)
        sw, sh = sb[2] - sb[0], sb[3] - sb[1]

    header = pad_top + th + (gap + sh if subtitle else 0) + 24
    canvas_w = max(bw + pad_x * 2, tw + pad_x * 2, sw + pad_x * 2)
    canvas_h = header + bh + 24
    canvas = Image.new("RGB", (canvas_w, canvas_h), (255, 255, 255))
    draw = ImageDraw.Draw(canvas)
    draw.text((pad_x - tb[0], pad_top - tb[1]), title, font=title_font, fill=TITLE_COLOR)
    if subtitle:
        draw.text(
            (pad_x - sb[0], pad_top + th + gap - sb[1]),
            subtitle,
            font=sub_font,
            fill=SUBTITLE_COLOR,
        )
    canvas.paste(bag, ((canvas_w - bw) // 2, header))
    return canvas


def extract_images() -> dict[str, str]:
    pdf_path = find_pdf()
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    doc = fitz.open(pdf_path)
    mapping: dict[str, str] = {}
    mat = fitz.Matrix(RENDER_DPI / 72, RENDER_DPI / 72)

    for slug, (page_num, x0, y0, x1, y1) in BAG_WINDOWS.items():
        page = doc[page_num - 1]
        clip = fitz.Rect(x0, y0, x1, y1)
        pix = page.get_pixmap(matrix=mat, clip=clip, alpha=False)
        bag = Image.open(io.BytesIO(pix.tobytes("png")))
        bag = optimize(bag)
        title, subtitle = TITLES[slug]
        img = compose_card(bag, title, subtitle)
        fname = f"page-{page_num:02d}-{slug}.webp"
        dest = OUT_DIR / fname
        img.save(dest, "WEBP", quality=WEBP_QUALITY, method=6)
        mapping[slug] = f"/assets/products/catalog/{fname}"
        print(f"{slug}: {img.size} {dest.stat().st_size} bytes")

    doc.close()
    return mapping


def slug_for_product(product: dict) -> str | None:
    name = product.get("name") or ""
    if product.get("line") != "PremieR Nutrição Clínica Cães":
        return None
    for hint, slug in SLUG_BY_HINT:
        if hint in name:
            return slug
    return None


def sql_literal(value: str) -> str:
    return "'" + value.replace("'", "''") + "'"


def update_products() -> None:
    products = json.loads(PRODUCTS_PATH.read_text(encoding="utf-8"))
    updated = []
    for product in products:
        slug = slug_for_product(product)
        if not slug:
            continue
        benefit = BENEFITS[slug]
        weight = product["weight"]
        product["description"] = (
            f"Alimento coadjuvante PremieR Nutrição Clínica. {benefit} Embalagem {weight}."
        )
        updated.append(product)

    payload = json.dumps(products, ensure_ascii=False, indent=2) + "\n"
    PRODUCTS_PATH.write_text(payload, encoding="utf-8")
    if SEED_PATH.parent.exists():
        SEED_PATH.write_text(payload, encoding="utf-8")

    sql = [
        "-- Atualiza descrições da Nutrição Clínica Cães (imagens refeitas no mesmo path)",
        "BEGIN;",
    ]
    for product in updated:
        sql.append(
            f"""
UPDATE products
SET description = {sql_literal(product['description'])},
    updated_at = NOW()
WHERE tenant_id = '{TENANT_ID}'
  AND external_id = {product['id']};
""".strip()
        )
    sql.append("COMMIT;")
    SQL_PATH.write_text("\n".join(sql) + "\n", encoding="utf-8")
    print(f"updated {len(updated)} descriptions -> {SQL_PATH}")


if __name__ == "__main__":
    extract_images()
    update_products()
