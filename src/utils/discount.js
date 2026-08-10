export const PARQUE_CECAP_DISCOUNT_PERCENT = 10

export function normalizeNeighborhood(value = '') {
  return value
    .trim()
    .toLowerCase()
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
}

export function isEligibleNeighborhood(neighborhood, configuredNeighborhood) {
  if (!configuredNeighborhood?.trim()) return false
  return (
    normalizeNeighborhood(neighborhood) ===
    normalizeNeighborhood(configuredNeighborhood)
  )
}

export function isParqueCecapNeighborhood(neighborhood) {
  return normalizeNeighborhood(neighborhood) === 'parque cecap'
}

function roundMoney(value) {
  return Math.round(value * 100) / 100
}

/**
 * Calcula subtotal, desconto e total com base no bairro e configurações da loja.
 */
export function calculateOrderTotals(
  subtotal,
  neighborhood = '',
  settings = {}
) {
  if (subtotal == null || Number.isNaN(subtotal)) {
    return {
      subtotal: null,
      discountPercent: 0,
      discountAmount: 0,
      total: null,
      hasDiscount: false,
    }
  }

  const discountPercent = Number(settings.discountPercent || 0)
  const hasDiscount =
    discountPercent > 0 &&
    isEligibleNeighborhood(neighborhood, settings.discountNeighborhood)

  const discountAmount = hasDiscount
    ? roundMoney(subtotal * (discountPercent / 100))
    : 0
  const total = roundMoney(subtotal - discountAmount)

  return {
    subtotal,
    discountPercent: hasDiscount ? discountPercent : 0,
    discountAmount,
    total,
    hasDiscount,
  }
}
