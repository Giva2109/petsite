import { useEffect, useState } from 'react'
import { useAuth } from '../../context/AuthContext'
import { formatCurrency } from '../../utils/currency'
import ImageUploadField from '../../components/admin/ImageUploadField'

const EMPTY_PRODUCT = {
  name: '',
  category: 'caes',
  brand: '',
  line: '',
  price: '',
  originalPrice: '',
  image: '',
  description: '',
  weight: '',
  stock: '',
  active: true,
}

export default function AdminProductsPage() {
  const { authorizedFetch, session } = useAuth()
  const [products, setProducts] = useState([])
  const [form, setForm] = useState(EMPTY_PRODUCT)
  const [editingId, setEditingId] = useState(null)
  const [error, setError] = useState('')
  const [message, setMessage] = useState('')
  const [isLoading, setIsLoading] = useState(true)

  const loadProducts = async () => {
    setIsLoading(true)
    setError('')
    try {
      const data = await authorizedFetch('/admin/products')
      setProducts(data)
    } catch (err) {
      setError(err.message)
    } finally {
      setIsLoading(false)
    }
  }

  useEffect(() => {
    loadProducts()
  }, [])

  const resetForm = () => {
    setForm(EMPTY_PRODUCT)
    setEditingId(null)
  }

  const handleEdit = (product) => {
    setEditingId(product.id)
    setForm({
      name: product.name || '',
      category: product.category || 'caes',
      brand: product.brand || '',
      line: product.line || '',
      price: product.price ?? '',
      originalPrice: product.originalPrice ?? '',
      image: product.image || '',
      description: product.description || '',
      weight: product.weight || '',
      stock: product.stock ?? '',
      active: product.active,
    })
  }

  const buildPayload = () => ({
    name: form.name,
    category: form.category,
    brand: form.brand || null,
    line: form.line || null,
    price: form.price === '' ? null : Number(form.price),
    originalPrice:
      form.originalPrice === '' ? null : Number(form.originalPrice),
    image: form.image || null,
    description: form.description || null,
    weight: form.weight || null,
    stock: form.stock === '' ? null : Number(form.stock),
    active: Boolean(form.active),
    catalogPage: null,
  })

  const handleSubmit = async (event) => {
    event.preventDefault()
    setError('')
    setMessage('')

    try {
      const payload = buildPayload()
      if (editingId) {
        await authorizedFetch(`/admin/products/${editingId}`, {
          method: 'PUT',
          body: payload,
        })
        setMessage('Produto atualizado com sucesso.')
      } else {
        await authorizedFetch('/admin/products', {
          method: 'POST',
          body: payload,
        })
        setMessage('Produto criado com sucesso.')
      }
      resetForm()
      await loadProducts()
    } catch (err) {
      setError(err.message)
    }
  }

  const handleDelete = async (id) => {
    if (!window.confirm('Excluir este produto?')) return
    setError('')
    try {
      await authorizedFetch(`/admin/products/${id}`, { method: 'DELETE' })
      setMessage('Produto excluído.')
      if (editingId === id) resetForm()
      await loadProducts()
    } catch (err) {
      setError(err.message)
    }
  }

  return (
    <div className="grid gap-8 lg:grid-cols-[1.1fr_1fr]">
      <section className="rounded-2xl bg-white p-6 shadow-sm">
        <h2 className="text-xl font-bold text-gray-900">Produtos</h2>
        <p className="mt-1 text-sm text-gray-500">
          {products.length} itens na loja{' '}
          <span className="font-semibold text-emerald-700">{session?.tenantSlug}</span>
        </p>

        {isLoading ? (
          <p className="mt-4 text-sm text-gray-500">Carregando...</p>
        ) : (
          <div className="mt-4 max-h-[70vh] space-y-3 overflow-y-auto">
            {products.map((product) => (
              <div
                key={product.id}
                className="flex items-start justify-between gap-3 rounded-xl border border-gray-100 p-3"
              >
                <div>
                  <p className="font-semibold text-gray-900">{product.name}</p>
                  <p className="text-sm text-gray-500">
                    {formatCurrency(product.price)} · Estoque:{' '}
                    {product.stock ?? '—'} ·{' '}
                    {product.active ? 'Ativo' : 'Inativo'}
                  </p>
                </div>
                <div className="flex gap-2">
                  <button
                    type="button"
                    onClick={() => handleEdit(product)}
                    className="rounded-lg bg-emerald-50 px-3 py-1.5 text-sm font-medium text-emerald-700"
                  >
                    Editar
                  </button>
                  <button
                    type="button"
                    onClick={() => handleDelete(product.id)}
                    className="rounded-lg bg-red-50 px-3 py-1.5 text-sm font-medium text-red-700"
                  >
                    Excluir
                  </button>
                </div>
              </div>
            ))}
          </div>
        )}
      </section>

      <section className="rounded-2xl bg-white p-6 shadow-sm">
        <h2 className="text-xl font-bold text-gray-900">
          {editingId ? 'Editar produto' : 'Novo produto'}
        </h2>

        <form onSubmit={handleSubmit} className="mt-4 space-y-3">
          <input
            placeholder="Nome"
            value={form.name}
            onChange={(e) => setForm({ ...form, name: e.target.value })}
            className="w-full rounded-xl border border-gray-200 px-3 py-2.5"
            required
          />
          <select
            value={form.category}
            onChange={(e) => setForm({ ...form, category: e.target.value })}
            className="w-full rounded-xl border border-gray-200 px-3 py-2.5"
          >
            <option value="caes">Cães</option>
            <option value="gatos">Gatos</option>
            <option value="acessorios">Acessórios</option>
          </select>
          <input
            placeholder="Marca"
            value={form.brand}
            onChange={(e) => setForm({ ...form, brand: e.target.value })}
            className="w-full rounded-xl border border-gray-200 px-3 py-2.5"
          />
          <input
            placeholder="Linha"
            value={form.line}
            onChange={(e) => setForm({ ...form, line: e.target.value })}
            className="w-full rounded-xl border border-gray-200 px-3 py-2.5"
          />
          <div className="grid grid-cols-2 gap-3">
            <input
              type="number"
              step="0.01"
              placeholder="Preço"
              value={form.price}
              onChange={(e) => setForm({ ...form, price: e.target.value })}
              className="w-full rounded-xl border border-gray-200 px-3 py-2.5"
            />
            <input
              type="number"
              step="1"
              placeholder="Estoque"
              value={form.stock}
              onChange={(e) => setForm({ ...form, stock: e.target.value })}
              className="w-full rounded-xl border border-gray-200 px-3 py-2.5"
            />
          </div>
          <input
            placeholder="Peso (ex: 15kg)"
            value={form.weight}
            onChange={(e) => setForm({ ...form, weight: e.target.value })}
            className="w-full rounded-xl border border-gray-200 px-3 py-2.5"
          />
          <ImageUploadField
            label="Foto do produto"
            value={form.image}
            onChange={(image) => setForm({ ...form, image })}
            token={session?.token}
            folder="products"
            category={form.category}
            hint="A imagem é ajustada automaticamente para o layout da loja (quadrada, object-contain)."
          />
          <textarea
            placeholder="Descrição"
            value={form.description}
            onChange={(e) => setForm({ ...form, description: e.target.value })}
            rows={3}
            className="w-full rounded-xl border border-gray-200 px-3 py-2.5"
          />
          <label className="flex items-center gap-2 text-sm text-gray-700">
            <input
              type="checkbox"
              checked={form.active}
              onChange={(e) => setForm({ ...form, active: e.target.checked })}
            />
            Produto ativo na loja
          </label>

          <div className="flex gap-3 pt-2">
            <button
              type="submit"
              className="rounded-xl bg-emerald-600 px-4 py-2.5 font-semibold text-white"
            >
              {editingId ? 'Salvar alterações' : 'Cadastrar produto'}
            </button>
            {editingId && (
              <button
                type="button"
                onClick={resetForm}
                className="rounded-xl border border-gray-200 px-4 py-2.5"
              >
                Cancelar
              </button>
            )}
          </div>
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
    </div>
  )
}
