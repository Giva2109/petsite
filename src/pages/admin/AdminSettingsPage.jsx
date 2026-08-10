import { useEffect, useState } from 'react'
import { useAuth } from '../../context/AuthContext'
import { useTenant } from '../../context/TenantContext'
import ImageUploadField from '../../components/admin/ImageUploadField'
import { buildStoreUrl } from '../../utils/catalogApi'

export default function AdminSettingsPage() {
  const { authorizedFetch, session } = useAuth()
  const { reloadCatalog } = useTenant()
  const [form, setForm] = useState({
    name: '',
    whatsappNumber: '',
    logoUrl: '',
    logoIconUrl: '',
    tagline: '',
    discountNeighborhood: '',
    discountPercent: 0,
  })
  const [error, setError] = useState('')
  const [message, setMessage] = useState('')
  const [isLoading, setIsLoading] = useState(true)

  useEffect(() => {
    const load = async () => {
      setIsLoading(true)
      setError('')
      try {
        const data = await authorizedFetch('/admin/settings')
        setForm({
          name: data.tenant.name || '',
          whatsappNumber: data.tenant.whatsappNumber || '',
          logoUrl: data.tenant.logoUrl || '',
          logoIconUrl: data.tenant.logoIconUrl || '',
          tagline: data.tenant.tagline || '',
          discountNeighborhood: data.settings.discountNeighborhood || '',
          discountPercent: Number(data.settings.discountPercent || 0),
        })
      } catch (err) {
        setError(err.message)
      } finally {
        setIsLoading(false)
      }
    }
    load()
  }, [])

  const handleSubmit = async (event) => {
    event.preventDefault()
    setError('')
    setMessage('')

    try {
      await authorizedFetch('/admin/settings', {
        method: 'PUT',
        body: {
          name: form.name,
          whatsappNumber: form.whatsappNumber,
          logoUrl: form.logoUrl,
          logoIconUrl: form.logoIconUrl,
          tagline: form.tagline,
          discountNeighborhood: form.discountNeighborhood,
          discountPercent: Number(form.discountPercent || 0),
        },
      })
      setMessage('Configurações salvas com sucesso.')
      await reloadCatalog()
    } catch (err) {
      setError(err.message)
    }
  }

  if (isLoading) {
    return <p className="text-sm text-gray-500">Carregando configurações...</p>
  }

  return (
    <section className="max-w-2xl rounded-2xl bg-white p-6 shadow-sm">
      <h2 className="text-xl font-bold text-gray-900">Configurações da loja</h2>
      <p className="mt-1 text-sm text-gray-500">
        Nome, logotipo, WhatsApp e desconto por bairro.
      </p>

      {session?.tenantSlug && (
        <div className="mt-4 rounded-xl border border-emerald-100 bg-emerald-50 px-4 py-3 text-sm text-emerald-900">
          <p className="font-semibold">URL pública da sua loja</p>
          <a
            href={buildStoreUrl(session.tenantSlug)}
            target="_blank"
            rel="noreferrer"
            className="mt-1 block break-all text-emerald-700 underline"
          >
            {buildStoreUrl(session.tenantSlug)}
          </a>
        </div>
      )}

      <form onSubmit={handleSubmit} className="mt-6 space-y-4">
        <input
          placeholder="Nome da loja"
          value={form.name}
          onChange={(e) => setForm({ ...form, name: e.target.value })}
          className="w-full rounded-xl border border-gray-200 px-3 py-2.5"
          required
        />
        <input
          placeholder="WhatsApp (5511999999999)"
          value={form.whatsappNumber}
          onChange={(e) =>
            setForm({ ...form, whatsappNumber: e.target.value })
          }
          className="w-full rounded-xl border border-gray-200 px-3 py-2.5"
        />
        <ImageUploadField
          label="Logotipo principal"
          value={form.logoUrl}
          onChange={(logoUrl) => setForm({ ...form, logoUrl })}
          token={session?.token}
          folder="logos"
          hint="Recomendado: imagem horizontal ou quadrada."
        />
        <ImageUploadField
          label="Ícone da loja"
          value={form.logoIconUrl}
          onChange={(logoIconUrl) => setForm({ ...form, logoIconUrl })}
          token={session?.token}
          folder="logos"
          hint="Usado no cabeçalho. Prefira formato quadrado."
        />
        <textarea
          placeholder="Slogan da loja"
          value={form.tagline}
          onChange={(e) => setForm({ ...form, tagline: e.target.value })}
          rows={2}
          className="w-full rounded-xl border border-gray-200 px-3 py-2.5"
        />
        <div className="grid grid-cols-2 gap-3">
          <input
            placeholder="Bairro com desconto"
            value={form.discountNeighborhood}
            onChange={(e) =>
              setForm({ ...form, discountNeighborhood: e.target.value })
            }
            className="w-full rounded-xl border border-gray-200 px-3 py-2.5"
          />
          <input
            type="number"
            step="0.01"
            placeholder="Desconto %"
            value={form.discountPercent}
            onChange={(e) =>
              setForm({ ...form, discountPercent: e.target.value })
            }
            className="w-full rounded-xl border border-gray-200 px-3 py-2.5"
          />
        </div>

        <button
          type="submit"
          className="rounded-xl bg-emerald-600 px-4 py-2.5 font-semibold text-white"
        >
          Salvar configurações
        </button>
      </form>

      {message && (
        <p className="mt-4 rounded-xl bg-emerald-50 px-3 py-2 text-sm text-emerald-800">
          {message}
        </p>
      )}
      {error && (
        <p className="mt-4 rounded-xl bg-red-50 px-3 py-2 text-sm text-red-700">
          {error}
        </p>
      )}
    </section>
  )
}
