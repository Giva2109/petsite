-- Insere mais 5 produtos Purina (catálogo + tabela 16-07 + 30%)
BEGIN;
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 384, 'Purina Dog Chow - Cães Adultos - Porte Mini e Pequeno - Embalagem 900g',
       'caes', 'UniPet', 'Purina',
       21.35, '/assets/products/catalog/purina-dogchow-adult-mini.webp', 'Linha Purina. Dog Chow. Adultos - Porte Mini e Pequeno.',
       '900g', 23, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Dog Chow - Cães Adultos - Porte Mini e Pequeno - Embalagem 900g'
    AND COALESCE(weight, '') = '900g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 385, 'Purina Dog Chow - Cães Adultos - Porte Médio e Grande - Embalagem 900g',
       'caes', 'UniPet', 'Purina',
       21.35, '/assets/products/catalog/purina-dogchow-adult-med-grande.webp', 'Linha Purina. Dog Chow. Adultos - Porte Médio e Grande.',
       '900g', 23, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Dog Chow - Cães Adultos - Porte Médio e Grande - Embalagem 900g'
    AND COALESCE(weight, '') = '900g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 386, 'Purina Dog Chow - Cães Adultos 7+ - Embalagem 900g',
       'caes', 'UniPet', 'Purina',
       20.15, '/assets/products/catalog/purina-dogchow-adult-med-grande.webp', 'Linha Purina. Dog Chow. Adultos 7+.',
       '900g', 23, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Dog Chow - Cães Adultos 7+ - Embalagem 900g'
    AND COALESCE(weight, '') = '900g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 387, 'Purina Pro Plan - Gatos - LiveClear Redução de Alérgenos - Embalagem 7.5kg',
       'gatos', 'UniPet', 'Purina',
       350.29, '/assets/products/catalog/purina-proplan-cat-liveclear.webp', 'Linha Purina. Pro Plan. Gatos. LiveClear Redução de Alérgenos.',
       '7.5kg', 5, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Pro Plan - Gatos - LiveClear Redução de Alérgenos - Embalagem 7.5kg'
    AND COALESCE(weight, '') = '7.5kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 388, 'Purina Pro Plan - Gatos Filhotes - Embalagem 3kg',
       'gatos', 'UniPet', 'Purina',
       190.81, '/assets/products/catalog/purina-proplan-cat-kitten.webp', 'Linha Purina. Pro Plan. Filhotes.',
       '3kg', 5, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Pro Plan - Gatos Filhotes - Embalagem 3kg'
    AND COALESCE(weight, '') = '3kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 389, 'Purina Pro Plan - Gatos - LiveClear Redução de Alérgenos - Embalagem 3kg',
       'gatos', 'UniPet', 'Purina',
       199.89, '/assets/products/catalog/purina-proplan-cat-liveclear.webp', 'Linha Purina. Pro Plan. Gatos. LiveClear Redução de Alérgenos.',
       '3kg', 5, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Pro Plan - Gatos - LiveClear Redução de Alérgenos - Embalagem 3kg'
    AND COALESCE(weight, '') = '3kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 390, 'Purina Dog Chow - Cães Adultos - Embalagem 15x85g',
       'caes', 'UniPet', 'Purina',
       54.21, '/assets/products/catalog/purina-dogchow-adult-med-grande.webp', 'Linha Purina. Dog Chow. Adultos.',
       '15x85g', 23, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Dog Chow - Cães Adultos - Embalagem 15x85g'
    AND COALESCE(weight, '') = '15x85g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 391, 'Purina Dog Chow - Cães Adultos - Embalagem 15x85g',
       'caes', 'UniPet', 'Purina',
       54.21, '/assets/products/catalog/purina-dogchow-adult-med-grande.webp', 'Linha Purina. Dog Chow. Adultos.',
       '15x85g', 23, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Dog Chow - Cães Adultos - Embalagem 15x85g'
    AND COALESCE(weight, '') = '15x85g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 392, 'Purina Dog Chow - Cães Adultos - Embalagem 15x85g',
       'caes', 'UniPet', 'Purina',
       54.21, '/assets/products/catalog/purina-dogchow-adult-med-grande.webp', 'Linha Purina. Dog Chow. Adultos.',
       '15x85g', 23, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Dog Chow - Cães Adultos - Embalagem 15x85g'
    AND COALESCE(weight, '') = '15x85g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 393, 'Purina Dog Chow - Cães Filhotes - Sabor Frango, Leite - Embalagem 15x85g',
       'caes', 'UniPet', 'Purina',
       54.21, '/assets/products/catalog/purina-dogchow-puppy-med.webp', 'Linha Purina. Dog Chow. Filhotes. Frango, Leite.',
       '15x85g', 23, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Dog Chow - Cães Filhotes - Sabor Frango, Leite - Embalagem 15x85g'
    AND COALESCE(weight, '') = '15x85g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 394, 'Purina Dog Chow - Cães Adultos - Embalagem 15x85g',
       'caes', 'UniPet', 'Purina',
       54.21, '/assets/products/catalog/purina-dogchow-adult-med-grande.webp', 'Linha Purina. Dog Chow. Adultos.',
       '15x85g', 23, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Dog Chow - Cães Adultos - Embalagem 15x85g'
    AND COALESCE(weight, '') = '15x85g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 395, 'Purina Dog Chow - Cães Adultos - Sabor Cordeiro, Arroz - Embalagem 15x85g',
       'caes', 'UniPet', 'Purina',
       54.21, '/assets/products/catalog/purina-dogchow-adult-med-grande.webp', 'Linha Purina. Dog Chow. Adultos. Cordeiro, Arroz.',
       '15x85g', 23, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Dog Chow - Cães Adultos - Sabor Cordeiro, Arroz - Embalagem 15x85g'
    AND COALESCE(weight, '') = '15x85g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 396, 'Purina Dog Chow - Cães Filhotes - Sabor Carne, Leite - Embalagem 15x85g',
       'caes', 'UniPet', 'Purina',
       54.21, '/assets/products/catalog/purina-dogchow-puppy-med.webp', 'Linha Purina. Dog Chow. Filhotes. Carne, Leite.',
       '15x85g', 23, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Dog Chow - Cães Filhotes - Sabor Carne, Leite - Embalagem 15x85g'
    AND COALESCE(weight, '') = '15x85g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 397, 'Purina Dog Chow - Cães Adultos - Sabor Frango, Arroz - Embalagem 15x85g',
       'caes', 'UniPet', 'Purina',
       54.21, '/assets/products/catalog/purina-dogchow-adult-med-grande.webp', 'Linha Purina. Dog Chow. Adultos. Frango, Arroz.',
       '15x85g', 23, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Dog Chow - Cães Adultos - Sabor Frango, Arroz - Embalagem 15x85g'
    AND COALESCE(weight, '') = '15x85g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 398, 'Purina Dog Chow - Cães Adultos - Sabor Carne, Arroz - Embalagem 15x85g',
       'caes', 'UniPet', 'Purina',
       54.21, '/assets/products/catalog/purina-dogchow-adult-med-grande.webp', 'Linha Purina. Dog Chow. Adultos. Carne, Arroz.',
       '15x85g', 23, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Dog Chow - Cães Adultos - Sabor Carne, Arroz - Embalagem 15x85g'
    AND COALESCE(weight, '') = '15x85g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 399, 'Purina Pro Plan - Cães Adultos - Porte Mini e Pequeno - Embalagem 7.5kg',
       'caes', 'UniPet', 'Purina',
       278.72, '/assets/products/catalog/purina-proplan-adult-mini.webp', 'Linha Purina. Pro Plan. Adultos - Porte Mini e Pequeno.',
       '7.5kg', 5, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Pro Plan - Cães Adultos - Porte Mini e Pequeno - Embalagem 7.5kg'
    AND COALESCE(weight, '') = '7.5kg'
    AND COALESCE(line, '') = 'Purina'
);
UPDATE products SET
  price = CASE external_id
    WHEN 384 THEN 21.35
    WHEN 385 THEN 21.35
    WHEN 386 THEN 20.15
    WHEN 387 THEN 350.29
    WHEN 388 THEN 190.81
    WHEN 389 THEN 199.89
    WHEN 390 THEN 54.21
    WHEN 391 THEN 54.21
    WHEN 392 THEN 54.21
    WHEN 393 THEN 54.21
    WHEN 394 THEN 54.21
    WHEN 395 THEN 54.21
    WHEN 396 THEN 54.21
    WHEN 397 THEN 54.21
    WHEN 398 THEN 54.21
    WHEN 399 THEN 278.72
  END,
  updated_at = NOW()
WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
  AND line = 'Purina'
  AND external_id IN (384, 385, 386, 387, 388, 389, 390, 391, 392, 393, 394, 395, 396, 397, 398, 399);
COMMIT;
