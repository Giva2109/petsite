-- Insere mais 5 produtos Purina (catálogo + tabela 16-07 + 30%)
BEGIN;
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 259, 'Purina Pro Plan - Gatos Adultos 7+ - Sabor Frango - Embalagem 1kg',
       'gatos', 'UniPet', 'Purina',
       71.7, '/assets/products/catalog/purina-proplan-cat-7plus.webp', 'Linha Purina. Pro Plan. Gatos Adultos 7+. Sabor Frango.',
       '1kg', 7, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Pro Plan - Gatos Adultos 7+ - Sabor Frango - Embalagem 1kg'
    AND COALESCE(weight, '') = '1kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 260, 'Purina Pro Plan - Cães Adultos - Porte Grande - Sabor Frango - Embalagem 2.5kg',
       'caes', 'UniPet', 'Purina',
       113.87, '/assets/products/catalog/purina-proplan-adult-grande.webp', 'Linha Purina. Pro Plan. Cães Adultos. Porte Grande. Sabor Frango.',
       '2.5kg', 8, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Pro Plan - Cães Adultos - Porte Grande - Sabor Frango - Embalagem 2.5kg'
    AND COALESCE(weight, '') = '2.5kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 261, 'Purina Cat Chow - Gatos Adultos - Sabor Peixe - Embalagem 10.1kg',
       'gatos', 'UniPet', 'Purina',
       190.07, '/assets/products/catalog/purina-catchow-adult-peixe.webp', 'Linha Purina. Cat Chow. Gatos Adultos. Sabor Peixe.',
       '10.1kg', 21, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Cat Chow - Gatos Adultos - Sabor Peixe - Embalagem 10.1kg'
    AND COALESCE(weight, '') = '10.1kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 262, 'Purina Dog Chow - Cães Adultos - Porte Mini e Pequeno - Sabor Carne e Frango - Embalagem 15kg',
       'caes', 'UniPet', 'Purina',
       170.0, '/assets/products/catalog/purina-dogchow-adult-mini.webp', 'Linha Purina. Dog Chow. Cães Adultos. Porte Mini e Pequeno. Sabor Carne e Frango.',
       '15kg', 23, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Dog Chow - Cães Adultos - Porte Mini e Pequeno - Sabor Carne e Frango - Embalagem 15kg'
    AND COALESCE(weight, '') = '15kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 263, 'Purina Friskies - Gatos Adultos - Sabor Mar de Sabores - Embalagem 10.1kg',
       'gatos', 'UniPet', 'Purina',
       183.86, '/assets/products/catalog/purina-friskies-mar.webp', 'Linha Purina. Friskies. Gatos Adultos. Sabor Mar de Sabores.',
       '10.1kg', 27, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Friskies - Gatos Adultos - Sabor Mar de Sabores - Embalagem 10.1kg'
    AND COALESCE(weight, '') = '10.1kg'
    AND COALESCE(line, '') = 'Purina'
);
UPDATE products SET
  price = CASE external_id
    WHEN 259 THEN 71.70
    WHEN 260 THEN 113.87
    WHEN 261 THEN 190.07
    WHEN 262 THEN 170.00
    WHEN 263 THEN 183.86
  END,
  updated_at = NOW()
WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
  AND line = 'Purina'
  AND external_id IN (259, 260, 261, 262, 263);
COMMIT;
