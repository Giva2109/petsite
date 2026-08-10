import { useState } from 'react'
import { Link, Navigate, useLocation, useNavigate } from 'react-router-dom'
import { useAuth } from '../../context/AuthContext'
import { DEFAULT_TENANT_SLUG } from '../../config/constants'

export default function AdminLoginPage() {
  const { login, isAuthenticated } = useAuth()
  const navigate = useNavigate()
  const location = useLocation()
  const [tenantSlug, setTenantSlug] = useState(
    location.state?.tenantSlug || DEFAULT_TENANT_SLUG
  )
  const [email, setEmail] = useState(location.state?.email || '')
  const [password, setPassword] = useState('')
  const [error, setError] = useState('')
  const [isSubmitting, setIsSubmitting] = useState(false)

  if (isAuthenticated) {
    return <Navigate to="/admin/products" replace />
  }

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

  return (
    <div className="flex min-h-screen items-center justify-center bg-gradient-to-br from-emerald-50 to-amber-50 px-4">
      <form
        onSubmit={handleSubmit}
        className="w-full max-w-md rounded-2xl bg-white p-8 shadow-xl"
      >
        <h1 className="text-2xl font-bold text-gray-900">Entrar no painel</h1>
        <p className="mt-2 text-sm text-gray-500">
          Gerencie produtos, preços, estoque e identidade da loja.
        </p>

        <div className="mt-6 space-y-4">
          <div>
            <label className="mb-1 block text-sm font-medium text-gray-700">
              Loja (slug)
            </label>
            <input
              value={tenantSlug}
              onChange={(e) => setTenantSlug(e.target.value)}
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

        <p className="mt-2 text-center text-xs text-gray-400">
          Primeiro acesso UniPet: admin@unipet1.com / UniPet@2026
        </p>
      </form>
    </div>
  )
}
