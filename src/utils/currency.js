/**
 * Formata valores numéricos para moeda brasileira (BRL).
 * Retorna "Sob consulta" quando o preço não está definido.
 * @param {number | null | undefined} value
 * @returns {string}
 */
export function formatCurrency(value) {
  if (value == null || Number.isNaN(value)) {
    return 'Sob consulta'
  }

  return new Intl.NumberFormat('pt-BR', {
    style: 'currency',
    currency: 'BRL',
  }).format(value)
}
