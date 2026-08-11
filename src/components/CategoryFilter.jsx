const CATEGORIES = [
  { id: 'todos', label: 'Todos', emoji: '🐾' },
  { id: 'caes', label: 'Cães', emoji: '🐕' },
  { id: 'gatos', label: 'Gatos', emoji: '🐈' },
  { id: 'acessorios', label: 'Acessórios', emoji: '🛍️' },
]

export default function CategoryFilter({ activeCategory, onCategoryChange }) {
  return (
    <div
      className="flex gap-2 overflow-x-auto pb-1 scrollbar-hide"
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
            className={`shrink-0 rounded-full px-4 py-2 text-sm font-semibold transition focus:outline-none focus:ring-2 focus:ring-emerald-300 focus:ring-offset-2 ${
              isActive
                ? 'bg-emerald-600 text-white shadow-md'
                : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
            }`}
          >
            <span aria-hidden="true">{cat.emoji}</span> {cat.label}
          </button>
        )
      })}
    </div>
  )
}
