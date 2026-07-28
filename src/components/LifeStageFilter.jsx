export default function LifeStageFilter({ activeLifeStage, onLifeStageChange }) {
  return (
    <div className="mt-2">
      <label htmlFor="life-stage-filter" className="sr-only">
        Filtrar por estágio de vida
      </label>
      <select
        id="life-stage-filter"
        value={activeLifeStage}
        onChange={(e) => onLifeStageChange(e.target.value)}
        className="w-full rounded-xl border border-gray-200 bg-gray-50 px-3 py-2.5 text-sm font-medium text-gray-800 focus:border-emerald-400 focus:bg-white focus:outline-none focus:ring-2 focus:ring-emerald-200 sm:w-auto"
      >
        <option value="todos">Todas as idades</option>
        <option value="filhotes">Filhotes</option>
        <option value="adultos">Adultos</option>
      </select>
    </div>
  )
}
