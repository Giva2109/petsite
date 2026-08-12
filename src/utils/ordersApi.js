import { API_BASE_URL } from '../config/constants'

function buildOrderPayload({
  items,
  customerName,
  phone,
  zipCode,
  street,
  streetNumber,
  complement,
  city,
  state,
  neighborhood,
  sameDeliveryAddress,
  deliveryAddress,
  idempotencyKey,
  channel,
  tenantSlug,
  totalAmount,
}) {
  return {
    customerName,
    phone,
    zipCode,
    street,
    streetNumber,
    complement: complement || null,
    city,
    state,
    neighborhood: neighborhood || null,
    sameDeliveryAddress,
    deliveryAddress,
    idempotencyKey,
    channel,
    tenantSlug: tenantSlug || null,
    totalAmount,
    items: items.map(({ product, quantity }) => ({
      productId: product.id,
      productName: product.name,
      productWeight: product.weight,
      quantity,
      unitPrice: product.price ?? null,
    })),
  }
}

async function parseError(response) {
  const text = await response.text()

  try {
    const data = JSON.parse(text)
    return data.detail || data.title || `Erro ${response.status} ao registrar pedido`
  } catch {
    if (response.status === 404) {
      return 'API não encontrada. Configure VITE_API_URL=https://unipet-api.fly.dev no Netlify.'
    }
    return text || `Erro ${response.status} ao registrar pedido`
  }
}

function getApiUrl() {
  if (API_BASE_URL) {
    return `${API_BASE_URL}/api/orders`
  }

  if (import.meta.env.PROD) {
    throw new Error(
      'API não configurada no site. Adicione VITE_API_URL=https://unipet-api.fly.dev no Netlify e faça redeploy.'
    )
  }

  return '/api/orders'
}

/**
 * Salva o pedido na API Java (Supabase).
 * @returns {Promise<{ id: string }>}
 */
export async function saveOrder(orderData) {
  const payload = buildOrderPayload(orderData)
  const url = getApiUrl()

  let response
  try {
    response = await fetch(url, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload),
    })
  } catch (error) {
    const detail = error instanceof Error && error.message ? ` (${error.message})` : ''
    throw new Error(
      `Não foi possível conectar à API em ${url}.${detail} Se o problema continuar, a API pode estar fora do ar.`
    )
  }

  if (!response.ok) {
    throw new Error(await parseError(response))
  }

  return response.json()
}
