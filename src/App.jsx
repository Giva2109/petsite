import { Navigate, Route, Routes } from 'react-router-dom'
import StorePage from './pages/StorePage'
import StoreLayout from './pages/StoreLayout'
import RegisterCompanyPage from './pages/RegisterCompanyPage'
import AdminLoginPage from './pages/admin/AdminLoginPage'
import AdminProductsPage from './pages/admin/AdminProductsPage'
import AdminSettingsPage from './pages/admin/AdminSettingsPage'
import AdminLayout from './pages/admin/AdminLayout'

export default function App() {
  return (
    <Routes>
      <Route element={<StoreLayout />}>
        <Route path="/" element={<StorePage />} />
        <Route path="/loja/:slug" element={<StorePage />} />
      </Route>
      <Route path="/cadastro" element={<RegisterCompanyPage />} />
      <Route path="/admin/login" element={<AdminLoginPage />} />
      <Route path="/admin" element={<AdminLayout />}>
        <Route index element={<Navigate to="/admin/products" replace />} />
        <Route path="products" element={<AdminProductsPage />} />
        <Route path="settings" element={<AdminSettingsPage />} />
      </Route>
      <Route path="*" element={<Navigate to="/" replace />} />
    </Routes>
  )
}
