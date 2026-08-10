import { API_BASE_URL } from '../config/constants'

const AUTH_STORAGE_KEY = 'unipet_admin_auth'

function getApiBase() {
  if (API_BASE_URL) {
    return `${API_BASE_URL}/api`
  }
  if (import.meta.env.PROD) {
    throw new Error('API não configurada. Defina VITE_API_URL no Netlify.')
  }
  return '/api'
}

export function loadAuthSession() {
  try {
    const raw = localStorage.getItem(AUTH_STORAGE_KEY)
    return raw ? JSON.parse(raw) : null
  } catch {
    return null
  }
}

export function saveAuthSession(session) {
  localStorage.setItem(AUTH_STORAGE_KEY, JSON.stringify(session))
}

export function clearAuthSession() {
  localStorage.removeItem(AUTH_STORAGE_KEY)
}

export async function loginAdmin({ tenantSlug, email, password }) {
  const response = await fetch(`${getApiBase()}/auth/login`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ tenantSlug, email, password }),
  })

  const data = await response.json().catch(() => ({}))
  if (!response.ok) {
    throw new Error(data.detail || data.title || 'Falha no login')
  }
  return data
}

export async function adminFetch(path, { method = 'GET', body, token } = {}) {
  const response = await fetch(`${getApiBase()}${path}`, {
    method,
    headers: {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${token}`,
    },
    body: body ? JSON.stringify(body) : undefined,
  })

  if (response.status === 204) {
    return null
  }

  const data = await response.json().catch(() => ({}))
  if (!response.ok) {
    throw new Error(data.detail || data.title || `Erro ${response.status}`)
  }
  return data
}
