-- Insere mais 5 produtos Purina (catálogo + tabela 16-07 + 30%)
BEGIN;
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 400, 'Purina Dog Chow - Cães Adultos - Porte Mini e Pequeno - Sachê - Sabor Frango - Embalagem 15x100g',
       'caes', 'UniPet', 'Purina',
       54.21, '/assets/products/catalog/purina-dogchow-adult-med-grande.webp', 'Linha Purina. Dog Chow. Adultos - Porte Mini e Pequeno. Sachê. Frango.',
       '15x100g', 23, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Dog Chow - Cães Adultos - Porte Mini e Pequeno - Sachê - Sabor Frango - Embalagem 15x100g'
    AND COALESCE(weight, '') = '15x100g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 401, 'Purina Dog Chow - Cães Adultos - Sachê - Sabor Carne - Embalagem 15x100g',
       'caes', 'UniPet', 'Purina',
       54.21, '/assets/products/catalog/purina-dogchow-adult-med-grande.webp', 'Linha Purina. Dog Chow. Adultos. Sachê. Carne.',
       '15x100g', 23, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Dog Chow - Cães Adultos - Sachê - Sabor Carne - Embalagem 15x100g'
    AND COALESCE(weight, '') = '15x100g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 402, 'Purina Dog Chow - Cães Adultos - Sachê - Sabor Cordeiro - Embalagem 15x100g',
       'caes', 'UniPet', 'Purina',
       54.21, '/assets/products/catalog/purina-dogchow-adult-med-grande.webp', 'Linha Purina. Dog Chow. Adultos. Sachê. Cordeiro.',
       '15x100g', 23, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Dog Chow - Cães Adultos - Sachê - Sabor Cordeiro - Embalagem 15x100g'
    AND COALESCE(weight, '') = '15x100g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 403, 'Purina Dog Chow - Cães Adultos - Sachê - Sabor Frango - Embalagem 15x100g',
       'caes', 'UniPet', 'Purina',
       54.21, '/assets/products/catalog/purina-dogchow-adult-med-grande.webp', 'Linha Purina. Dog Chow. Adultos. Sachê. Frango.',
       '15x100g', 23, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Dog Chow - Cães Adultos - Sachê - Sabor Frango - Embalagem 15x100g'
    AND COALESCE(weight, '') = '15x100g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 404, 'Purina Dog Chow - Cães Adultos - Triploproteína - Embalagem 15x85g',
       'caes', 'UniPet', 'Purina',
       54.21, '/assets/products/catalog/purina-dogchow-adult-med-grande.webp', 'Linha Purina. Dog Chow. Adultos. Triploproteína.',
       '15x85g', 23, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Dog Chow - Cães Adultos - Triploproteína - Embalagem 15x85g'
    AND COALESCE(weight, '') = '15x85g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 405, 'Purina Dog Chow - Cães Adultos - Triploproteína Salmão - Embalagem 15x85g',
       'caes', 'UniPet', 'Purina',
       54.21, '/assets/products/catalog/purina-dogchow-adult-med-grande.webp', 'Linha Purina. Dog Chow. Adultos. Triploproteína Salmão.',
       '15x85g', 23, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Dog Chow - Cães Adultos - Triploproteína Salmão - Embalagem 15x85g'
    AND COALESCE(weight, '') = '15x85g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 406, 'Purina Dog Chow - Cães Adultos - Multiproteína - Embalagem 15x85g',
       'caes', 'UniPet', 'Purina',
       54.21, '/assets/products/catalog/purina-dogchow-adult-med-grande.webp', 'Linha Purina. Dog Chow. Adultos. Multiproteína.',
       '15x85g', 23, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Dog Chow - Cães Adultos - Multiproteína - Embalagem 15x85g'
    AND COALESCE(weight, '') = '15x85g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 407, 'Purina Dog Chow - Cães Adultos - Alta Proteína - Embalagem 15x85g',
       'caes', 'UniPet', 'Purina',
       54.21, '/assets/products/catalog/purina-dogchow-adult-med-grande.webp', 'Linha Purina. Dog Chow. Adultos. Alta Proteína.',
       '15x85g', 23, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Dog Chow - Cães Adultos - Alta Proteína - Embalagem 15x85g'
    AND COALESCE(weight, '') = '15x85g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 408, 'Purina Pro Plan - Gatos Castrados - Sterilised - Embalagem 7.5kg',
       'caes', 'UniPet', 'Purina',
       319.55, '/assets/products/catalog/purina-proplan-cat-sterilized.webp', 'Linha Purina. Pro Plan. Castrados. Sterilised.',
       '7.5kg', 7, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Pro Plan - Gatos Castrados - Sterilised - Embalagem 7.5kg'
    AND COALESCE(weight, '') = '7.5kg'
    AND COALESCE(line, '') = 'Purina'
);
UPDATE products SET
  price = CASE external_id
    WHEN 400 THEN 54.21
    WHEN 401 THEN 54.21
    WHEN 402 THEN 54.21
    WHEN 403 THEN 54.21
    WHEN 404 THEN 54.21
    WHEN 405 THEN 54.21
    WHEN 406 THEN 54.21
    WHEN 407 THEN 54.21
    WHEN 408 THEN 319.55
  END,
  updated_at = NOW()
WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
  AND line = 'Purina'
  AND external_id IN (400, 401, 402, 403, 404, 405, 406, 407, 408);
COMMIT;
