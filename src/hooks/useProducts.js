import { useMemo } from 'react'
import productsData from '../data/products.json'
import { buildWeightOptions } from '../utils/weight'
import { matchesLifeStage } from '../utils/lifeStage'

/**
 * Hook de produtos — lê catálogo estático (extraído do PDF PremieRpet 2026).
 * TODO: Substituir por fetch/axios para API (Java/Python) mantendo a mesma interface.
 */
export function useProducts({
  category = 'todos',
  search = '',
  line = 'todas',
  lifeStage = 'todos',
  weight = 'todos',
} = {}) {
  const lines = useMemo(() => {
    const unique = [...new Set(productsData.map((p) => p.line))].sort()
    return unique
  }, [])

  const weightOptions = useMemo(
    () => buildWeightOptions(productsData),
    [],
  )

  const products = useMemo(() => {
    const query = search.trim().toLowerCase()

    return productsData.filter((product) => {
      const matchesCategory =
        category === 'todos' || product.category === category

      const matchesLine = line === 'todas' || product.line === line

      const matchesLifeStageFilter = matchesLifeStage(product, lifeStage)

      const matchesWeight =
        weight === 'todos' || product.weight === weight

      const matchesSearch =
        !query ||
        product.name.toLowerCase().includes(query) ||
        product.brand.toLowerCase().includes(query) ||
        product.line.toLowerCase().includes(query) ||
        product.description.toLowerCase().includes(query)

      return matchesCategory && matchesLine && matchesLifeStageFilter && matchesWeight && matchesSearch
    })
  }, [category, search, line, lifeStage, weight])

  return {
    products,
    lines,
    weightOptions,
    isLoading: false,
    error: null,
    total: products.length,
  }
}
