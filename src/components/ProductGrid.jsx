import ProductCard from './ProductCard'
import { PackageOpen } from 'lucide-react'

export default function ProductGrid({ products, onAddToCart }) {
  if (products.length === 0) {
    return (
      <div className="flex flex-col items-center justify-center rounded-2xl border-2 border-dashed border-gray-200 bg-white py-16 text-center">
        <PackageOpen className="h-12 w-12 text-gray-300" aria-hidden="true" />
        <p className="mt-4 text-lg font-semibold text-gray-700">
          Nenhum produto encontrado
        </p>
        <p className="mt-1 text-sm text-gray-500">
          Tente outro termo de busca ou filtro de categoria.
        </p>
      </div>
    )
  }

  return (
    <div className="grid grid-cols-1 gap-5 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
      {products.map((product) => (
        <ProductCard
          key={product.id}
          product={product}
          onAddToCart={onAddToCart}
        />
      ))}
    </div>
  )
}
