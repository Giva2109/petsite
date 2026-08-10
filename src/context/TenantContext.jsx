import {
  createContext,
  useCallback,
  useContext,
  useEffect,
  useMemo,
  useState,
} from 'react'
import { DEFAULT_TENANT_SLUG, WHATSAPP_NUMBER } from '../config/constants'
import { fetchCatalog } from '../utils/catalogApi'
import productsFallback from '../data/products.json'

const TenantContext = createContext(null)

function mapApiProduct(product) {
  return {
    id: product.id,
    name: product.name,
    category: product.category,
    brand: product.brand,
    line: product.line,
    price: product.price != null ? Number(product.price) : null,
    originalPrice:
      product.originalPrice != null ? Number(product.originalPrice) : null,
    image: product.image,
    description: product.description,
    weight: product.weight,
    stock: product.stock,
    catalogPage: product.catalogPage,
  }
}

const defaultTenant = {
  slug: DEFAULT_TENANT_SLUG,
  name: 'UniPet',
  whatsappNumber: WHATSAPP_NUMBER,
  logoUrl: '/logo.webp',
  logoIconUrl: '/logo-icon.webp',
  tagline: 'Catálogo 2026 — rações e acessórios para cães e gatos',
}

const defaultSettings = {
  discountNeighborhood: 'Parque Cecap',
  discountPercent: 10,
  mercadoPagoPublicKey: null,
  mercadoPagoEnabled: false,
  pixKeyType: null,
  pixKey: null,
  staticPixEnabled: false,
}

export function TenantProvider({ tenantSlug, children }) {
  const [tenant, setTenant] = useState(defaultTenant)
  const [settings, setSettings] = useState(defaultSettings)
  const [products, setProducts] = useState(productsFallback)
  const [isLoading, setIsLoading] = useState(true)
  const [error, setError] = useState(null)
  const [source, setSource] = useState('fallback')

  const loadCatalog = useCallback(async () => {
    setIsLoading(true)
    setError(null)

    try {
      const host =
        typeof window !== 'undefined' ? window.location.hostname : null
      const data = await fetchCatalog({
        slug: tenantSlug || null,
        host,
      })

      setTenant({
        slug: data.tenant.slug,
        name: data.tenant.name,
        whatsappNumber: data.tenant.whatsappNumber || WHATSAPP_NUMBER,
        logoUrl: data.tenant.logoUrl || '/logo.webp',
        logoIconUrl: data.tenant.logoIconUrl || '/logo-icon.webp',
        tagline: data.tenant.tagline || defaultTenant.tagline,
      })
      setSettings({
        discountNeighborhood: data.settings?.discountNeighborhood || null,
        discountPercent: Number(data.settings?.discountPercent || 0),
        mercadoPagoPublicKey: data.settings?.mercadoPagoPublicKey || null,
        mercadoPagoEnabled: Boolean(data.settings?.mercadoPagoEnabled),
        pixKeyType: data.settings?.pixKeyType || null,
        pixKey: data.settings?.pixKey || null,
        staticPixEnabled: Boolean(data.settings?.staticPixEnabled),
      })
      setProducts(data.products.map(mapApiProduct))
      setSource('api')
    } catch (err) {
      setError(err.message)
      setTenant({
        ...defaultTenant,
        slug: tenantSlug || DEFAULT_TENANT_SLUG,
      })
      setSettings(defaultSettings)
      setProducts(productsFallback)
      setSource('fallback')
    } finally {
      setIsLoading(false)
    }
  }, [tenantSlug])

  useEffect(() => {
    loadCatalog()
  }, [loadCatalog])

  const value = useMemo(
    () => ({
      tenant,
      settings,
      products,
      isLoading,
      error,
      source,
      reloadCatalog: loadCatalog,
    }),
    [tenant, settings, products, isLoading, error, source, loadCatalog]
  )

  return (
    <TenantContext.Provider value={value}>{children}</TenantContext.Provider>
  )
}

export function useTenant() {
  const context = useContext(TenantContext)
  if (!context) {
    throw new Error('useTenant deve ser usado dentro de TenantProvider')
  }
  return context
}
