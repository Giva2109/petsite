const CATEGORIES = [
  { id: 'todos', label: 'Todos', emoji: '🐾' },
  { id: 'caes', label: 'Cães', emoji: '🐕' },
  { id: 'gatos', label: 'Gatos', emoji: '🐈' },
  { id: 'acessorios', label: 'Acessórios', emoji: '🛍️' },
]

export default function CategoryFilter({ activeCategory, onCategoryChange }) {
  return (
    <div
      className="grid w-full grid-cols-2 gap-1.5 sm:flex sm:w-auto sm:gap-2"
      role="tablist"
      aria-label="Filtrar por categoria"
    >
      {CATEGORIES.map((cat) => {
        const isActive = activeCategory === cat.id
        return (
          <button
            key={cat.id}
            type="button"
            role="tab"
            aria-selected={isActive}
            onClick={() => onCategoryChange(cat.id)}
            className={`min-w-0 rounded-full px-2 py-2 text-center text-xs font-semibold leading-tight transition focus:outline-none focus:ring-2 focus:ring-emerald-300 focus:ring-offset-2 sm:shrink-0 sm:px-4 sm:text-sm ${
              isActive
                ? 'bg-emerald-600 text-white shadow-md'
                : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
            }`}
          >
            <span className="inline-flex flex-col items-center justify-center gap-0.5 sm:flex-row sm:gap-1">
              <span aria-hidden="true">{cat.emoji}</span>
              <span className="whitespace-nowrap">{cat.label}</span>
            </span>
          </button>
        )
      })}
    </div>
  )
}
