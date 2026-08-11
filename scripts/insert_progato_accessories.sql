-- Insere areias Progato no catálogo UniPet
BEGIN;
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image, description, weight, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 195, 'Progato Clássica Multigrãos', 'acessorios', 'Progato', 'Areia de Gato',
       15.9, '/assets/products/accessories/progato/classica-multigraos.webp', 'Areia sanitária Clássica Multigrãos. Embalagem 4kg.', '4kg', TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Progato Clássica Multigrãos'
    AND COALESCE(weight, '') = '4kg'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image, description, weight, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 196, 'Progato Clássica Multigrãos', 'acessorios', 'Progato', 'Areia de Gato',
       38.5, '/assets/products/accessories/progato/classica-multigraos.webp', 'Areia sanitária Clássica Multigrãos. Embalagem 10kg.', '10kg', TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Progato Clássica Multigrãos'
    AND COALESCE(weight, '') = '10kg'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image, description, weight, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 197, 'Progato Clássica Multigrãos Perfumada', 'acessorios', 'Progato', 'Areia de Gato',
       45.9, '/assets/products/accessories/progato/classica-multigraos-perfumada.webp', 'Areia sanitária Clássica Multigrãos Perfumada. Embalagem 10kg.', '10kg', TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Progato Clássica Multigrãos Perfumada'
    AND COALESCE(weight, '') = '10kg'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image, description, weight, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 198, 'Progato Clássica Grãos Pequenos Perfumada', 'acessorios', 'Progato', 'Areia de Gato',
       18.5, '/assets/products/accessories/progato/classica-graos-pequenos-perfumada.webp', 'Areia sanitária Clássica Grãos Pequenos Perfumada. Embalagem 4kg.', '4kg', TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Progato Clássica Grãos Pequenos Perfumada'
    AND COALESCE(weight, '') = '4kg'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image, description, weight, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 199, 'Progato Premium', 'acessorios', 'Progato', 'Areia de Gato',
       49.9, '/assets/products/accessories/progato/premium.webp', 'Areia sanitária Premium. Embalagem 4kg.', '4kg', TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Progato Premium'
    AND COALESCE(weight, '') = '4kg'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image, description, weight, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 200, 'Progato Premium', 'acessorios', 'Progato', 'Areia de Gato',
       114.9, '/assets/products/accessories/progato/premium.webp', 'Areia sanitária Premium. Embalagem 10kg.', '10kg', TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Progato Premium'
    AND COALESCE(weight, '') = '10kg'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image, description, weight, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 201, 'Progato Super Premium', 'acessorios', 'Progato', 'Areia de Gato',
       54.5, '/assets/products/accessories/progato/super-premium.webp', 'Areia sanitária Super Premium. Embalagem 4kg.', '4kg', TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Progato Super Premium'
    AND COALESCE(weight, '') = '4kg'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image, description, weight, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 202, 'Progato Branco', 'acessorios', 'Progato', 'Areia de Gato',
       23.9, '/assets/products/accessories/progato/branco.webp', 'Areia sanitária Branco. Embalagem 1.8kg.', '1.8kg', TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Progato Branco'
    AND COALESCE(weight, '') = '1.8kg'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image, description, weight, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 203, 'Progato Branco', 'acessorios', 'Progato', 'Areia de Gato',
       45.6, '/assets/products/accessories/progato/branco.webp', 'Areia sanitária Branco. Embalagem 3.6kg.', '3.6kg', TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Progato Branco'
    AND COALESCE(weight, '') = '3.6kg'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image, description, weight, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 204, 'Progato Branco', 'acessorios', 'Progato', 'Areia de Gato',
       120.9, '/assets/products/accessories/progato/branco.webp', 'Areia sanitária Branco. Embalagem 10kg.', '10kg', TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Progato Branco'
    AND COALESCE(weight, '') = '10kg'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image, description, weight, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 205, 'Progato Vida Comfort', 'acessorios', 'Progato', 'Areia de Gato',
       59.9, '/assets/products/accessories/progato/vida-comfort.webp', 'Areia sanitária Vida Comfort. Embalagem 3.6kg.', '3.6kg', TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Progato Vida Comfort'
    AND COALESCE(weight, '') = '3.6kg'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image, description, weight, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 206, 'Progato Vida Clean', 'acessorios', 'Progato', 'Areia de Gato',
       59.9, '/assets/products/accessories/progato/vida-clean.webp', 'Areia sanitária Vida Clean. Embalagem 3.6kg.', '3.6kg', TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Progato Vida Clean'
    AND COALESCE(weight, '') = '3.6kg'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image, description, weight, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 207, 'Progato Ecorice', 'acessorios', 'Progato', 'Areia de Gato',
       23.9, '/assets/products/accessories/progato/ecorice.webp', 'Areia sanitária Ecorice. Embalagem 4kg.', '4kg', TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Progato Ecorice'
    AND COALESCE(weight, '') = '4kg'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image, description, weight, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 208, 'Progato Sensitive', 'acessorios', 'Progato', 'Areia de Gato',
       24.9, '/assets/products/accessories/progato/sensitive.webp', 'Areia sanitária Sensitive. Embalagem 1.8kg.', '1.8kg', TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Progato Sensitive'
    AND COALESCE(weight, '') = '1.8kg'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image, description, weight, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 209, 'Progato Light Weight', 'acessorios', 'Progato', 'Areia de Gato',
       54.5, '/assets/products/accessories/progato/light-weight.webp', 'Areia sanitária Light Weight. Embalagem 4kg.', '4kg', TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Progato Light Weight'
    AND COALESCE(weight, '') = '4kg'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image, description, weight, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 210, 'Progato Pinus', 'acessorios', 'Progato', 'Areia de Gato',
       38.9, '/assets/products/accessories/progato/pinus.webp', 'Areia sanitária Pinus. Embalagem 5kg.', '5kg', TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Progato Pinus'
    AND COALESCE(weight, '') = '5kg'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image, description, weight, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 211, 'Progato Pinus', 'acessorios', 'Progato', 'Areia de Gato',
       72.9, '/assets/products/accessories/progato/pinus.webp', 'Areia sanitária Pinus. Embalagem 10kg.', '10kg', TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Progato Pinus'
    AND COALESCE(weight, '') = '10kg'
);
INSERT INTO products (
  tenant_id, external_id, name, category, brand, line, price, image, description, weight, active
)
SELECT 'a0000000-0000-4000-8000-000000000001', 212, 'Progato Biobom', 'acessorios', 'Progato', 'Areia de Gato',
       41.9, '/assets/products/accessories/progato/biobom.webp', 'Areia sanitária Biobom. Embalagem 3kg.', '3kg', TRUE
WHERE NOT EXISTS (
  SELECT 1 FROM products
  WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
    AND name = 'Progato Biobom'
    AND COALESCE(weight, '') = '3kg'
);
COMMIT;
