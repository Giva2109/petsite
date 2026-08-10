import { useState } from 'react'
import { Link, useLocation, useNavigate } from 'react-router-dom'
import { useAuth } from '../../context/AuthContext'
import { buildStoreUrl } from '../../utils/catalogApi'

export default function AdminLoginPage() {
  const { login, logout, isAuthenticated, session } = useAuth()
  const navigate = useNavigate()
  const location = useLocation()
  const [tenantSlug, setTenantSlug] = useState(
    location.state?.tenantSlug || ''
  )
  const [email, setEmail] = useState(location.state?.email || '')
  const [password, setPassword] = useState('')
  const [error, setError] = useState('')
  const [isSubmitting, setIsSubmitting] = useState(false)

  const handleSubmit = async (event) => {
    event.preventDefault()
    setError('')
    setIsSubmitting(true)

    try {
      await login({ tenantSlug, email, password })
      const redirectTo = location.state?.from || '/admin/products'
      navigate(redirectTo, { replace: true })
    } catch (err) {
      setError(err.message)
    } finally {
      setIsSubmitting(false)
    }
  }

  const handleSwitchAccount = () => {
    logout()
    setPassword('')
    setError('')
  }

  if (isAuthenticated) {
    return (
      <div className="flex min-h-screen items-center justify-center bg-gradient-to-br from-emerald-50 to-amber-50 px-4">
        <div className="w-full max-w-md rounded-2xl bg-white p-8 shadow-xl">
          <h1 className="text-2xl font-bold text-gray-900">Sessão ativa</h1>
          <p className="mt-2 text-sm text-gray-500">
            Você já está logado na loja{' '}
            <span className="font-semibold text-emerald-700">
              {session.tenantSlug}
            </span>
            {session.email ? ` (${session.email})` : ''}.
          </p>
          <p className="mt-2 text-sm text-gray-500">
            Por isso os produtos exibidos são dessa loja. Para entrar em outra,
            saia primeiro.
          </p>

          <div className="mt-6 space-y-3">
            <button
              type="button"
              onClick={() => navigate('/admin/products', { replace: true })}
              className="w-full rounded-xl bg-emerald-600 py-3 font-semibold text-white hover:bg-emerald-700"
            >
              Continuar no painel
            </button>
            <button
              type="button"
              onClick={handleSwitchAccount}
              className="w-full rounded-xl border border-gray-200 py-3 font-semibold text-gray-700 hover:bg-gray-50"
            >
              Sair e entrar com outra loja
            </button>
            <a
              href={buildStoreUrl(session.tenantSlug)}
              className="block text-center text-sm font-medium text-emerald-700 underline"
            >
              Ver loja pública
            </a>
          </div>
        </div>
      </div>
    )
  }

  return (
    <div className="flex min-h-screen items-center justify-center bg-gradient-to-br from-emerald-50 to-amber-50 px-4">
      <form
        onSubmit={handleSubmit}
        className="w-full max-w-md rounded-2xl bg-white p-8 shadow-xl"
      >
        <h1 className="text-2xl font-bold text-gray-900">Entrar no painel</h1>
        <p className="mt-2 text-sm text-gray-500">
          Use o <strong>slug</strong> da sua loja (ex: petgiva). Cada loja tem
          produtos e admin separados.
        </p>

        <div className="mt-6 space-y-4">
          <div>
            <label className="mb-1 block text-sm font-medium text-gray-700">
              Loja (slug) *
            </label>
            <input
              value={tenantSlug}
              onChange={(e) => setTenantSlug(e.target.value.trim().toLowerCase())}
              placeholder="ex: petgiva"
              className="w-full rounded-xl border border-gray-200 px-3 py-2.5"
              required
            />
          </div>
          <div>
            <label className="mb-1 block text-sm font-medium text-gray-700">
              E-mail
            </label>
            <input
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              className="w-full rounded-xl border border-gray-200 px-3 py-2.5"
              required
            />
          </div>
          <div>
            <label className="mb-1 block text-sm font-medium text-gray-700">
              Senha
            </label>
            <input
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              className="w-full rounded-xl border border-gray-200 px-3 py-2.5"
              required
            />
          </div>
        </div>

        {error && (
          <p className="mt-4 rounded-xl bg-red-50 px-3 py-2 text-sm text-red-700">
            {error}
          </p>
        )}

        <button
          type="submit"
          disabled={isSubmitting}
          className="mt-6 w-full rounded-xl bg-emerald-600 py-3 font-semibold text-white hover:bg-emerald-700 disabled:opacity-60"
        >
          {isSubmitting ? 'Entrando...' : 'Entrar'}
        </button>

        {location.state?.storeUrl && (
          <p className="mt-4 rounded-xl bg-emerald-50 px-3 py-2 text-sm text-emerald-800">
            Sua loja:{' '}
            <a
              href={location.state.storeUrl}
              className="font-semibold underline"
              target="_blank"
              rel="noreferrer"
            >
              {location.state.storeUrl}
            </a>
          </p>
        )}

        <p className="mt-4 text-center text-sm text-gray-500">
          Ainda não tem loja?{' '}
          <Link to="/cadastro" className="font-semibold text-emerald-700">
            Cadastrar empresa
          </Link>
        </p>
      </form>
    </div>
  )
}
