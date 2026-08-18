-- Insere mais 5 produtos Purina (catálogo + tabela 16-07 + 30%)
BEGIN;
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 269, 'Purina Pro Plan - Gatos Adultos - Trato Urinário - Sabor Frango - Embalagem 1kg',
       'gatos', 'UniPet', 'Purina',
       78.39, '/assets/products/catalog/purina-proplan-cat-urinary.webp', 'Linha Purina. Pro Plan. Gatos Adultos. Trato Urinário. Sabor Frango.',
       '1kg', 7, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Pro Plan - Gatos Adultos - Trato Urinário - Sabor Frango - Embalagem 1kg'
    AND COALESCE(weight, '') = '1kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 270, 'Purina Pro Plan - Cães Adultos - Porte Mini e Pequeno - Caloria Reduzida - Embalagem 1kg',
       'caes', 'UniPet', 'Purina',
       55.67, '/assets/products/catalog/purina-proplan-reduced-mini.webp', 'Linha Purina. Pro Plan. Cães Adultos. Porte Mini e Pequeno. Caloria Reduzida.',
       '1kg', 8, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Pro Plan - Cães Adultos - Porte Mini e Pequeno - Caloria Reduzida - Embalagem 1kg'
    AND COALESCE(weight, '') = '1kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 271, 'Purina Cat Chow - Gatos Castrados - Sabor Peixe - Embalagem 10.1kg',
       'gatos', 'UniPet', 'Purina',
       190.07, '/assets/products/catalog/purina-catchow-cast-peixe.webp', 'Linha Purina. Cat Chow. Gatos Castrados. Sabor Peixe.',
       '10.1kg', 21, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Cat Chow - Gatos Castrados - Sabor Peixe - Embalagem 10.1kg'
    AND COALESCE(weight, '') = '10.1kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 272, 'Purina Dog Chow - Cães Adultos 7+ - Todos os Tamanhos - Sabor Carne e Frango - Embalagem 15kg',
       'caes', 'UniPet', 'Purina',
       178.41, '/assets/products/catalog/purina-dogchow-7plus.webp', 'Linha Purina. Dog Chow. Cães Adultos 7+. Todos os Tamanhos. Sabor Carne e Frango.',
       '15kg', 23, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Dog Chow - Cães Adultos 7+ - Todos os Tamanhos - Sabor Carne e Frango - Embalagem 15kg'
    AND COALESCE(weight, '') = '15kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 273, 'Purina Friskies - Gatos Filhotes - Sabor Frango, Leite e Cenoura - Embalagem 10.1kg',
       'gatos', 'UniPet', 'Purina',
       193.05, '/assets/products/catalog/purina-friskies-kitten.webp', 'Linha Purina. Friskies. Gatos Filhotes. Sabor Frango, Leite e Cenoura.',
       '10.1kg', 27, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Friskies - Gatos Filhotes - Sabor Frango, Leite e Cenoura - Embalagem 10.1kg'
    AND COALESCE(weight, '') = '10.1kg'
    AND COALESCE(line, '') = 'Purina'
);
UPDATE products SET
  price = CASE external_id
    WHEN 269 THEN 78.39
    WHEN 270 THEN 55.67
    WHEN 271 THEN 190.07
    WHEN 272 THEN 178.41
    WHEN 273 THEN 193.05
  END,
  updated_at = NOW()
WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
  AND line = 'Purina'
  AND external_id IN (269, 270, 271, 272, 273);
COMMIT;
