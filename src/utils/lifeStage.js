/**
 * Estágio de vida para filtro: filhotes vs adultos (inclui castrados, sênior, light, etc.).
 */
export function getLifeStage(product) {
  if (/Filhotes/i.test(product.name)) {
    return 'filhotes'
  }
  return 'adultos'
}

export function matchesLifeStage(product, lifeStage) {
  if (!lifeStage || lifeStage === 'todos') {
    return true
  }
  return getLifeStage(product) === lifeStage
}
