-- Catálogo Purina completo (tabela 16-07 + 30%)
BEGIN;
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 249, 'Purina Pro Plan - Gatos Adultos - Sabor Frango e Arroz - Embalagem 1kg',
       'gatos', 'UniPet', 'Purina',
       71.7, '/assets/products/catalog/purina-proplan-cat-urinary-1kg.webp', 'Linha Purina. Pro Plan. Gatos Adultos. Sabor Frango e Arroz.',
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
       53.13, '/assets/products/catalog/purina-proplan-puppy-mini-1kg.webp', 'Linha Purina. Pro Plan. Cães Filhotes. Porte Mini e Pequeno. Sabor Frango.',
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
       190.07, '/assets/products/catalog/purina-catchow-adult-carne-10-1kg.webp', 'Linha Purina. Cat Chow. Gatos Adultos. Sabor Carne.',
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
       170.0, '/assets/products/catalog/purina-dogchow-adult-med-grande-10-1kg.webp', 'Linha Purina. Dog Chow. Cães Adultos. Porte Médio e Grande. Sabor Carne, Frango e Arroz.',
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
       183.86, '/assets/products/catalog/purina-friskies-mix-carnes-1kg.webp', 'Linha Purina. Friskies. Gatos Adultos. Sabor Mix de Carnes.',
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
       75.24, '/assets/products/catalog/purina-proplan-cat-kitten-1kg.webp', 'Linha Purina. Pro Plan. Gatos Filhotes. Sabor Frango.',
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
       50.65, '/assets/products/catalog/purina-proplan-puppy-mini-1kg.webp', 'Linha Purina. Pro Plan. Cães Adultos. Porte Mini e Pequeno. Sabor Frango.',
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
       199.58, '/assets/products/catalog/purina-catchow-kitten-10-1kg.webp', 'Linha Purina. Cat Chow. Gatos Filhotes. Sabor Frango e Leite.',
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
       183.66, '/assets/products/catalog/purina-dogchow-adult-med-grande-10-1kg.webp', 'Linha Purina. Dog Chow. Cães Filhotes. Porte Médio e Grande. Sabor Carne, Frango, Frutas e Leite.',
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
       183.86, '/assets/products/catalog/purina-friskies-granja-1kg.webp', 'Linha Purina. Friskies. Gatos Adultos. Sabor Delícias da Granja.',
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
       71.7, '/assets/products/catalog/purina-proplan-cat-7plus-1kg.webp', 'Linha Purina. Pro Plan. Gatos Adultos 7+. Sabor Frango.',
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
       113.87, '/assets/products/catalog/purina-proplan-reduced-med-2-5kg.webp', 'Linha Purina. Pro Plan. Cães Adultos. Porte Grande. Sabor Frango.',
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
       190.07, '/assets/products/catalog/purina-catchow-adult-peixe-10-1kg.webp', 'Linha Purina. Cat Chow. Gatos Adultos. Sabor Peixe.',
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
       170.0, '/assets/products/catalog/purina-dogchow-adult-mini-10-1kg.webp', 'Linha Purina. Dog Chow. Cães Adultos. Porte Mini e Pequeno. Sabor Carne e Frango.',
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
       183.86, '/assets/products/catalog/purina-friskies-mar-1kg.webp', 'Linha Purina. Friskies. Gatos Adultos. Sabor Mar de Sabores.',
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
       71.7, '/assets/products/catalog/purina-proplan-cat-urinary-1kg.webp', 'Linha Purina. Pro Plan. Gatos Castrados. Sabor Salmão.',
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
       119.57, '/assets/products/catalog/purina-proplan-reduced-med-2-5kg.webp', 'Linha Purina. Pro Plan. Cães Filhotes. Porte Médio e Grande. Sabor Frango.',
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
       190.07, '/assets/products/catalog/purina-catchow-cast-frango-10-1kg.webp', 'Linha Purina. Cat Chow. Gatos Castrados. Sabor Frango.',
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
       183.66, '/assets/products/catalog/purina-dogchow-adult-mini-10-1kg.webp', 'Linha Purina. Dog Chow. Cães Filhotes. Porte Mini e Pequeno. Sabor Carne, Frango, Frutas e Leite.',
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
       183.86, '/assets/products/catalog/purina-friskies-megamix-1kg.webp', 'Linha Purina. Friskies. Gatos Adultos. Sabor Megamix.',
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
       78.39, '/assets/products/catalog/purina-proplan-cat-urinary-1kg.webp', 'Linha Purina. Pro Plan. Gatos Adultos. Trato Urinário. Sabor Frango.',
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
       55.67, '/assets/products/catalog/purina-proplan-puppy-mini-1kg.webp', 'Linha Purina. Pro Plan. Cães Adultos. Porte Mini e Pequeno. Caloria Reduzida.',
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
       190.07, '/assets/products/catalog/purina-catchow-cast-peixe-10-1kg.webp', 'Linha Purina. Cat Chow. Gatos Castrados. Sabor Peixe.',
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
       178.41, '/assets/products/catalog/purina-dogchow-7plus-15kg.webp', 'Linha Purina. Dog Chow. Cães Adultos 7+. Todos os Tamanhos. Sabor Carne e Frango.',
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
       193.05, '/assets/products/catalog/purina-friskies-kitten-1kg.webp', 'Linha Purina. Friskies. Gatos Filhotes. Sabor Frango, Leite e Cenoura.',
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
       107.13, '/assets/products/catalog/purina-proplan-cat-urinary-1kg.webp', 'Linha Purina. Pro Plan. Gatos Adultos. LiveClear. Redução de Alérgenos.',
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
       124.75, '/assets/products/catalog/purina-proplan-reduced-med-2-5kg.webp', 'Linha Purina. Pro Plan. Cães Adultos. Porte Médio e Grande. Caloria Reduzida.',
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
       62.01, '/assets/products/catalog/purina-catchow-sachet-kitten-85g.webp', 'Linha Purina. Cat Chow. Gatos Filhotes. Sachê Frango ao Molho.',
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
       275.98, '/assets/products/catalog/purina-dogchow-papita-20kg.webp', 'Linha Purina. Dog Chow. Cães Filhotes. Papita. Todos os Tamanhos. Sabor Carne, Frango, Arroz, Milho e Leite.',
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
       24.87, '/assets/products/catalog/purina-friskies-mix-cast-1kg.webp', 'Linha Purina. Friskies. Gatos Castrados. Sabor Mix de Carnes.',
       '1kg', 27, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Friskies - Gatos Castrados - Sabor Mix de Carnes - Embalagem 1kg'
    AND COALESCE(weight, '') = '1kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 279, 'Purina Pro Plan - Gatos Adultos - Sachê Frango ao Molho - Embalagem 15x85g',
       'gatos', 'UniPet', 'Purina',
       107.25, '/assets/products/catalog/purina-proplan-sachet-adult-frango-85g.webp', 'Linha Purina. Pro Plan. Gatos Adultos. Sachê Frango ao Molho.',
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
       63.26, '/assets/products/catalog/purina-proplan-activemind-1kg.webp', 'Linha Purina. Pro Plan. Cães Adultos 7+. Mente Ativa. Sabor Frango.',
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
       62.01, '/assets/products/catalog/purina-catchow-sachet-adult-carne-85g.webp', 'Linha Purina. Cat Chow. Gatos Adultos. Sachê Carne ao Molho.',
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
       198.9, '/assets/products/catalog/purina-dogchow-oral-mini-45g.webp', 'Linha Purina. Dog Chow. Cães Adultos. Porte Mini e Pequeno. Saúde Oral.',
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
       103.55, '/assets/products/catalog/purina-friskies-petisco-frango-40g.webp', 'Linha Purina. Friskies. Gatos Adultos. Petiscos Sabor Frango.',
       '15x40g', 29, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Friskies - Gatos Adultos - Petiscos Sabor Frango - Embalagem 15x40g'
    AND COALESCE(weight, '') = '15x40g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 284, 'Purina Alpo - Cães Adultos - Embalagem 18kg',
       'caes', 'UniPet', 'Purina',
       203.94, '/assets/products/catalog/purina-alpo-adulto-18kg.webp', 'Linha Purina. Alpo. Adultos.',
       '18kg', 31, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Alpo - Cães Adultos - Embalagem 18kg'
    AND COALESCE(weight, '') = '18kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 285, 'Purina Cat Chow - Gatos Castrados - Sabor Frango - Embalagem 2.7kg',
       'gatos', 'UniPet', 'Purina',
       64.74, '/assets/products/catalog/purina-catchow-cast-frango-10-1kg.webp', 'Linha Purina. Cat Chow. Castrados. Frango.',
       '2.7kg', 21, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Cat Chow - Gatos Castrados - Sabor Frango - Embalagem 2.7kg'
    AND COALESCE(weight, '') = '2.7kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 286, 'Purina Cat Chow - Gatos Castrados - Sabor Peixe - Embalagem 1kg',
       'gatos', 'UniPet', 'Purina',
       31.14, '/assets/products/catalog/purina-catchow-cast-peixe-10-1kg.webp', 'Linha Purina. Cat Chow. Castrados. Peixe.',
       '1kg', 21, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Cat Chow - Gatos Castrados - Sabor Peixe - Embalagem 1kg'
    AND COALESCE(weight, '') = '1kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 287, 'Purina Cat Chow - Gatos Castrados - Sabor Peixe - Embalagem 2.7kg',
       'gatos', 'UniPet', 'Purina',
       64.74, '/assets/products/catalog/purina-catchow-cast-peixe-10-1kg.webp', 'Linha Purina. Cat Chow. Castrados. Peixe.',
       '2.7kg', 21, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Cat Chow - Gatos Castrados - Sabor Peixe - Embalagem 2.7kg'
    AND COALESCE(weight, '') = '2.7kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 288, 'Purina Dentalife - Cães - Porte Grande - Embalagem 7x196g',
       'caes', 'UniPet', 'Purina',
       184.28, '/assets/products/catalog/purina-dentalife-grande-196g.webp', 'Linha Purina. Dentalife. - Porte Grande.',
       '7x196g', 15, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Dentalife - Cães - Porte Grande - Embalagem 7x196g'
    AND COALESCE(weight, '') = '7x196g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 289, 'Purina Dentalife - Cães - Embalagem 7x119g',
       'caes', 'UniPet', 'Purina',
       140.05, '/assets/products/catalog/purina-dentalife-media-119g.webp', 'Linha Purina. Dentalife. Cães.',
       '7x119g', 15, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Dentalife - Cães - Embalagem 7x119g'
    AND COALESCE(weight, '') = '7x119g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 290, 'Purina Dentalife - Cães - Porte Mini e Pequeno - Embalagem 7x42g',
       'caes', 'UniPet', 'Purina',
       110.11, '/assets/products/catalog/purina-dentalife-pequena-42g.webp', 'Linha Purina. Dentalife. - Porte Mini e Pequeno.',
       '7x42g', 15, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Dentalife - Cães - Porte Mini e Pequeno - Embalagem 7x42g'
    AND COALESCE(weight, '') = '7x42g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 291, 'Purina Dentalife - Gatos - Embalagem 12x40g',
       'gatos', 'UniPet', 'Purina',
       111.7, '/assets/products/catalog/purina-dentalife-gatos-40g.webp', 'Linha Purina. Dentalife. Gatos.',
       '12x40g', 15, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Dentalife - Gatos - Embalagem 12x40g'
    AND COALESCE(weight, '') = '12x40g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 292, 'Purina Dog Chow - Cães Adultos - Porte Mini e Pequeno - Sachê - Embalagem 15x100g',
       'caes', 'UniPet', 'Purina',
       54.21, '/assets/products/catalog/purina-dogchow-puppy-mini-1kg.webp', 'Linha Purina. Dog Chow. Adultos - Porte Mini e Pequeno. Sachê.',
       '15x100g', 23, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Dog Chow - Cães Adultos - Porte Mini e Pequeno - Sachê - Embalagem 15x100g'
    AND COALESCE(weight, '') = '15x100g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 296, 'Purina Dog Chow - Cães Filhotes - Biscoitos - Sabor Frango, Leite - Embalagem 300g',
       'caes', 'UniPet', 'Purina',
       17.76, '/assets/products/catalog/purina-dogchow-biscoito-filhotes-500g.webp', 'Linha Purina. Dog Chow. Filhotes. Biscoitos. Frango, Leite.',
       '300g', 23, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Dog Chow - Cães Filhotes - Biscoitos - Sabor Frango, Leite - Embalagem 300g'
    AND COALESCE(weight, '') = '300g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 297, 'Purina Dog Chow - Cães Adultos - Porte Médio e Grande - Biscoitos - Sabor Frango - Embalagem 500g',
       'caes', 'UniPet', 'Purina',
       22.31, '/assets/products/catalog/purina-dogchow-biscoito-adult-med-500g.webp', 'Linha Purina. Dog Chow. Adultos - Porte Médio e Grande. Biscoitos. Frango.',
       '500g', 23, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Dog Chow - Cães Adultos - Porte Médio e Grande - Biscoitos - Sabor Frango - Embalagem 500g'
    AND COALESCE(weight, '') = '500g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 298, 'Purina Dog Chow - Cães Filhotes - Sachê - Sabor Frango - Embalagem 15x100g',
       'caes', 'UniPet', 'Purina',
       54.21, '/assets/products/catalog/purina-dogchow-puppy-med-1kg.webp', 'Linha Purina. Dog Chow. Filhotes. Sachê. Frango.',
       '15x100g', 23, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Dog Chow - Cães Filhotes - Sachê - Sabor Frango - Embalagem 15x100g'
    AND COALESCE(weight, '') = '15x100g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 299, 'Purina Dog Chow - Cães - Porte Médio e Grande - Saúde Oral - Embalagem 20x80g',
       'caes', 'UniPet', 'Purina',
       228.8, '/assets/products/catalog/purina-dogchow-oral-med-80g.webp', 'Linha Purina. Dog Chow. - Porte Médio e Grande. Saúde Oral.',
       '20x80g', 23, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Dog Chow - Cães - Porte Médio e Grande - Saúde Oral - Embalagem 20x80g'
    AND COALESCE(weight, '') = '20x80g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 300, 'Purina Dog Chow - Cães - Porte Médio e Grande - Saúde Oral - Embalagem 12x200g',
       'caes', 'UniPet', 'Purina',
       255.68, '/assets/products/catalog/purina-dogchow-oral-med-200g.webp', 'Linha Purina. Dog Chow. - Porte Médio e Grande. Saúde Oral.',
       '12x200g', 23, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Dog Chow - Cães - Porte Médio e Grande - Saúde Oral - Embalagem 12x200g'
    AND COALESCE(weight, '') = '12x200g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 301, 'Purina Dog Chow - Cães - Porte Mini e Pequeno - Saúde Oral - Embalagem 20x105g',
       'caes', 'UniPet', 'Purina',
       314.6, '/assets/products/catalog/purina-dogchow-oral-mini-105g.webp', 'Linha Purina. Dog Chow. - Porte Mini e Pequeno. Saúde Oral.',
       '20x105g', 23, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Dog Chow - Cães - Porte Mini e Pequeno - Saúde Oral - Embalagem 20x105g'
    AND COALESCE(weight, '') = '20x105g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 302, 'Purina Dog Chow - Cães Adultos - Porte Mini e Pequeno - Biscoitos - Sabor Frango - Embalagem 500g',
       'caes', 'UniPet', 'Purina',
       22.31, '/assets/products/catalog/purina-dogchow-biscoito-adult-mini-500g.webp', 'Linha Purina. Dog Chow. Adultos - Porte Mini e Pequeno. Biscoitos. Frango.',
       '500g', 23, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Dog Chow - Cães Adultos - Porte Mini e Pequeno - Biscoitos - Sabor Frango - Embalagem 500g'
    AND COALESCE(weight, '') = '500g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 303, 'Purina Doguitos - Cães - Sabor Carne - Embalagem 20x65g',
       'caes', 'UniPet', 'Purina',
       149.76, '/assets/products/catalog/purina-doguitos-carne-65g.webp', 'Linha Purina. Doguitos. Cães. Carne.',
       '20x65g', 19, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Doguitos - Cães - Sabor Carne - Embalagem 20x65g'
    AND COALESCE(weight, '') = '20x65g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 304, 'Purina Doguitos - Cães - Sabor Frango - Embalagem 20x65g',
       'caes', 'UniPet', 'Purina',
       149.76, '/assets/products/catalog/purina-doguitos-frango-65g.webp', 'Linha Purina. Doguitos. Cães. Frango.',
       '20x65g', 19, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Doguitos - Cães - Sabor Frango - Embalagem 20x65g'
    AND COALESCE(weight, '') = '20x65g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 305, 'Purina Doguitos - Cães - Sabor Linguicinha - Embalagem 20x45g',
       'caes', 'UniPet', 'Purina',
       149.76, '/assets/products/catalog/purina-doguitos-linguica-45g.webp', 'Linha Purina. Doguitos. Cães. Linguicinha.',
       '20x45g', 19, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Doguitos - Cães - Sabor Linguicinha - Embalagem 20x45g'
    AND COALESCE(weight, '') = '20x45g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 306, 'Purina Fancy Feast - Gatos - Casserole - Sabor Salmão, Atum - Embalagem 15x85g',
       'gatos', 'UniPet', 'Purina',
       87.17, '/assets/products/catalog/purina-fancy-casserole-atum-85g.webp', 'Linha Purina. Fancy Feast. Gatos. Casserole. Salmão, Atum.',
       '15x85g', 17, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Fancy Feast - Gatos - Casserole - Sabor Salmão, Atum - Embalagem 15x85g'
    AND COALESCE(weight, '') = '15x85g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 307, 'Purina Fancy Feast - Gatos - Casserole - Sabor Frango, Peru - Embalagem 15x85g',
       'gatos', 'UniPet', 'Purina',
       87.17, '/assets/products/catalog/purina-fancy-casserole-frango-85g.webp', 'Linha Purina. Fancy Feast. Gatos. Casserole. Frango, Peru.',
       '15x85g', 17, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Fancy Feast - Gatos - Casserole - Sabor Frango, Peru - Embalagem 15x85g'
    AND COALESCE(weight, '') = '15x85g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 308, 'Purina Fancy Feast - Gatos - Demi Glacé - Sabor Carne - Embalagem 15x85g',
       'gatos', 'UniPet', 'Purina',
       87.17, '/assets/products/catalog/purina-fancy-demi-carne-85g.webp', 'Linha Purina. Fancy Feast. Gatos. Demi Glacé. Carne.',
       '15x85g', 17, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Fancy Feast - Gatos - Demi Glacé - Sabor Carne - Embalagem 15x85g'
    AND COALESCE(weight, '') = '15x85g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 309, 'Purina Fancy Feast - Gatos - Demi Glacé - Sabor Frango - Embalagem 15x85g',
       'gatos', 'UniPet', 'Purina',
       87.17, '/assets/products/catalog/purina-fancy-demi-frango-85g.webp', 'Linha Purina. Fancy Feast. Gatos. Demi Glacé. Frango.',
       '15x85g', 17, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Fancy Feast - Gatos - Demi Glacé - Sabor Frango - Embalagem 15x85g'
    AND COALESCE(weight, '') = '15x85g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 310, 'Purina Fancy Feast - Gatos - Goulash - Sabor Atum - Embalagem 15x85g',
       'gatos', 'UniPet', 'Purina',
       87.17, '/assets/products/catalog/purina-fancy-goulash-atum-85g.webp', 'Linha Purina. Fancy Feast. Gatos. Goulash. Atum.',
       '15x85g', 17, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Fancy Feast - Gatos - Goulash - Sabor Atum - Embalagem 15x85g'
    AND COALESCE(weight, '') = '15x85g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 311, 'Purina Fancy Feast - Gatos - Goulash - Sabor Peru - Embalagem 15x85g',
       'gatos', 'UniPet', 'Purina',
       87.17, '/assets/products/catalog/purina-fancy-goulash-peru-85g.webp', 'Linha Purina. Fancy Feast. Gatos. Goulash. Peru.',
       '15x85g', 17, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Fancy Feast - Gatos - Goulash - Sabor Peru - Embalagem 15x85g'
    AND COALESCE(weight, '') = '15x85g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 312, 'Purina Fancy Feast - Gatos - Petit Filet - Sabor Carne - Embalagem 15x85g',
       'gatos', 'UniPet', 'Purina',
       87.17, '/assets/products/catalog/purina-fancy-petit-carne-85g.webp', 'Linha Purina. Fancy Feast. Gatos. Petit Filet. Carne.',
       '15x85g', 17, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Fancy Feast - Gatos - Petit Filet - Sabor Carne - Embalagem 15x85g'
    AND COALESCE(weight, '') = '15x85g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 313, 'Purina Fancy Feast - Gatos - Petit Filet - Sabor Salmão - Embalagem 15x85g',
       'gatos', 'UniPet', 'Purina',
       87.17, '/assets/products/catalog/purina-fancy-petit-salmao-85g.webp', 'Linha Purina. Fancy Feast. Gatos. Petit Filet. Salmão.',
       '15x85g', 17, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Fancy Feast - Gatos - Petit Filet - Sabor Salmão - Embalagem 15x85g'
    AND COALESCE(weight, '') = '15x85g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 314, 'Purina Friskies - Gatos - Sachê - Sabor Atum - Embalagem 15x85g',
       'gatos', 'UniPet', 'Purina',
       54.41, '/assets/products/catalog/purina-friskies-sachet-atum-85g.webp', 'Linha Purina. Friskies. Gatos. Sachê. Atum.',
       '15x85g', 27, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Friskies - Gatos - Sachê - Sabor Atum - Embalagem 15x85g'
    AND COALESCE(weight, '') = '15x85g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 315, 'Purina Friskies - Gatos - Sachê - Sabor Carne - Embalagem 15x85g',
       'gatos', 'UniPet', 'Purina',
       54.41, '/assets/products/catalog/purina-friskies-sachet-carne-85g.webp', 'Linha Purina. Friskies. Gatos. Sachê. Carne.',
       '15x85g', 27, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Friskies - Gatos - Sachê - Sabor Carne - Embalagem 15x85g'
    AND COALESCE(weight, '') = '15x85g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 316, 'Purina Friskies - Gatos - Sachê - Sabor Cordeiro - Embalagem 15x85g',
       'gatos', 'UniPet', 'Purina',
       54.41, '/assets/products/catalog/purina-friskies-sachet-cordeiro-85g.webp', 'Linha Purina. Friskies. Gatos. Sachê. Cordeiro.',
       '15x85g', 27, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Friskies - Gatos - Sachê - Sabor Cordeiro - Embalagem 15x85g'
    AND COALESCE(weight, '') = '15x85g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 317, 'Purina Friskies - Gatos - Sabor Frango, Delícias da Granja - Embalagem 3kg',
       'gatos', 'UniPet', 'Purina',
       59.32, '/assets/products/catalog/purina-friskies-granja-1kg.webp', 'Linha Purina. Friskies. Gatos. Frango, Delícias da Granja.',
       '3kg', 27, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Friskies - Gatos - Sabor Frango, Delícias da Granja - Embalagem 3kg'
    AND COALESCE(weight, '') = '3kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 318, 'Purina Friskies - Gatos Filhotes - Sachê - Sabor Carne - Embalagem 15x85g',
       'gatos', 'UniPet', 'Purina',
       54.41, '/assets/products/catalog/purina-friskies-sachet-carne-85g.webp', 'Linha Purina. Friskies. Filhotes. Sachê. Carne.',
       '15x85g', 27, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Friskies - Gatos Filhotes - Sachê - Sabor Carne - Embalagem 15x85g'
    AND COALESCE(weight, '') = '15x85g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 319, 'Purina Friskies - Gatos - Sachê - Sabor Frango - Embalagem 15x85g',
       'gatos', 'UniPet', 'Purina',
       54.41, '/assets/products/catalog/purina-friskies-sachet-frango-85g.webp', 'Linha Purina. Friskies. Gatos. Sachê. Frango.',
       '15x85g', 27, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Friskies - Gatos - Sachê - Sabor Frango - Embalagem 15x85g'
    AND COALESCE(weight, '') = '15x85g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 320, 'Purina Friskies - Gatos - Sabor Mar de Sabores - Embalagem 3kg',
       'gatos', 'UniPet', 'Purina',
       59.32, '/assets/products/catalog/purina-friskies-mar-1kg.webp', 'Linha Purina. Friskies. Gatos. Mar de Sabores.',
       '3kg', 27, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Friskies - Gatos - Sabor Mar de Sabores - Embalagem 3kg'
    AND COALESCE(weight, '') = '3kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 321, 'Purina Friskies - Gatos - Sachê - Sabor Peixe - Embalagem 15x85g',
       'gatos', 'UniPet', 'Purina',
       54.41, '/assets/products/catalog/purina-friskies-sachet-carne-85g.webp', 'Linha Purina. Friskies. Gatos. Sachê. Peixe.',
       '15x85g', 27, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Friskies - Gatos - Sachê - Sabor Peixe - Embalagem 15x85g'
    AND COALESCE(weight, '') = '15x85g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 322, 'Purina Friskies - Gatos - Sachê - Sabor Peru - Embalagem 15x85g',
       'gatos', 'UniPet', 'Purina',
       54.41, '/assets/products/catalog/purina-friskies-sachet-carne-85g.webp', 'Linha Purina. Friskies. Gatos. Sachê. Peru.',
       '15x85g', 27, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Friskies - Gatos - Sachê - Sabor Peru - Embalagem 15x85g'
    AND COALESCE(weight, '') = '15x85g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 323, 'Purina Friskies - Gatos - Petiscos - Sabor Salmão - Embalagem 15x80g',
       'gatos', 'UniPet', 'Purina',
       178.43, '/assets/products/catalog/purina-friskies-petisco-salmao-80g.webp', 'Linha Purina. Friskies. Gatos. Petiscos. Salmão.',
       '15x80g', 27, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Friskies - Gatos - Petiscos - Sabor Salmão - Embalagem 15x80g'
    AND COALESCE(weight, '') = '15x80g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 324, 'Purina Friskies - Gatos - Sachê - Sabor Salmão - Embalagem 15x85g',
       'gatos', 'UniPet', 'Purina',
       54.41, '/assets/products/catalog/purina-friskies-sachet-carne-85g.webp', 'Linha Purina. Friskies. Gatos. Sachê. Salmão.',
       '15x85g', 27, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Friskies - Gatos - Sachê - Sabor Salmão - Embalagem 15x85g'
    AND COALESCE(weight, '') = '15x85g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 325, 'Purina Gatsy - Cães - Sabor Carne - Embalagem 20kg',
       'caes', 'UniPet', 'Purina',
       292.37, '/assets/products/catalog/purina-gatsy-carne-20kg.webp', 'Linha Purina. Gatsy. Cães. Carne.',
       '20kg', 31, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Gatsy - Cães - Sabor Carne - Embalagem 20kg'
    AND COALESCE(weight, '') = '20kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 326, 'Purina One - Cães - Sachê - Sabor Multiproteínas - Embalagem 15x85g',
       'caes', 'UniPet', 'Purina',
       78.59, '/assets/products/catalog/purina-purinaone-sachet-dog-85g.webp', 'Linha Purina. One. Cães. Sachê. Multiproteínas.',
       '15x85g', 11, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina One - Cães - Sachê - Sabor Multiproteínas - Embalagem 15x85g'
    AND COALESCE(weight, '') = '15x85g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 327, 'Purina One - Cães - Sachê - Sabor Super Foods - Embalagem 15x85g',
       'caes', 'UniPet', 'Purina',
       78.59, '/assets/products/catalog/purina-purinaone-sachet-dog-85g.webp', 'Linha Purina. One. Cães. Sachê. Super Foods.',
       '15x85g', 11, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina One - Cães - Sachê - Sabor Super Foods - Embalagem 15x85g'
    AND COALESCE(weight, '') = '15x85g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 328, 'Purina One - Gatos - Sachê - Sabor Multiproteínas - Embalagem 15x85g',
       'gatos', 'UniPet', 'Purina',
       92.04, '/assets/products/catalog/purina-purinaone-sachet-cat-85g.webp', 'Linha Purina. One. Gatos. Sachê. Multiproteínas.',
       '15x85g', 11, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina One - Gatos - Sachê - Sabor Multiproteínas - Embalagem 15x85g'
    AND COALESCE(weight, '') = '15x85g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 329, 'Purina One - Cães - Sachê - Sabor Super Nutrientes - Embalagem 15x85g',
       'caes', 'UniPet', 'Purina',
       78.59, '/assets/products/catalog/purina-purinaone-sachet-dog-85g.webp', 'Linha Purina. One. Cães. Sachê. Super Nutrientes.',
       '15x85g', 11, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina One - Cães - Sachê - Sabor Super Nutrientes - Embalagem 15x85g'
    AND COALESCE(weight, '') = '15x85g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 330, 'Purina One - Gatos - Sachê - Sabor Super Foods - Embalagem 15x85g',
       'gatos', 'UniPet', 'Purina',
       92.04, '/assets/products/catalog/purina-purinaone-sachet-cat-85g.webp', 'Linha Purina. One. Gatos. Sachê. Super Foods.',
       '15x85g', 11, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina One - Gatos - Sachê - Sabor Super Foods - Embalagem 15x85g'
    AND COALESCE(weight, '') = '15x85g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 331, 'Purina One - Gatos - Sachê - Sabor Super Nutrientes - Embalagem 15x85g',
       'gatos', 'UniPet', 'Purina',
       92.04, '/assets/products/catalog/purina-purinaone-sachet-cat-85g.webp', 'Linha Purina. One. Gatos. Sachê. Super Nutrientes.',
       '15x85g', 11, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina One - Gatos - Sachê - Sabor Super Nutrientes - Embalagem 15x85g'
    AND COALESCE(weight, '') = '15x85g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 332, 'Purina Pro Plan - Cães - Neurológico - Embalagem 2kg',
       'caes', 'UniPet', 'Purina',
       169.77, '/assets/products/catalog/purina-ppvd-nc-dog-2kg.webp', 'Linha Purina. Pro Plan. Cães. Neurológico.',
       '2kg', 5, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Pro Plan - Cães - Neurológico - Embalagem 2kg'
    AND COALESCE(weight, '') = '2kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 333, 'Purina Pro Plan - Cães - Neurológico - Embalagem 7.5kg',
       'caes', 'UniPet', 'Purina',
       527.35, '/assets/products/catalog/purina-ppvd-nc-dog-2kg.webp', 'Linha Purina. Pro Plan. Cães. Neurológico.',
       '7.5kg', 5, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Pro Plan - Cães - Neurológico - Embalagem 7.5kg'
    AND COALESCE(weight, '') = '7.5kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 334, 'Purina Pro Plan - Cães - Caloria Reduzida - Embalagem 2kg',
       'caes', 'UniPet', 'Purina',
       130.68, '/assets/products/catalog/purina-ppvd-om-dog-2kg.webp', 'Linha Purina. Pro Plan. Cães. Caloria Reduzida.',
       '2kg', 5, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Pro Plan - Cães - Caloria Reduzida - Embalagem 2kg'
    AND COALESCE(weight, '') = '2kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 335, 'Purina Pro Plan - Cães - Caloria Reduzida - Embalagem 7.5kg',
       'caes', 'UniPet', 'Purina',
       451.61, '/assets/products/catalog/purina-proplan-reduced-mini-7-5kg.webp', 'Linha Purina. Pro Plan. Cães. Caloria Reduzida.',
       '7.5kg', 5, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Pro Plan - Cães - Caloria Reduzida - Embalagem 7.5kg'
    AND COALESCE(weight, '') = '7.5kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 336, 'Purina Pro Plan - Cães - Trato Urinário - Embalagem 2kg',
       'caes', 'UniPet', 'Purina',
       130.68, '/assets/products/catalog/purina-ppvd-ur-dog-2kg.webp', 'Linha Purina. Pro Plan. Cães. Trato Urinário.',
       '2kg', 5, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Pro Plan - Cães - Trato Urinário - Embalagem 2kg'
    AND COALESCE(weight, '') = '2kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 337, 'Purina Pro Plan - Cães - Trato Urinário - Embalagem 7.5kg',
       'caes', 'UniPet', 'Purina',
       451.61, '/assets/products/catalog/purina-ppvd-ur-dog-2kg.webp', 'Linha Purina. Pro Plan. Cães. Trato Urinário.',
       '7.5kg', 5, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Pro Plan - Cães - Trato Urinário - Embalagem 7.5kg'
    AND COALESCE(weight, '') = '7.5kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 338, 'Purina Pro Plan - Gatos - Trato Urinário - Embalagem 1.5kg',
       'gatos', 'UniPet', 'Purina',
       151.72, '/assets/products/catalog/purina-proplan-cat-urinary-1kg.webp', 'Linha Purina. Pro Plan. Gatos. Trato Urinário.',
       '1.5kg', 5, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Pro Plan - Gatos - Trato Urinário - Embalagem 1.5kg'
    AND COALESCE(weight, '') = '1.5kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 339, 'Purina Pro Plan - Gatos - Trato Urinário - Embalagem 7.5kg',
       'gatos', 'UniPet', 'Purina',
       422.54, '/assets/products/catalog/purina-proplan-cat-urinary-1kg.webp', 'Linha Purina. Pro Plan. Gatos. Trato Urinário.',
       '7.5kg', 5, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Pro Plan - Gatos - Trato Urinário - Embalagem 7.5kg'
    AND COALESCE(weight, '') = '7.5kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 340, 'Purina Pro Plan - Gatos - Caloria Reduzida - Embalagem 1.5kg',
       'gatos', 'UniPet', 'Purina',
       151.72, '/assets/products/catalog/purina-proplan-cat-urinary-1kg.webp', 'Linha Purina. Pro Plan. Gatos. Caloria Reduzida.',
       '1.5kg', 5, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Pro Plan - Gatos - Caloria Reduzida - Embalagem 1.5kg'
    AND COALESCE(weight, '') = '1.5kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 341, 'Purina Pro Plan - Cães Adultos 7+ - Mente Ativa - Embalagem 7.5kg',
       'caes', 'UniPet', 'Purina',
       318.36, '/assets/products/catalog/purina-proplan-adult-mini-7-5kg.webp', 'Linha Purina. Pro Plan. Adultos 7+. Mente Ativa.',
       '7.5kg', 5, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Pro Plan - Cães Adultos 7+ - Mente Ativa - Embalagem 7.5kg'
    AND COALESCE(weight, '') = '7.5kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 342, 'Purina Pro Plan - Gatos Adultos 7+ - Embalagem 7.5kg',
       'gatos', 'UniPet', 'Purina',
       304.29, '/assets/products/catalog/purina-proplan-cat-7plus-1kg.webp', 'Linha Purina. Pro Plan. Adultos 7+.',
       '7.5kg', 5, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Pro Plan - Gatos Adultos 7+ - Embalagem 7.5kg'
    AND COALESCE(weight, '') = '7.5kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 343, 'Purina Pro Plan - Cães Adultos - Sachê - Sabor Carne - Embalagem 15x100g',
       'caes', 'UniPet', 'Purina',
       101.2, '/assets/products/catalog/purina-proplan-sachet-dog-carne-100g.webp', 'Linha Purina. Pro Plan. Adultos. Sachê. Carne.',
       '15x100g', 5, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Pro Plan - Cães Adultos - Sachê - Sabor Carne - Embalagem 15x100g'
    AND COALESCE(weight, '') = '15x100g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 344, 'Purina Pro Plan - Cães Filhotes - Porte Mini e Pequeno - Embalagem 7.5kg',
       'caes', 'UniPet', 'Purina',
       289.74, '/assets/products/catalog/purina-proplan-adult-mini-7-5kg.webp', 'Linha Purina. Pro Plan. Filhotes - Porte Mini e Pequeno.',
       '7.5kg', 5, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Pro Plan - Cães Filhotes - Porte Mini e Pequeno - Embalagem 7.5kg'
    AND COALESCE(weight, '') = '7.5kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 345, 'Purina Pro Plan - Gatos Castrados - Embalagem 3kg',
       'gatos', 'UniPet', 'Purina',
       161.36, '/assets/products/catalog/purina-proplan-cat-urinary-1kg.webp', 'Linha Purina. Pro Plan. Castrados.',
       '3kg', 5, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Pro Plan - Gatos Castrados - Embalagem 3kg'
    AND COALESCE(weight, '') = '3kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 346, 'Purina Pro Plan - Gatos Castrados - Embalagem 7.5kg',
       'gatos', 'UniPet', 'Purina',
       304.29, '/assets/products/catalog/purina-proplan-cat-urinary-1kg.webp', 'Linha Purina. Pro Plan. Castrados.',
       '7.5kg', 5, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Pro Plan - Gatos Castrados - Embalagem 7.5kg'
    AND COALESCE(weight, '') = '7.5kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 347, 'Purina Pro Plan - Cães - Hipoalergênico - Embalagem 2kg',
       'caes', 'UniPet', 'Purina',
       141.73, '/assets/products/catalog/purina-ppvd-ha-dog-2kg.webp', 'Linha Purina. Pro Plan. Cães. Hipoalergênico.',
       '2kg', 5, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Pro Plan - Cães - Hipoalergênico - Embalagem 2kg'
    AND COALESCE(weight, '') = '2kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 348, 'Purina Pro Plan - Cães - Hipoalergênico - Embalagem 7.5kg',
       'caes', 'UniPet', 'Purina',
       397.31, '/assets/products/catalog/purina-ppvd-ha-dog-2kg.webp', 'Linha Purina. Pro Plan. Cães. Hipoalergênico.',
       '7.5kg', 5, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Pro Plan - Cães - Hipoalergênico - Embalagem 7.5kg'
    AND COALESCE(weight, '') = '7.5kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 349, 'Purina Pro Plan - Cães - Porte Mini e Pequeno - Caloria Reduzida - Embalagem 7.5kg',
       'caes', 'UniPet', 'Purina',
       289.74, '/assets/products/catalog/purina-proplan-reduced-mini-7-5kg.webp', 'Linha Purina. Pro Plan. - Porte Mini e Pequeno. Caloria Reduzida.',
       '7.5kg', 5, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Pro Plan - Cães - Porte Mini e Pequeno - Caloria Reduzida - Embalagem 7.5kg'
    AND COALESCE(weight, '') = '7.5kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 350, 'Purina Pro Plan - Gatos - Hipoalergênico - Embalagem 1.5kg',
       'gatos', 'UniPet', 'Purina',
       165.3, '/assets/products/catalog/purina-proplan-cat-urinary-1kg.webp', 'Linha Purina. Pro Plan. Gatos. Hipoalergênico.',
       '1.5kg', 5, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Pro Plan - Gatos - Hipoalergênico - Embalagem 1.5kg'
    AND COALESCE(weight, '') = '1.5kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 351, 'Purina Dog Chow - Cães Adultos - Porte Mini e Pequeno - Embalagem 2.5kg',
       'caes', 'UniPet', 'Purina',
       49.73, '/assets/products/catalog/purina-dogchow-puppy-mini-1kg.webp', 'Linha Purina. Dog Chow. Adultos - Porte Mini e Pequeno.',
       '2.5kg', 23, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Dog Chow - Cães Adultos - Porte Mini e Pequeno - Embalagem 2.5kg'
    AND COALESCE(weight, '') = '2.5kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 352, 'Purina Dog Chow - Cães Filhotes - Porte Mini e Pequeno - Embalagem 2.5kg',
       'caes', 'UniPet', 'Purina',
       52.17, '/assets/products/catalog/purina-dogchow-puppy-mini-1kg.webp', 'Linha Purina. Dog Chow. Filhotes - Porte Mini e Pequeno.',
       '2.5kg', 23, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Dog Chow - Cães Filhotes - Porte Mini e Pequeno - Embalagem 2.5kg'
    AND COALESCE(weight, '') = '2.5kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 353, 'Purina Dog Chow - Cães Filhotes - Porte Mini e Pequeno - Embalagem 900g',
       'caes', 'UniPet', 'Purina',
       20.05, '/assets/products/catalog/purina-dogchow-puppy-mini-1kg.webp', 'Linha Purina. Dog Chow. Filhotes - Porte Mini e Pequeno.',
       '900g', 23, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Dog Chow - Cães Filhotes - Porte Mini e Pequeno - Embalagem 900g'
    AND COALESCE(weight, '') = '900g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 354, 'Purina Pro Plan - Cães - Porte Mini e Pequeno - LiveClear Redução de Alérgenos - Embalagem 7.5kg',
       'caes', 'UniPet', 'Purina',
       306.61, '/assets/products/catalog/purina-proplan-adult-mini-7-5kg.webp', 'Linha Purina. Pro Plan. - Porte Mini e Pequeno. LiveClear Redução de Alérgenos.',
       '7.5kg', 5, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Pro Plan - Cães - Porte Mini e Pequeno - LiveClear Redução de Alérgenos - Embalagem 7.5kg'
    AND COALESCE(weight, '') = '7.5kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 355, 'Purina Pro Plan - Cães - Porte Médio e Grande - Caloria Reduzida - Embalagem 10.1kg',
       'caes', 'UniPet', 'Purina',
       275.26, '/assets/products/catalog/purina-proplan-adult-grande-15kg.webp', 'Linha Purina. Pro Plan. - Porte Médio e Grande. Caloria Reduzida.',
       '10.1kg', 5, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Pro Plan - Cães - Porte Médio e Grande - Caloria Reduzida - Embalagem 10.1kg'
    AND COALESCE(weight, '') = '10.1kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 356, 'Purina Pro Plan - Cães - Porte Médio e Grande - LiveClear Redução de Alérgenos - Embalagem 10.1kg',
       'caes', 'UniPet', 'Purina',
       275.26, '/assets/products/catalog/purina-proplan-adult-grande-15kg.webp', 'Linha Purina. Pro Plan. - Porte Médio e Grande. LiveClear Redução de Alérgenos.',
       '10.1kg', 5, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Pro Plan - Cães - Porte Médio e Grande - LiveClear Redução de Alérgenos - Embalagem 10.1kg'
    AND COALESCE(weight, '') = '10.1kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 357, 'Purina Pro Plan - Cães Adultos 7+ - Porte Mini e Pequeno - Longevidade - Embalagem 7.5kg',
       'caes', 'UniPet', 'Purina',
       292.66, '/assets/products/catalog/purina-proplan-adult-mini-7-5kg.webp', 'Linha Purina. Pro Plan. Adultos 7+ - Porte Mini e Pequeno. Longevidade.',
       '7.5kg', 5, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Pro Plan - Cães Adultos 7+ - Porte Mini e Pequeno - Longevidade - Embalagem 7.5kg'
    AND COALESCE(weight, '') = '7.5kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 358, 'Purina Pro Plan - Cães - Paladar Exigente - Embalagem 7.5kg',
       'caes', 'UniPet', 'Purina',
       306.61, '/assets/products/catalog/purina-proplan-adult-mini-7-5kg.webp', 'Linha Purina. Pro Plan. Cães. Paladar Exigente.',
       '7.5kg', 5, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Pro Plan - Cães - Paladar Exigente - Embalagem 7.5kg'
    AND COALESCE(weight, '') = '7.5kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 359, 'Purina Pro Plan - Cães - Alta Vitalidade - Embalagem 12kg',
       'caes', 'UniPet', 'Purina',
       297.3, '/assets/products/catalog/purina-proplan-adult-grande-15kg.webp', 'Linha Purina. Pro Plan. Cães. Alta Vitalidade.',
       '12kg', 5, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Pro Plan - Cães - Alta Vitalidade - Embalagem 12kg'
    AND COALESCE(weight, '') = '12kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 360, 'Purina Pro Plan - Cães Adultos - Porte Grande - Embalagem 12kg',
       'caes', 'UniPet', 'Purina',
       297.3, '/assets/products/catalog/purina-proplan-adult-grande-15kg.webp', 'Linha Purina. Pro Plan. Adultos - Porte Grande.',
       '12kg', 5, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Pro Plan - Cães Adultos - Porte Grande - Embalagem 12kg'
    AND COALESCE(weight, '') = '12kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 361, 'Purina Pro Plan - Cães Adultos - Embalagem 12kg',
       'caes', 'UniPet', 'Purina',
       297.3, '/assets/products/catalog/purina-proplan-adult-grande-15kg.webp', 'Linha Purina. Pro Plan. Adultos.',
       '12kg', 5, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Pro Plan - Cães Adultos - Embalagem 12kg'
    AND COALESCE(weight, '') = '12kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 362, 'Purina Pro Plan - Cães Adultos 7+ - Longevidade - Embalagem 12kg',
       'caes', 'UniPet', 'Purina',
       312.17, '/assets/products/catalog/purina-proplan-adult-grande-15kg.webp', 'Linha Purina. Pro Plan. Adultos 7+. Longevidade.',
       '12kg', 5, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Pro Plan - Cães Adultos 7+ - Longevidade - Embalagem 12kg'
    AND COALESCE(weight, '') = '12kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 363, 'Purina Pro Plan - Gatos Adultos 7+ - Embalagem 3kg',
       'gatos', 'UniPet', 'Purina',
       190.81, '/assets/products/catalog/purina-proplan-cat-7plus-1kg.webp', 'Linha Purina. Pro Plan. Adultos 7+.',
       '3kg', 5, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Pro Plan - Gatos Adultos 7+ - Embalagem 3kg'
    AND COALESCE(weight, '') = '3kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 364, 'Purina Pro Plan - Gatos - Trato Urinário - Embalagem 3kg',
       'gatos', 'UniPet', 'Purina',
       199.89, '/assets/products/catalog/purina-proplan-cat-urinary-1kg.webp', 'Linha Purina. Pro Plan. Gatos. Trato Urinário.',
       '3kg', 5, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Pro Plan - Gatos - Trato Urinário - Embalagem 3kg'
    AND COALESCE(weight, '') = '3kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 365, 'Purina Friskies - Gatos - Sachê - Sabor Carne, Mix de Carnes - Embalagem 15x80g',
       'gatos', 'UniPet', 'Purina',
       54.41, '/assets/products/catalog/purina-friskies-sachet-carne-85g.webp', 'Linha Purina. Friskies. Gatos. Sachê. Carne, Mix de Carnes.',
       '15x80g', 27, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Friskies - Gatos - Sachê - Sabor Carne, Mix de Carnes - Embalagem 15x80g'
    AND COALESCE(weight, '') = '15x80g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 366, 'Purina Friskies - Gatos - Sachê - Sabor Mar de Sabores - Embalagem 15x80g',
       'gatos', 'UniPet', 'Purina',
       54.41, '/assets/products/catalog/purina-friskies-sachet-carne-85g.webp', 'Linha Purina. Friskies. Gatos. Sachê. Mar de Sabores.',
       '15x80g', 27, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Friskies - Gatos - Sachê - Sabor Mar de Sabores - Embalagem 15x80g'
    AND COALESCE(weight, '') = '15x80g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 367, 'Purina Friskies - Gatos - Sachê - Sabor Mix de Carnes, Megamix - Embalagem 15x80g',
       'gatos', 'UniPet', 'Purina',
       54.41, '/assets/products/catalog/purina-friskies-sachet-carne-85g.webp', 'Linha Purina. Friskies. Gatos. Sachê. Mix de Carnes, Megamix.',
       '15x80g', 27, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Friskies - Gatos - Sachê - Sabor Mix de Carnes, Megamix - Embalagem 15x80g'
    AND COALESCE(weight, '') = '15x80g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 368, 'Purina Dog Chow - Cães Filhotes - Porte Médio e Grande - Embalagem 2.5kg',
       'caes', 'UniPet', 'Purina',
       52.17, '/assets/products/catalog/purina-dogchow-puppy-med-1kg.webp', 'Linha Purina. Dog Chow. Filhotes - Porte Médio e Grande.',
       '2.5kg', 23, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Dog Chow - Cães Filhotes - Porte Médio e Grande - Embalagem 2.5kg'
    AND COALESCE(weight, '') = '2.5kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 369, 'Purina Dog Chow - Cães Filhotes - Porte Médio e Grande - Embalagem 900g',
       'caes', 'UniPet', 'Purina',
       20.05, '/assets/products/catalog/purina-dogchow-puppy-med-1kg.webp', 'Linha Purina. Dog Chow. Filhotes - Porte Médio e Grande.',
       '900g', 23, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Dog Chow - Cães Filhotes - Porte Médio e Grande - Embalagem 900g'
    AND COALESCE(weight, '') = '900g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 370, 'Purina Friskies - Gatos Castrados - Sabor Mix de Carnes, Megamix - Embalagem 2.5kg',
       'gatos', 'UniPet', 'Purina',
       49.44, '/assets/products/catalog/purina-friskies-mega-cast-1kg.webp', 'Linha Purina. Friskies. Castrados. Mix de Carnes, Megamix.',
       '2.5kg', 27, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Friskies - Gatos Castrados - Sabor Mix de Carnes, Megamix - Embalagem 2.5kg'
    AND COALESCE(weight, '') = '2.5kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 371, 'Purina Friskies - Gatos - Sabor Mar de Sabores - Embalagem 850g',
       'gatos', 'UniPet', 'Purina',
       21.14, '/assets/products/catalog/purina-friskies-mar-1kg.webp', 'Linha Purina. Friskies. Gatos. Mar de Sabores.',
       '850g', 27, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Friskies - Gatos - Sabor Mar de Sabores - Embalagem 850g'
    AND COALESCE(weight, '') = '850g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 372, 'Purina Friskies - Gatos - Sabor Frango, Delícias da Granja - Embalagem 850g',
       'gatos', 'UniPet', 'Purina',
       21.14, '/assets/products/catalog/purina-friskies-granja-1kg.webp', 'Linha Purina. Friskies. Gatos. Frango, Delícias da Granja.',
       '850g', 27, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Friskies - Gatos - Sabor Frango, Delícias da Granja - Embalagem 850g'
    AND COALESCE(weight, '') = '850g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 373, 'Purina Friskies - Gatos Castrados - Sabor Mix de Carnes, Megamix - Embalagem 850g',
       'gatos', 'UniPet', 'Purina',
       21.14, '/assets/products/catalog/purina-friskies-mega-cast-1kg.webp', 'Linha Purina. Friskies. Castrados. Mix de Carnes, Megamix.',
       '850g', 27, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Friskies - Gatos Castrados - Sabor Mix de Carnes, Megamix - Embalagem 850g'
    AND COALESCE(weight, '') = '850g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 374, 'Purina Fancy Feast - Gatos - Supremo - Sabor Bacalhau - Embalagem 15x75g',
       'gatos', 'UniPet', 'Purina',
       87.17, '/assets/products/catalog/purina-fancy-supremo-bacalhau-75g.webp', 'Linha Purina. Fancy Feast. Gatos. Supremo. Bacalhau.',
       '15x75g', 17, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Fancy Feast - Gatos - Supremo - Sabor Bacalhau - Embalagem 15x75g'
    AND COALESCE(weight, '') = '15x75g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 375, 'Purina Fancy Feast - Gatos - Supremo - Sabor Carne - Embalagem 15x75g',
       'gatos', 'UniPet', 'Purina',
       87.17, '/assets/products/catalog/purina-fancy-supremo-carne-75g.webp', 'Linha Purina. Fancy Feast. Gatos. Supremo. Carne.',
       '15x75g', 17, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Fancy Feast - Gatos - Supremo - Sabor Carne - Embalagem 15x75g'
    AND COALESCE(weight, '') = '15x75g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 376, 'Purina Friskies - Gatos - Sabor Mar de Sabores - Embalagem 2.5kg',
       'gatos', 'UniPet', 'Purina',
       741.59, '/assets/products/catalog/purina-friskies-mar-1kg.webp', 'Linha Purina. Friskies. Gatos. Mar de Sabores.',
       '2.5kg', 27, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Friskies - Gatos - Sabor Mar de Sabores - Embalagem 2.5kg'
    AND COALESCE(weight, '') = '2.5kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 377, 'Purina Pro Plan - Cães Filhotes - Porte Grande - Desempenho Excepcional - Embalagem 12kg',
       'caes', 'UniPet', 'Purina',
       312.17, '/assets/products/catalog/purina-proplan-puppy-grande-15kg.webp', 'Linha Purina. Pro Plan. Filhotes - Porte Grande. Desempenho Excepcional.',
       '12kg', 5, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Pro Plan - Cães Filhotes - Porte Grande - Desempenho Excepcional - Embalagem 12kg'
    AND COALESCE(weight, '') = '12kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 378, 'Purina Pro Plan - Cães Filhotes - Desempenho Excepcional - Embalagem 12kg',
       'caes', 'UniPet', 'Purina',
       312.17, '/assets/products/catalog/purina-proplan-puppy-grande-15kg.webp', 'Linha Purina. Pro Plan. Filhotes. Desempenho Excepcional.',
       '12kg', 5, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Pro Plan - Cães Filhotes - Desempenho Excepcional - Embalagem 12kg'
    AND COALESCE(weight, '') = '12kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 379, 'Purina Friskies - Gatos - Sabor Frango, Delícias da Granja - Embalagem 2.5kg',
       'gatos', 'UniPet', 'Purina',
       59.32, '/assets/products/catalog/purina-friskies-granja-1kg.webp', 'Linha Purina. Friskies. Gatos. Frango, Delícias da Granja.',
       '2.5kg', 27, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Friskies - Gatos - Sabor Frango, Delícias da Granja - Embalagem 2.5kg'
    AND COALESCE(weight, '') = '2.5kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 380, 'Purina Fancy Feast - Gatos - Supremo - Sabor Peixe - Embalagem 15x75g',
       'gatos', 'UniPet', 'Purina',
       87.17, '/assets/products/catalog/purina-fancy-supremo-peixe-75g.webp', 'Linha Purina. Fancy Feast. Gatos. Supremo. Peixe.',
       '15x75g', 17, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Fancy Feast - Gatos - Supremo - Sabor Peixe - Embalagem 15x75g'
    AND COALESCE(weight, '') = '15x75g'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 381, 'Purina Pro Plan - Gatos Castrados - Sterilised - Embalagem 7.5kg',
       'gatos', 'UniPet', 'Purina',
       319.55, '/assets/products/catalog/purina-proplan-cat-urinary-1kg.webp', 'Linha Purina. Pro Plan. Castrados.',
       '7.5kg', 7, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Pro Plan - Gatos Castrados - Sterilised - Embalagem 7.5kg'
    AND COALESCE(weight, '') = '7.5kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 382, 'Purina Pro Plan - Cães Adultos 7+ - Embalagem 7.5kg',
       'caes', 'UniPet', 'Purina',
       335.54, '/assets/products/catalog/purina-proplan-adult-mini-7-5kg.webp', 'Linha Purina. Pro Plan. Adultos 7+.',
       '7.5kg', 7, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Pro Plan - Cães Adultos 7+ - Embalagem 7.5kg'
    AND COALESCE(weight, '') = '7.5kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 383, 'Purina Pro Plan - Gatos Filhotes - Desempenho Excepcional - Embalagem 7.5kg',
       'gatos', 'UniPet', 'Purina',
       335.54, '/assets/products/catalog/purina-proplan-cat-kitten-1kg.webp', 'Linha Purina. Pro Plan. Filhotes. Desempenho Excepcional.',
       '7.5kg', 7, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Pro Plan - Gatos Filhotes - Desempenho Excepcional - Embalagem 7.5kg'
    AND COALESCE(weight, '') = '7.5kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 384, 'Purina Dog Chow - Cães Adultos - Porte Mini e Pequeno - Embalagem 900g',
       'caes', 'UniPet', 'Purina',
       21.35, '/assets/products/catalog/purina-dogchow-puppy-mini-1kg.webp', 'Linha Purina. Dog Chow. Adultos - Porte Mini e Pequeno.',
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
       21.35, '/assets/products/catalog/purina-dogchow-puppy-med-1kg.webp', 'Linha Purina. Dog Chow. Adultos - Porte Médio e Grande.',
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
       20.15, '/assets/products/catalog/purina-dogchow-puppy-mini-1kg.webp', 'Linha Purina. Dog Chow. Adultos 7+.',
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
       350.29, '/assets/products/catalog/purina-proplan-cat-urinary-1kg.webp', 'Linha Purina. Pro Plan. Gatos. LiveClear Redução de Alérgenos.',
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
       190.81, '/assets/products/catalog/purina-proplan-cat-kitten-1kg.webp', 'Linha Purina. Pro Plan. Filhotes.',
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
       199.89, '/assets/products/catalog/purina-proplan-cat-urinary-1kg.webp', 'Linha Purina. Pro Plan. Gatos. LiveClear Redução de Alérgenos.',
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
       54.21, '/assets/products/catalog/purina-dogchow-adult-med-grande-10-1kg.webp', 'Linha Purina. Dog Chow. Adultos.',
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
       54.21, '/assets/products/catalog/purina-dogchow-puppy-med-1kg.webp', 'Linha Purina. Dog Chow. Filhotes. Frango, Leite.',
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
SELECT 'a0000000-0000-4000-8000-000000000001', 395, 'Purina Dog Chow - Cães Adultos - Sabor Cordeiro, Arroz - Embalagem 15x85g',
       'caes', 'UniPet', 'Purina',
       54.21, '/assets/products/catalog/purina-dogchow-adult-med-grande-10-1kg.webp', 'Linha Purina. Dog Chow. Adultos. Cordeiro, Arroz.',
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
       54.21, '/assets/products/catalog/purina-dogchow-puppy-med-1kg.webp', 'Linha Purina. Dog Chow. Filhotes. Carne, Leite.',
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
       54.21, '/assets/products/catalog/purina-dogchow-adult-med-grande-10-1kg.webp', 'Linha Purina. Dog Chow. Adultos. Frango, Arroz.',
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
       54.21, '/assets/products/catalog/purina-dogchow-adult-med-grande-10-1kg.webp', 'Linha Purina. Dog Chow. Adultos. Carne, Arroz.',
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
       278.72, '/assets/products/catalog/purina-proplan-adult-mini-7-5kg.webp', 'Linha Purina. Pro Plan. Adultos - Porte Mini e Pequeno.',
       '7.5kg', 5, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Pro Plan - Cães Adultos - Porte Mini e Pequeno - Embalagem 7.5kg'
    AND COALESCE(weight, '') = '7.5kg'
    AND COALESCE(line, '') = 'Purina'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image,
  description, weight, catalog_page, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 400, 'Purina Dog Chow - Cães Adultos - Porte Mini e Pequeno - Sachê - Sabor Frango - Embalagem 15x100g',
       'caes', 'UniPet', 'Purina',
       54.21, '/assets/products/catalog/purina-dogchow-puppy-mini-1kg.webp', 'Linha Purina. Dog Chow. Adultos - Porte Mini e Pequeno. Sachê. Frango.',
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
       54.21, '/assets/products/catalog/purina-dogchow-adult-med-grande-10-1kg.webp', 'Linha Purina. Dog Chow. Adultos. Sachê. Carne.',
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
       54.21, '/assets/products/catalog/purina-dogchow-adult-med-grande-10-1kg.webp', 'Linha Purina. Dog Chow. Adultos. Sachê. Cordeiro.',
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
       54.21, '/assets/products/catalog/purina-dogchow-adult-med-grande-10-1kg.webp', 'Linha Purina. Dog Chow. Adultos. Sachê. Frango.',
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
       54.21, '/assets/products/catalog/purina-dogchow-adult-med-grande-10-1kg.webp', 'Linha Purina. Dog Chow. Adultos. Triploproteína.',
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
       54.21, '/assets/products/catalog/purina-dogchow-adult-med-grande-10-1kg.webp', 'Linha Purina. Dog Chow. Adultos. Triploproteína Salmão.',
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
       54.21, '/assets/products/catalog/purina-dogchow-adult-med-grande-10-1kg.webp', 'Linha Purina. Dog Chow. Adultos. Multiproteína.',
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
       54.21, '/assets/products/catalog/purina-dogchow-adult-med-grande-10-1kg.webp', 'Linha Purina. Dog Chow. Adultos. Alta Proteína.',
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
       319.55, '/assets/products/catalog/purina-proplan-cat-urinary-1kg.webp', 'Linha Purina. Pro Plan. Castrados. Sterilised.',
       '7.5kg', 7, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Purina Pro Plan - Gatos Castrados - Sterilised - Embalagem 7.5kg'
    AND COALESCE(weight, '') = '7.5kg'
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
    WHEN 279 THEN 107.25
    WHEN 280 THEN 63.26
    WHEN 281 THEN 62.01
    WHEN 282 THEN 198.90
    WHEN 283 THEN 103.55
    WHEN 284 THEN 203.94
    WHEN 285 THEN 64.74
    WHEN 286 THEN 31.14
    WHEN 287 THEN 64.74
    WHEN 288 THEN 184.28
    WHEN 289 THEN 140.05
    WHEN 290 THEN 110.11
    WHEN 291 THEN 111.70
    WHEN 292 THEN 54.21
    WHEN 296 THEN 17.76
    WHEN 297 THEN 22.31
    WHEN 298 THEN 54.21
    WHEN 299 THEN 228.80
    WHEN 300 THEN 255.68
    WHEN 301 THEN 314.60
    WHEN 302 THEN 22.31
    WHEN 303 THEN 149.76
    WHEN 304 THEN 149.76
    WHEN 305 THEN 149.76
    WHEN 306 THEN 87.17
    WHEN 307 THEN 87.17
    WHEN 308 THEN 87.17
    WHEN 309 THEN 87.17
    WHEN 310 THEN 87.17
    WHEN 311 THEN 87.17
    WHEN 312 THEN 87.17
    WHEN 313 THEN 87.17
    WHEN 314 THEN 54.41
    WHEN 315 THEN 54.41
    WHEN 316 THEN 54.41
    WHEN 317 THEN 59.32
    WHEN 318 THEN 54.41
    WHEN 319 THEN 54.41
    WHEN 320 THEN 59.32
    WHEN 321 THEN 54.41
    WHEN 322 THEN 54.41
    WHEN 323 THEN 178.43
    WHEN 324 THEN 54.41
    WHEN 325 THEN 292.37
    WHEN 326 THEN 78.59
    WHEN 327 THEN 78.59
    WHEN 328 THEN 92.04
    WHEN 329 THEN 78.59
    WHEN 330 THEN 92.04
    WHEN 331 THEN 92.04
    WHEN 332 THEN 169.77
    WHEN 333 THEN 527.35
    WHEN 334 THEN 130.68
    WHEN 335 THEN 451.61
    WHEN 336 THEN 130.68
    WHEN 337 THEN 451.61
    WHEN 338 THEN 151.72
    WHEN 339 THEN 422.54
    WHEN 340 THEN 151.72
    WHEN 341 THEN 318.36
    WHEN 342 THEN 304.29
    WHEN 343 THEN 101.20
    WHEN 344 THEN 289.74
    WHEN 345 THEN 161.36
    WHEN 346 THEN 304.29
    WHEN 347 THEN 141.73
    WHEN 348 THEN 397.31
    WHEN 349 THEN 289.74
    WHEN 350 THEN 165.30
    WHEN 351 THEN 49.73
    WHEN 352 THEN 52.17
    WHEN 353 THEN 20.05
    WHEN 354 THEN 306.61
    WHEN 355 THEN 275.26
    WHEN 356 THEN 275.26
    WHEN 357 THEN 292.66
    WHEN 358 THEN 306.61
    WHEN 359 THEN 297.30
    WHEN 360 THEN 297.30
    WHEN 361 THEN 297.30
    WHEN 362 THEN 312.17
    WHEN 363 THEN 190.81
    WHEN 364 THEN 199.89
    WHEN 365 THEN 54.41
    WHEN 366 THEN 54.41
    WHEN 367 THEN 54.41
    WHEN 368 THEN 52.17
    WHEN 369 THEN 20.05
    WHEN 370 THEN 49.44
    WHEN 371 THEN 21.14
    WHEN 372 THEN 21.14
    WHEN 373 THEN 21.14
    WHEN 374 THEN 87.17
    WHEN 375 THEN 87.17
    WHEN 376 THEN 741.59
    WHEN 377 THEN 312.17
    WHEN 378 THEN 312.17
    WHEN 379 THEN 59.32
    WHEN 380 THEN 87.17
    WHEN 381 THEN 319.55
    WHEN 382 THEN 335.54
    WHEN 383 THEN 335.54
    WHEN 384 THEN 21.35
    WHEN 385 THEN 21.35
    WHEN 386 THEN 20.15
    WHEN 387 THEN 350.29
    WHEN 388 THEN 190.81
    WHEN 389 THEN 199.89
    WHEN 390 THEN 54.21
    WHEN 393 THEN 54.21
    WHEN 395 THEN 54.21
    WHEN 396 THEN 54.21
    WHEN 397 THEN 54.21
    WHEN 398 THEN 54.21
    WHEN 399 THEN 278.72
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
  AND external_id IN (249, 250, 251, 252, 253, 254, 255, 256, 257, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 268, 269, 270, 271, 272, 273, 274, 275, 276, 277, 278, 279, 280, 281, 282, 283, 284, 285, 286, 287, 288, 289, 290, 291, 292, 296, 297, 298, 299, 300, 301, 302, 303, 304, 305, 306, 307, 308, 309, 310, 311, 312, 313, 314, 315, 316, 317, 318, 319, 320, 321, 322, 323, 324, 325, 326, 327, 328, 329, 330, 331, 332, 333, 334, 335, 336, 337, 338, 339, 340, 341, 342, 343, 344, 345, 346, 347, 348, 349, 350, 351, 352, 353, 354, 355, 356, 357, 358, 359, 360, 361, 362, 363, 364, 365, 366, 367, 368, 369, 370, 371, 372, 373, 374, 375, 376, 377, 378, 379, 380, 381, 382, 383, 384, 385, 386, 387, 388, 389, 390, 393, 395, 396, 397, 398, 399, 400, 401, 402, 403, 404, 405, 406, 407, 408);
COMMIT;
