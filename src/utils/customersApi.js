import { API_BASE_URL } from '../config/constants'
import { normalizePhone } from './checkoutForm'

function getApiBase() {
  if (API_BASE_URL) {
    return `${API_BASE_URL}/api`
  }
  if (import.meta.env.PROD) {
    throw new Error('API não configurada. Defina VITE_API_URL no Netlify.')
  }
  return '/api'
}

/**
 * Busca cliente cadastrado pelo telefone da loja.
 * @returns {Promise<{found: boolean, customerName?: string, phone?: string, zipCode?: string, street?: string, streetNumber?: string, complement?: string, city?: string, state?: string, neighborhood?: string}>}
 */
export async function lookupCustomerByPhone(tenantSlug, phone) {
  const digits = normalizePhone(phone)
  if (digits.length < 10 || digits.length > 15) {
    return { found: false }
  }

  const base = getApiBase()
  const url = `${base}/public/tenants/${encodeURIComponent(tenantSlug)}/customers/by-phone?phone=${encodeURIComponent(digits)}`

  const response = await fetch(url)
  if (!response.ok) {
    return { found: false }
  }

  return response.json()
}
