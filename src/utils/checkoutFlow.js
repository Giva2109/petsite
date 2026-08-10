import { MERCADOPAGO_PUBLIC_KEY } from '../config/constants'

/**
 * Verifica se todos os itens do carrinho têm preço definido para pagamento online.
 */
export function canPayOnline(items) {
  if (!items.length) return false

  return items.every(
    ({ product }) => product.price != null && product.price > 0
  )
}

function resolveMercadoPagoPublicKey(settings = {}) {
  return settings.mercadoPagoPublicKey || MERCADOPAGO_PUBLIC_KEY || ''
}

function hasMercadoPago(settings = {}) {
  if (settings.mercadoPagoEnabled === true) return true
  return Boolean(resolveMercadoPagoPublicKey(settings))
}

function hasStaticPix(settings = {}) {
  if (settings.staticPixEnabled === true) return true
  return Boolean(settings.pixKey && settings.pixKeyType)
}

/**
 * Retorna todas as formas de pagamento disponíveis para o carrinho atual.
 */
export function getCheckoutOptions(items, settings = {}) {
  const options = []
  const pricedItems = canPayOnline(items)

  if (pricedItems && hasMercadoPago(settings)) {
    options.push({
      id: 'mercadopago',
      mode: 'online',
      channel: 'MERCADOPAGO',
      label: 'Pix ou cartão (Mercado Pago)',
      hint: 'Pagamento automático. Após concluir, envie a confirmação pelo WhatsApp.',
      buttonClass:
        'bg-emerald-600 hover:bg-emerald-700 focus:ring-emerald-400',
      icon: 'card',
    })
  }

  if (pricedItems && hasStaticPix(settings)) {
    options.push({
      id: 'static_pix',
      mode: 'static_pix',
      channel: 'STATIC_PIX',
      label: 'Pix (chave da loja)',
      hint: 'Gere o QR Code Pix da loja e envie o comprovante pelo WhatsApp.',
      buttonClass: 'bg-sky-600 hover:bg-sky-700 focus:ring-sky-400',
      icon: 'pix',
    })
  }

  options.push({
    id: 'whatsapp',
    mode: 'whatsapp',
    channel: 'WHATSAPP',
    label: 'Solicitar pelo WhatsApp',
    hint: pricedItems
      ? 'Combine pagamento e entrega diretamente com a loja.'
      : 'Alguns itens estão sob consulta. Enviaremos seu pedido para cotação.',
    buttonClass: 'bg-green-600 hover:bg-green-700 focus:ring-green-400',
    icon: 'whatsapp',
  })

  return options
}

/**
 * Compatibilidade com fluxo antigo (primeira opção disponível).
 */
export function getCheckoutAction(items, settings = {}) {
  const options = getCheckoutOptions(items, settings)
  const primary =
    options.find((option) => option.id !== 'whatsapp') || options[0]

  return {
    mode: primary.mode,
    label: primary.label,
    channel: primary.channel,
    hint: primary.hint,
    buttonClass: primary.buttonClass,
  }
}
