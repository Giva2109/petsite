export const PIX_KEY_TYPES = [
  { value: 'PHONE', label: 'Telefone' },
  { value: 'CPF', label: 'CPF' },
  { value: 'CNPJ', label: 'CNPJ' },
  { value: 'EMAIL', label: 'E-mail' },
  { value: 'RANDOM', label: 'Chave aleatória' },
]

export function normalizePixKey(pixKeyType, pixKey) {
  const type = String(pixKeyType || '').toUpperCase()
  const raw = String(pixKey || '').trim()
  if (!type || !raw) return ''

  if (type === 'PHONE') {
    const digits = raw.replace(/\D/g, '')
    if (digits.startsWith('55')) return `+${digits}`
    return `+55${digits}`
  }

  if (type === 'CPF' || type === 'CNPJ') {
    return raw.replace(/\D/g, '')
  }

  return raw
}

export function formatPixKeyLabel(pixKeyType) {
  return PIX_KEY_TYPES.find((item) => item.value === pixKeyType)?.label || 'Pix'
}
