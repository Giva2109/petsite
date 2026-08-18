from pathlib import Path
import io

import fitz
from PIL import Image

PDF = Path(r"C:\Users\givan\OneDrive\Desktop\GIVA\Mercado Livre\Purina\CATALAGO PURINA.pdf")
OUT = Path(__file__).parent / "purina"
OUT.mkdir(parents=True, exist_ok=True)

CROPS = {
    "proplan-cat-sterilized": (7, 250.2, 403.1, 345.3, 498.2),
    "proplan-puppy-grande": (8, 257.0, 259.1, 312.1, 357.0),
    "catchow-cast-frango": (21, 360.0, 231.6, 466.2, 337.8),
    "dogchow-puppy-mini": (23, 108.7, 206.9, 229.3, 324.8),
    "friskies-megamix": (27, 310.3, 237.2, 424.0, 350.8),
}

doc = fitz.open(PDF)
mat = fitz.Matrix(400 / 72, 400 / 72)
for slug, (pn, x0, y0, x1, y1) in CROPS.items():
    page = doc[pn - 1]
    clip = fitz.Rect(max(0, x0 - 8), max(0, y0 - 8), x1 + 8, y1 + 8)
    pix = page.get_pixmap(matrix=mat, clip=clip, alpha=False)
    img = Image.open(io.BytesIO(pix.tobytes("png"))).convert("RGB")
    img.save(OUT / f"b4_{slug}.jpg", quality=90)
    print(slug, img.size)
doc.close()
