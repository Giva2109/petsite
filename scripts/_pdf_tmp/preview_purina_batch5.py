from pathlib import Path
import io

import fitz
from PIL import Image

PDF = Path(r"C:\Users\givan\OneDrive\Desktop\GIVA\Mercado Livre\Purina\CATALAGO PURINA.pdf")
OUT = Path(__file__).parent / "purina"
OUT.mkdir(parents=True, exist_ok=True)

CROPS = {
    "proplan-cat-urinary": (7, 107.6, 402.0, 202.8, 497.2),
    "proplan-reduced-mini": (8, 400.6, 530.9, 501.1, 631.4),
    "catchow-cast-peixe": (21, 472.4, 230.8, 579.4, 337.8),
    "dogchow-7plus": (23, 400.1, 524.2, 476.3, 633.1),
    "friskies-kitten": (27, 36.3, 239.3, 151.2, 354.2),
}

doc = fitz.open(PDF)
mat = fitz.Matrix(400 / 72, 400 / 72)
for slug, (pn, x0, y0, x1, y1) in CROPS.items():
    page = doc[pn - 1]
    clip = fitz.Rect(max(0, x0 - 8), max(0, y0 - 8), x1 + 8, y1 + 8)
    pix = page.get_pixmap(matrix=mat, clip=clip, alpha=False)
    img = Image.open(io.BytesIO(pix.tobytes("png"))).convert("RGB")
    img.save(OUT / f"b5_{slug}.jpg", quality=90)
    print(slug, img.size)
doc.close()
