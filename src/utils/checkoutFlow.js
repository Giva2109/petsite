/**
 * Verifica se todos os itens do carrinho têm preço definido para pagamento online.
 */
export function canPayOnline(items) {
  if (!items.length) return false

  return items.every(
    ({ product }) => product.price != null && product.price > 0
  )
}

/**
 * Define o fluxo de checkout com base no conteúdo do carrinho.
 */
export function getCheckoutAction(items) {
  if (canPayOnline(items)) {
    return {
      mode: 'online',
      label: 'Finalizar pedido',
      channel: 'MERCADOPAGO',
      hint: 'Pagamento via Pix ou cartão. Após confirmar, enviaremos os detalhes pelo WhatsApp.',
      buttonClass:
        'bg-emerald-600 hover:bg-emerald-700 focus:ring-emerald-400',
    }
  }

  return {
    mode: 'whatsapp',
    label: 'Solicitar pelo WhatsApp',
    channel: 'WHATSAPP',
    hint: 'Alguns itens estão sob consulta. Enviaremos seu pedido para cotação e confirmação de valores.',
    buttonClass: 'bg-green-600 hover:bg-green-700 focus:ring-green-400',
  }
}
