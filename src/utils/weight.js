/**
 * Converte peso do catálogo (ex.: "250g", "3kg") para gramas para ordenação.
 */
export function parseWeightToGrams(weight) {
  if (!weight || weight === 'Sob consulta') return null

  const normalized = weight.trim().toLowerCase().replace(/\s+/g, '')
  const kgMatch = normalized.match(/^([\d.]+)kg$/)
  if (kgMatch) return parseFloat(kgMatch[1]) * 1000

  const gMatch = normalized.match(/^([\d.]+)g$/)
  if (gMatch) return parseFloat(gMatch[1])

  return null
}

function getWeightUnit(weight) {
  if (!weight || weight === 'Sob consulta') return 'other'
  const normalized = weight.trim().toLowerCase()
  if (normalized.endsWith('kg')) return 'kg'
  if (normalized.endsWith('g')) return 'g'
  return 'other'
}

function sortByGrams(weights) {
  return [...weights].sort(
    (a, b) => parseWeightToGrams(a) - parseWeightToGrams(b),
  )
}

/**
 * Agrupa pesos únicos do catálogo em gramas (g) e quilos (kg).
 */
export function buildWeightOptions(products) {
  const unique = [...new Set(products.map((p) => p.weight).filter(Boolean))]

  return {
    grams: sortByGrams(unique.filter((w) => getWeightUnit(w) === 'g')),
    kilos: sortByGrams(unique.filter((w) => getWeightUnit(w) === 'kg')),
    other: unique.filter((w) => getWeightUnit(w) === 'other'),
  }
}
