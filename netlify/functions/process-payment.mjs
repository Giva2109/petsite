import { MercadoPagoConfig, Payment } from 'mercadopago'
import { randomUUID } from 'crypto'

const CORS_HEADERS = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'Content-Type',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
  'Content-Type': 'application/json',
}

function jsonResponse(statusCode, body) {
  return {
    statusCode,
    headers: CORS_HEADERS,
    body: JSON.stringify(body),
  }
}

function calculateOrderTotal(items = []) {
  if (!Array.isArray(items) || items.length === 0) return null

  return items.reduce((sum, item) => {
    const price = item?.product?.price
    if (price == null || Number.isNaN(Number(price))) {
      throw new Error('Todos os itens precisam ter preço para pagamento online.')
    }
    return sum + Number(price) * Number(item.quantity || 1)
  }, 0)
}

function buildDescription(items = []) {
  if (!items.length) return 'Pedido UniPet'

  const summary = items
    .slice(0, 3)
    .map(({ product, quantity }) => `${quantity}x ${product.name}`)
    .join(', ')

  return items.length > 3 ? `${summary} e mais itens` : summary
}

export const handler = async (event) => {
  if (event.httpMethod === 'OPTIONS') {
    return { statusCode: 204, headers: CORS_HEADERS, body: '' }
  }

  if (event.httpMethod !== 'POST') {
    return jsonResponse(405, { success: false, message: 'Método não permitido.' })
  }

  const accessToken = process.env.MERCADOPAGO_ACCESS_TOKEN
  if (!accessToken) {
    return jsonResponse(500, {
      success: false,
      message: 'MERCADOPAGO_ACCESS_TOKEN não configurado no Netlify.',
    })
  }

  let payload
  try {
    payload = JSON.parse(event.body || '{}')
  } catch {
    return jsonResponse(400, { success: false, message: 'JSON inválido.' })
  }

  const { formData, items = [], customerName = '', address = '' } = payload

  if (!formData || formData.transaction_amount == null) {
    return jsonResponse(400, {
      success: false,
      message: 'Dados do pagamento incompletos.',
    })
  }

  try {
    const expectedTotal = calculateOrderTotal(items)
    const amount = Number(formData.transaction_amount)

    if (expectedTotal != null && Math.abs(expectedTotal - amount) > 0.01) {
      return jsonResponse(400, {
        success: false,
        message: 'Valor do pagamento não confere com o pedido.',
      })
    }

    if (!amount || amount <= 0) {
      return jsonResponse(400, {
        success: false,
        message: 'Valor do pagamento inválido.',
      })
    }

    const client = new MercadoPagoConfig({ accessToken })
    const paymentClient = new Payment(client)

    const paymentBody = {
      transaction_amount: amount,
      description: buildDescription(items),
      payment_method_id: formData.payment_method_id,
      payer: {
        email: formData.payer?.email,
        first_name: formData.payer?.first_name,
        last_name: formData.payer?.last_name,
        identification: formData.payer?.identification,
      },
      metadata: {
        customer_name: customerName,
        address,
        items_count: items.length,
      },
    }

    if (formData.token) {
      paymentBody.token = formData.token
    }

    if (formData.installments) {
      paymentBody.installments = Number(formData.installments)
    }

    if (formData.issuer_id) {
      paymentBody.issuer_id = formData.issuer_id
    }

    const payment = await paymentClient.create({
      body: paymentBody,
      requestOptions: { idempotencyKey: randomUUID() },
    })

    const pixData = payment.point_of_interaction?.transaction_data

    return jsonResponse(200, {
      success: true,
      id: payment.id,
      status: payment.status,
      status_detail: payment.status_detail,
      payment_method_id: payment.payment_method_id,
      transaction_amount: payment.transaction_amount,
      pix:
        payment.payment_method_id === 'pix' && pixData
          ? {
              qr_code: pixData.qr_code,
              qr_code_base64: pixData.qr_code_base64,
              ticket_url: pixData.ticket_url,
            }
          : null,
    })
  } catch (error) {
    console.error('Mercado Pago error:', error)

    const apiMessage =
      error?.cause?.[0]?.description ||
      error?.message ||
      'Erro ao processar pagamento.'

    return jsonResponse(500, {
      success: false,
      message: apiMessage,
    })
  }
}
