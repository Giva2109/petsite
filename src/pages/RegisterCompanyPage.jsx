import { useState } from 'react'
import { Link, useNavigate } from 'react-router-dom'
import { buildStoreUrl } from '../utils/catalogApi'
import { normalizeSlug, registerCompany } from '../utils/registerApi'

const EMPTY_FORM = {
  slug: '',
  companyName: '',
  domain: '',
  whatsappNumber: '',
  adminName: '',
  adminEmail: '',
  adminPassword: '',
  confirmPassword: '',
}

export default function RegisterCompanyPage() {
  const navigate = useNavigate()
  const [form, setForm] = useState(EMPTY_FORM)
  const [error, setError] = useState('')
  const [message, setMessage] = useState('')
  const [isSubmitting, setIsSubmitting] = useState(false)

  const handleSlugChange = (value) => {
    setForm((current) => ({ ...current, slug: normalizeSlug(value) }))
  }

  const handleSubmit = async (event) => {
    event.preventDefault()
    setError('')
    setMessage('')

    if (form.adminPassword !== form.confirmPassword) {
      setError('As senhas não conferem.')
      return
    }

    setIsSubmitting(true)
    try {
      const result = await registerCompany({
        slug: form.slug,
        companyName: form.companyName,
        domain: form.domain || null,
        whatsappNumber: form.whatsappNumber || null,
        adminName: form.adminName,
        adminEmail: form.adminEmail,
        adminPassword: form.adminPassword,
      })
      setMessage(`${result.message} Loja: ${buildStoreUrl(result.slug)}`)
      setTimeout(() => {
        navigate('/admin/login', {
          replace: true,
          state: {
            tenantSlug: result.slug,
            email: result.adminEmail,
            storeUrl: buildStoreUrl(result.slug),
          },
        })
      }, 2000)
    } catch (err) {
      setError(err.message)
    } finally {
      setIsSubmitting(false)
    }
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-emerald-50 to-amber-50 px-4 py-10">
      <div className="mx-auto max-w-2xl rounded-2xl bg-white p-8 shadow-xl">
        <h1 className="text-2xl font-bold text-gray-900">Cadastrar minha loja</h1>
        <p className="mt-2 text-sm text-gray-500">
          Crie sua empresa no sistema e o usuário administrador para gerenciar
          produtos, preços e configurações.
        </p>

        <form onSubmit={handleSubmit} className="mt-8 space-y-6">
          <section className="space-y-3">
            <h2 className="text-sm font-semibold uppercase tracking-wide text-emerald-700">
              Dados da loja
            </h2>
            <input
              placeholder="Nome da empresa *"
              value={form.companyName}
              onChange={(e) =>
                setForm({ ...form, companyName: e.target.value })
              }
              className="w-full rounded-xl border border-gray-200 px-3 py-2.5"
              required
            />
            <div>
              <input
                placeholder="Identificador da loja (slug) *"
                value={form.slug}
                onChange={(e) => handleSlugChange(e.target.value)}
                className="w-full rounded-xl border border-gray-200 px-3 py-2.5"
                required
                minLength={3}
              />
              <p className="mt-1 text-xs text-gray-500">
                Usado no login do painel. Ex: <code>minha-pet-shop</code>
              </p>
            </div>
            <input
              placeholder="Domínio (opcional, ex: minhaloja.com.br)"
              value={form.domain}
              onChange={(e) => setForm({ ...form, domain: e.target.value })}
              className="w-full rounded-xl border border-gray-200 px-3 py-2.5"
            />
            <input
              placeholder="WhatsApp (opcional, 5511999999999)"
              value={form.whatsappNumber}
              onChange={(e) =>
                setForm({ ...form, whatsappNumber: e.target.value })
              }
              className="w-full rounded-xl border border-gray-200 px-3 py-2.5"
            />
          </section>

          <section className="space-y-3">
            <h2 className="text-sm font-semibold uppercase tracking-wide text-emerald-700">
              Administrador
            </h2>
            <input
              placeholder="Seu nome *"
              value={form.adminName}
              onChange={(e) => setForm({ ...form, adminName: e.target.value })}
              className="w-full rounded-xl border border-gray-200 px-3 py-2.5"
              required
            />
            <input
              type="email"
              placeholder="E-mail de acesso *"
              value={form.adminEmail}
              onChange={(e) =>
                setForm({ ...form, adminEmail: e.target.value })
              }
              className="w-full rounded-xl border border-gray-200 px-3 py-2.5"
              required
            />
            <input
              type="password"
              placeholder="Senha *"
              value={form.adminPassword}
              onChange={(e) =>
                setForm({ ...form, adminPassword: e.target.value })
              }
              className="w-full rounded-xl border border-gray-200 px-3 py-2.5"
              required
              minLength={6}
            />
            <input
              type="password"
              placeholder="Confirmar senha *"
              value={form.confirmPassword}
              onChange={(e) =>
                setForm({ ...form, confirmPassword: e.target.value })
              }
              className="w-full rounded-xl border border-gray-200 px-3 py-2.5"
              required
              minLength={6}
            />
          </section>

          {error && (
            <p className="rounded-xl bg-red-50 px-3 py-2 text-sm text-red-700">
              {error}
            </p>
          )}
          {message && (
            <p className="rounded-xl bg-emerald-50 px-3 py-2 text-sm text-emerald-800">
              {message}
            </p>
          )}

          <button
            type="submit"
            disabled={isSubmitting}
            className="w-full rounded-xl bg-emerald-600 py-3 font-semibold text-white hover:bg-emerald-700 disabled:opacity-60"
          >
            {isSubmitting ? 'Criando loja...' : 'Criar loja e acessar painel'}
          </button>
        </form>

        <p className="mt-6 text-center text-sm text-gray-500">
          Já tem conta?{' '}
          <Link to="/admin/login" className="font-semibold text-emerald-700">
            Entrar no painel
          </Link>
        </p>
      </div>
    </div>
  )
}
