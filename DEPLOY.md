# Deploy UniPet — resumo

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

## Supabase

Dashboard: https://supabase.com/dashboard/project/qpgjdrhxfevrmkrfydco

Após o deploy da API, verifique **Table Editor** → tabelas `orders` e `order_items`.
