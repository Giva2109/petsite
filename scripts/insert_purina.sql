-- Insere 5 produtos Purina de teste (catálogo + tabela 16-07)
BEGIN;
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 249, 'Purina Pro Plan - Gatos Adultos - Sabor Frango e Arroz - Embalagem 1kg',
       'gatos', 'UniPet', 'Purina',
       71.70, '/assets/products/catalog/purina-proplan-cat-adult-frango.webp', 'Linha Purina. Pro Plan. Gatos Adultos. Sabor Frango e Arroz.',
       '1kg', 7, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Pro Plan - Gatos Adultos - Sabor Frango e Arroz - Embalagem 1kg'
    AND COALESCE(weight, '') = '1kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 250, 'Purina Pro Plan - Cães Filhotes - Porte Mini e Pequeno - Sabor Frango - Embalagem 1kg',
       'caes', 'UniPet', 'Purina',
       53.13, '/assets/products/catalog/purina-proplan-puppy-mini.webp', 'Linha Purina. Pro Plan. Cães Filhotes. Porte Mini e Pequeno. Sabor Frango.',
       '1kg', 8, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Pro Plan - Cães Filhotes - Porte Mini e Pequeno - Sabor Frango - Embalagem 1kg'
    AND COALESCE(weight, '') = '1kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 251, 'Purina Cat Chow - Gatos Adultos - Sabor Carne - Embalagem 10.1kg',
       'gatos', 'UniPet', 'Purina',
       190.07, '/assets/products/catalog/purina-catchow-adult-carne.webp', 'Linha Purina. Cat Chow. Gatos Adultos. Sabor Carne.',
       '10.1kg', 21, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Cat Chow - Gatos Adultos - Sabor Carne - Embalagem 10.1kg'
    AND COALESCE(weight, '') = '10.1kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 252, 'Purina Dog Chow - Cães Adultos - Porte Médio e Grande - Sabor Carne, Frango e Arroz - Embalagem 15kg',
       'caes', 'UniPet', 'Purina',
       170.00, '/assets/products/catalog/purina-dogchow-adult-med-grande.webp', 'Linha Purina. Dog Chow. Cães Adultos. Porte Médio e Grande. Sabor Carne, Frango e Arroz.',
       '15kg', 23, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Dog Chow - Cães Adultos - Porte Médio e Grande - Sabor Carne, Frango e Arroz - Embalagem 15kg'
    AND COALESCE(weight, '') = '15kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 253, 'Purina Friskies - Gatos Adultos - Sabor Mix de Carnes - Embalagem 10.1kg',
       'gatos', 'UniPet', 'Purina',
       183.86, '/assets/products/catalog/purina-friskies-mix-carnes.webp', 'Linha Purina. Friskies. Gatos Adultos. Sabor Mix de Carnes.',
       '10.1kg', 27, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Friskies - Gatos Adultos - Sabor Mix de Carnes - Embalagem 10.1kg'
    AND COALESCE(weight, '') = '10.1kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 254, 'Purina Pro Plan - Gatos Filhotes - Sabor Frango - Embalagem 1kg',
       'gatos', 'UniPet', 'Purina',
       75.24, '/assets/products/catalog/purina-proplan-cat-kitten.webp', 'Linha Purina. Pro Plan. Gatos Filhotes. Sabor Frango.',
       '1kg', 7, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Pro Plan - Gatos Filhotes - Sabor Frango - Embalagem 1kg'
    AND COALESCE(weight, '') = '1kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 255, 'Purina Pro Plan - Cães Adultos - Porte Mini e Pequeno - Sabor Frango - Embalagem 1kg',
       'caes', 'UniPet', 'Purina',
       50.65, '/assets/products/catalog/purina-proplan-adult-mini.webp', 'Linha Purina. Pro Plan. Cães Adultos. Porte Mini e Pequeno. Sabor Frango.',
       '1kg', 8, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Pro Plan - Cães Adultos - Porte Mini e Pequeno - Sabor Frango - Embalagem 1kg'
    AND COALESCE(weight, '') = '1kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 256, 'Purina Cat Chow - Gatos Filhotes - Sabor Frango e Leite - Embalagem 10.1kg',
       'gatos', 'UniPet', 'Purina',
       199.58, '/assets/products/catalog/purina-catchow-kitten.webp', 'Linha Purina. Cat Chow. Gatos Filhotes. Sabor Frango e Leite.',
       '10.1kg', 21, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Cat Chow - Gatos Filhotes - Sabor Frango e Leite - Embalagem 10.1kg'
    AND COALESCE(weight, '') = '10.1kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 257, 'Purina Dog Chow - Cães Filhotes - Porte Médio e Grande - Sabor Carne, Frango, Frutas e Leite - Embalagem 15kg',
       'caes', 'UniPet', 'Purina',
       183.66, '/assets/products/catalog/purina-dogchow-puppy-med.webp', 'Linha Purina. Dog Chow. Cães Filhotes. Porte Médio e Grande. Sabor Carne, Frango, Frutas e Leite.',
       '15kg', 23, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Dog Chow - Cães Filhotes - Porte Médio e Grande - Sabor Carne, Frango, Frutas e Leite - Embalagem 15kg'
    AND COALESCE(weight, '') = '15kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 258, 'Purina Friskies - Gatos Adultos - Sabor Delícias da Granja - Embalagem 10.1kg',
       'gatos', 'UniPet', 'Purina',
       183.86, '/assets/products/catalog/purina-friskies-granja.webp', 'Linha Purina. Friskies. Gatos Adultos. Sabor Delícias da Granja.',
       '10.1kg', 27, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Friskies - Gatos Adultos - Sabor Delícias da Granja - Embalagem 10.1kg'
    AND COALESCE(weight, '') = '10.1kg'
    AND COALESCE(line, '') = 'Purina'
);
-- Se os SKUs já existirem, aplica os preços com +30% sobre a tabela 16-07.
UPDATE products SET
  price = CASE external_id
    WHEN 249 THEN 71.70
    WHEN 250 THEN 53.13
    WHEN 251 THEN 190.07
    WHEN 252 THEN 170.00
    WHEN 253 THEN 183.86
    WHEN 254 THEN 75.24
    WHEN 255 THEN 50.65
    WHEN 256 THEN 199.58
    WHEN 257 THEN 183.66
    WHEN 258 THEN 183.86
  END,
  updated_at = NOW()
WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
  AND line = 'Purina'
  AND external_id IN (249, 250, 251, 252, 253, 254, 255, 256, 257, 258);
COMMIT;
