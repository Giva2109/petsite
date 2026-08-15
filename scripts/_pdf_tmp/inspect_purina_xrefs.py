from pathlib import Path

import fitz

PDF = Path(r"C:\Users\givan\OneDrive\Desktop\GIVA\Mercado Livre\Purina\CATALAGO PURINA.pdf")
doc = fitz.open(PDF)
page = doc[6]
clip = fitz.Rect(251.6, 154.2, 347.3, 247.2)
print("clip", clip)
infos = page.get_image_info(xrefs=True)
print("n infos", len(infos))
if infos:
    print("keys", infos[0].keys())
    for info in infos[:8]:
        print({k: info.get(k) for k in ("xref", "width", "height", "bpc", "cs-name", "bbox")})

# also list images
print("get_images", len(page.get_images(full=True)))
for item in page.get_images(full=True)[:10]:
    print(item)
    xref = item[0]
    try:
        raw = doc.extract_image(xref)
        print("  ", raw["width"], raw["height"], raw["ext"], len(raw["image"]))
    except Exception as e:
        print("  err", e)
doc.close()
