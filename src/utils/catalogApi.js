import { API_BASE_URL, DEFAULT_TENANT_SLUG, STORE_URL } from '../config/constants'

function getApiBase() {
  if (API_BASE_URL) {
    return `${API_BASE_URL}/api`
  }
  if (import.meta.env.PROD) {
    throw new Error('API não configurada. Defina VITE_API_URL no Netlify.')
  }
  return '/api'
}

function isGenericHost(host = '') {
  const normalized = host.toLowerCase()
  return (
    normalized === 'localhost' ||
    normalized.startsWith('127.0.0.1') ||
    normalized.endsWith('.netlify.app')
  )
}

export async function fetchCatalog({ slug, host } = {}) {
  const base = getApiBase()
  let url

  if (slug) {
    url = `${base}/public/tenants/${encodeURIComponent(slug)}/catalog`
  } else if (host && !isGenericHost(host)) {
    url = `${base}/public/catalog?host=${encodeURIComponent(host)}`
  } else {
    url = `${base}/public/tenants/${DEFAULT_TENANT_SLUG}/catalog`
  }

  const response = await fetch(url)
  if (!response.ok) {
    throw new Error('Não foi possível carregar o catálogo')
  }
  return response.json()
}

export function buildStorePath(tenantSlug) {
  return `/loja/${tenantSlug}`
}

export function buildStoreUrl(tenantSlug, origin) {
  const base =
    origin ||
    (typeof window !== 'undefined' ? window.location.origin : STORE_URL)
  return `${base}${buildStorePath(tenantSlug)}`
}
