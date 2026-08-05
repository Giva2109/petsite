import { useState } from 'react'
import { Minus, Plus, ShoppingBag, MessageCircle } from 'lucide-react'
import { formatCurrency } from '../utils/currency'
import { openWhatsAppAvailability } from '../utils/whatsapp'

export default function ProductCard({ product, onAddToCart }) {
  const [quantity, setQuantity] = useState(1)
  const [imageError, setImageError] = useState(false)

  const hasDiscount =
    product.originalPrice && product.originalPrice > product.price

  const discountPercent = hasDiscount
    ? Math.round(
        ((product.originalPrice - product.price) / product.originalPrice) * 100
      )
    : 0

  const handleDecrease = () => setQuantity((q) => Math.max(1, q - 1))
  const handleIncrease = () => setQuantity((q) => q + 1)

  const handleAdd = () => {
    onAddToCart(product, quantity)
    setQuantity(1)
  }

  const handleAvailability = () => {
    openWhatsAppAvailability({ product })
  }

  return (
    <article className="group flex flex-col overflow-hidden rounded-2xl border border-gray-100 bg-white shadow-sm transition hover:shadow-lg">
      <div className="relative aspect-square overflow-hidden bg-gradient-to-br from-amber-50 to-emerald-50 p-2">
        {!imageError ? (
          <img
            src={product.image}
            alt={product.name}
            className="h-full w-full object-contain transition duration-300 group-hover:scale-105"
            onError={() => setImageError(true)}
            loading="lazy"
            decoding="async"
          />
        ) : (
          <div className="flex h-full flex-col items-center justify-center gap-2 p-4 text-center text-emerald-700">
            <span className="text-5xl" aria-hidden="true">
              {product.category === 'caes' ? '🐕' : '🐈'}
            </span>
            <p className="text-sm font-medium">Imagem em breve</p>
          </div>
        )}

        {hasDiscount && (
          <span className="absolute left-3 top-3 rounded-full bg-red-500 px-2.5 py-1 text-xs font-bold text-white">
            -{discountPercent}%
          </span>
        )}

        <span className="absolute right-3 top-3 rounded-full bg-white/90 px-2.5 py-1 text-xs font-semibold text-gray-700 shadow">
          {product.weight}
        </span>
      </div>

      <div className="flex flex-1 flex-col p-4">
        <p className="text-xs font-medium uppercase tracking-wide text-emerald-600">
          {product.line || product.brand}
        </p>
        <h3 className="mt-1 text-base font-bold leading-snug text-gray-900 sm:text-lg">
          {product.name}
        </h3>
        <p className="mt-1 line-clamp-2 text-sm text-gray-500">
          {product.description}
        </p>

        <div className="mt-3 flex items-baseline gap-2">
          <span
            className={`text-xl font-bold ${
              product.price != null ? 'text-emerald-700' : 'text-amber-600'
            }`}
          >
            {formatCurrency(product.price)}
          </span>
          {hasDiscount && (
            <span className="text-sm text-gray-400 line-through">
              {formatCurrency(product.originalPrice)}
            </span>
          )}
        </div>

        <div className="mt-4 flex items-center gap-3">
          <div className="flex items-center rounded-xl border border-gray-200 bg-gray-50">
            <button
              type="button"
              onClick={handleDecrease}
              className="flex h-10 w-10 items-center justify-center rounded-l-xl text-gray-600 transition hover:bg-gray-200 focus:outline-none focus:ring-2 focus:ring-emerald-300"
              aria-label="Diminuir quantidade"
            >
              <Minus className="h-4 w-4" />
            </button>
            <span
              className="min-w-8 text-center text-base font-semibold text-gray-900"
              aria-live="polite"
            >
              {quantity}
            </span>
            <button
              type="button"
              onClick={handleIncrease}
              className="flex h-10 w-10 items-center justify-center rounded-r-xl text-gray-600 transition hover:bg-gray-200 focus:outline-none focus:ring-2 focus:ring-emerald-300"
              aria-label="Aumentar quantidade"
            >
              <Plus className="h-4 w-4" />
            </button>
          </div>
        </div>

        <button
          type="button"
          onClick={handleAdd}
          className="mt-4 flex w-full items-center justify-center gap-2 rounded-xl bg-amber-500 py-3 text-base font-bold text-white shadow-md transition hover:bg-amber-600 focus:outline-none focus:ring-2 focus:ring-amber-300 focus:ring-offset-2"
        >
          <ShoppingBag className="h-5 w-5" aria-hidden="true" />
          Adicionar ao Pedido
        </button>

        <button
          type="button"
          onClick={handleAvailability}
          className="mt-2 flex w-full items-center justify-center gap-2 rounded-xl border border-green-200 bg-green-50 py-2.5 text-sm font-semibold text-green-700 transition hover:bg-green-100 focus:outline-none focus:ring-2 focus:ring-green-300 focus:ring-offset-2"
        >
          <MessageCircle className="h-4 w-4" aria-hidden="true" />
          Consultar disponibilidade
        </button>
      </div>
    </article>
  )
}
