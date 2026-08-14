-- Insere acessórios Ultimix no catálogo UniPet
BEGIN;
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image, description, weight, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 213, 'Escova Secadora', 'acessorios', 'Ultimix', 'Escova Secadora',
       48.99, '/assets/products/accessories/ultimix/escova-secadora.webp', 'Escova Secadora Pet Portatil Profissional 2 Em 1 Banho E Tosa Cachorro e Gato', NULL, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Escova Secadora'
    AND COALESCE(line, '') = 'Escova Secadora'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image, description, weight, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 214, 'Bebedouro Pet', 'acessorios', 'Ultimix', 'Bebedouro Pet',
       58.99, '/assets/products/accessories/ultimix/bebedouro-pet.webp', 'Bebedouro Pet Inteligente Fonte de Água Automático Com Filtro', NULL, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Bebedouro Pet'
    AND COALESCE(line, '') = 'Bebedouro Pet'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image, description, weight, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 215, 'Garrafa Bebedouro', 'acessorios', 'Ultimix', 'Garrafa Bebedouro',
       25.99, '/assets/products/accessories/ultimix/garrafa-bebedouro.webp', 'Garrafa Bebedouro Pet Portátil 2 em 1 Água e Ração', NULL, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Garrafa Bebedouro'
    AND COALESCE(line, '') = 'Garrafa Bebedouro'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image, description, weight, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 216, 'Luvas Removedoras de Pelos', 'acessorios', 'Ultimix', 'Luvas Removedoras de Pelos',
       4.99, '/assets/products/accessories/ultimix/luvas-removedoras-pelos.webp', 'Luvas Removedoras de Pelos Dupla Face para Pets, Roupas e Sofás', NULL, TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Luvas Removedoras de Pelos'
    AND COALESCE(line, '') = 'Luvas Removedoras de Pelos'
);
COMMIT;
