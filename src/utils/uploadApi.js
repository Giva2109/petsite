import { API_BASE_URL } from '../config/constants'

function getApiBase() {
  if (API_BASE_URL) {
    return `${API_BASE_URL}/api`
  }
  if (import.meta.env.PROD) {
    throw new Error('API não configurada. Defina VITE_API_URL no Netlify.')
  }
  return '/api'
}

export async function uploadAdminImage({ file, token, folder = 'products' }) {
  const formData = new FormData()
  formData.append('file', file)

  const response = await fetch(`${getApiBase()}/admin/uploads/${folder}`, {
    method: 'POST',
    headers: {
      Authorization: `Bearer ${token}`,
    },
    body: formData,
  })

  const data = await response.json().catch(() => ({}))
  if (!response.ok) {
    throw new Error(data.detail || data.title || 'Falha ao enviar imagem')
  }
  return data
}
