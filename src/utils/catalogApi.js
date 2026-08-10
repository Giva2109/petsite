import { API_BASE_URL, DEFAULT_TENANT_SLUG } from '../config/constants'

function getApiBase() {
  if (API_BASE_URL) {
    return `${API_BASE_URL}/api`
  }
  if (import.meta.env.PROD) {
    throw new Error('API não configurada. Defina VITE_API_URL no Netlify.')
  }
  return '/api'
}

export async function fetchCatalog({ slug, host } = {}) {
  const base = getApiBase()
  const url = host
    ? `${base}/public/catalog?host=${encodeURIComponent(host)}`
    : `${base}/public/tenants/${slug || DEFAULT_TENANT_SLUG}/catalog`

  const response = await fetch(url)
  if (!response.ok) {
    throw new Error('Não foi possível carregar o catálogo')
  }
  return response.json()
}
