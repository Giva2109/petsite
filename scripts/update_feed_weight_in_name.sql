-- Move o peso da descrição para o nome (rações cães/gatos).
-- Só produtos com peso, sem 'Embalagem' no nome. Acessórios não entram.
UPDATE products
SET
  name = name || ' - Embalagem ' || weight,
  description = regexp_replace(description, '\s*Embalagem\s+.*$', '', 'i'),
  updated_at = NOW()
WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
  AND category IN ('caes', 'gatos')
  AND weight IS NOT NULL
  AND btrim(weight) <> ''
  AND weight <> 'Sob consulta'
  AND name NOT ILIKE '%Embalagem%';
