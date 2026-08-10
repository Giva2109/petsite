import { useTenant } from '../context/TenantContext'

const SIZES = {
  sm: 'h-9 w-9',
  md: 'h-10 w-10',
}

export default function BrandIcon({ size = 'md', className = '' }) {
  const { tenant } = useTenant()

  return (
    <img
      src={tenant.logoIconUrl || '/logo-icon.webp'}
      alt={`${tenant.name} logo`}
      className={`shrink-0 rounded-xl object-contain ${SIZES[size]} ${className}`}
      decoding="async"
    />
  )
}
