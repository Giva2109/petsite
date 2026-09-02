"""Corrige imagens Purina: peso visível na embalagem deve bater com a descrição."""
from __future__ import annotations

import json
import re
import unicodedata
from pathlib import Path

import fitz
from PIL import Image

from add_purina import (
    CROPS,
    OUT_DIR,
    PRODUCTS_PATH,
    SEED_PATH,
    TENANT_ID,
    best_embedded,
    expand,
    optimize,
    render_crop,
    sql_literal,
)

BASE = Path(__file__).parent
PDF_PATH = Path(
    r"C:\Users\givan\OneDrive\Desktop\GIVA\Mercado Livre\Purina\CATALAGO PURINA.pdf"
)

# page, x0, y0, x1, y1 — peso impresso na embalagem conferido no catálogo PDF.
WEIGHT_CROPS: dict[str, tuple[int, float, float, float, float, str]] = {
    # --- Pro Plan Gatos (p.7) ---
    "proplan-cat-kitten-1kg": (7, 108.0, 157.7, 203.7, 248.8, "1kg"),
    "proplan-cat-adult-frango-1kg": (7, 251.6, 154.2, 347.3, 247.2, "1kg"),
    "proplan-cat-7plus-1kg": (7, 392.0, 156.1, 487.0, 248.8, "1kg"),
    "proplan-cat-urinary-1kg": (7, 107.6, 402.0, 202.8, 497.2, "1kg"),
    "proplan-cat-sterilized-1kg": (7, 250.2, 403.1, 345.3, 498.2, "1kg"),
    "proplan-cat-liveclear-1kg": (7, 412.4, 406.3, 469.3, 494.3, "1kg"),
    "proplan-sachet-adult-frango-85g": (7, 192.5, 625.9, 266.2, 732.0, "85g"),
    # --- Pro Plan Cães (p.8) ---
    "proplan-puppy-mini-1kg": (8, 80.2, 255.2, 180.9, 355.9, "1kg"),
    "proplan-puppy-grande-15kg": (8, 228.0, 248.0, 350.0, 368.0, "15kg"),
    "proplan-adult-mini-7-5kg": (8, 400.1, 256.8, 500.1, 356.4, "7.5kg"),
    "proplan-adult-medio-15kg": (8, 100.4, 536.7, 158.2, 633.3, "15kg"),
    "proplan-adult-grande-15kg": (8, 232.5, 535.1, 332.8, 635.0, "15kg"),
    "proplan-reduced-mini-7-5kg": (8, 400.6, 530.9, 501.1, 631.4, "7.5kg"),
    # --- Pro Plan Cães (p.9) ---
    "proplan-reduced-med-2-5kg": (9, 48.6, 268.7, 149.1, 369.2, "2.5kg"),
    "proplan-sens-mini-2-5kg": (9, 197.8, 270.4, 254.6, 366.9, "2.5kg"),
    "proplan-sens-med-2-5kg": (9, 303.4, 267.7, 404.5, 368.9, "2.5kg"),
    "proplan-activemind-1kg": (9, 437.6, 268.8, 538.6, 369.8, "1kg"),
    "proplan-sachet-dog-carne-100g": (9, 195.4, 544.1, 251.4, 633.4, "100g"),
    "proplan-sachet-dog-frango-100g": (9, 330.8, 548.4, 384.9, 634.1, "100g"),
    # --- PPVD (p.5) ---
    "ppvd-ha-cat-1-5kg": (5, 62.4, 252.9, 123.9, 349.5, "1.5kg"),
    "ppvd-ur-cat-1-5kg": (5, 185.5, 244.3, 267.1, 362.8, "1.5kg"),
    "ppvd-om-cat-1-5kg": (5, 321.9, 245.5, 404.8, 362.6, "1.5kg"),
    "ppvd-ha-dog-2kg": (5, 116.8, 534.2, 198.0, 654.1, "2kg"),
    "ppvd-nc-dog-2kg": (5, 251.0, 531.8, 337.1, 658.0, "2kg"),
    "ppvd-om-dog-2kg": (5, 391.5, 534.9, 468.7, 653.2, "2kg"),
    "ppvd-ur-dog-2kg": (5, 458.1, 244.5, 542.8, 363.4, "2kg"),
    # --- Cat Chow (p.21) — saco seco mostra 10,1 kg ---
    "catchow-kitten-10-1kg": (21, 28.0, 232.0, 130.0, 335.2, "10.1kg"),
    "catchow-adult-carne-10-1kg": (21, 137.8, 230.3, 242.6, 335.2, "10.1kg"),
    "catchow-adult-peixe-10-1kg": (21, 255.6, 236.6, 349.5, 330.5, "10.1kg"),
    "catchow-cast-frango-10-1kg": (21, 360.0, 231.6, 466.2, 337.8, "10.1kg"),
    "catchow-cast-peixe-10-1kg": (21, 472.4, 230.8, 579.4, 337.8, "10.1kg"),
    "catchow-sachet-kitten-85g": (21, 146.1, 469.8, 231.6, 552.2, "85g"),
    "catchow-sachet-cast-peixe-85g": (21, 370.4, 470.7, 455.5, 546.0, "85g"),
    "catchow-sachet-cast-carne-85g": (21, 258.7, 470.7, 343.8, 546.0, "85g"),
    "catchow-sachet-adult-frango-85g": (21, 146.4, 646.0, 231.8, 727.9, "85g"),
    "catchow-sachet-adult-carne-85g": (21, 258.6, 646.0, 344.0, 727.9, "85g"),
    "catchow-sachet-adult-peixe-85g": (21, 390.2, 656.2, 435.6, 721.4, "85g"),
    # --- Dog Chow (p.23) ---
    "dogchow-puppy-mini-1kg": (23, 108.7, 206.9, 229.3, 324.8, "1kg"),
    "dogchow-puppy-med-1kg": (23, 243.7, 207.4, 362.7, 326.4, "1kg"),
    "dogchow-papita-20kg": (23, 413.0, 219.1, 465.5, 314.3, "20kg"),
    "dogchow-adult-mini-10-1kg": (23, 109.6, 524.2, 217.8, 632.1, "10.1kg"),
    "dogchow-adult-med-grande-10-1kg": (23, 249.9, 524.2, 356.6, 632.4, "10.1kg"),
    "dogchow-7plus-15kg": (23, 400.1, 524.2, 476.3, 633.1, "15kg"),
    # --- Dog Chow biscoitos / oral (p.25) ---
    "dogchow-biscoito-filhotes-500g": (25, 149.0, 268.0, 286.0, 405.0, "500g"),
    "dogchow-biscoito-adult-mini-500g": (25, 286.0, 268.0, 422.0, 405.0, "500g"),
    "dogchow-biscoito-adult-med-500g": (25, 422.0, 268.0, 558.0, 405.0, "500g"),
    "dogchow-oral-mini-45g": (25, 56.7, 457.5, 136.0, 552.0, "45g"),
    "dogchow-oral-mini-105g": (25, 261.8, 236.0, 332.6, 333.3, "105g"),
    "dogchow-oral-med-80g": (25, 326.4, 449.6, 405.4, 549.5, "80g"),
    "dogchow-oral-med-200g": (25, 455.0, 461.7, 550.4, 550.7, "200g"),
    # --- Friskies (p.27) — saco seco mostra 1 kg ---
    "friskies-kitten-1kg": (27, 36.3, 239.3, 151.2, 354.2, "1kg"),
    "friskies-mix-carnes-1kg": (27, 173.6, 239.9, 286.7, 352.9, "1kg"),
    "friskies-megamix-1kg": (27, 310.3, 237.2, 424.0, 350.8, "1kg"),
    "friskies-mar-1kg": (27, 446.1, 237.9, 559.1, 350.9, "1kg"),
    "friskies-granja-1kg": (27, 101.3, 534.3, 215.3, 648.3, "1kg"),
    "friskies-mix-cast-1kg": (27, 240.9, 531.9, 354.0, 645.0, "1kg"),
    "friskies-mega-cast-1kg": (27, 377.7, 530.9, 491.1, 644.3, "1kg"),
    # --- Friskies sachês (p.28) ---
    "friskies-sachet-atum-85g": (28, 36.3, 48.0, 141.0, 152.0, "85g"),
    "friskies-sachet-carne-85g": (28, 173.0, 48.0, 278.0, 152.0, "85g"),
    "friskies-sachet-cordeiro-85g": (28, 310.0, 48.0, 415.0, 152.0, "85g"),
    "friskies-sachet-frango-85g": (28, 446.0, 48.0, 551.0, 152.0, "85g"),
    # --- Friskies petiscos (p.29) ---
    "friskies-petisco-frango-40g": (29, 157.6, 266.5, 217.0, 363.6, "40g"),
    "friskies-petisco-carne-40g": (29, 378.2, 266.5, 437.7, 363.6, "40g"),
    "friskies-petisco-salmao-80g": (29, 273.9, 553.5, 333.3, 650.7, "80g"),
    # --- Fancy Feast (p.17) ---
    "fancy-casserole-atum-85g": (17, 319.7, 303.4, 417.2, 400.8, "85g"),
    "fancy-casserole-frango-85g": (17, 457.2, 303.4, 554.6, 400.8, "85g"),
    "fancy-demi-carne-85g": (17, 41.6, 542.6, 141.2, 642.3, "85g"),
    "fancy-demi-frango-85g": (17, 181.2, 546.0, 280.9, 645.7, "85g"),
    "fancy-goulash-atum-85g": (17, 318.6, 543.3, 418.3, 643.0, "85g"),
    "fancy-goulash-peru-85g": (17, 456.1, 542.6, 555.7, 642.2, "85g"),
    "fancy-petit-carne-85g": (17, 43.8, 304.5, 141.3, 402.0, "85g"),
    "fancy-petit-salmao-85g": (17, 182.3, 304.5, 279.7, 402.0, "85g"),
    "fancy-supremo-bacalhau-75g": (17, 318.6, 543.3, 418.3, 643.0, "75g"),
    "fancy-supremo-carne-75g": (17, 456.1, 542.6, 555.7, 642.2, "75g"),
    "fancy-supremo-peixe-75g": (17, 318.6, 543.3, 418.3, 643.0, "75g"),
    # --- Dentalife (p.15) ---
    "dentalife-pequena-42g": (15, 60.3, 246.1, 195.4, 381.1, "42g"),
    "dentalife-media-119g": (15, 236.7, 255.6, 357.9, 376.8, "119g"),
    "dentalife-grande-196g": (15, 396.3, 245.4, 537.3, 386.3, "196g"),
    "dentalife-gatos-40g": (15, 214.5, 559.7, 348.6, 693.8, "40g"),
    # --- Doguitos (p.19) ---
    "doguitos-frango-65g": (19, 109.4, 206.7, 258.0, 378.3, "65g"),
    "doguitos-carne-65g": (19, 343.7, 206.7, 479.5, 379.3, "65g"),
    "doguitos-linguica-45g": (19, 238.9, 514.3, 366.1, 686.6, "45g"),
    # --- Purina One (p.11-13) ---
    "purinaone-dog-1kg": (11, 48.0, 48.0, 192.0, 192.0, "1kg"),
    "purinaone-cat-1kg": (12, 48.0, 48.0, 192.0, 192.0, "1kg"),
    "purinaone-sachet-dog-85g": (13, 48.0, 268.0, 149.0, 369.0, "85g"),
    "purinaone-sachet-cat-85g": (13, 303.0, 268.0, 404.0, 369.0, "85g"),
    # --- Alpo / Gatsy (p.31) ---
    "alpo-adulto-18kg": (31, 304.2, 280.8, 566.9, 543.5, "18kg"),
    "alpo-filhote-18kg": (31, 12.8, 266.5, 304.2, 557.9, "18kg"),
    "gatsy-carne-20kg": (31, 304.2, 280.8, 566.9, 543.5, "20kg"),
}

# Peso impresso na embalagem -> slug preferido por família de produto.
FAMILY_WEIGHT_SLUGS: list[tuple[str, str, str]] = [
    # Dog Chow biscoitos
    ("DOG CHOW BISCOITO FILHOTES", "300g", "dogchow-biscoito-filhotes-500g"),
    ("DOG CHOW BISCOITO FILHOTES", "500g", "dogchow-biscoito-filhotes-500g"),
    ("DOG CHOW BISCOITO ADULTOS MINI", "500g", "dogchow-biscoito-adult-mini-500g"),
    ("DOG CHOW BISCOITO ADULTO M", "500g", "dogchow-biscoito-adult-med-500g"),
    # Dog Chow oral
    ("DOG CHOW ORAL MINI", "45g", "dogchow-oral-mini-45g"),
    ("DOG CHOW ORAL MINI", "105g", "dogchow-oral-mini-105g"),
    ("DOG CHOW ORAL M", "80g", "dogchow-oral-med-80g"),
    ("DOG CHOW ORAL", "200g", "dogchow-oral-med-200g"),
    # Dog Chow filhotes mini
    ("DOG CHOW EXTRA LIFE FILHOTES MINIS", "1kg", "dogchow-puppy-mini-1kg"),
    ("DOG CHOW EXTRA LIFE FILHOTES MINIS", "3kg", "dogchow-puppy-mini-1kg"),
    ("DOG CHOW EXTRA LIFE FILHOTES MINIS", "900g", "dogchow-puppy-mini-1kg"),
    ("DOG CHOW EXTRA LIFE FILHOTES MINIS", "2.5kg", "dogchow-puppy-mini-1kg"),
    ("DOG CHOW EXTRA LIFE FILHOTES MINIS", "10.1kg", "dogchow-adult-mini-10-1kg"),
    ("DOG CHOW EXTRA LIFE FILHOTES MINIS", "15kg", "dogchow-adult-mini-10-1kg"),
    ("DOG CHOW SACHE FILHOTES", "15x100g", "dogchow-puppy-med-1kg"),
    ("DOG CHOW FILHOTE", "15x85g", "dogchow-puppy-med-1kg"),
    # Dog Chow filhotes med
    ("DOG CHOW EXTRA LIFE FILHOTES M", "1kg", "dogchow-puppy-med-1kg"),
    ("DOG CHOW EXTRA LIFE FILHOTES M", "3kg", "dogchow-puppy-med-1kg"),
    ("DOG CHOW EXTRA LIFE FILHOTES M", "900g", "dogchow-puppy-med-1kg"),
    ("DOG CHOW EXTRA LIFE FILHOTES M", "2.5kg", "dogchow-puppy-med-1kg"),
    ("DOG CHOW EXTRA LIFE FILHOTES M", "10.1kg", "dogchow-adult-med-grande-10-1kg"),
    ("DOG CHOW EXTRA LIFE FILHOTES M", "15kg", "dogchow-adult-med-grande-10-1kg"),
    # Dog Chow adult mini
    ("DOG CHOW EXTRA LIFE ADULTOS MINIS", "900g", "dogchow-puppy-mini-1kg"),
    ("DOG CHOW EXTRA LIFE ADULTOS MINIS", "2.5kg", "dogchow-puppy-mini-1kg"),
    ("DOG CHOW EXTRA LIFE ADULTOS MINIS", "1kg", "dogchow-puppy-mini-1kg"),
    ("DOG CHOW EXTRA LIFE ADULTOS MINIS", "3kg", "dogchow-puppy-mini-1kg"),
    ("DOG CHOW EXTRA LIFE ADULTOS MINIS", "10.1kg", "dogchow-adult-mini-10-1kg"),
    ("DOG CHOW EXTRA LIFE ADULTOS MINIS", "15kg", "dogchow-adult-mini-10-1kg"),
    ("DOG CHOW EXTRA LIFE ADULTOS MINIS", "20kg", "dogchow-papita-20kg"),
    ("DOG CHOW ADULTOS MINIS E PEQUENOS", "900g", "dogchow-puppy-mini-1kg"),
    ("DOG CHOW ADULTOS MINIS E PEQUENOS", "2.5kg", "dogchow-puppy-mini-1kg"),
    ("DOG CHOW ADULTOS MINIS E PEQUENOS", "10.1kg", "dogchow-adult-mini-10-1kg"),
    ("DOG CHOW ADULTOS MINIS E PEQUENOS", "15kg", "dogchow-adult-mini-10-1kg"),
    # Dog Chow adult med
    ("DOG CHOW EXTRA LIFE ADULTOS M", "900g", "dogchow-puppy-med-1kg"),
    ("DOG CHOW EXTRA LIFE ADULTOS M", "2.5kg", "dogchow-puppy-med-1kg"),
    ("DOG CHOW EXTRA LIFE ADULTOS M", "10.1kg", "dogchow-adult-med-grande-10-1kg"),
    ("DOG CHOW EXTRA LIFE ADULTOS M", "15kg", "dogchow-adult-med-grande-10-1kg"),
    ("DOG CHOW EXTRA LIFE ADULTOS M", "20kg", "dogchow-papita-20kg"),
    ("DOG CHOW ADULTOS MEDIOS E GRANDES", "900g", "dogchow-puppy-med-1kg"),
    ("DOG CHOW ADULTOS MEDIOS E GRANDES", "2.5kg", "dogchow-puppy-med-1kg"),
    ("DOG CHOW ADULTOS MEDIOS E GRANDES", "10.1kg", "dogchow-adult-med-grande-10-1kg"),
    ("DOG CHOW ADULTOS MEDIOS E GRANDES", "15kg", "dogchow-adult-med-grande-10-1kg"),
    # Dog Chow 7+
    ("DOG CHOW EXTRA LIFE ADULTOS LONGEVIDADE", "900g", "dogchow-puppy-mini-1kg"),
    ("DOG CHOW EXTRA LIFE ADULTOS 7+", "900g", "dogchow-puppy-mini-1kg"),
    ("DOG CHOW EXTRA LIFE ADULTOS LONGEVIDADE", "15kg", "dogchow-7plus-15kg"),
    ("DOG CHOW EXTRA LIFE ADULTOS 7+", "15kg", "dogchow-7plus-15kg"),
    ("DOG CHOW EXTRA LIFE PAPITA", "20kg", "dogchow-papita-20kg"),
    # Cat Chow seco — catálogo só tem foto 10,1 kg
    ("CAT CHOW FILHOTES", "1kg", "catchow-kitten-10-1kg"),
    ("CAT CHOW FILHOTES", "2.7kg", "catchow-kitten-10-1kg"),
    ("CAT CHOW FILHOTES", "10.1kg", "catchow-kitten-10-1kg"),
    ("CAT CHOW ADULTOS CARNE", "1kg", "catchow-adult-carne-10-1kg"),
    ("CAT CHOW ADULTOS CARNE", "2.7kg", "catchow-adult-carne-10-1kg"),
    ("CAT CHOW ADULTOS CARNE", "10.1kg", "catchow-adult-carne-10-1kg"),
    ("CAT CHOW ADULTOS PEIXE", "1kg", "catchow-adult-peixe-10-1kg"),
    ("CAT CHOW ADULTOS PEIXE", "2.7kg", "catchow-adult-peixe-10-1kg"),
    ("CAT CHOW ADULTOS PEIXE", "10.1kg", "catchow-adult-peixe-10-1kg"),
    ("CAT CHOW ADULTOS CASTRADOS FRANGO", "1kg", "catchow-cast-frango-10-1kg"),
    ("CAT CHOW ADULTOS CASTRADOS FRANGO", "2.7kg", "catchow-cast-frango-10-1kg"),
    ("CAT CHOW ADULTOS CASTRADOS FRANGO", "10.1kg", "catchow-cast-frango-10-1kg"),
    ("CAT CHOW ADULTOS CASTRADOS PEIXE", "1kg", "catchow-cast-peixe-10-1kg"),
    ("CAT CHOW ADULTOS CASTRADOS PEIXE", "2.7kg", "catchow-cast-peixe-10-1kg"),
    ("CAT CHOW ADULTOS CASTRADOS PEIXE", "10.1kg", "catchow-cast-peixe-10-1kg"),
    # Friskies seco — catálogo mostra 1 kg; 10,1 kg usa saco proporcionalmente maior (mesma arte)
    ("FRISKIES FILHOTES", "500g", "friskies-kitten-1kg"),
    ("FRISKIES FILHOTES", "850g", "friskies-kitten-1kg"),
    ("FRISKIES FILHOTES", "1kg", "friskies-kitten-1kg"),
    ("FRISKIES FILHOTES", "2.5kg", "friskies-kitten-1kg"),
    ("FRISKIES FILHOTES", "3kg", "friskies-kitten-1kg"),
    ("FRISKIES FILHOTES", "10.1kg", "friskies-kitten-1kg"),
    ("FRISKIES MIX CARNE ADULTOS", "1kg", "friskies-mix-carnes-1kg"),
    ("FRISKIES MIX CARNE ADULTOS", "3kg", "friskies-mix-carnes-1kg"),
    ("FRISKIES MIX CARNE ADULTOS", "10.1kg", "friskies-mix-carnes-1kg"),
    ("FRISKIES MIX CARNE ADULTOS", "20kg", "friskies-mix-carnes-1kg"),
    ("FRISKIES MEGAMIX ADULTOS", "1kg", "friskies-megamix-1kg"),
    ("FRISKIES MEGAMIX ADULTOS", "3kg", "friskies-megamix-1kg"),
    ("FRISKIES MEGAMIX ADULTOS", "10.1kg", "friskies-megamix-1kg"),
    ("FRISKIES MEGAMIX CASTRADOS", "850g", "friskies-mega-cast-1kg"),
    ("FRISKIES MEGAMIX CASTRADOS", "1kg", "friskies-mega-cast-1kg"),
    ("FRISKIES MEGAMIX CASTRADOS", "2.5kg", "friskies-mega-cast-1kg"),
    ("FRISKIES MEGAMIX CASTRADOS", "3kg", "friskies-mega-cast-1kg"),
    ("FRISKIES MEGAMIX CASTRADOS", "10.1kg", "friskies-mega-cast-1kg"),
    ("FRISKIES MAR DE SABORES", "850g", "friskies-mar-1kg"),
    ("FRISKIES MAR DE SABORES", "1kg", "friskies-mar-1kg"),
    ("FRISKIES MAR DE SABORES", "2.5kg", "friskies-mar-1kg"),
    ("FRISKIES MAR DE SABORES", "3kg", "friskies-mar-1kg"),
    ("FRISKIES MAR DE SABORES", "10.1kg", "friskies-mar-1kg"),
    ("FRISKIES DELICIAS DA GRANJA", "850g", "friskies-granja-1kg"),
    ("FRISKIES DELICIAS DA GRANJA", "1kg", "friskies-granja-1kg"),
    ("FRISKIES DELICIAS DA GRANJA", "2.5kg", "friskies-granja-1kg"),
    ("FRISKIES DELICIAS DA GRANJA", "3kg", "friskies-granja-1kg"),
    ("FRISKIES DELICIAS DA GRANJA", "10.1kg", "friskies-granja-1kg"),
    ("FRISKIES MIX CARNE CASTRADOS", "1kg", "friskies-mix-cast-1kg"),
    ("FRISKIES MIX CARNE CASTRADOS", "3kg", "friskies-mix-cast-1kg"),
    ("FRISKIES MIX CARNE CASTRADOS", "10.1kg", "friskies-mix-cast-1kg"),
    # Pro Plan gatos
    ("PRO PLAN CAT KITTEN", "1kg", "proplan-cat-kitten-1kg"),
    ("PRO PLAN CAT KITTEN", "3kg", "proplan-cat-kitten-1kg"),
    ("PRO PLAN CAT KITTEN", "7.5kg", "proplan-cat-kitten-1kg"),
    ("PRO PLAN CAT ADULT FRANGO", "1kg", "proplan-cat-adult-frango-1kg"),
    ("PRO PLAN CAT ADULT FRANGO", "3kg", "proplan-cat-adult-frango-1kg"),
    ("PRO PLAN CAT ADULT FRANGO", "7.5kg", "proplan-cat-adult-frango-1kg"),
    ("PRO PLAN CAT ADULT 7+", "1kg", "proplan-cat-7plus-1kg"),
    ("PRO PLAN CAT ADULT 7+", "3kg", "proplan-cat-7plus-1kg"),
    ("PRO PLAN CAT ADULT 7+", "7.5kg", "proplan-cat-7plus-1kg"),
    ("PRO PLAN CAT URINARY", "1kg", "proplan-cat-urinary-1kg"),
    ("PRO PLAN CAT URINARY", "1.5kg", "proplan-cat-urinary-1kg"),
    ("PRO PLAN CAT URINARY", "3kg", "proplan-cat-urinary-1kg"),
    ("PRO PLAN CAT URINARY", "7.5kg", "proplan-cat-urinary-1kg"),
    ("PRO PLAN CAT STERILIZED", "1kg", "proplan-cat-sterilized-1kg"),
    ("PRO PLAN CAT STERILIZED", "3kg", "proplan-cat-sterilized-1kg"),
    ("PRO PLAN CAT STERILIZED", "7.5kg", "proplan-cat-sterilized-1kg"),
    ("PRO PLAN CAT STERILISED", "3kg", "proplan-cat-sterilized-1kg"),
    ("PRO PLAN CAT STERILISED", "7.5kg", "proplan-cat-sterilized-1kg"),
    ("PRPN STERILISED", "7.5kg", "proplan-cat-sterilized-1kg"),
    ("PRPN ADULT 7+", "7.5kg", "proplan-cat-7plus-1kg"),
    ("PRPN DES EXCP GATO FILHOTE", "7.5kg", "proplan-cat-kitten-1kg"),
    ("PRO PLAN CAT ADULT LIVECLEAR", "1kg", "proplan-cat-liveclear-1kg"),
    ("PRO PLAN CAT ADULT LIVECLEAR", "3kg", "proplan-cat-liveclear-1kg"),
    ("PRO PLAN CAT ADULT LIVECLEAR", "7.5kg", "proplan-cat-liveclear-1kg"),
    ("PRO PLAN CAT HIPOALERGENICO", "1.5kg", "proplan-cat-liveclear-1kg"),
    ("PRO PLAN CAT HIPOALERGENICO", "3kg", "proplan-cat-liveclear-1kg"),
    ("PRO PLAN CAT HIPOALERGENICO", "7.5kg", "proplan-cat-liveclear-1kg"),
    ("PRO PLAN CAT FILHOTE", "3kg", "proplan-cat-kitten-1kg"),
    ("PRO PLAN URINARY", "7.5kg", "proplan-cat-urinary-1kg"),
    # Pro Plan cães
    ("PRO PLAN PUPPY MINI", "1kg", "proplan-puppy-mini-1kg"),
    ("PRO PLAN PUPPY MINI", "2.5kg", "proplan-puppy-mini-1kg"),
    ("PRO PLAN PUPPY MINI", "7.5kg", "proplan-adult-mini-7-5kg"),
    ("PRO PLAN FILH. R. MINI", "7.5kg", "proplan-adult-mini-7-5kg"),
    ("PRO PLAN PUPPY", "2.5kg", "proplan-puppy-grande-15kg"),
    ("PRO PLAN PUPPY", "7.5kg", "proplan-adult-mini-7-5kg"),
    ("PRO PLAN PUPPY", "12kg", "proplan-puppy-grande-15kg"),
    ("PRO PLAN PUPPY", "15kg", "proplan-puppy-grande-15kg"),
    ("PRO PLAN DES EXCP", "12kg", "proplan-puppy-grande-15kg"),
    ("PRO PLAN FILH. DESEMPENHO", "12kg", "proplan-puppy-grande-15kg"),
    ("PRO PLAN ADULT R. MINI", "1kg", "proplan-puppy-mini-1kg"),
    ("PRO PLAN ADULT R. MINI", "2.5kg", "proplan-puppy-mini-1kg"),
    ("PRO PLAN ADULT R. MINI", "7.5kg", "proplan-adult-mini-7-5kg"),
    ("PRO PLAN ADULT MINI", "7.5kg", "proplan-adult-mini-7-5kg"),
    ("PRO PLAN ADULT R. MED", "2.5kg", "proplan-reduced-med-2-5kg"),
    ("PRO PLAN ADULT R. MED", "7.5kg", "proplan-adult-mini-7-5kg"),
    ("PRO PLAN ADULT R. MED", "15kg", "proplan-adult-medio-15kg"),
    ("PRO PLAN ADULT R. GRANDE", "2.5kg", "proplan-reduced-med-2-5kg"),
    ("PRO PLAN ADULT R. GRANDE", "7.5kg", "proplan-adult-mini-7-5kg"),
    ("PRO PLAN ADULT R. GRANDE", "10.1kg", "proplan-adult-grande-15kg"),
    ("PRO PLAN ADULT R. GRANDE", "12kg", "proplan-adult-grande-15kg"),
    ("PRO PLAN ADULT R. GRANDE", "15kg", "proplan-adult-grande-15kg"),
    ("PRO PLAN CONTROLE PESO R. MINI", "2.5kg", "proplan-reduced-mini-7-5kg"),
    ("PRO PLAN CONTROLE PESO R. MINI", "7.5kg", "proplan-reduced-mini-7-5kg"),
    ("PRO PLAN REDUCED CALORIE MINI", "7.5kg", "proplan-reduced-mini-7-5kg"),
    ("PRO PLAN CONTROLE PESO R. MED", "2.5kg", "proplan-reduced-med-2-5kg"),
    ("PRO PLAN CONTROLE PESO R. MED", "10.1kg", "proplan-adult-grande-15kg"),
    ("PRO PLAN REDUCED CALORIE M", "2.5kg", "proplan-reduced-med-2-5kg"),
    ("PRO PLAN ACTIVE MIND", "1kg", "proplan-activemind-1kg"),
    ("PRO PLAN ACTIVE MIND", "7.5kg", "proplan-adult-mini-7-5kg"),
    ("PRO PLAN ACTIVE MIND", "12kg", "proplan-adult-grande-15kg"),
    ("PRO PLAN LONGEVIDADE", "7.5kg", "proplan-adult-mini-7-5kg"),
    ("PRO PLAN LONGEVIDADE", "12kg", "proplan-adult-grande-15kg"),
    ("PRO PLAN PALADAR", "7.5kg", "proplan-adult-mini-7-5kg"),
    ("PRO PLAN ALTA VITALIDADE", "12kg", "proplan-adult-grande-15kg"),
    ("PRO PLAN HIPOALERGENICO", "2kg", "ppvd-ha-dog-2kg"),
    ("PRO PLAN HIPOALERGENICO", "7.5kg", "proplan-adult-mini-7-5kg"),
    ("PRO PLAN SENSITIVE SKIN", "2.5kg", "proplan-sens-mini-2-5kg"),
    ("PRO PLAN SENSITIVE SKIN R. MINI", "7.5kg", "proplan-sens-mini-2-5kg"),
    # PPVD
    ("PPVD FELINE HA", "1.5kg", "ppvd-ha-cat-1-5kg"),
    ("PPVD FELINE HA", "7.5kg", "ppvd-ha-cat-1-5kg"),
    ("PPVD FELINE UR", "1.5kg", "ppvd-ur-cat-1-5kg"),
    ("PPVD FELINE UR", "7.5kg", "ppvd-ur-cat-1-5kg"),
    ("PPVD FELINE OM", "1.5kg", "ppvd-om-cat-1-5kg"),
    ("PPVD FELINE OM", "7.5kg", "ppvd-om-cat-1-5kg"),
    ("PPVD CANINE HA", "2kg", "ppvd-ha-dog-2kg"),
    ("PPVD CANINE HA", "7.5kg", "ppvd-ha-dog-2kg"),
    ("PPVD CANINE NC", "2kg", "ppvd-nc-dog-2kg"),
    ("PPVD CANINE NC", "7.5kg", "ppvd-nc-dog-2kg"),
    ("PPVD CANINE OM", "2kg", "ppvd-om-dog-2kg"),
    ("PPVD CANINE OM", "7.5kg", "ppvd-om-dog-2kg"),
    ("PPVD CANINE UR", "2kg", "ppvd-ur-dog-2kg"),
    ("PPVD CANINE UR", "7.5kg", "ppvd-ur-dog-2kg"),
]

WEIGHT_ORDER = [
    "45g", "70g", "80g", "85g", "100g", "105g", "119g", "196g", "300g", "400g", "500g",
    "850g", "900g", "1kg", "1.5kg", "2kg", "2.5kg", "2.7kg", "3kg", "7.5kg", "10.1kg",
    "12kg", "15kg", "18kg", "20kg",
]


def norm(s: str) -> str:
    s = unicodedata.normalize("NFKD", s).encode("ascii", "ignore").decode("ascii")
    return re.sub(r"\s+", " ", s.upper().strip())


def normalize_weight(w: str) -> str:
    w = w.lower().replace(",", ".").replace(" ", "")
    m = re.match(r"(\d+(?:\.\d+)?)(kg|g)", w)
    if not m:
        return w
    val, unit = m.groups()
    if unit == "kg" and val.endswith(".0"):
        val = val[:-2]
    return f"{val}{unit}"


def product_family_key(name: str, description: str) -> str:
    text = norm(f"{name} {description}")
    # Ordem importa: padrões mais específicos primeiro.
    patterns = [
        r"DOG CHOW EXTRA LIFE FILHOTES MINIS",
        r"DOG CHOW EXTRA LIFE FILHOTES M",
        r"DOG CHOW EXTRA LIFE ADULTOS LONGEVIDADE",
        r"DOG CHOW EXTRA LIFE ADULTOS 7\+",
        r"DOG CHOW EXTRA LIFE ADULTOS MINIS",
        r"DOG CHOW EXTRA LIFE ADULTOS M",
        r"DOG CHOW EXTRA LIFE PAPITA",
        r"DOG CHOW BISCOITO FILHOTES",
        r"DOG CHOW BISCOITO ADULTOS MINI",
        r"DOG CHOW BISCOITO ADULTO M",
        r"DOG CHOW ORAL MINI",
        r"DOG CHOW ORAL M",
        r"DOG CHOW SACHET",
        r"DOG CHOW SACHE FILHOTES",
        r"DOG CHOW ADULTO",
        r"DOG CHOW FILHOTE",
        r"DOG CHOW ADULTOS MINIS E PEQUENOS",
        r"DOG CHOW ADULTOS MEDIOS E GRANDES",
        r"CAT CHOW SACHET FILHOTES",
        r"CAT CHOW SACHET ADULTOS CASTRADOS",
        r"CAT CHOW SACHET ADULTOS",
        r"CAT CHOW ADULTOS CASTRADOS FRANGO",
        r"CAT CHOW ADULTOS CASTRADOS PEIXE",
        r"CAT CHOW ADULTOS CARNE",
        r"CAT CHOW ADULTOS PEIXE",
        r"CAT CHOW FILHOTES",
        r"FRISKIES SACHET",
        r"FRISKIES PETISCOS",
        r"FRISKIES MEGAMIX CASTRADOS",
        r"FRISKIES MEGAMIX ADULTOS",
        r"FRISKIES MIX CARNE CASTRADOS",
        r"FRISKIES MIX CARNE ADULTOS",
        r"FRISKIES DELICIAS DA GRANJA",
        r"FRISKIES MAR DE SABORES",
        r"FRISKIES FILHOTES",
        r"PRO PLAN CAT SACHET",
        r"PRO PLAN SACHET",
        r"PRO PLAN CAT KITTEN",
        r"PRO PLAN CAT ADULT FRANGO",
        r"PRO PLAN CAT ADULT 7\+",
        r"PRO PLAN CAT URINARY",
        r"PRO PLAN CAT STERILIZED",
        r"PRO PLAN CAT STERILISED",
        r"PRO PLAN CAT ADULT LIVECLEAR",
        r"PRO PLAN CAT HIPOALERGENICO",
        r"PRO PLAN CAT FILHOTE",
        r"PRPN STERILISED",
        r"PRPN ADULT 7\+",
        r"PRPN DES EXCP GATO FILHOTE",
        r"PRO PLAN PUPPY MINI",
        r"PRO PLAN FILH\. R\. MINI",
        r"PRO PLAN PUPPY",
        r"PRO PLAN ADULT R\. MINI",
        r"PRO PLAN ADULT MINI",
        r"PRO PLAN ADULT R\. MED",
        r"PRO PLAN ADULT R\. GRANDE",
        r"PRO PLAN CONTROLE PESO R\. MINI",
        r"PRO PLAN REDUCED CALORIE MINI",
        r"PRO PLAN CONTROLE PESO R\. MED",
        r"PRO PLAN REDUCED CALORIE M",
        r"PRO PLAN ACTIVE MIND",
        r"PRO PLAN LONGEVIDADE",
        r"PRO PLAN PALADAR",
        r"PRO PLAN ALTA VITALIDADE",
        r"PRO PLAN HIPOALERGENICO",
        r"PRO PLAN SENSITIVE SKIN",
        r"PRO PLAN URINARY",
        r"PPVD FELINE HA",
        r"PPVD FELINE UR",
        r"PPVD FELINE OM",
        r"PPVD CANINE HA",
        r"PPVD CANINE NC",
        r"PPVD CANINE OM",
        r"PPVD CANINE UR",
        r"FANCY FEAST CASSEROLE",
        r"FANCY FEAST DEMI GLACE",
        r"FANCY FEAST GOULASH",
        r"FANCY FEAST PETIT FILET",
        r"FANCY FEAST SUPREMO",
        r"DENTALIFE CAES RACAS PEQUENAS",
        r"DENTALIFE CAES RACAS MEDIAS",
        r"DENTALIFE CAES RACAS GRANDES",
        r"DENTALIFE GATOS",
        r"DOGUITOS BIFINHO LINGUICINHA",
        r"DOGUITOS BIFINHO FRANGO",
        r"DOGUITOS BIFINHO CARNE",
        r"ONE DOG SACHET",
        r"ONE CAT SACHET",
        r"ONE DOG",
        r"ONE CAT",
        r"ALPO FILHOTES",
        r"ALPO ADULTOS",
        r"GATSY CARNE",
    ]
    for pat in patterns:
        if re.search(pat, text):
            return pat.replace(r"\+", "+").replace(r"\.", ".")
    return text[:60]


def resolve_slug_from_name(name: str, description: str, weight: str) -> str | None:
    text = norm(f"{name} {description}")
    w = normalize_weight(weight)

    # --- Biscoitos Dog Chow (p.25) ---
    if "BISCOITO" in text:
        if "FILHOTE" in text:
            return "dogchow-biscoito-filhotes-500g"
        if "MINI" in text or "PEQUENO" in text:
            return "dogchow-biscoito-adult-mini-500g"
        return "dogchow-biscoito-adult-med-500g"

    # --- Saúde Oral Dog Chow (p.25) ---
    if "ORAL" in text or "SAUDE ORAL" in text:
        if "45" in w:
            return "dogchow-oral-mini-45g"
        if "105" in w:
            return "dogchow-oral-mini-105g"
        if "80" in w:
            return "dogchow-oral-med-80g"
        return "dogchow-oral-med-200g"

    # --- Dog Chow ração seca ---
    if "DOG CHOW" in text and "x" not in w:
        is_puppy = "FILHOTE" in text or "PAPITA" in text
        is_mini = "MINI" in text or "PEQUENO" in text
        is_med = "MEDIO" in text or "GRANDE" in text
        is_7plus = "7+" in text or "LONGEVIDADE" in text
        if is_puppy:
            if "PAPITA" in text:
                return "dogchow-papita-20kg"
            if w in ("1kg", "3kg", "900g", "2.5kg"):
                return "dogchow-puppy-mini-1kg" if is_mini else "dogchow-puppy-med-1kg"
            if w == "10.1kg":
                return "dogchow-adult-mini-10-1kg" if is_mini else "dogchow-adult-med-grande-10-1kg"
            if w == "15kg":
                return "dogchow-adult-mini-10-1kg" if is_mini else "dogchow-adult-med-grande-10-1kg"
        elif is_7plus:
            if w == "15kg":
                return "dogchow-7plus-15kg"
            return "dogchow-puppy-mini-1kg"
        else:
            if w in ("900g", "2.5kg", "1kg", "3kg"):
                return "dogchow-puppy-mini-1kg" if is_mini else "dogchow-puppy-med-1kg"
            if w == "10.1kg":
                return "dogchow-adult-mini-10-1kg" if is_mini else "dogchow-adult-med-grande-10-1kg"
            if w == "15kg":
                return "dogchow-adult-mini-10-1kg" if is_mini else "dogchow-adult-med-grande-10-1kg"
            if w == "20kg":
                return "dogchow-papita-20kg"

    # --- Cat Chow ração seca (catálogo só tem foto 10,1 kg) ---
    if "CAT CHOW" in text and "SACHE" not in text and "x" not in w:
        if "FILHOTE" in text:
            return "catchow-kitten-10-1kg"
        if "CASTRAD" in text:
            return "catchow-cast-peixe-10-1kg" if "PEIXE" in text else "catchow-cast-frango-10-1kg"
        if "PEIXE" in text:
            return "catchow-adult-peixe-10-1kg"
        return "catchow-adult-carne-10-1kg"

    # --- Friskies ração seca (catálogo mostra 1 kg) ---
    if "FRISKIES" in text and "SACHET" not in text and "PETISCO" not in text and "x" not in w:
        if "FILHOTE" in text:
            return "friskies-kitten-1kg"
        if "MEGAMIX" in text and "CASTRAD" in text:
            return "friskies-mega-cast-1kg"
        if "MEGAMIX" in text:
            return "friskies-megamix-1kg"
        if "GRANJA" in text:
            return "friskies-granja-1kg"
        if "MAR DE SABORES" in text or ("MAR" in text and "SABORES" in text):
            return "friskies-mar-1kg"
        if "CASTRAD" in text:
            return "friskies-mix-cast-1kg"
        return "friskies-mix-carnes-1kg"

    # --- Pro Plan gatos seco ---
    if "PRO PLAN" in text and ("GATO" in text or "CAT" in text) and "SACH" not in text and "x" not in w:
        if "FILHOTE" in text or "KITTEN" in text:
            return "proplan-cat-kitten-1kg"
        if "7+" in text:
            return "proplan-cat-7plus-1kg"
        if "URIN" in text:
            return "proplan-cat-urinary-1kg"
        if "STERIL" in text or "CASTRAD" in text:
            return "proplan-cat-sterilized-1kg"
        if "LIVECLEAR" in text or "ALERGEN" in text or "HIPOALER" in text:
            return "proplan-cat-liveclear-1kg"
        return "proplan-cat-adult-frango-1kg"

    # --- Pro Plan cães seco ---
    if "PRO PLAN" in text and "x" not in w and "SACH" not in text:
        if "NEUROLOG" in text:
            return "ppvd-nc-dog-2kg"
        if ("TRATO URIN" in text or "URINARIO" in text) and "GATO" not in text:
            return "ppvd-ur-dog-2kg" if w == "2kg" else "ppvd-ur-dog-2kg"
        if "HIPOALER" in text and "GATO" not in text:
            return "ppvd-ha-dog-2kg"
        if ("CALORIA REDUZIDA" in text or "OBESIDADE" in text) and "GATO" not in text and w == "2kg":
            return "ppvd-om-dog-2kg"
        if "PPVD" in text:
            if "FELINE" in text or "GATO" in text:
                if "UR" in text:
                    return "ppvd-ur-cat-1-5kg"
                if "OM" in text:
                    return "ppvd-om-cat-1-5kg"
                return "ppvd-ha-cat-1-5kg"
            if "UR" in text:
                return "ppvd-ur-dog-2kg" if w == "2kg" else "ppvd-ur-dog-2kg"
            if "NC" in text or "NEURO" in text:
                return "ppvd-nc-dog-2kg"
            if "OM" in text or "OBESIDADE" in text:
                return "ppvd-om-dog-2kg"
            return "ppvd-ha-dog-2kg"
        if "PRPN" in text:
            if "STERIL" in text:
                return "proplan-cat-sterilized-1kg"
            if "7+" in text:
                return "proplan-cat-7plus-1kg"
            return "proplan-cat-kitten-1kg"
        is_mini = "MINI" in text or "PEQUENO" in text
        is_puppy = "FILHOTE" in text or "PUPPY" in text
        is_reduced = "CALORIA" in text or "REDUCED" in text or "CONTROLE PESO" in text
        is_sensitive = "SENSITIVE" in text or "PELE SENS" in text
        is_active = "ACTIVE MIND" in text or "MENTE ATIVA" in text or "LONGEVIDADE" in text
        if is_puppy:
            if w in ("1kg", "2.5kg"):
                return "proplan-puppy-mini-1kg" if is_mini else "proplan-reduced-med-2-5kg"
            if w == "7.5kg":
                return "proplan-adult-mini-7-5kg"
            return "proplan-puppy-grande-15kg"
        if is_reduced:
            if w in ("1kg", "2.5kg"):
                return "proplan-puppy-mini-1kg" if is_mini else "proplan-reduced-med-2-5kg"
            if w == "7.5kg":
                return "proplan-reduced-mini-7-5kg"
            return "proplan-adult-grande-15kg"
        if is_sensitive:
            if w == "2.5kg":
                return "proplan-sens-mini-2-5kg" if is_mini else "proplan-sens-med-2-5kg"
            if w == "7.5kg":
                return "proplan-sens-mini-2-5kg"
            return "proplan-adult-grande-15kg"
        if is_active:
            if w == "1kg":
                return "proplan-activemind-1kg"
            if w == "7.5kg":
                return "proplan-adult-mini-7-5kg"
            return "proplan-adult-grande-15kg"
        if is_mini:
            if w in ("1kg", "2.5kg"):
                return "proplan-puppy-mini-1kg"
            if w == "7.5kg":
                return "proplan-adult-mini-7-5kg"
            return "proplan-adult-grande-15kg"
        # médio/grande adulto
        if w == "2.5kg":
            return "proplan-reduced-med-2-5kg"
        if w == "7.5kg":
            return "proplan-adult-mini-7-5kg"
        return "proplan-adult-grande-15kg"

    # --- Alpo / Gatsy ---
    if "ALPO" in text:
        return "alpo-filhote-18kg" if "FILHOTE" in text else "alpo-adulto-18kg"
    if "GATSY" in text:
        return "gatsy-carne-20kg"

    # Sachês / multipacks
    if "x" in w:
        if "DOG CHOW" in text and "BISCOITO" not in text:
            if "FILHOTE" in text or "PAPITA" in text:
                return "dogchow-puppy-med-1kg"
            if "ORAL" in text:
                if "45" in w:
                    return "dogchow-oral-mini-45g"
                if "105" in w:
                    return "dogchow-oral-mini-105g"
                if "80" in w:
                    return "dogchow-oral-med-80g"
                return "dogchow-oral-med-200g"
            if "MINI" in text or "PEQUENO" in text:
                return "dogchow-puppy-mini-1kg"
            return "dogchow-adult-med-grande-10-1kg"
        if "CAT CHOW" in text and "SACH" in text:
            if "FILHOTE" in text:
                return "catchow-sachet-kitten-85g"
            if "CASTRAD" in text:
                if "PEIXE" in text:
                    return "catchow-sachet-cast-peixe-85g"
                return "catchow-sachet-cast-carne-85g"
            if "FRANGO" in text:
                return "catchow-sachet-adult-frango-85g"
            if "PEIXE" in text:
                return "catchow-sachet-adult-peixe-85g"
            return "catchow-sachet-adult-carne-85g"
        if "FRISKIES" in text:
            if "PETISCO" in text:
                if "SALMAO" in text or "SALM" in text:
                    return "friskies-petisco-salmao-80g"
                if "CARNE" in text:
                    return "friskies-petisco-carne-40g"
                return "friskies-petisco-frango-40g"
            if "ATUM" in text:
                return "friskies-sachet-atum-85g"
            if "CORDEIRO" in text:
                return "friskies-sachet-cordeiro-85g"
            if "FRANGO" in text:
                return "friskies-sachet-frango-85g"
            return "friskies-sachet-carne-85g"
        if "PRO PLAN" in text and "SACH" in text:
            if "GATO" in text or "CAT" in text:
                return "proplan-sachet-adult-frango-85g"
            if "CARNE" in text:
                return "proplan-sachet-dog-carne-100g"
            return "proplan-sachet-dog-frango-100g"
        if "FANCY FEAST" in text:
            if "75" in w:
                if "BACALHAU" in text:
                    return "fancy-supremo-bacalhau-75g"
                if "CARNE" in text:
                    return "fancy-supremo-carne-75g"
                return "fancy-supremo-peixe-75g"
            if "CASSEROLE" in text:
                return "fancy-casserole-atum-85g" if "ATUM" in text else "fancy-casserole-frango-85g"
            if "DEMI" in text:
                return "fancy-demi-carne-85g" if "CARNE" in text else "fancy-demi-frango-85g"
            if "GOULASH" in text:
                return "fancy-goulash-atum-85g" if "ATUM" in text else "fancy-goulash-peru-85g"
            if "PETIT" in text:
                return "fancy-petit-salmao-85g" if "SALMAO" in text else "fancy-petit-carne-85g"
        if "ONE " in text:
            return "purinaone-sachet-cat-85g" if "GATO" in text else "purinaone-sachet-dog-85g"
        if "DENTALIFE" in text:
            if "GATO" in text:
                return "dentalife-gatos-40g"
            if "42" in w:
                return "dentalife-pequena-42g"
            if "119" in w:
                return "dentalife-media-119g"
            return "dentalife-grande-196g"
        if "DOGUITOS" in text:
            if "LINGUI" in text:
                return "doguitos-linguica-45g"
            return "doguitos-carne-65g" if "CARNE" in text else "doguitos-frango-65g"

    for pattern, map_weight, slug in FAMILY_WEIGHT_SLUGS:
        if pattern in text and normalize_weight(map_weight) == w:
            return slug

    return None


def resolve_slug_from_legacy_image(image: str) -> str:
    slug = image.split("/")[-1].replace(".webp", "").replace("purina-", "")
    legacy_map = {
        "proplan-cat-adult-frango": "proplan-cat-adult-frango-1kg",
        "proplan-cat-kitten": "proplan-cat-kitten-1kg",
        "proplan-cat-7plus": "proplan-cat-7plus-1kg",
        "proplan-cat-sterilized": "proplan-cat-sterilized-1kg",
        "proplan-cat-urinary": "proplan-cat-urinary-1kg",
        "proplan-cat-liveclear": "proplan-cat-liveclear-1kg",
        "proplan-puppy-mini": "proplan-puppy-mini-1kg",
        "proplan-puppy-grande": "proplan-puppy-grande-15kg",
        "proplan-adult-mini": "proplan-adult-mini-7-5kg",
        "proplan-adult-grande": "proplan-adult-grande-15kg",
        "proplan-adult-medio": "proplan-adult-medio-15kg",
        "proplan-reduced-mini": "proplan-reduced-mini-7-5kg",
        "proplan-reduced-med": "proplan-reduced-med-2-5kg",
        "proplan-activemind": "proplan-activemind-1kg",
        "catchow-kitten": "catchow-kitten-10-1kg",
        "catchow-adult-carne": "catchow-adult-carne-10-1kg",
        "catchow-adult-peixe": "catchow-adult-peixe-10-1kg",
        "catchow-cast-frango": "catchow-cast-frango-10-1kg",
        "catchow-cast-peixe": "catchow-cast-peixe-10-1kg",
        "dogchow-puppy-mini": "dogchow-puppy-mini-1kg",
        "dogchow-puppy-med": "dogchow-puppy-med-1kg",
        "dogchow-adult-mini": "dogchow-adult-mini-10-1kg",
        "dogchow-adult-med-grande": "dogchow-adult-med-grande-10-1kg",
        "dogchow-7plus": "dogchow-7plus-15kg",
        "dogchow-papita": "dogchow-papita-20kg",
        "friskies-kitten": "friskies-kitten-1kg",
        "friskies-mix-carnes": "friskies-mix-carnes-1kg",
        "friskies-megamix": "friskies-megamix-1kg",
        "friskies-mar": "friskies-mar-1kg",
        "friskies-granja": "friskies-granja-1kg",
        "friskies-mix-cast": "friskies-mix-cast-1kg",
    }
    return legacy_map.get(slug, slug)


def pick_slug(product: dict) -> str:
    slug = resolve_slug_from_name(product["name"], product.get("description", ""), product["weight"])
    if slug and slug in WEIGHT_CROPS:
        return slug
    # fallback pelo slug legado + peso mais próximo disponível
    base = resolve_slug_from_legacy_image(product["image"])
    if base in WEIGHT_CROPS:
        return base
    return base


def extract_all_images() -> dict[str, str]:
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    doc = fitz.open(PDF_PATH)
    mapping: dict[str, str] = {}
    for slug, (page_num, x0, y0, x1, y1, _bag_w) in WEIGHT_CROPS.items():
        page = doc[page_num - 1]
        pad = 2 if slug.startswith("catchow-") else 8
        bbox = expand((x0, y0, x1, y1), page.rect, pad=pad)
        rendered = render_crop(page, bbox)
        embedded = best_embedded(page, bbox)
        if embedded and embedded.size[0] * embedded.size[1] > rendered.size[0] * rendered.size[1] * 1.2:
            img = embedded
        else:
            img = rendered
        img = optimize(img)
        fname = f"purina-{slug}.webp"
        dest = OUT_DIR / fname
        img.save(dest, "WEBP", quality=88, method=6)
        mapping[slug] = f"/assets/products/catalog/{fname}"
        print(f"{slug}: {img.size}")
    doc.close()
    return mapping


def rebuild_sql(products: list[dict]) -> None:
    purina = [p for p in products if p.get("line") == "Purina"]
    purina.sort(key=lambda p: p["id"])
    blocks = ["-- Catálogo Purina completo (tabela 16-07 + 30%)", "BEGIN;"]
    for p in purina:
        blocks.append(
            f"""
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT {sql_literal(TENANT_ID)}, {p['id']}, {sql_literal(p['name'])},
       {sql_literal(p['category'])}, {sql_literal(p['brand'])}, {sql_literal(p['line'])},
       {p['price']}, {sql_literal(p['image'])}, {sql_literal(p['description'])},
       {sql_literal(p['weight'])}, {p['catalogPage']}, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = {sql_literal(TENANT_ID)}
    AND name = {sql_literal(p['name'])}
    AND COALESCE(weight, '') = {sql_literal(p['weight'])}
    AND COALESCE(line, '') = {sql_literal(p['line'])}
);""".strip()
        )
    blocks.append("-- Se os SKUs já existirem, aplica os preços com +30% sobre a tabela 16-07.")
    blocks.append("UPDATE products SET")
    blocks.append("  price = CASE external_id")
    for p in purina:
        blocks.append(f"    WHEN {p['id']} THEN {p['price']:.2f}")
    ids = ", ".join(str(p["id"]) for p in purina)
    blocks.append("  END,")
    blocks.append("  updated_at = NOW()")
    blocks.append(f"WHERE tenant_id = {sql_literal(TENANT_ID)}")
    blocks.append("  AND line = 'Purina'")
    blocks.append(f"  AND external_id IN ({ids});")
    blocks.append("COMMIT;")
    (BASE / "insert_purina.sql").write_text("\n".join(blocks) + "\n", encoding="utf-8")


def main() -> None:
    images = extract_all_images()
    products = json.loads(PRODUCTS_PATH.read_text(encoding="utf-8"))
    changed = 0
    unresolved = []
    for p in products:
        if p.get("line") != "Purina":
            continue
        slug = pick_slug(p)
        if slug not in images:
            unresolved.append((p["id"], p["name"], p["weight"], slug))
            continue
        new_image = images[slug]
        if p["image"] != new_image:
            p["image"] = new_image
            changed += 1
    payload = json.dumps(products, ensure_ascii=False, indent=2) + "\n"
    PRODUCTS_PATH.write_text(payload, encoding="utf-8")
    if SEED_PATH.parent.exists():
        SEED_PATH.write_text(payload, encoding="utf-8")
    rebuild_sql(products)
    print(f"Imagens atualizadas: {changed}")
    if unresolved:
        print("Sem crop:", len(unresolved))
        for row in unresolved[:15]:
            print(" ", row)


if __name__ == "__main__":
    main()
