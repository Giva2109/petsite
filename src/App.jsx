import { useState } from 'react'
import Header from './components/Header'
import ProductGrid from './components/ProductGrid'
import CartDrawer from './components/CartDrawer'
import Footer from './components/Footer'
import Pagination from './components/Pagination'
import { useCart } from './hooks/useCart'
import { useProducts } from './hooks/useProducts'
import { usePagination } from './hooks/usePagination'
import HeroBanner from './components/HeroBanner'
import { PRODUCTS_PER_PAGE } from './config/constants'

function App() {
  const [search, setSearch] = useState('')
  const [category, setCategory] = useState('todos')
  const [line, setLine] = useState('todas')
  const [lifeStage, setLifeStage] = useState('todos')
  const [weight, setWeight] = useState('todos')
  const [isCartOpen, setIsCartOpen] = useState(false)

  const { products, lines, weightOptions, total } = useProducts({
    category,
    search,
    line,
    lifeStage,
    weight,
  })
  const { addItem, totalItems } = useCart()

  const {
    page,
    setPage,
    totalPages,
    paginatedItems,
    pageSize,
    hasNext,
    hasPrev,
  } = usePagination(products, {
    pageSize: PRODUCTS_PER_PAGE,
    resetDeps: [category, search, line, lifeStage, weight],
  })

  const handleAddToCart = (product, quantity) => {
    addItem(product, quantity)
    setIsCartOpen(true)
  }

  return (
    <div className="flex min-h-screen flex-col bg-gradient-to-b from-amber-50/50 via-white to-emerald-50/30">
      <Header
        search={search}
        onSearchChange={setSearch}
        category={category}
        onCategoryChange={setCategory}
        line={line}
        lines={lines}
        onLineChange={setLine}
        lifeStage={lifeStage}
        onLifeStageChange={setLifeStage}
        weight={weight}
        weightOptions={weightOptions}
        onWeightChange={setWeight}
        cartCount={totalItems}
        onCartOpen={() => setIsCartOpen(true)}
      />

      <main className="mx-auto w-full max-w-7xl flex-1 px-4 py-8 sm:px-6 lg:px-8">
        <HeroBanner />

        <section aria-label="Catálogo de produtos">
          <div className="mb-6 flex flex-col gap-1 sm:flex-row sm:items-end sm:justify-between">
            <div>
              <h2 className="text-2xl font-bold text-gray-900">
                Catálogo Completo
              </h2>
              <p className="mt-1 text-sm text-gray-500">
                {total} {total === 1 ? 'produto encontrado' : 'produtos encontrados'}
                {totalPages > 1 && (
                  <span>
                    {' '}
                    · Página {page} de {totalPages}
                  </span>
                )}
              </p>
            </div>
          </div>

          <ProductGrid
            products={paginatedItems}
            onAddToCart={handleAddToCart}
          />

          <Pagination
            page={page}
            totalPages={totalPages}
            totalItems={total}
            pageSize={pageSize}
            onPageChange={setPage}
            hasPrev={hasPrev}
            hasNext={hasNext}
          />
        </section>
      </main>

      <Footer />

      <CartDrawer isOpen={isCartOpen} onClose={() => setIsCartOpen(false)} />
    </div>
  )
}

export default App
