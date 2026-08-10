/**
 * Configurações globais da loja.
 * Para alterar o WhatsApp em produção, edite aqui ou use VITE_WHATSAPP_NUMBER no .env
 */
export const WHATSAPP_NUMBER =
  import.meta.env.VITE_WHATSAPP_NUMBER || '5511942232220'

export const STORE_NAME = 'UniPet'
export const STORE_URL = 'https://unipet1.com'
export const DEFAULT_TENANT_SLUG =
  import.meta.env.VITE_TENANT_SLUG || 'unipet'
export const STORE_TAGLINE =
  'Catálogo 2026 — rações e acessórios para cães e gatos'

/** Produtos exibidos por página (paginação local) */
export const PRODUCTS_PER_PAGE = 12

/** Chave pública do Mercado Pago (segura no frontend) */
export const MERCADOPAGO_PUBLIC_KEY =
  import.meta.env.VITE_MERCADOPAGO_PUBLIC_KEY || ''

/** URL da API Java (Fly.io). Em dev, use proxy do Vite com string vazia. */
export const API_BASE_URL = import.meta.env.VITE_API_URL || ''
