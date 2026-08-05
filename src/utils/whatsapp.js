import { WHATSAPP_NUMBER } from '../config/constants'
import { formatCurrency } from './currency'
import { calculateOrderTotals } from './discount'

function formatOrderTotalLines({ items, neighborhood = '' }) {
  const hasUnknownPrice = items.some(({ product }) => product.price == null)

  if (hasUnknownPrice) {
    return '*Total:* A combinar — aguardo cotação'
  }

  const totals = calculateOrderTotals(
    items.reduce(
      (sum, { product, quantity }) => sum + product.price * quantity,
      0
    ),
    neighborhood
  )

  if (totals.hasDiscount) {
    return `*Subtotal:* ${formatCurrency(totals.subtotal)}
*Desconto Parque Cecap (10%):* - ${formatCurrency(totals.discountAmount)}
*Total:* ${formatCurrency(totals.total)}`
  }

  return `*Total:* ${formatCurrency(totals.total)}`
}

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
  neighborhood = '',
}) {
  const itemLines = items.map(formatItemLine).join('\n')
  const totalLines = formatOrderTotalLines({ items, neighborhood })

  let message = `Olá! Gostaria de fazer o seguinte pedido:

*Itens:*
${itemLines}

${totalLines}`

  if (customerName.trim()) {
    message += `\n\n*Cliente:* ${customerName.trim()}`
  }

  if (phone.trim()) {
    message += `\n*Telefone:* ${phone.trim()}`
  }

  if (address.trim()) {
    message += `\n*Endereço:* ${address.trim()}`
  }

  message += hasUnknownPrice(items)
    ? '\n\nAguardo cotação dos valores e confirmação de disponibilidade. Obrigado!'
    : '\n\nAguardo as orientações para o pagamento via PIX / QR Code!'

  return message
}

function hasUnknownPrice(items) {
  return items.some(({ product }) => product.price == null)
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
  subtotalAmount,
  discountAmount = 0,
  paymentId = '',
  paymentMethod = 'Mercado Pago',
}) {
  const itemLines = items.map(formatItemLine).join('\n')

  let totalLines = `*Total pago:* ${formatCurrency(totalAmount)}`
  if (discountAmount > 0 && subtotalAmount != null) {
    totalLines = `*Subtotal:* ${formatCurrency(subtotalAmount)}
*Desconto Parque Cecap (10%):* - ${formatCurrency(discountAmount)}
*Total pago:* ${formatCurrency(totalAmount)}`
  }

  let message = `Olá! Acabei de realizar o pagamento do meu pedido:

*Itens:*
${itemLines}

${totalLines}`

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
