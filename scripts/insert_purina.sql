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
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 259, 'Purina Pro Plan - Gatos Adultos 7+ - Sabor Frango - Embalagem 1kg',
       'gatos', 'UniPet', 'Purina',
       71.70, '/assets/products/catalog/purina-proplan-cat-7plus.webp', 'Linha Purina. Pro Plan. Gatos Adultos 7+. Sabor Frango.',
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
       170.00, '/assets/products/catalog/purina-dogchow-adult-mini.webp', 'Linha Purina. Dog Chow. Cães Adultos. Porte Mini e Pequeno. Sabor Carne e Frango.',
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
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 264, 'Purina Pro Plan - Gatos Castrados - Sabor Salmão - Embalagem 1kg',
       'gatos', 'UniPet', 'Purina',
       71.70, '/assets/products/catalog/purina-proplan-cat-sterilized.webp', 'Linha Purina. Pro Plan. Gatos Castrados. Sabor Salmão.',
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
    WHEN 259 THEN 71.70
    WHEN 260 THEN 113.87
    WHEN 261 THEN 190.07
    WHEN 262 THEN 170.00
    WHEN 263 THEN 183.86
    WHEN 264 THEN 71.70
    WHEN 265 THEN 119.57
    WHEN 266 THEN 190.07
    WHEN 267 THEN 183.66
    WHEN 268 THEN 183.86
    WHEN 269 THEN 78.39
    WHEN 270 THEN 55.67
    WHEN 271 THEN 190.07
    WHEN 272 THEN 178.41
    WHEN 273 THEN 193.05
    WHEN 274 THEN 107.13
    WHEN 275 THEN 124.75
    WHEN 276 THEN 62.01
    WHEN 277 THEN 275.98
    WHEN 278 THEN 24.87
  END,
  updated_at = NOW()
WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
  AND line = 'Purina'
  AND external_id IN (249, 250, 251, 252, 253, 254, 255, 256, 257, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 268, 269, 270, 271, 272, 273, 274, 275, 276, 277, 278);
COMMIT;
