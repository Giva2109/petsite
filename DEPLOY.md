# Deploy UniPet — resumo

**Site em produção:** https://unipet1.com  
**Alternativo:** https://unipet1.netlify.app

## URLs das lojas (multi-tenant)

| Loja | URL |
|------|-----|
| UniPet (domínio principal) | https://unipet1.com |
| Qualquer loja por slug | https://unipet1.com/loja/{slug} |
| Exemplo | https://unipet1.com/loja/unipet |
| Cadastro de nova empresa | https://unipet1.com/cadastro |
| Painel admin | https://unipet1.com/admin/login |

## Backend (Fly.io + Supabase)

Guia completo: [petsite-api/DEPLOY.md](../petsite-api/DEPLOY.md)

**Você precisa fazer:**

1. Copiar `petsite-api/.env.example` → `petsite-api/.env`
2. Preencher `DATABASE_PASSWORD` e `SUPABASE_SERVICE_ROLE_KEY`
3. No Supabase SQL Editor: executar `petsite-api/scripts/supabase-storage-setup.sql`
4. `cd petsite-api` → `.\scripts\deploy.ps1`

## Frontend (Netlify)

No painel Netlify → **Environment variables**:

```
VITE_API_URL=https://unipet-api.fly.dev
```

Depois: **Trigger deploy** (branch com as novas features).

### Domínio customizado

1. Netlify → **Domain management** → adicionar `unipet1.com` e `www.unipet1.com`
2. Configurar DNS no registrador do domínio
3. Atualizar CORS na API (ver `petsite-api/DEPLOY.md` — Passo 6)
4. Mercado Pago: autorizar `unipet1.com` no painel do desenvolvedor

## Como testar

1. **Cadastro:** https://unipet1.com/cadastro → criar loja teste
2. **Login admin:** usar slug + e-mail + senha criados
3. **Upload:** Admin → Produtos → Enviar imagem
4. **Loja pública:** https://unipet1.com/loja/{seu-slug}

## Supabase

Dashboard: https://supabase.com/dashboard/project/qpgjdrhxfevrmkrfydco

- **Table Editor:** `tenants`, `products`, `orders`
- **Storage:** bucket `petsite-media`
