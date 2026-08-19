from pathlib import Path
import io
import json

import fitz
from PIL import Image

PDF = Path(r"C:\Users\givan\OneDrive\Desktop\GIVA\Mercado Livre\Purina\CATALAGO PURINA.pdf")
OUT = Path(__file__).parent / "purina"
OUT.mkdir(parents=True, exist_ok=True)

CROPS = {
    "proplan-cat-liveclear": (7, 412.4, 406.3, 469.3, 494.3),
    "proplan-adult-medio": (8, 100.4, 536.7, 158.2, 633.3),
    "catchow-wet-a": (21, 146.1, 469.8, 231.6, 552.2),
    "catchow-wet-b": (21, 258.7, 470.7, 343.8, 546.0),
    "catchow-wet-c": (21, 370.4, 470.7, 455.5, 546.0),
    "catchow-wet-d": (21, 146.4, 646.0, 231.8, 727.9),
    "catchow-wet-e": (21, 258.6, 646.0, 344.0, 727.9),
    "catchow-wet-f": (21, 390.2, 656.2, 435.6, 721.4),
    "dogchow-papita": (23, 413.0, 219.1, 465.5, 314.3),
    "friskies-mix-cast": (27, 240.9, 531.9, 354.0, 645.0),
    "friskies-mega-cast": (27, 377.7, 530.9, 491.1, 644.3),
}

doc = fitz.open(PDF)
mat = fitz.Matrix(400 / 72, 400 / 72)
for slug, (pn, x0, y0, x1, y1) in CROPS.items():
    page = doc[pn - 1]
    clip = fitz.Rect(max(0, x0 - 8), max(0, y0 - 8), x1 + 8, y1 + 8)
    pix = page.get_pixmap(matrix=mat, clip=clip, alpha=False)
    img = Image.open(io.BytesIO(pix.tobytes("png"))).convert("RGB")
    img.save(OUT / f"b6_{slug}.jpg", quality=90)
    print(slug, img.size)

for pn in (9, 31):
    page = doc[pn - 1]
    mats = fitz.Matrix(120 / 72, 120 / 72)
    pix = page.get_pixmap(matrix=mats, alpha=False)
    pix.save(str(OUT / f"page_{pn:02d}.jpg"))
    imgs = []
    for i, block in enumerate(page.get_text("dict")["blocks"]):
        if block.get("type") != 1:
            continue
        x0, y0, x1, y1 = block["bbox"]
        w, h = x1 - x0, y1 - y0
        if w * h < 4000:
            continue
        imgs.append({"bbox": [round(x0, 1), round(y0, 1), round(x1, 1), round(y1, 1)], "w": round(w, 1), "h": round(h, 1)})
    imgs.sort(key=lambda item: (round(item["bbox"][1] / 20), item["bbox"][0]))
    print(f"\nPAGE {pn}")
    for item in imgs:
        print(f"  {item['bbox']} w={item['w']} h={item['h']}")
    (OUT / f"page_{pn:02d}_imgs.json").write_text(json.dumps(imgs, indent=2), encoding="utf-8")
doc.close()
print("done")
