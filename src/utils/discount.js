export const PARQUE_CECAP_DISCOUNT_PERCENT = 10

export function normalizeNeighborhood(value = '') {
  return value
    .trim()
    .toLowerCase()
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
}

export function isParqueCecapNeighborhood(neighborhood) {
  return normalizeNeighborhood(neighborhood) === 'parque cecap'
}

function roundMoney(value) {
  return Math.round(value * 100) / 100
}

/**
 * Calcula subtotal, desconto e total com base no bairro.
 * @param {number | null | undefined} subtotal
 * @param {string} neighborhood
 */
export function calculateOrderTotals(subtotal, neighborhood = '') {
  if (subtotal == null || Number.isNaN(subtotal)) {
    return {
      subtotal: null,
      discountPercent: 0,
      discountAmount: 0,
      total: null,
      hasDiscount: false,
    }
  }

  const hasDiscount = isParqueCecapNeighborhood(neighborhood)
  const discountPercent = hasDiscount ? PARQUE_CECAP_DISCOUNT_PERCENT : 0
  const discountAmount = hasDiscount
    ? roundMoney(subtotal * (discountPercent / 100))
    : 0
  const total = roundMoney(subtotal - discountAmount)

  return {
    subtotal,
    discountPercent,
    discountAmount,
    total,
    hasDiscount,
  }
}
