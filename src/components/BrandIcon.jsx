import { STORE_NAME } from '../config/constants'

const SIZES = {
  sm: 'h-9 w-9',
  md: 'h-10 w-10',
}

export default function BrandIcon({ size = 'md', className = '' }) {
  return (
    <img
      src="/logo-icon.webp"
      alt={`${STORE_NAME} logo`}
      className={`shrink-0 rounded-xl object-contain ${SIZES[size]} ${className}`}
      decoding="async"
    />
  )
}
