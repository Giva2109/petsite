import { useMemo } from 'react'
import { useTenant } from '../context/TenantContext'
import { buildWeightOptions } from '../utils/weight'
import { matchesLifeStage } from '../utils/lifeStage'

function matchesCategory(product, category) {
  if (!category || category === 'todos') return true
  return product.category === category
}

function matchesAccessoryType(product, accessoryType) {
  if (!accessoryType || accessoryType === 'todos') return true
  if (product.category !== 'acessorios') return true
  return product.line === accessoryType
}

export function useProducts({
  category = 'todos',
  accessoryType = 'todos',
  search = '',
  line = 'todas',
  lifeStage = 'todos',
  weight = 'todos',
} = {}) {
  const { products: catalog, isLoading, error } = useTenant()

  const lines = useMemo(() => {
    const pool =
      category === 'acessorios'
        ? catalog.filter((product) => product.category === 'acessorios')
        : catalog.filter((product) => product.category !== 'acessorios')

    return [...new Set(pool.map((p) => p.line).filter(Boolean))].sort()
  }, [catalog, category])

  const accessoryTypes = useMemo(() => {
    return [
      ...new Set(
        catalog
          .filter((product) => product.category === 'acessorios')
          .map((product) => product.line)
          .filter(Boolean)
      ),
    ].sort()
  }, [catalog])

  const weightOptions = useMemo(
    () => buildWeightOptions(catalog),
    [catalog]
  )

  const products = useMemo(() => {
    const query = search.trim().toLowerCase()

    return catalog.filter((product) => {
      const matchesCategoryFilter = matchesCategory(product, category)
      const matchesAccessoryTypeFilter = matchesAccessoryType(
        product,
        accessoryType
      )

      const matchesLine =
        category === 'acessorios' ||
        line === 'todas' ||
        product.line === line

      const matchesLifeStageFilter =
        product.category === 'acessorios' ||
        matchesLifeStage(product, lifeStage)

      const matchesWeight =
        weight === 'todos' || product.weight === weight

      const matchesSearch =
        !query ||
        product.name.toLowerCase().includes(query) ||
        product.brand?.toLowerCase().includes(query) ||
        product.line?.toLowerCase().includes(query) ||
        product.description?.toLowerCase().includes(query)

      return (
        matchesCategoryFilter &&
        matchesAccessoryTypeFilter &&
        matchesLine &&
        matchesLifeStageFilter &&
        matchesWeight &&
        matchesSearch
      )
    })
  }, [catalog, category, accessoryType, search, line, lifeStage, weight])

  return {
    products,
    lines,
    accessoryTypes,
    weightOptions,
    isLoading,
    error,
    total: products.length,
  }
}
