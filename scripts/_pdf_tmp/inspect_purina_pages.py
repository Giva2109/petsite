import json
from pathlib import Path

import fitz

PDF = Path(r"C:\Users\givan\OneDrive\Desktop\GIVA\Mercado Livre\Purina\CATALAGO PURINA.pdf")
OUT = Path(__file__).parent / "purina"
OUT.mkdir(parents=True, exist_ok=True)

doc = fitz.open(PDF)
for pn in (7, 8, 21, 23, 27):
    page = doc[pn - 1]
    mat = fitz.Matrix(120 / 72, 120 / 72)
    pix = page.get_pixmap(matrix=mat, alpha=False)
    pix.save(str(OUT / f"page_{pn:02d}.jpg"))
    imgs = []
    for i, block in enumerate(page.get_text("dict")["blocks"]):
        if block.get("type") != 1:
            continue
        x0, y0, x1, y1 = block["bbox"]
        w, h = x1 - x0, y1 - y0
        imgs.append(
            {
                "i": i,
                "bbox": [round(x0, 1), round(y0, 1), round(x1, 1), round(y1, 1)],
                "w": round(w, 1),
                "h": round(h, 1),
                "area": round(w * h),
            }
        )
    imgs.sort(key=lambda item: (round(item["bbox"][1] / 20), item["bbox"][0]))
    print(f"\nPAGE {pn} n={len(imgs)}")
    for item in imgs:
        print(f"  {item['bbox']} w={item['w']} h={item['h']} area={item['area']}")
    (OUT / f"page_{pn:02d}_imgs.json").write_text(
        json.dumps(imgs, indent=2), encoding="utf-8"
    )
doc.close()
print("done")
