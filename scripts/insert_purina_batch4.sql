-- Insere mais 5 produtos Purina (catálogo + tabela 16-07 + 30%)
BEGIN;
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 264, 'Purina Pro Plan - Gatos Castrados - Sabor Salmão - Embalagem 1kg',
       'gatos', 'UniPet', 'Purina',
       71.7, '/assets/products/catalog/purina-proplan-cat-sterilized.webp', 'Linha Purina. Pro Plan. Gatos Castrados. Sabor Salmão.',
       '1kg', 7, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Pro Plan - Gatos Castrados - Sabor Salmão - Embalagem 1kg'
    AND COALESCE(weight, '') = '1kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 265, 'Purina Pro Plan - Cães Filhotes - Porte Médio e Grande - Sabor Frango - Embalagem 2.5kg',
       'caes', 'UniPet', 'Purina',
       119.57, '/assets/products/catalog/purina-proplan-puppy-grande.webp', 'Linha Purina. Pro Plan. Cães Filhotes. Porte Médio e Grande. Sabor Frango.',
       '2.5kg', 8, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Pro Plan - Cães Filhotes - Porte Médio e Grande - Sabor Frango - Embalagem 2.5kg'
    AND COALESCE(weight, '') = '2.5kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 266, 'Purina Cat Chow - Gatos Castrados - Sabor Frango - Embalagem 10.1kg',
       'gatos', 'UniPet', 'Purina',
       190.07, '/assets/products/catalog/purina-catchow-cast-frango.webp', 'Linha Purina. Cat Chow. Gatos Castrados. Sabor Frango.',
       '10.1kg', 21, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Cat Chow - Gatos Castrados - Sabor Frango - Embalagem 10.1kg'
    AND COALESCE(weight, '') = '10.1kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 267, 'Purina Dog Chow - Cães Filhotes - Porte Mini e Pequeno - Sabor Carne, Frango, Frutas e Leite - Embalagem 15kg',
       'caes', 'UniPet', 'Purina',
       183.66, '/assets/products/catalog/purina-dogchow-puppy-mini.webp', 'Linha Purina. Dog Chow. Cães Filhotes. Porte Mini e Pequeno. Sabor Carne, Frango, Frutas e Leite.',
       '15kg', 23, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Dog Chow - Cães Filhotes - Porte Mini e Pequeno - Sabor Carne, Frango, Frutas e Leite - Embalagem 15kg'
    AND COALESCE(weight, '') = '15kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 268, 'Purina Friskies - Gatos Adultos - Sabor Megamix - Embalagem 10.1kg',
       'gatos', 'UniPet', 'Purina',
       183.86, '/assets/products/catalog/purina-friskies-megamix.webp', 'Linha Purina. Friskies. Gatos Adultos. Sabor Megamix.',
       '10.1kg', 27, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Friskies - Gatos Adultos - Sabor Megamix - Embalagem 10.1kg'
    AND COALESCE(weight, '') = '10.1kg'
    AND COALESCE(line, '') = 'Purina'
);
UPDATE products SET
  price = CASE external_id
    WHEN 264 THEN 71.70
    WHEN 265 THEN 119.57
    WHEN 266 THEN 190.07
    WHEN 267 THEN 183.66
    WHEN 268 THEN 183.86
  END,
  updated_at = NOW()
WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
  AND line = 'Purina'
  AND external_id IN (264, 265, 266, 267, 268);
COMMIT;
