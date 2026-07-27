import { Search, ShoppingCart } from 'lucide-react'
import { STORE_NAME } from '../config/constants'
import CategoryFilter from './CategoryFilter'
import LineFilter from './LineFilter'
import BrandIcon from './BrandIcon'

export default function Header({
  search,
  onSearchChange,
  category,
  onCategoryChange,
  line,
  lines,
  onLineChange,
  cartCount,
  onCartOpen,
}) {
  return (
    <header className="sticky top-0 z-40 border-b border-emerald-100 bg-white/95 shadow-sm backdrop-blur-md">
      <div className="mx-auto max-w-7xl px-4 py-3 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between gap-3">
          <a href="#" className="flex shrink-0 items-center gap-2">
            <BrandIcon size="md" />
            <div className="hidden sm:block">
              <p className="text-lg font-bold leading-tight text-emerald-900">
                {STORE_NAME}
              </p>
              <p className="text-xs text-emerald-600">Catálogo 2026</p>
            </div>
          </a>

          <div className="relative flex-1 max-w-md">
            <Search
              className="pointer-events-none absolute left-3 top-1/2 h-5 w-5 -translate-y-1/2 text-gray-400"
              aria-hidden="true"
            />
            <input
              type="search"
              placeholder="Buscar por nome, linha ou sabor..."
              value={search}
              onChange={(e) => onSearchChange(e.target.value)}
              className="w-full rounded-xl border border-gray-200 bg-gray-50 py-2.5 pl-10 pr-4 text-base text-gray-900 placeholder:text-gray-400 focus:border-emerald-400 focus:bg-white focus:outline-none focus:ring-2 focus:ring-emerald-200"
              aria-label="Buscar produtos"
            />
          </div>

          <button
            type="button"
            onClick={onCartOpen}
            className="relative flex h-11 w-11 shrink-0 items-center justify-center rounded-xl bg-amber-500 text-white shadow-md transition hover:bg-amber-600 focus:outline-none focus:ring-2 focus:ring-amber-300 focus:ring-offset-2"
            aria-label={`Abrir carrinho${cartCount > 0 ? `, ${cartCount} itens` : ''}`}
          >
            <ShoppingCart className="h-5 w-5" aria-hidden="true" />
            {cartCount > 0 && (
              <span className="absolute -right-1.5 -top-1.5 flex h-5 min-w-5 items-center justify-center rounded-full bg-red-500 px-1 text-xs font-bold text-white">
                {cartCount > 99 ? '99+' : cartCount}
              </span>
            )}
          </button>
        </div>

        <div className="mt-3 flex flex-col gap-2 sm:flex-row sm:items-center sm:justify-between">
          <CategoryFilter
            activeCategory={category}
            onCategoryChange={onCategoryChange}
          />
          <LineFilter
            lines={lines}
            activeLine={line}
            onLineChange={onLineChange}
          />
        </div>
      </div>
    </header>
  )
}
