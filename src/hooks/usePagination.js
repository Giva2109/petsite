import { useState, useEffect, useMemo, useCallback } from 'react'

/**
 * Paginação local em memória (sem backend).
 * @param {Array} items - Lista completa filtrada
 * @param {{ pageSize?: number, resetDeps?: unknown[] }} options
 */
export function usePagination(items, { pageSize = 12, resetDeps = [] } = {}) {
  const [page, setPage] = useState(1)

  const totalPages = Math.max(1, Math.ceil(items.length / pageSize))

  const safePage = Math.min(page, totalPages)

  const paginatedItems = useMemo(() => {
    const start = (safePage - 1) * pageSize
    return items.slice(start, start + pageSize)
  }, [items, safePage, pageSize])

  const goToPage = useCallback(
    (nextPage) => {
      setPage(Math.max(1, Math.min(totalPages, nextPage)))
    },
    [totalPages]
  )

  const nextPage = useCallback(() => goToPage(safePage + 1), [goToPage, safePage])
  const prevPage = useCallback(() => goToPage(safePage - 1), [goToPage, safePage])

  // Volta à página 1 quando filtros mudam
  useEffect(() => {
    setPage(1)
  }, [items.length, pageSize, ...resetDeps])

  return {
    page: safePage,
    setPage: goToPage,
    nextPage,
    prevPage,
    totalPages,
    paginatedItems,
    pageSize,
    totalItems: items.length,
    hasNext: safePage < totalPages,
    hasPrev: safePage > 1,
  }
}
