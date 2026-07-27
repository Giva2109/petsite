/**
 * Configurações globais da loja.
 * Para alterar o WhatsApp em produção, edite aqui ou use VITE_WHATSAPP_NUMBER no .env
 */
export const WHATSAPP_NUMBER =
  import.meta.env.VITE_WHATSAPP_NUMBER || '5511942232220'

export const STORE_NAME = 'UniPet'
export const STORE_TAGLINE =
  'Catálogo 2026 — rações e acessórios para cães e gatos'

/** Produtos exibidos por página (paginação local) */
export const PRODUCTS_PER_PAGE = 12
