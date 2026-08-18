from pathlib import Path
import io

import fitz
from PIL import Image

PDF = Path(r"C:\Users\givan\OneDrive\Desktop\GIVA\Mercado Livre\Purina\CATALAGO PURINA.pdf")
OUT = Path(__file__).parent / "purina"
OUT.mkdir(parents=True, exist_ok=True)

CROPS = {
    "proplan-cat-7plus": (7, 392.0, 156.1, 487.0, 248.8),
    "proplan-adult-grande": (8, 232.5, 535.1, 332.8, 635.0),
    "catchow-adult-peixe": (21, 255.6, 236.6, 349.5, 330.5),
    "dogchow-adult-mini": (23, 109.6, 524.2, 217.8, 632.1),
    "friskies-mar": (27, 446.1, 237.9, 559.1, 350.9),
}

doc = fitz.open(PDF)
mat = fitz.Matrix(400 / 72, 400 / 72)
for slug, (pn, x0, y0, x1, y1) in CROPS.items():
    page = doc[pn - 1]
    clip = fitz.Rect(max(0, x0 - 8), max(0, y0 - 8), x1 + 8, y1 + 8)
    pix = page.get_pixmap(matrix=mat, clip=clip, alpha=False)
    img = Image.open(io.BytesIO(pix.tobytes("png"))).convert("RGB")
    img.save(OUT / f"b3_{slug}.jpg", quality=90)
    print(slug, img.size)
doc.close()
