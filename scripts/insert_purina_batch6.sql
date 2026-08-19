-- Insere mais 5 produtos Purina (catálogo + tabela 16-07 + 30%)
BEGIN;
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 274, 'Purina Pro Plan - Gatos Adultos - LiveClear Redução de Alérgenos - Embalagem 1kg',
       'gatos', 'UniPet', 'Purina',
       107.13, '/assets/products/catalog/purina-proplan-cat-liveclear.webp', 'Linha Purina. Pro Plan. Gatos Adultos. LiveClear. Redução de Alérgenos.',
       '1kg', 7, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Pro Plan - Gatos Adultos - LiveClear Redução de Alérgenos - Embalagem 1kg'
    AND COALESCE(weight, '') = '1kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 275, 'Purina Pro Plan - Cães Adultos - Porte Médio e Grande - Caloria Reduzida - Embalagem 2.5kg',
       'caes', 'UniPet', 'Purina',
       124.75, '/assets/products/catalog/purina-proplan-reduced-med.webp', 'Linha Purina. Pro Plan. Cães Adultos. Porte Médio e Grande. Caloria Reduzida.',
       '2.5kg', 9, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Pro Plan - Cães Adultos - Porte Médio e Grande - Caloria Reduzida - Embalagem 2.5kg'
    AND COALESCE(weight, '') = '2.5kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 276, 'Purina Cat Chow - Gatos Filhotes - Sachê Frango ao Molho - Embalagem 15x85g',
       'gatos', 'UniPet', 'Purina',
       62.01, '/assets/products/catalog/purina-catchow-sachet-kitten.webp', 'Linha Purina. Cat Chow. Gatos Filhotes. Sachê Frango ao Molho.',
       '15x85g', 21, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Cat Chow - Gatos Filhotes - Sachê Frango ao Molho - Embalagem 15x85g'
    AND COALESCE(weight, '') = '15x85g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 277, 'Purina Dog Chow - Cães Filhotes - Papita - Todos os Tamanhos - Sabor Carne, Frango, Arroz, Milho e Leite - Embalagem 20kg',
       'caes', 'UniPet', 'Purina',
       275.98, '/assets/products/catalog/purina-dogchow-papita.webp', 'Linha Purina. Dog Chow. Cães Filhotes. Papita. Todos os Tamanhos. Sabor Carne, Frango, Arroz, Milho e Leite.',
       '20kg', 23, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Dog Chow - Cães Filhotes - Papita - Todos os Tamanhos - Sabor Carne, Frango, Arroz, Milho e Leite - Embalagem 20kg'
    AND COALESCE(weight, '') = '20kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 278, 'Purina Friskies - Gatos Castrados - Sabor Mix de Carnes - Embalagem 1kg',
       'gatos', 'UniPet', 'Purina',
       24.87, '/assets/products/catalog/purina-friskies-mix-cast.webp', 'Linha Purina. Friskies. Gatos Castrados. Sabor Mix de Carnes.',
       '1kg', 27, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Friskies - Gatos Castrados - Sabor Mix de Carnes - Embalagem 1kg'
    AND COALESCE(weight, '') = '1kg'
    AND COALESCE(line, '') = 'Purina'
);
UPDATE products SET
  price = CASE external_id
    WHEN 274 THEN 107.13
    WHEN 275 THEN 124.75
    WHEN 276 THEN 62.01
    WHEN 277 THEN 275.98
    WHEN 278 THEN 24.87
  END,
  updated_at = NOW()
WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
  AND line = 'Purina'
  AND external_id IN (274, 275, 276, 277, 278);
COMMIT;
