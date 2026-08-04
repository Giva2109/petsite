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
  channel,
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
    channel,
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
  try {
    const data = await response.json()
    return data.detail || data.title || 'Não foi possível registrar o pedido'
  } catch {
    return 'Não foi possível registrar o pedido'
  }
}

/**
 * Salva o pedido na API Java (Supabase).
 * @returns {Promise<{ id: string }>}
 */
export async function saveOrder(orderData) {
  const payload = buildOrderPayload(orderData)
  const url = `${API_BASE_URL}/api/orders`

  const response = await fetch(url, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(payload),
  })

  if (!response.ok) {
    throw new Error(await parseError(response))
  }

  return response.json()
}
