import { WHATSAPP_NUMBER } from '../config/constants'
import { formatCurrency } from './currency'

function formatItemLine({ product, quantity }) {
  const priceLabel =
    product.price != null
      ? `(${formatCurrency(product.price)} cada)`
      : '(valor a combinar)'

  return `- ${quantity}x ${product.name} ${product.weight} ${priceLabel}`
}

/**
 * Monta a mensagem de pedido formatada para o WhatsApp.
 */
export function buildOrderMessage({
  items,
  customerName = '',
  phone = '',
  address = '',
}) {
  const itemLines = items.map(formatItemLine).join('\n')

  const hasUnknownPrice = items.some(({ product }) => product.price == null)

  const total = hasUnknownPrice
    ? null
    : items.reduce(
        (sum, { product, quantity }) => sum + product.price * quantity,
        0
      )

  let message = `Olá! Gostaria de fazer o seguinte pedido:

*Itens:*
${itemLines}

*Total:* ${total != null ? formatCurrency(total) : 'A combinar — aguardo cotação'}`

  if (customerName.trim()) {
    message += `\n\n*Cliente:* ${customerName.trim()}`
  }

  if (phone.trim()) {
    message += `\n*Telefone:* ${phone.trim()}`
  }

  if (address.trim()) {
    message += `\n*Endereço:* ${address.trim()}`
  }

  message += hasUnknownPrice
    ? '\n\nAguardo cotação dos valores e confirmação de disponibilidade. Obrigado!'
    : '\n\nAguardo as orientações para o pagamento via PIX / QR Code!'

  return message
}

/**
 * Gera o link wa.me com a mensagem codificada.
 */
export function buildWhatsAppLink(message) {
  return `https://wa.me/${WHATSAPP_NUMBER}?text=${encodeURIComponent(message)}`
}

/**
 * Abre o WhatsApp com o pedido formatado.
 */
export function openWhatsAppOrder(orderData) {
  const message = buildOrderMessage(orderData)
  const link = buildWhatsAppLink(message)
  window.open(link, '_blank', 'noopener,noreferrer')
}

/**
 * Mensagem de confirmação após pagamento online (Mercado Pago).
 */
export function buildPaymentConfirmationMessage({
  items,
  customerName = '',
  phone = '',
  address = '',
  totalAmount,
  paymentId = '',
  paymentMethod = 'Mercado Pago',
}) {
  const itemLines = items.map(formatItemLine).join('\n')

  let message = `Olá! Acabei de realizar o pagamento do meu pedido:

*Itens:*
${itemLines}

*Total pago:* ${formatCurrency(totalAmount)}`

  if (customerName.trim()) {
    message += `\n\n*Cliente:* ${customerName.trim()}`
  }

  if (phone.trim()) {
    message += `\n*Telefone:* ${phone.trim()}`
  }

  if (address.trim()) {
    message += `\n*Endereço:* ${address.trim()}`
  }

  message += `\n\n*Pagamento:* ${paymentMethod}`

  if (paymentId) {
    message += ` (ID: ${paymentId})`
  }

  message += '\n\nAguardo confirmação da entrega. Obrigado!'

  return message
}

export function openWhatsAppPaymentConfirmation(orderData) {
  const message = buildPaymentConfirmationMessage(orderData)
  const link = buildWhatsAppLink(message)
  window.open(link, '_blank', 'noopener,noreferrer')
}

/**
 * Mensagem leve para consulta de disponibilidade (sem carrinho).
 */
export function buildAvailabilityMessage({ product, customerName = '' }) {
  const priceLabel =
    product.price != null
      ? formatCurrency(product.price)
      : 'sob consulta'

  let message = `Olá! Gostaria de saber se têm disponível:

*Produto:* ${product.name}
*Marca:* ${product.brand || product.line || '—'}
*Peso:* ${product.weight || '—'}
*Preço no site:* ${priceLabel}`

  if (customerName.trim()) {
    message += `\n\n*Meu nome:* ${customerName.trim()}`
  }

  message += '\n\nAguardo retorno sobre disponibilidade. Obrigado!'

  return message
}

export function openWhatsAppAvailability({ product, customerName = '' }) {
  const message = buildAvailabilityMessage({ product, customerName })
  const link = buildWhatsAppLink(message)
  window.open(link, '_blank', 'noopener,noreferrer')
}
