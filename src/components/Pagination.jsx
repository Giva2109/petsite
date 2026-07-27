import { ChevronLeft, ChevronRight } from 'lucide-react'

export default function Pagination({
  page,
  totalPages,
  totalItems,
  pageSize,
  onPageChange,
  hasPrev,
  hasNext,
}) {
  if (totalItems === 0) return null

  const start = (page - 1) * pageSize + 1
  const end = Math.min(page * pageSize, totalItems)

  const pages = buildPageNumbers(page, totalPages)

  return (
    <nav
      className="mt-8 flex flex-col items-center gap-4 sm:flex-row sm:justify-between"
      aria-label="Paginação do catálogo"
    >
      <p className="text-sm text-gray-500">
        Exibindo <span className="font-semibold text-gray-700">{start}–{end}</span>{' '}
        de <span className="font-semibold text-gray-700">{totalItems}</span> produtos
      </p>

      <div className="flex items-center gap-1">
        <button
          type="button"
          onClick={() => onPageChange(page - 1)}
          disabled={!hasPrev}
          className="flex h-10 w-10 items-center justify-center rounded-xl border border-gray-200 bg-white text-gray-600 transition hover:bg-gray-50 disabled:cursor-not-allowed disabled:opacity-40"
          aria-label="Página anterior"
        >
          <ChevronLeft className="h-5 w-5" />
        </button>

        {pages.map((p, idx) =>
          p === '...' ? (
            <span
              key={`ellipsis-${idx}`}
              className="flex h-10 w-8 items-center justify-center text-gray-400"
            >
              …
            </span>
          ) : (
            <button
              key={p}
              type="button"
              onClick={() => onPageChange(p)}
              aria-current={p === page ? 'page' : undefined}
              className={`flex h-10 min-w-10 items-center justify-center rounded-xl px-3 text-sm font-semibold transition ${
                p === page
                  ? 'bg-emerald-600 text-white shadow-md'
                  : 'border border-gray-200 bg-white text-gray-700 hover:bg-gray-50'
              }`}
            >
              {p}
            </button>
          )
        )}

        <button
          type="button"
          onClick={() => onPageChange(page + 1)}
          disabled={!hasNext}
          className="flex h-10 w-10 items-center justify-center rounded-xl border border-gray-200 bg-white text-gray-600 transition hover:bg-gray-50 disabled:cursor-not-allowed disabled:opacity-40"
          aria-label="Próxima página"
        >
          <ChevronRight className="h-5 w-5" />
        </button>
      </div>
    </nav>
  )
}

function buildPageNumbers(current, total) {
  if (total <= 7) {
    return Array.from({ length: total }, (_, i) => i + 1)
  }

  const pages = [1]

  if (current > 3) pages.push('...')

  for (let p = Math.max(2, current - 1); p <= Math.min(total - 1, current + 1); p++) {
    pages.push(p)
  }

  if (current < total - 2) pages.push('...')

  pages.push(total)
  return pages
}
