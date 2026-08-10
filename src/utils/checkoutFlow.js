/**
 * Verifica se todos os itens do carrinho têm preço definido para pagamento online.
 */
export function canPayOnline(items) {
  if (!items.length) return false

  return items.every(
    ({ product }) => product.price != null && product.price > 0
  )
}

function hasMercadoPago(settings = {}) {
  return settings.mercadoPagoEnabled === true
}

function hasStaticPix(settings = {}) {
  return settings.staticPixEnabled === true
}

/**
 * Retorna as formas de pagamento disponíveis.
 * WhatsApp só aparece quando não há pagamento online configurado
 * (comportamento da tela antiga).
 */
export function getCheckoutOptions(items, settings = {}) {
  const options = []
  const pricedItems = canPayOnline(items)
  const mercadoPagoAvailable = pricedItems && hasMercadoPago(settings)
  const staticPixAvailable = pricedItems && hasStaticPix(settings)
  const hasOnlinePayment = mercadoPagoAvailable || staticPixAvailable

  if (mercadoPagoAvailable) {
    options.push({
      id: 'mercadopago',
      mode: 'online',
      channel: 'MERCADOPAGO',
      label: staticPixAvailable
        ? 'Pix ou cartão (Mercado Pago)'
        : 'Finalizar pedido',
      hint: 'Pix ou cartão via Mercado Pago. Após pagar, o WhatsApp abrirá para confirmar o pedido.',
      buttonClass:
        'bg-emerald-600 hover:bg-emerald-700 focus:ring-emerald-400',
      icon: 'card',
    })
  }

  if (staticPixAvailable) {
    options.push({
      id: 'static_pix',
      mode: 'static_pix',
      channel: 'STATIC_PIX',
      label:
        mercadoPagoAvailable ? 'Pix (chave da loja)' : 'Finalizar pedido',
      hint: 'Gere o QR Code Pix e, após pagar, confirme o pedido pelo WhatsApp.',
      buttonClass: mercadoPagoAvailable
        ? 'bg-sky-600 hover:bg-sky-700 focus:ring-sky-400'
        : 'bg-emerald-600 hover:bg-emerald-700 focus:ring-emerald-400',
      icon: mercadoPagoAvailable ? 'pix' : 'card',
    })
  }

  if (!hasOnlinePayment) {
    options.push({
      id: 'whatsapp',
      mode: 'whatsapp',
      channel: 'WHATSAPP',
      label: pricedItems ? 'Finalizar pedido' : 'Solicitar pelo WhatsApp',
      hint: pricedItems
        ? 'Enviaremos seu pedido pelo WhatsApp da loja para confirmação e pagamento.'
        : 'Alguns itens estão sob consulta. Enviaremos seu pedido para cotação.',
      buttonClass: 'bg-green-600 hover:bg-green-700 focus:ring-green-400',
      icon: 'whatsapp',
    })
  }

  return options
}

/**
 * Compatibilidade com fluxo antigo (primeira opção disponível).
 */
export function getCheckoutAction(items, settings = {}) {
  const options = getCheckoutOptions(items, settings)
  const primary = options[0]

  return {
    mode: primary.mode,
    label: primary.label,
    channel: primary.channel,
    hint: primary.hint,
    buttonClass: primary.buttonClass,
  }
}
