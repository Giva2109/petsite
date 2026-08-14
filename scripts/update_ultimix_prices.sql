-- Atualiza só os 4 acessórios Ultimix (ids 213–216).
UPDATE products
SET
  price = CASE external_id
    WHEN 213 THEN 64.00
    WHEN 214 THEN 68.00
    WHEN 215 THEN 35.00
    WHEN 216 THEN 15.00
  END,
  updated_at = NOW()
WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
  AND external_id IN (213, 214, 215, 216);
