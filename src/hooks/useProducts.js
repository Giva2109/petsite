import { useMemo, useState, useEffect, useCallback } from 'react'
import productsData from '../data/products.json'

/**
 * Hook de produtos — lê catálogo estático (extraído do PDF PremieRpet 2026).
 * TODO: Substituir por fetch/axios para API (Java/Python) mantendo a mesma interface.
 */
export function useProducts({
  category = 'todos',
  search = '',
  line = 'todas',
} = {}) {
  const lines = useMemo(() => {
    const unique = [...new Set(productsData.map((p) => p.line))].sort()
    return unique
  }, [])

  const products = useMemo(() => {
    const query = search.trim().toLowerCase()

    return productsData.filter((product) => {
      const matchesCategory =
        category === 'todos' || product.category === category

      const matchesLine = line === 'todas' || product.line === line

      const matchesSearch =
        !query ||
        product.name.toLowerCase().includes(query) ||
        product.brand.toLowerCase().includes(query) ||
        product.line.toLowerCase().includes(query) ||
        product.description.toLowerCase().includes(query)

      return matchesCategory && matchesLine && matchesSearch
    })
  }, [category, search, line])

  return { products, lines, isLoading: false, error: null, total: products.length }
}
