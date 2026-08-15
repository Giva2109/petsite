-- Insere 5 produtos Purina de teste (catálogo + tabela 16-07)
BEGIN;
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 249, 'Purina Pro Plan - Gatos Adultos - Sabor Frango e Arroz - Embalagem 1kg',
       'gatos', 'UniPet', 'Purina',
       55.15, '/assets/products/catalog/purina-proplan-cat-adult-frango.webp', 'Linha Purina. Pro Plan. Gatos Adultos. Sabor Frango e Arroz.',
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
       40.87, '/assets/products/catalog/purina-proplan-puppy-mini.webp', 'Linha Purina. Pro Plan. Cães Filhotes. Porte Mini e Pequeno. Sabor Frango.',
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
       146.21, '/assets/products/catalog/purina-catchow-adult-carne.webp', 'Linha Purina. Cat Chow. Gatos Adultos. Sabor Carne.',
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
       130.77, '/assets/products/catalog/purina-dogchow-adult-med-grande.webp', 'Linha Purina. Dog Chow. Cães Adultos. Porte Médio e Grande. Sabor Carne, Frango e Arroz.',
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
       141.43, '/assets/products/catalog/purina-friskies-mix-carnes.webp', 'Linha Purina. Friskies. Gatos Adultos. Sabor Mix de Carnes.',
       '10.1kg', 27, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Friskies - Gatos Adultos - Sabor Mix de Carnes - Embalagem 10.1kg'
    AND COALESCE(weight, '') = '10.1kg'
    AND COALESCE(line, '') = 'Purina'
);
COMMIT;
