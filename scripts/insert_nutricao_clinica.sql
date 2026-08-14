-- Insere PremieR Nutrição Clínica (catálogo 2026 + preços sugeridos ago/26)
BEGIN;
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 217, 'PremieR Nutrição Clínica Cães - Cardio - Porte Pequeno',
       'caes', 'UniPet',
       'PremieR Nutrição Clínica Cães', 95.9, '/assets/products/catalog/page-56-caes-cardio.webp',
       'Linha PremieR Nutrição Clínica Cães. Cardio. Porte Pequeno. Embalagem 2kg.', '2kg',
       56, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'PremieR Nutrição Clínica Cães - Cardio - Porte Pequeno'
    AND COALESCE(weight, '') = '2kg'
    AND COALESCE(line, '') = 'PremieR Nutrição Clínica Cães'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 218, 'PremieR Nutrição Clínica Cães - Cardio - Porte Pequeno',
       'caes', 'UniPet',
       'PremieR Nutrição Clínica Cães', 379.9, '/assets/products/catalog/page-56-caes-cardio.webp',
       'Linha PremieR Nutrição Clínica Cães. Cardio. Porte Pequeno. Embalagem 10.1kg.', '10.1kg',
       56, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'PremieR Nutrição Clínica Cães - Cardio - Porte Pequeno'
    AND COALESCE(weight, '') = '10.1kg'
    AND COALESCE(line, '') = 'PremieR Nutrição Clínica Cães'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 219, 'PremieR Nutrição Clínica Cães - Cardio - Porte Médio/Grande',
       'caes', 'UniPet',
       'PremieR Nutrição Clínica Cães', 379.9, '/assets/products/catalog/page-56-caes-cardio.webp',
       'Linha PremieR Nutrição Clínica Cães. Cardio. Porte Médio/Grande. Embalagem 10.1kg.', '10.1kg',
       56, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'PremieR Nutrição Clínica Cães - Cardio - Porte Médio/Grande'
    AND COALESCE(weight, '') = '10.1kg'
    AND COALESCE(line, '') = 'PremieR Nutrição Clínica Cães'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 220, 'PremieR Nutrição Clínica Cães - Diabetes - Porte Pequeno',
       'caes', 'UniPet',
       'PremieR Nutrição Clínica Cães', 95.9, '/assets/products/catalog/page-56-caes-diabetes.webp',
       'Linha PremieR Nutrição Clínica Cães. Diabetes. Porte Pequeno. Embalagem 2kg.', '2kg',
       56, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'PremieR Nutrição Clínica Cães - Diabetes - Porte Pequeno'
    AND COALESCE(weight, '') = '2kg'
    AND COALESCE(line, '') = 'PremieR Nutrição Clínica Cães'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 221, 'PremieR Nutrição Clínica Cães - Diabetes - Porte Pequeno',
       'caes', 'UniPet',
       'PremieR Nutrição Clínica Cães', 379.9, '/assets/products/catalog/page-56-caes-diabetes.webp',
       'Linha PremieR Nutrição Clínica Cães. Diabetes. Porte Pequeno. Embalagem 10.1kg.', '10.1kg',
       56, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'PremieR Nutrição Clínica Cães - Diabetes - Porte Pequeno'
    AND COALESCE(weight, '') = '10.1kg'
    AND COALESCE(line, '') = 'PremieR Nutrição Clínica Cães'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 222, 'PremieR Nutrição Clínica Cães - Diabetes - Porte Médio/Grande',
       'caes', 'UniPet',
       'PremieR Nutrição Clínica Cães', 379.9, '/assets/products/catalog/page-56-caes-diabetes.webp',
       'Linha PremieR Nutrição Clínica Cães. Diabetes. Porte Médio/Grande. Embalagem 10.1kg.', '10.1kg',
       56, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'PremieR Nutrição Clínica Cães - Diabetes - Porte Médio/Grande'
    AND COALESCE(weight, '') = '10.1kg'
    AND COALESCE(line, '') = 'PremieR Nutrição Clínica Cães'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 223, 'PremieR Nutrição Clínica Cães - Gastrointestinal - Porte Pequeno',
       'caes', 'UniPet',
       'PremieR Nutrição Clínica Cães', 95.9, '/assets/products/catalog/page-56-caes-gastro.webp',
       'Linha PremieR Nutrição Clínica Cães. Gastrointestinal. Porte Pequeno. Embalagem 2kg.', '2kg',
       56, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'PremieR Nutrição Clínica Cães - Gastrointestinal - Porte Pequeno'
    AND COALESCE(weight, '') = '2kg'
    AND COALESCE(line, '') = 'PremieR Nutrição Clínica Cães'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 224, 'PremieR Nutrição Clínica Cães - Gastrointestinal - Porte Pequeno',
       'caes', 'UniPet',
       'PremieR Nutrição Clínica Cães', 379.9, '/assets/products/catalog/page-56-caes-gastro.webp',
       'Linha PremieR Nutrição Clínica Cães. Gastrointestinal. Porte Pequeno. Embalagem 10.1kg.', '10.1kg',
       56, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'PremieR Nutrição Clínica Cães - Gastrointestinal - Porte Pequeno'
    AND COALESCE(weight, '') = '10.1kg'
    AND COALESCE(line, '') = 'PremieR Nutrição Clínica Cães'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 225, 'PremieR Nutrição Clínica Cães - Gastrointestinal - Porte Médio/Grande',
       'caes', 'UniPet',
       'PremieR Nutrição Clínica Cães', 379.9, '/assets/products/catalog/page-56-caes-gastro.webp',
       'Linha PremieR Nutrição Clínica Cães. Gastrointestinal. Porte Médio/Grande. Embalagem 10.1kg.', '10.1kg',
       56, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'PremieR Nutrição Clínica Cães - Gastrointestinal - Porte Médio/Grande'
    AND COALESCE(weight, '') = '10.1kg'
    AND COALESCE(line, '') = 'PremieR Nutrição Clínica Cães'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 226, 'PremieR Nutrição Clínica Cães - Hipoalergênico Proteína Hidrolisada - Porte Pequeno',
       'caes', 'UniPet',
       'PremieR Nutrição Clínica Cães', 99.9, '/assets/products/catalog/page-56-caes-hipo-hidro.webp',
       'Linha PremieR Nutrição Clínica Cães. Hipoalergênico Proteína Hidrolisada. Porte Pequeno. Embalagem 2kg.', '2kg',
       56, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'PremieR Nutrição Clínica Cães - Hipoalergênico Proteína Hidrolisada - Porte Pequeno'
    AND COALESCE(weight, '') = '2kg'
    AND COALESCE(line, '') = 'PremieR Nutrição Clínica Cães'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 227, 'PremieR Nutrição Clínica Cães - Hipoalergênico Proteína Hidrolisada - Porte Pequeno',
       'caes', 'UniPet',
       'PremieR Nutrição Clínica Cães', 399.9, '/assets/products/catalog/page-56-caes-hipo-hidro.webp',
       'Linha PremieR Nutrição Clínica Cães. Hipoalergênico Proteína Hidrolisada. Porte Pequeno. Embalagem 10.1kg.', '10.1kg',
       56, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'PremieR Nutrição Clínica Cães - Hipoalergênico Proteína Hidrolisada - Porte Pequeno'
    AND COALESCE(weight, '') = '10.1kg'
    AND COALESCE(line, '') = 'PremieR Nutrição Clínica Cães'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 228, 'PremieR Nutrição Clínica Cães - Hipoalergênico Proteína Hidrolisada - Porte Médio/Grande',
       'caes', 'UniPet',
       'PremieR Nutrição Clínica Cães', 399.9, '/assets/products/catalog/page-56-caes-hipo-hidro.webp',
       'Linha PremieR Nutrição Clínica Cães. Hipoalergênico Proteína Hidrolisada. Porte Médio/Grande. Embalagem 10.1kg.', '10.1kg',
       56, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'PremieR Nutrição Clínica Cães - Hipoalergênico Proteína Hidrolisada - Porte Médio/Grande'
    AND COALESCE(weight, '') = '10.1kg'
    AND COALESCE(line, '') = 'PremieR Nutrição Clínica Cães'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 229, 'PremieR Nutrição Clínica Cães - Hipoalergênico Cordeiro e Arroz - Porte Pequeno',
       'caes', 'UniPet',
       'PremieR Nutrição Clínica Cães', 99.9, '/assets/products/catalog/page-57-caes-hipo-cordeiro.webp',
       'Linha PremieR Nutrição Clínica Cães. Hipoalergênico Cordeiro e Arroz. Porte Pequeno. Embalagem 2kg.', '2kg',
       57, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'PremieR Nutrição Clínica Cães - Hipoalergênico Cordeiro e Arroz - Porte Pequeno'
    AND COALESCE(weight, '') = '2kg'
    AND COALESCE(line, '') = 'PremieR Nutrição Clínica Cães'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 230, 'PremieR Nutrição Clínica Cães - Hipoalergênico Cordeiro e Arroz - Porte Pequeno',
       'caes', 'UniPet',
       'PremieR Nutrição Clínica Cães', 399.9, '/assets/products/catalog/page-57-caes-hipo-cordeiro.webp',
       'Linha PremieR Nutrição Clínica Cães. Hipoalergênico Cordeiro e Arroz. Porte Pequeno. Embalagem 10.1kg.', '10.1kg',
       57, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'PremieR Nutrição Clínica Cães - Hipoalergênico Cordeiro e Arroz - Porte Pequeno'
    AND COALESCE(weight, '') = '10.1kg'
    AND COALESCE(line, '') = 'PremieR Nutrição Clínica Cães'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 231, 'PremieR Nutrição Clínica Cães - Hipoalergênico Cordeiro e Arroz - Porte Médio/Grande',
       'caes', 'UniPet',
       'PremieR Nutrição Clínica Cães', 399.9, '/assets/products/catalog/page-57-caes-hipo-cordeiro.webp',
       'Linha PremieR Nutrição Clínica Cães. Hipoalergênico Cordeiro e Arroz. Porte Médio/Grande. Embalagem 10.1kg.', '10.1kg',
       57, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'PremieR Nutrição Clínica Cães - Hipoalergênico Cordeiro e Arroz - Porte Médio/Grande'
    AND COALESCE(weight, '') = '10.1kg'
    AND COALESCE(line, '') = 'PremieR Nutrição Clínica Cães'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 232, 'PremieR Nutrição Clínica Cães - Obesidade - Porte Pequeno',
       'caes', 'UniPet',
       'PremieR Nutrição Clínica Cães', 99.9, '/assets/products/catalog/page-57-caes-obesidade.webp',
       'Linha PremieR Nutrição Clínica Cães. Obesidade. Porte Pequeno. Embalagem 2kg.', '2kg',
       57, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'PremieR Nutrição Clínica Cães - Obesidade - Porte Pequeno'
    AND COALESCE(weight, '') = '2kg'
    AND COALESCE(line, '') = 'PremieR Nutrição Clínica Cães'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 233, 'PremieR Nutrição Clínica Cães - Obesidade - Porte Pequeno',
       'caes', 'UniPet',
       'PremieR Nutrição Clínica Cães', 399.9, '/assets/products/catalog/page-57-caes-obesidade.webp',
       'Linha PremieR Nutrição Clínica Cães. Obesidade. Porte Pequeno. Embalagem 10.1kg.', '10.1kg',
       57, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'PremieR Nutrição Clínica Cães - Obesidade - Porte Pequeno'
    AND COALESCE(weight, '') = '10.1kg'
    AND COALESCE(line, '') = 'PremieR Nutrição Clínica Cães'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 234, 'PremieR Nutrição Clínica Cães - Obesidade - Porte Médio/Grande',
       'caes', 'UniPet',
       'PremieR Nutrição Clínica Cães', 399.9, '/assets/products/catalog/page-57-caes-obesidade.webp',
       'Linha PremieR Nutrição Clínica Cães. Obesidade. Porte Médio/Grande. Embalagem 10.1kg.', '10.1kg',
       57, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'PremieR Nutrição Clínica Cães - Obesidade - Porte Médio/Grande'
    AND COALESCE(weight, '') = '10.1kg'
    AND COALESCE(line, '') = 'PremieR Nutrição Clínica Cães'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 235, 'PremieR Nutrição Clínica Cães - Renal - Porte Pequeno',
       'caes', 'UniPet',
       'PremieR Nutrição Clínica Cães', 95.9, '/assets/products/catalog/page-57-caes-renal.webp',
       'Linha PremieR Nutrição Clínica Cães. Renal. Porte Pequeno. Embalagem 2kg.', '2kg',
       57, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'PremieR Nutrição Clínica Cães - Renal - Porte Pequeno'
    AND COALESCE(weight, '') = '2kg'
    AND COALESCE(line, '') = 'PremieR Nutrição Clínica Cães'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 236, 'PremieR Nutrição Clínica Cães - Renal - Porte Pequeno',
       'caes', 'UniPet',
       'PremieR Nutrição Clínica Cães', 379.9, '/assets/products/catalog/page-57-caes-renal.webp',
       'Linha PremieR Nutrição Clínica Cães. Renal. Porte Pequeno. Embalagem 10.1kg.', '10.1kg',
       57, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'PremieR Nutrição Clínica Cães - Renal - Porte Pequeno'
    AND COALESCE(weight, '') = '10.1kg'
    AND COALESCE(line, '') = 'PremieR Nutrição Clínica Cães'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 237, 'PremieR Nutrição Clínica Cães - Renal - Porte Médio/Grande',
       'caes', 'UniPet',
       'PremieR Nutrição Clínica Cães', 379.9, '/assets/products/catalog/page-57-caes-renal.webp',
       'Linha PremieR Nutrição Clínica Cães. Renal. Porte Médio/Grande. Embalagem 10.1kg.', '10.1kg',
       57, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'PremieR Nutrição Clínica Cães - Renal - Porte Médio/Grande'
    AND COALESCE(weight, '') = '10.1kg'
    AND COALESCE(line, '') = 'PremieR Nutrição Clínica Cães'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 238, 'PremieR Nutrição Clínica Gatos - Obesidade',
       'gatos', 'UniPet',
       'PremieR Nutrição Clínica Gatos', 109.9, '/assets/products/catalog/page-58-gatos-obesidade.webp',
       'Linha PremieR Nutrição Clínica Gatos. Obesidade. Embalagem 1.5kg.', '1.5kg',
       58, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'PremieR Nutrição Clínica Gatos - Obesidade'
    AND COALESCE(weight, '') = '1.5kg'
    AND COALESCE(line, '') = 'PremieR Nutrição Clínica Gatos'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 239, 'PremieR Nutrição Clínica Gatos - Urinário Estruvita',
       'gatos', 'UniPet',
       'PremieR Nutrição Clínica Gatos', 49.9, '/assets/products/catalog/page-58-gatos-urinario.webp',
       'Linha PremieR Nutrição Clínica Gatos. Urinário Estruvita. Embalagem 500g.', '500g',
       58, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'PremieR Nutrição Clínica Gatos - Urinário Estruvita'
    AND COALESCE(weight, '') = '500g'
    AND COALESCE(line, '') = 'PremieR Nutrição Clínica Gatos'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 240, 'PremieR Nutrição Clínica Gatos - Urinário Estruvita',
       'gatos', 'UniPet',
       'PremieR Nutrição Clínica Gatos', 109.9, '/assets/products/catalog/page-58-gatos-urinario.webp',
       'Linha PremieR Nutrição Clínica Gatos. Urinário Estruvita. Embalagem 1.5kg.', '1.5kg',
       58, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'PremieR Nutrição Clínica Gatos - Urinário Estruvita'
    AND COALESCE(weight, '') = '1.5kg'
    AND COALESCE(line, '') = 'PremieR Nutrição Clínica Gatos'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 241, 'PremieR Nutrição Clínica Gatos - Renal Estágios Iniciais',
       'gatos', 'UniPet',
       'PremieR Nutrição Clínica Gatos', 109.9, '/assets/products/catalog/page-58-gatos-renal-iniciais.webp',
       'Linha PremieR Nutrição Clínica Gatos. Renal Estágios Iniciais. Embalagem 1.5kg.', '1.5kg',
       58, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'PremieR Nutrição Clínica Gatos - Renal Estágios Iniciais'
    AND COALESCE(weight, '') = '1.5kg'
    AND COALESCE(line, '') = 'PremieR Nutrição Clínica Gatos'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 242, 'PremieR Nutrição Clínica Gatos - Renal',
       'gatos', 'UniPet',
       'PremieR Nutrição Clínica Gatos', 49.9, '/assets/products/catalog/page-58-gatos-renal.webp',
       'Linha PremieR Nutrição Clínica Gatos. Renal. Embalagem 500g.', '500g',
       58, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'PremieR Nutrição Clínica Gatos - Renal'
    AND COALESCE(weight, '') = '500g'
    AND COALESCE(line, '') = 'PremieR Nutrição Clínica Gatos'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 243, 'PremieR Nutrição Clínica Gatos - Renal',
       'gatos', 'UniPet',
       'PremieR Nutrição Clínica Gatos', 109.9, '/assets/products/catalog/page-58-gatos-renal.webp',
       'Linha PremieR Nutrição Clínica Gatos. Renal. Embalagem 1.5kg.', '1.5kg',
       58, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'PremieR Nutrição Clínica Gatos - Renal'
    AND COALESCE(weight, '') = '1.5kg'
    AND COALESCE(line, '') = 'PremieR Nutrição Clínica Gatos'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 244, 'PremieR Nutrição Clínica Úmidos - Cães Diabetes',
       'caes', 'UniPet',
       'PremieR Nutrição Clínica Úmidos', 258.0, '/assets/products/catalog/page-59-umido-caes-diabetes.webp',
       'Linha PremieR Nutrição Clínica Úmidos. Cães Diabetes. Embalagem 85g (pacote com 20 un.).', '85g',
       59, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'PremieR Nutrição Clínica Úmidos - Cães Diabetes'
    AND COALESCE(weight, '') = '85g'
    AND COALESCE(line, '') = 'PremieR Nutrição Clínica Úmidos'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 245, 'PremieR Nutrição Clínica Úmidos - Cães Obesidade',
       'caes', 'UniPet',
       'PremieR Nutrição Clínica Úmidos', 258.0, '/assets/products/catalog/page-59-umido-caes-obesidade.webp',
       'Linha PremieR Nutrição Clínica Úmidos. Cães Obesidade. Embalagem 85g (pacote com 20 un.).', '85g',
       59, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'PremieR Nutrição Clínica Úmidos - Cães Obesidade'
    AND COALESCE(weight, '') = '85g'
    AND COALESCE(line, '') = 'PremieR Nutrição Clínica Úmidos'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 246, 'PremieR Nutrição Clínica Úmidos - Gatos Obesidade',
       'gatos', 'UniPet',
       'PremieR Nutrição Clínica Úmidos', 238.0, '/assets/products/catalog/page-59-umido-gatos-obesidade.webp',
       'Linha PremieR Nutrição Clínica Úmidos. Gatos Obesidade. Embalagem 70g (pacote com 20 un.).', '70g',
       59, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'PremieR Nutrição Clínica Úmidos - Gatos Obesidade'
    AND COALESCE(weight, '') = '70g'
    AND COALESCE(line, '') = 'PremieR Nutrição Clínica Úmidos'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 247, 'PremieR Nutrição Clínica Úmidos - Gatos Urinário',
       'gatos', 'UniPet',
       'PremieR Nutrição Clínica Úmidos', 238.0, '/assets/products/catalog/page-59-umido-gatos-urinario.webp',
       'Linha PremieR Nutrição Clínica Úmidos. Gatos Urinário. Embalagem 70g (pacote com 20 un.).', '70g',
       59, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'PremieR Nutrição Clínica Úmidos - Gatos Urinário'
    AND COALESCE(weight, '') = '70g'
    AND COALESCE(line, '') = 'PremieR Nutrição Clínica Úmidos'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 248, 'PremieR Nutrição Clínica Úmidos - Cães e Gatos Recuperação',
       'caes', 'UniPet',
       'PremieR Nutrição Clínica Úmidos', 298.0, '/assets/products/catalog/page-59-umido-recuperacao.webp',
       'Linha PremieR Nutrição Clínica Úmidos. Cães e Gatos Recuperação. Embalagem 85g (pacote com 20 un.).', '85g',
       59, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'PremieR Nutrição Clínica Úmidos - Cães e Gatos Recuperação'
    AND COALESCE(weight, '') = '85g'
    AND COALESCE(line, '') = 'PremieR Nutrição Clínica Úmidos'
);
COMMIT;
