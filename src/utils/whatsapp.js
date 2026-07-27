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
export function buildOrderMessage({ items, customerName = '', address = '' }) {
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

  if (address.trim()) {
    message += `\n*Endereço:* ${address.trim()}`
  }

  message +=
    '\n\nAguardo as orientações para o pagamento via PIX / QR Code!'

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
