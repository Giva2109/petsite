export default function AccessoryTypeFilter({
  activeType,
  onTypeChange,
  types = [],
}) {
  return (
    <div className="min-w-0 flex-1 sm:flex-none">
      <label htmlFor="accessory-type-filter" className="sr-only">
        Tipo de acessório
      </label>
      <select
        id="accessory-type-filter"
        value={activeType}
        onChange={(e) => onTypeChange(e.target.value)}
        className="filter-select w-full min-w-0 rounded-lg border border-gray-200 bg-gray-50 px-0.5 py-2 text-xs font-semibold leading-tight tracking-tight text-gray-800 focus:border-emerald-400 focus:bg-white focus:outline-none focus:ring-2 focus:ring-emerald-200 sm:w-auto sm:rounded-xl sm:px-3 sm:py-2.5 sm:text-sm sm:tracking-normal"
      >
        <option value="todos">Todos os acessórios</option>
        {types.map((type) => (
          <option key={type} value={type}>
            {type}
          </option>
        ))}
      </select>
    </div>
  )
}
