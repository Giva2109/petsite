"""Extrai imagens dos produtos Progato (areia de gato) do catálogo PDF em alta qualidade."""
from __future__ import annotations

import io
from pathlib import Path

import fitz
from PIL import Image

PDF_PATH = Path(
    r"C:\Users\givan\OneDrive\Desktop\GIVA\Mercado Livre\Pet_P2_P2p"
    r"\NOVO CATÁLOGO PROGATO PREMIER 2024 - ALT 5.pdf"
)
OUT_DIR = Path(__file__).parent.parent / "public" / "assets" / "products" / "accessories" / "progato"

RENDER_DPI = 400
MAX_LONG_EDGE = 1500
WEBP_QUALITY = 88
BBOX_PADDING_PT = 8

# slug -> página do PDF (1-based). Grãos pequenos perfumada não tem página dedicada.
PDF_PAGES: dict[str, int] = {
    "classica-multigraos": 6,
    "classica-multigraos-perfumada": 7,
    "premium": 8,
    "super-premium": 9,
    "light-weight": 10,
    "biobom": 11,
    "vida-comfort": 12,
    "vida-clean": 13,
    "ecorice": 14,
    "pinus": 15,
    "branco": 16,
    "sensitive": 17,
}

# Página 4 (infográfico): embalagem roxa "Clássica" grãos pequenos perfumada
MANUAL_CROPS: dict[str, tuple[int, tuple[float, float, float, float]]] = {
    "classica-graos-pequenos-perfumada": (
        4,
        (129.6, 489.6, 176.4, 608.4),
    ),
}


def main_bag_bbox(page) -> tuple[float, float, float, float] | None:
    """Detecta a embalagem principal (maior imagem vertical, excluindo fundo e logo)."""
    candidates: list[tuple[float, tuple[float, float, float, float]]] = []

    for block in page.get_text("dict")["blocks"]:
        if block["type"] != 1:
            continue
        x0, y0, x1, y1 = block["bbox"]
        w, h = x1 - x0, y1 - y0
        area = w * h

        if area > 400_000:
            continue
        if y0 < 50 and x0 < 200 and area < 50_000:
            continue
        if h < 100:
            continue
        if h < w * 0.5:
            continue

        candidates.append((area, (x0, y0, x1, y1)))

    if not candidates:
        return None

    candidates.sort(key=lambda item: item[0], reverse=True)
    return candidates[0][1]


def expand_bbox(bbox, page_rect, padding: float = BBOX_PADDING_PT):
    x0, y0, x1, y1 = bbox
    return (
        max(page_rect.x0, x0 - padding),
        max(page_rect.y0, y0 - padding),
        min(page_rect.x1, x1 + padding),
        min(page_rect.y1, y1 + padding),
    )


def render_crop(page, bbox, dpi: int = RENDER_DPI) -> Image.Image:
    mat = fitz.Matrix(dpi / 72, dpi / 72)
    clip = fitz.Rect(bbox)
    pix = page.get_pixmap(matrix=mat, clip=clip, alpha=False)
    return Image.open(io.BytesIO(pix.tobytes("png")))


def optimize_for_web(img: Image.Image) -> Image.Image:
    img = img.convert("RGB")
    w, h = img.size
    long_edge = max(w, h)
    if long_edge > MAX_LONG_EDGE:
        scale = MAX_LONG_EDGE / long_edge
        img = img.resize((int(w * scale), int(h * scale)), Image.Resampling.LANCZOS)
    return img


def save_webp(img: Image.Image, out_path: Path) -> tuple[int, int]:
    optimized = optimize_for_web(img)
    out_path.parent.mkdir(parents=True, exist_ok=True)
    optimized.save(out_path, "WEBP", quality=WEBP_QUALITY, method=6)
    return optimized.size


def extract_from_pdf(doc: fitz.Document, slug: str, page_num: int) -> tuple[int, int]:
    page = doc[page_num - 1]
    bbox = main_bag_bbox(page)
    if bbox is None:
        raise RuntimeError(f"Não foi possível detectar embalagem na página {page_num} ({slug})")

    bbox = expand_bbox(bbox, page.rect)
    img = render_crop(page, bbox)
    return save_webp(img, OUT_DIR / f"{slug}.webp")


MANUAL_RENDER_DPI = 800


def extract_manual_crop(
    doc: fitz.Document, slug: str, page_num: int, bbox: tuple[float, float, float, float]
) -> tuple[int, int]:
    page = doc[page_num - 1]
    expanded = expand_bbox(bbox, page.rect, padding=4)
    img = render_crop(page, expanded, dpi=MANUAL_RENDER_DPI)
    return save_webp(img, OUT_DIR / f"{slug}.webp")


def main():
    if not PDF_PATH.exists():
        raise FileNotFoundError(f"PDF não encontrado: {PDF_PATH}")

    OUT_DIR.mkdir(parents=True, exist_ok=True)
    doc = fitz.open(PDF_PATH)
    paths: dict[str, str] = {}

    try:
        for slug, page_num in PDF_PAGES.items():
            size = extract_from_pdf(doc, slug, page_num)
            rel = f"/assets/products/accessories/progato/{slug}.webp"
            paths[slug] = rel
            print(f"{slug:40} p.{page_num:2} {size[0]}x{size[1]} -> {slug}.webp")

        for slug, (page_num, bbox) in MANUAL_CROPS.items():
            size = extract_manual_crop(doc, slug, page_num, bbox)
            paths[slug] = f"/assets/products/accessories/progato/{slug}.webp"
            print(f"{slug:40} p.{page_num:2} manual {size[0]}x{size[1]} -> {slug}.webp")
    finally:
        doc.close()

    print(f"\n{len(paths)} imagens salvas em {OUT_DIR}")
    return paths


if __name__ == "__main__":
    main()
