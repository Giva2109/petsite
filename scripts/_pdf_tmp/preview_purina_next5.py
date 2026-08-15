from pathlib import Path

import fitz
from PIL import Image
import io

PDF = Path(r"C:\Users\givan\OneDrive\Desktop\GIVA\Mercado Livre\Purina\CATALAGO PURINA.pdf")
OUT = Path(__file__).parent / "purina"
OUT.mkdir(parents=True, exist_ok=True)
CROPS = {
    "proplan-cat-kitten": (7, 108.0, 157.7, 203.7, 248.8),
    "proplan-adult-mini": (8, 400.1, 256.8, 500.1, 356.4),
    "catchow-kitten": (21, 25.9, 229.2, 131.8, 335.2),
    "dogchow-puppy-med": (23, 243.7, 207.4, 362.7, 326.4),
    "friskies-granja": (27, 101.3, 534.3, 215.3, 648.3),
}
doc = fitz.open(PDF)
mat = fitz.Matrix(400 / 72, 400 / 72)
for slug, (pn, x0, y0, x1, y1) in CROPS.items():
    page = doc[pn - 1]
    clip = fitz.Rect(max(0, x0 - 8), max(0, y0 - 8), x1 + 8, y1 + 8)
    pix = page.get_pixmap(matrix=mat, clip=clip, alpha=False)
    img = Image.open(io.BytesIO(pix.tobytes("png"))).convert("RGB")
    dest = OUT / f"next_{slug}.jpg"
    img.save(dest, quality=90)
    print(slug, img.size)
doc.close()
