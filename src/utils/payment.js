const PAYMENT_ENDPOINT = '/.netlify/functions/process-payment'

/**
 * Envia o pagamento do Payment Brick para a Netlify Function.
 */
export async function processPayment({
  formData,
  items,
  customerName = '',
  address = '',
  neighborhood = '',
}) {
  const response = await fetch(PAYMENT_ENDPOINT, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      formData,
      items,
      customerName,
      address,
      neighborhood,
    }),
  })

  const data = await response.json()

  if (!response.ok || !data.success) {
    throw new Error(data.message || 'Não foi possível processar o pagamento.')
  }

  return data
}
