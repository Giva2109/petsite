# Deploy UniPet — resumo

**Site em produção:** https://unipet1.com  
**Alternativo:** https://unipet1.netlify.app

## Backend (Fly.io + Supabase)

Guia completo: [petsite-api/DEPLOY.md](../petsite-api/DEPLOY.md)

**Você precisa fazer:**

1. Copiar `petsite-api/.env.example` → `petsite-api/.env`
2. Colar a **senha do Postgres** do Supabase (projeto `petsite`)
3. Instalar Fly CLI e fazer login: `fly auth login`
4. Rodar: `cd petsite-api` → `.\scripts\deploy.ps1`

## Frontend (Netlify)

No painel Netlify → **Environment variables**:

```
VITE_API_URL=https://unipet-api.fly.dev
```

Depois: **Trigger deploy**.

### Domínio customizado

1. Netlify → **Domain management** → adicionar `unipet1.com` e `www.unipet1.com`
2. Configurar DNS no registrador do domínio
3. Atualizar CORS na API (ver `petsite-api/DEPLOY.md` — Passo 6)
4. Mercado Pago: autorizar `unipet1.com` no painel do desenvolvedor

As variáveis `VITE_*` **não precisam mudar** ao trocar o domínio.

## Supabase

Dashboard: https://supabase.com/dashboard/project/qpgjdrhxfevrmkrfydco

Após o deploy da API, verifique **Table Editor** → tabelas `orders` e `order_items`.
