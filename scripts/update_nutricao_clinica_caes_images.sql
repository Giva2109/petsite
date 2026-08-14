-- Atualiza só as descrições dos 21 SKUs de Nutrição Clínica Cães (ids 217–237).
-- Não altera os demais produtos.
UPDATE products
SET
  description = CASE external_id
    WHEN 217 THEN 'Alimento coadjuvante PremieR Nutrição Clínica. Sódio controlado; taurina, L-carnitina e EPA+DHA. Embalagem 2kg.'
    WHEN 218 THEN 'Alimento coadjuvante PremieR Nutrição Clínica. Sódio controlado; taurina, L-carnitina e EPA+DHA. Embalagem 10.1kg.'
    WHEN 219 THEN 'Alimento coadjuvante PremieR Nutrição Clínica. Sódio controlado; taurina, L-carnitina e EPA+DHA. Embalagem 10.1kg.'
    WHEN 220 THEN 'Alimento coadjuvante PremieR Nutrição Clínica. Baixo amido, fibras e alta proteína para controle glicêmico. Embalagem 2kg.'
    WHEN 221 THEN 'Alimento coadjuvante PremieR Nutrição Clínica. Baixo amido, fibras e alta proteína para controle glicêmico. Embalagem 10.1kg.'
    WHEN 222 THEN 'Alimento coadjuvante PremieR Nutrição Clínica. Baixo amido, fibras e alta proteína para controle glicêmico. Embalagem 10.1kg.'
    WHEN 223 THEN 'Alimento coadjuvante PremieR Nutrição Clínica. Alta digestibilidade, prebióticos e vitaminas do complexo B. Embalagem 2kg.'
    WHEN 224 THEN 'Alimento coadjuvante PremieR Nutrição Clínica. Alta digestibilidade, prebióticos e vitaminas do complexo B. Embalagem 10.1kg.'
    WHEN 225 THEN 'Alimento coadjuvante PremieR Nutrição Clínica. Alta digestibilidade, prebióticos e vitaminas do complexo B. Embalagem 10.1kg.'
    WHEN 226 THEN 'Alimento coadjuvante PremieR Nutrição Clínica. Proteína hidrolisada e mandioca; fonte restrita de proteínas. Embalagem 2kg.'
    WHEN 227 THEN 'Alimento coadjuvante PremieR Nutrição Clínica. Proteína hidrolisada e mandioca; fonte restrita de proteínas. Embalagem 10.1kg.'
    WHEN 228 THEN 'Alimento coadjuvante PremieR Nutrição Clínica. Proteína hidrolisada e mandioca; fonte restrita de proteínas. Embalagem 10.1kg.'
    WHEN 229 THEN 'Alimento coadjuvante PremieR Nutrição Clínica. Cordeiro e arroz; fonte restrita de proteínas e cuidado da pele. Embalagem 2kg.'
    WHEN 230 THEN 'Alimento coadjuvante PremieR Nutrição Clínica. Cordeiro e arroz; fonte restrita de proteínas e cuidado da pele. Embalagem 10.1kg.'
    WHEN 231 THEN 'Alimento coadjuvante PremieR Nutrição Clínica. Cordeiro e arroz; fonte restrita de proteínas e cuidado da pele. Embalagem 10.1kg.'
    WHEN 232 THEN 'Alimento coadjuvante PremieR Nutrição Clínica. Baixa caloria, alto teor de fibras e suporte articular. Embalagem 2kg.'
    WHEN 233 THEN 'Alimento coadjuvante PremieR Nutrição Clínica. Baixa caloria, alto teor de fibras e suporte articular. Embalagem 10.1kg.'
    WHEN 234 THEN 'Alimento coadjuvante PremieR Nutrição Clínica. Baixa caloria, alto teor de fibras e suporte articular. Embalagem 10.1kg.'
    WHEN 235 THEN 'Alimento coadjuvante PremieR Nutrição Clínica. Fósforo e proteína reduzidos; EPA+DHA para suporte renal. Embalagem 2kg.'
    WHEN 236 THEN 'Alimento coadjuvante PremieR Nutrição Clínica. Fósforo e proteína reduzidos; EPA+DHA para suporte renal. Embalagem 10.1kg.'
    WHEN 237 THEN 'Alimento coadjuvante PremieR Nutrição Clínica. Fósforo e proteína reduzidos; EPA+DHA para suporte renal. Embalagem 10.1kg.'
  END,
  updated_at = NOW()
WHERE tenant_id = 'a0000000-0000-4000-8000-000000000001'
  AND external_id BETWEEN 217 AND 237;
