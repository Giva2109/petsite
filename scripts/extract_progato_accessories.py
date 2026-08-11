"""Extrai imagens dos produtos Progato (areia de gato) do catálogo de preços."""
from pathlib import Path

from PIL import Image

SRC = Path(
    r"C:\Users\givan\.cursor\projects\c-workspace-pet-shop\assets"
    r"\c__Users_givan_AppData_Roaming_Cursor_User_workspaceStorage_85cb72ca7c1939b54314a4d36375646a_images_Preco_Areia_Gatos-7ea51f23-757e-416f-9f88-a31434ba2ce6.png"
)
OUT_DIR = Path(__file__).parent.parent / "public" / "assets" / "products" / "accessories" / "progato"

# Regiões (left, top, right, bottom) — apenas a embalagem, sem tabela de preços
CROPS = [
    ("classica-multigraos", (8, 118, 205, 295)),
    ("classica-multigraos-perfumada", (218, 118, 415, 295)),
    ("classica-graos-pequenos-perfumada", (428, 118, 625, 295)),
    ("premium", (8, 352, 205, 528)),
    ("super-premium", (218, 352, 415, 528)),
    ("branco", (428, 352, 625, 528)),
    ("vida-comfort", (8, 586, 205, 762)),
    ("vida-clean", (218, 586, 415, 762)),
    ("ecorice", (428, 586, 625, 762)),
    ("sensitive", (8, 820, 155, 955)),
    ("light-weight", (165, 820, 312, 955)),
    ("pinus", (322, 820, 469, 955)),
    ("biobom", (476, 820, 625, 955)),
]

MAX_EDGE = 1500
WEBP_QUALITY = 88


def optimize(img: Image.Image) -> Image.Image:
    img = img.convert("RGB")
    w, h = img.size
    long_edge = max(w, h)
    if long_edge > MAX_EDGE:
        scale = MAX_EDGE / long_edge
        img = img.resize((int(w * scale), int(h * scale)), Image.Resampling.LANCZOS)
    return img


def main():
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    source = Image.open(SRC)
    paths = {}
    for slug, box in CROPS:
        crop = source.crop(box)
        crop = optimize(crop)
        out = OUT_DIR / f"{slug}.webp"
        crop.save(out, "WEBP", quality=WEBP_QUALITY, method=6)
        paths[slug] = f"/assets/products/accessories/progato/{slug}.webp"
        print(slug, crop.size, "->", out.name)
    return paths


if __name__ == "__main__":
    main()
