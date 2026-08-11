export default function AccessoryTypeFilter({
  activeType,
  onTypeChange,
  types = [],
}) {
  return (
    <div>
      <label htmlFor="accessory-type-filter" className="sr-only">
        Tipo de acessório
      </label>
      <select
        id="accessory-type-filter"
        value={activeType}
        onChange={(e) => onTypeChange(e.target.value)}
        className="w-full rounded-xl border border-gray-200 bg-gray-50 px-3 py-2.5 text-sm font-medium text-gray-800 focus:border-emerald-400 focus:bg-white focus:outline-none focus:ring-2 focus:ring-emerald-200 sm:w-auto"
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
