import { API_BASE_URL } from '../config/constants'

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
 * Processa pagamento via API Java (Mercado Pago por loja).
 */
export async function processPayment({
  tenantSlug,
  formData,
  items,
  customerName = '',
  address = '',
  neighborhood = '',
}) {
  if (!tenantSlug) {
    throw new Error('Loja não identificada para o pagamento.')
  }

  const response = await fetch(
    `${getApiBase()}/public/tenants/${encodeURIComponent(tenantSlug)}/payments`,
    {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        formData,
        items,
        customerName,
        address,
        neighborhood,
      }),
    }
  )

  const data = await response.json().catch(() => ({}))

  if (!response.ok) {
    throw new Error(data.detail || data.title || 'Não foi possível processar o pagamento.')
  }

  return {
    success: true,
    id: data.id,
    status: data.status,
    status_detail: data.statusDetail,
    payment_method_id: data.paymentMethodId,
    transaction_amount: data.transactionAmount,
    pix: data.pix,
  }
}
