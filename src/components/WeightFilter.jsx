export default function WeightFilter({
  weightOptions,
  activeWeight,
  onWeightChange,
}) {
  const { grams, kilos, other } = weightOptions
  const hasOptions = grams.length > 0 || kilos.length > 0 || other.length > 0

  if (!hasOptions) return null

  return (
    <div className="min-w-0 flex-1 sm:flex-none">
      <label htmlFor="weight-filter" className="sr-only">
        Filtrar por peso da embalagem
      </label>
      <select
        id="weight-filter"
        value={activeWeight}
        onChange={(e) => onWeightChange(e.target.value)}
        className="filter-select w-full min-w-0 rounded-lg border border-gray-200 bg-gray-50 px-0.5 py-2 text-xs font-semibold leading-tight tracking-tight text-gray-800 focus:border-emerald-400 focus:bg-white focus:outline-none focus:ring-2 focus:ring-emerald-200 sm:w-auto sm:rounded-xl sm:px-3 sm:py-2.5 sm:text-sm sm:tracking-normal"
      >
        <option value="todos">Todos os pesos</option>
        {grams.length > 0 && (
          <optgroup label="Gramas (g)">
            {grams.map((weight) => (
              <option key={weight} value={weight}>
                {weight}
              </option>
            ))}
          </optgroup>
        )}
        {kilos.length > 0 && (
          <optgroup label="Quilos (kg)">
            {kilos.map((weight) => (
              <option key={weight} value={weight}>
                {weight}
              </option>
            ))}
          </optgroup>
        )}
        {other.length > 0 && (
          <optgroup label="Outros">
            {other.map((weight) => (
              <option key={weight} value={weight}>
                {weight}
              </option>
            ))}
          </optgroup>
        )}
      </select>
    </div>
  )
}
