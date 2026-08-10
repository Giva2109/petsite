import { Link, Navigate, Outlet, useLocation, useNavigate } from 'react-router-dom'
import { useAuth } from '../../context/AuthContext'
import { buildStorePath } from '../../utils/catalogApi'

export default function AdminLayout() {
  const { isAuthenticated, session, logout } = useAuth()
  const location = useLocation()
  const navigate = useNavigate()

  if (!isAuthenticated) {
    return <Navigate to="/admin/login" state={{ from: location.pathname }} replace />
  }

  const handleLogout = () => {
    logout()
    navigate('/admin/login', { replace: true })
  }

  return (
    <div className="min-h-screen bg-gray-50">
      <header className="border-b border-gray-200 bg-white">
        <div className="mx-auto flex max-w-6xl flex-wrap items-center justify-between gap-4 px-4 py-4">
          <div>
            <p className="text-lg font-bold text-emerald-800">Painel Admin</p>
            <p className="text-sm text-gray-500">
              Loja: <span className="font-semibold text-emerald-700">{session.tenantSlug}</span>
              {session.email ? ` · ${session.email}` : ''}
            </p>
          </div>
          <nav className="flex flex-wrap items-center gap-4 text-sm font-medium">
            <Link to="/admin/products" className="text-gray-700 hover:text-emerald-700">
              Produtos
            </Link>
            <Link to="/admin/settings" className="text-gray-700 hover:text-emerald-700">
              Configurações
            </Link>
            <Link
              to={buildStorePath(session.tenantSlug)}
              className="text-gray-700 hover:text-emerald-700"
            >
              Ver loja
            </Link>
            <button
              type="button"
              onClick={handleLogout}
              className="rounded-lg border border-gray-200 px-3 py-1.5 text-gray-700 hover:bg-gray-50"
            >
              Sair
            </button>
          </nav>
        </div>
      </header>
      <main className="mx-auto max-w-6xl px-4 py-8">
        <Outlet />
      </main>
    </div>
  )
}
