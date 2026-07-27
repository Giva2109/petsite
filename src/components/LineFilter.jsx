export default function LineFilter({ lines, activeLine, onLineChange }) {
  return (
    <div className="mt-2">
      <label htmlFor="line-filter" className="sr-only">
        Filtrar por linha do catálogo
      </label>
      <select
        id="line-filter"
        value={activeLine}
        onChange={(e) => onLineChange(e.target.value)}
        className="w-full rounded-xl border border-gray-200 bg-gray-50 px-3 py-2.5 text-sm font-medium text-gray-800 focus:border-emerald-400 focus:bg-white focus:outline-none focus:ring-2 focus:ring-emerald-200 sm:w-auto"
      >
        <option value="todas">Todas as linhas</option>
        {lines.map((line) => (
          <option key={line} value={line}>
            {line}
          </option>
        ))}
      </select>
    </div>
  )
}
