-- Insere mais 5 produtos Purina (catálogo + tabela 16-07 + 30%)
BEGIN;
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 279, 'Purina Pro Plan - Gatos Adultos - Sachê Frango ao Molho - Embalagem 15x85g',
       'gatos', 'UniPet', 'Purina',
       107.25, '/assets/products/catalog/purina-proplan-sachet-adult-frango.webp', 'Linha Purina. Pro Plan. Gatos Adultos. Sachê Frango ao Molho.',
       '15x85g', 7, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Pro Plan - Gatos Adultos - Sachê Frango ao Molho - Embalagem 15x85g'
    AND COALESCE(weight, '') = '15x85g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 280, 'Purina Pro Plan - Cães Adultos 7+ - Mente Ativa - Sabor Frango - Embalagem 1kg',
       'caes', 'UniPet', 'Purina',
       63.26, '/assets/products/catalog/purina-proplan-activemind.webp', 'Linha Purina. Pro Plan. Cães Adultos 7+. Mente Ativa. Sabor Frango.',
       '1kg', 9, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Pro Plan - Cães Adultos 7+ - Mente Ativa - Sabor Frango - Embalagem 1kg'
    AND COALESCE(weight, '') = '1kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 281, 'Purina Cat Chow - Gatos Adultos - Sachê Carne ao Molho - Embalagem 15x85g',
       'gatos', 'UniPet', 'Purina',
       62.01, '/assets/products/catalog/purina-catchow-sachet-adult-carne.webp', 'Linha Purina. Cat Chow. Gatos Adultos. Sachê Carne ao Molho.',
       '15x85g', 21, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Cat Chow - Gatos Adultos - Sachê Carne ao Molho - Embalagem 15x85g'
    AND COALESCE(weight, '') = '15x85g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 282, 'Purina Dog Chow - Cães Adultos - Porte Mini e Pequeno - Saúde Oral - Embalagem 20x45g',
       'caes', 'UniPet', 'Purina',
       198.90, '/assets/products/catalog/purina-dogchow-oral-mini.webp', 'Linha Purina. Dog Chow. Cães Adultos. Porte Mini e Pequeno. Saúde Oral.',
       '20x45g', 25, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Dog Chow - Cães Adultos - Porte Mini e Pequeno - Saúde Oral - Embalagem 20x45g'
    AND COALESCE(weight, '') = '20x45g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 283, 'Purina Friskies - Gatos Adultos - Petiscos Sabor Frango - Embalagem 15x40g',
       'gatos', 'UniPet', 'Purina',
       103.55, '/assets/products/catalog/purina-friskies-petisco-frango.webp', 'Linha Purina. Friskies. Gatos Adultos. Petiscos Sabor Frango.',
       '15x40g', 29, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Friskies - Gatos Adultos - Petiscos Sabor Frango - Embalagem 15x40g'
    AND COALESCE(weight, '') = '15x40g'
    AND COALESCE(line, '') = 'Purina'
);
UPDATE products SET
  price = CASE external_id
    WHEN 279 THEN 107.25
    WHEN 280 THEN 63.26
    WHEN 281 THEN 62.01
    WHEN 282 THEN 198.90
    WHEN 283 THEN 103.55
  END,
  updated_at = NOW()
WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
  AND line = 'Purina'
  AND external_id IN (279, 280, 281, 282, 283);
COMMIT;
