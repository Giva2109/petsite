import { useMemo } from 'react'
import { useTenant } from '../context/TenantContext'
import { buildWeightOptions } from '../utils/weight'
import { matchesLifeStage } from '../utils/lifeStage'

export function useProducts({
  category = 'todos',
  search = '',
  line = 'todas',
  lifeStage = 'todos',
  weight = 'todos',
} = {}) {
  const { products: catalog, isLoading, error } = useTenant()

  const lines = useMemo(() => {
    const unique = [...new Set(catalog.map((p) => p.line).filter(Boolean))].sort()
    return unique
  }, [catalog])

  const weightOptions = useMemo(
    () => buildWeightOptions(catalog),
    [catalog]
  )

  const products = useMemo(() => {
    const query = search.trim().toLowerCase()

    return catalog.filter((product) => {
      const matchesCategory =
        category === 'todos' || product.category === category

      const matchesLine = line === 'todas' || product.line === line

      const matchesLifeStageFilter = matchesLifeStage(product, lifeStage)

      const matchesWeight =
        weight === 'todos' || product.weight === weight

      const matchesSearch =
        !query ||
        product.name.toLowerCase().includes(query) ||
        product.brand?.toLowerCase().includes(query) ||
        product.line?.toLowerCase().includes(query) ||
        product.description?.toLowerCase().includes(query)

      return (
        matchesCategory &&
        matchesLine &&
        matchesLifeStageFilter &&
        matchesWeight &&
        matchesSearch
      )
    })
  }, [catalog, category, search, line, lifeStage, weight])

  return {
    products,
    lines,
    weightOptions,
    isLoading,
    error,
    total: products.length,
  }
}
