import { Link, Navigate, Outlet, useLocation } from 'react-router-dom'
import { useAuth } from '../../context/AuthContext'

export default function AdminLayout() {
  const { isAuthenticated } = useAuth()
  const location = useLocation()

  if (!isAuthenticated) {
    return <Navigate to="/admin/login" state={{ from: location.pathname }} replace />
  }

  return (
    <div className="min-h-screen bg-gray-50">
      <header className="border-b border-gray-200 bg-white">
        <div className="mx-auto flex max-w-6xl items-center justify-between px-4 py-4">
          <div>
            <p className="text-lg font-bold text-emerald-800">Painel Admin</p>
            <p className="text-sm text-gray-500">Gerencie produtos e configurações</p>
          </div>
          <nav className="flex items-center gap-4 text-sm font-medium">
            <Link to="/admin/products" className="text-gray-700 hover:text-emerald-700">
              Produtos
            </Link>
            <Link to="/admin/settings" className="text-gray-700 hover:text-emerald-700">
              Configurações
            </Link>
            <Link to="/" className="text-gray-700 hover:text-emerald-700">
              Ver loja
            </Link>
          </nav>
        </div>
      </header>
      <main className="mx-auto max-w-6xl px-4 py-8">
        <Outlet />
      </main>
    </div>
  )
}
