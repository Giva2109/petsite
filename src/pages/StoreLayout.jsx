import { Outlet, useParams } from 'react-router-dom'
import { TenantProvider } from '../context/TenantContext'

export default function StoreLayout() {
  const { slug } = useParams()

  return (
    <TenantProvider tenantSlug={slug}>
      <Outlet />
    </TenantProvider>
  )
}
