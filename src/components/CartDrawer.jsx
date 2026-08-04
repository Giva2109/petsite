import { useEffect, useState } from 'react'
import {
  X,
  Minus,
  Plus,
  Trash2,
  MessageCircle,
  ShoppingCart,
  CreditCard,
} from 'lucide-react'
import { useCart } from '../hooks/useCart'
import { formatCurrency } from '../utils/currency'
import { openWhatsAppOrder } from '../utils/whatsapp'
import { saveOrder } from '../utils/ordersApi'
import { validateCheckoutFields } from '../utils/checkoutForm'
import PaymentCheckout from './PaymentCheckout'
import PixPaymentModal from './PixPaymentModal'
import PaymentSuccess from './PaymentSuccess'

export default function CartDrawer({ isOpen, onClose }) {
  const { items, updateQuantity, removeItem, totalPrice, clearCart } = useCart()
  const [customerName, setCustomerName] = useState('')
  const [phone, setPhone] = useState('')
  const [address, setAddress] = useState('')
  const [isPaymentOpen, setIsPaymentOpen] = useState(false)
  const [isSavingOrder, setIsSavingOrder] = useState(false)
  const [pixResult, setPixResult] = useState(null)
  const [successResult, setSuccessResult] = useState(null)
  const [paymentError, setPaymentError] = useState('')
  const [checkoutError, setCheckoutError] = useState('')
  const [fieldErrors, setFieldErrors] = useState({
    customerName: '',
    phone: '',
    address: '',
  })

  const canPayOnline = totalPrice != null && totalPrice > 0

  useEffect(() => {
    if (isOpen) {
      document.body.style.overflow = 'hidden'
    } else {
      document.body.style.overflow = ''
    }
    return () => {
      document.body.style.overflow = ''
    }
  }, [isOpen])

  useEffect(() => {
    const handleEscape = (e) => {
      if (e.key === 'Escape') onClose()
    }
    if (isOpen) {
      window.addEventListener('keydown', handleEscape)
    }
    return () => window.removeEventListener('keydown', handleEscape)
  }, [isOpen, onClose])

  const clearFieldError = (field) => {
    if (fieldErrors[field]) {
      setFieldErrors((prev) => ({ ...prev, [field]: '' }))
    }
    if (checkoutError) setCheckoutError('')
  }

  const getValidatedCheckout = () => {
    const result = validateCheckoutFields({ customerName, phone, address })
    if (Object.keys(result.errors).length > 0) {
      setFieldErrors((prev) => ({ ...prev, ...result.errors }))
      setCheckoutError(
        'Preencha nome, telefone e endereço para continuar com o pedido.'
      )
      return null
    }
    setFieldErrors({ customerName: '', phone: '', address: '' })
    setCheckoutError('')
    return result.values
  }

  const persistOrder = async (channel) => {
    const values = getValidatedCheckout()
    if (!values) return null

    setIsSavingOrder(true)
    try {
      const saved = await saveOrder({
        items,
        customerName: values.customerName,
        phone: values.phone,
        address: values.address,
        channel,
        totalAmount: totalPrice,
      })
      return { ...values, orderId: saved.id }
    } catch (error) {
      setCheckoutError(
        error.message || 'Não foi possível salvar o pedido. Tente novamente.'
      )
      return null
    } finally {
      setIsSavingOrder(false)
    }
  }

  const handleWhatsAppCheckout = async () => {
    if (items.length === 0 || isSavingOrder) return

    const saved = await persistOrder('WHATSAPP')
    if (!saved) return

    openWhatsAppOrder({
      items,
      customerName: saved.customerName,
      phone: saved.phone,
      address: saved.address,
    })
  }

  const handleOpenPayment = async () => {
    if (isSavingOrder) return
    setPaymentError('')

    const saved = await persistOrder('MERCADOPAGO')
    if (!saved) return

    setIsPaymentOpen(true)
  }

  const handlePaymentSuccess = () => {
    clearCart()
    setCustomerName('')
    setPhone('')
    setAddress('')
  }

  return (
    <>
      <div
        className={`fixed inset-0 z-50 bg-black/40 transition-opacity duration-300 ${
          isOpen ? 'opacity-100' : 'pointer-events-none opacity-0'
        }`}
        onClick={onClose}
        aria-hidden="true"
      />

      <aside
        className={`fixed right-0 top-0 z-50 flex h-full w-full max-w-md flex-col bg-white shadow-2xl transition-transform duration-300 ease-out ${
          isOpen ? 'translate-x-0' : 'translate-x-full'
        }`}
        role="dialog"
        aria-modal="true"
        aria-label="Carrinho de compras"
      >
        <div className="flex items-center justify-between border-b border-gray-100 px-5 py-4">
          <div className="flex items-center gap-2">
            <ShoppingCart className="h-5 w-5 text-emerald-600" aria-hidden="true" />
            <h2 className="text-lg font-bold text-gray-900">Seu Pedido</h2>
          </div>
          <button
            type="button"
            onClick={onClose}
            className="flex h-10 w-10 items-center justify-center rounded-xl text-gray-500 transition hover:bg-gray-100 focus:outline-none focus:ring-2 focus:ring-emerald-300"
            aria-label="Fechar carrinho"
          >
            <X className="h-5 w-5" />
          </button>
        </div>

        <div className="flex-1 overflow-y-auto px-5 py-4">
          {items.length === 0 ? (
            <div className="flex h-full flex-col items-center justify-center text-center">
              <ShoppingCart
                className="h-16 w-16 text-gray-200"
                aria-hidden="true"
              />
              <p className="mt-4 text-lg font-semibold text-gray-700">
                Carrinho vazio
              </p>
              <p className="mt-1 text-sm text-gray-500">
                Adicione rações ao seu pedido para continuar.
              </p>
            </div>
          ) : (
            <ul className="space-y-4">
              {items.map(({ product, quantity }) => (
                <li
                  key={product.id}
                  className="flex gap-3 rounded-xl border border-gray-100 bg-gray-50 p-3"
                >
                  <img
                    src={product.image}
                    alt={product.name}
                    className="h-20 w-20 shrink-0 rounded-lg object-contain bg-white p-1"
                    onError={(e) => {
                      e.target.style.display = 'none'
                    }}
                  />
                  <div className="flex flex-1 flex-col">
                    <p className="text-sm font-bold text-gray-900 line-clamp-2">
                      {product.name}
                    </p>
                    <p className="text-xs text-gray-500">
                      {product.brand} · {product.weight}
                    </p>
                    <p className="mt-1 text-sm font-semibold text-emerald-700">
                      {formatCurrency(product.price)}
                    </p>

                    <div className="mt-2 flex items-center justify-between">
                      <div className="flex items-center rounded-lg border border-gray-200 bg-white">
                        <button
                          type="button"
                          onClick={() =>
                            updateQuantity(product.id, quantity - 1)
                          }
                          className="flex h-8 w-8 items-center justify-center text-gray-600 hover:bg-gray-100"
                          aria-label="Diminuir quantidade"
                        >
                          <Minus className="h-3.5 w-3.5" />
                        </button>
                        <span className="min-w-6 text-center text-sm font-semibold">
                          {quantity}
                        </span>
                        <button
                          type="button"
                          onClick={() =>
                            updateQuantity(product.id, quantity + 1)
                          }
                          className="flex h-8 w-8 items-center justify-center text-gray-600 hover:bg-gray-100"
                          aria-label="Aumentar quantidade"
                        >
                          <Plus className="h-3.5 w-3.5" />
                        </button>
                      </div>

                      <button
                        type="button"
                        onClick={() => removeItem(product.id)}
                        className="flex h-8 w-8 items-center justify-center rounded-lg text-red-500 transition hover:bg-red-50"
                        aria-label="Remover item"
                      >
                        <Trash2 className="h-4 w-4" />
                      </button>
                    </div>
                  </div>
                </li>
              ))}
            </ul>
          )}

          {items.length > 0 && (
            <div className="mt-6 space-y-3">
              <div>
                <label
                  htmlFor="customer-name"
                  className="mb-1 block text-sm font-medium text-gray-700"
                >
                  Nome do Cliente <span className="text-red-500">*</span>
                </label>
                <input
                  id="customer-name"
                  type="text"
                  value={customerName}
                  onChange={(e) => {
                    setCustomerName(e.target.value)
                    clearFieldError('customerName')
                  }}
                  placeholder="Seu nome"
                  required
                  aria-invalid={Boolean(fieldErrors.customerName)}
                  aria-describedby={
                    fieldErrors.customerName ? 'customer-name-error' : undefined
                  }
                  className={`w-full rounded-xl border px-3 py-2.5 text-base focus:outline-none focus:ring-2 ${
                    fieldErrors.customerName
                      ? 'border-red-300 focus:border-red-400 focus:ring-red-200'
                      : 'border-gray-200 focus:border-emerald-400 focus:ring-emerald-200'
                  }`}
                />
                {fieldErrors.customerName && (
                  <p
                    id="customer-name-error"
                    className="mt-1 text-xs text-red-600"
                  >
                    {fieldErrors.customerName}
                  </p>
                )}
              </div>
              <div>
                <label
                  htmlFor="phone"
                  className="mb-1 block text-sm font-medium text-gray-700"
                >
                  Telefone / WhatsApp <span className="text-red-500">*</span>
                </label>
                <input
                  id="phone"
                  type="tel"
                  inputMode="tel"
                  autoComplete="tel"
                  value={phone}
                  onChange={(e) => {
                    setPhone(e.target.value)
                    clearFieldError('phone')
                  }}
                  placeholder="(11) 99999-9999"
                  required
                  aria-invalid={Boolean(fieldErrors.phone)}
                  aria-describedby={fieldErrors.phone ? 'phone-error' : undefined}
                  className={`w-full rounded-xl border px-3 py-2.5 text-base focus:outline-none focus:ring-2 ${
                    fieldErrors.phone
                      ? 'border-red-300 focus:border-red-400 focus:ring-red-200'
                      : 'border-gray-200 focus:border-emerald-400 focus:ring-emerald-200'
                  }`}
                />
                {fieldErrors.phone && (
                  <p id="phone-error" className="mt-1 text-xs text-red-600">
                    {fieldErrors.phone}
                  </p>
                )}
              </div>
              <div>
                <label
                  htmlFor="address"
                  className="mb-1 block text-sm font-medium text-gray-700"
                >
                  Endereço de Entrega <span className="text-red-500">*</span>
                </label>
                <textarea
                  id="address"
                  value={address}
                  onChange={(e) => {
                    setAddress(e.target.value)
                    clearFieldError('address')
                  }}
                  placeholder="Rua, número, bairro, cidade..."
                  rows={3}
                  required
                  aria-invalid={Boolean(fieldErrors.address)}
                  aria-describedby={
                    fieldErrors.address ? 'address-error' : undefined
                  }
                  className={`w-full resize-none rounded-xl border px-3 py-2.5 text-base focus:outline-none focus:ring-2 ${
                    fieldErrors.address
                      ? 'border-red-300 focus:border-red-400 focus:ring-red-200'
                      : 'border-gray-200 focus:border-emerald-400 focus:ring-emerald-200'
                  }`}
                />
                {fieldErrors.address && (
                  <p id="address-error" className="mt-1 text-xs text-red-600">
                    {fieldErrors.address}
                  </p>
                )}
              </div>
            </div>
          )}
        </div>

        {items.length > 0 && (
          <div className="border-t border-gray-100 px-5 py-4">
            <div className="mb-4 flex items-center justify-between">
              <span className="text-base font-medium text-gray-600">Total</span>
              <span
                className={`text-2xl font-bold ${
                  totalPrice != null ? 'text-emerald-700' : 'text-amber-600'
                }`}
              >
                {formatCurrency(totalPrice)}
              </span>
            </div>

            {paymentError && (
              <p className="mb-3 rounded-xl bg-red-50 px-3 py-2 text-sm text-red-700">
                {paymentError}
              </p>
            )}

            {checkoutError && (
              <p className="mb-3 rounded-xl bg-red-50 px-3 py-2 text-sm text-red-700">
                {checkoutError}
              </p>
            )}

            {canPayOnline ? (
              <button
                type="button"
                onClick={handleOpenPayment}
                disabled={isSavingOrder}
                className="mb-3 flex w-full items-center justify-center gap-2 rounded-xl bg-sky-600 py-3.5 text-base font-bold text-white shadow-lg transition hover:bg-sky-700 focus:outline-none focus:ring-2 focus:ring-sky-400 focus:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-60"
              >
                <CreditCard className="h-5 w-5" aria-hidden="true" />
                Pagar com Mercado Pago
              </button>
            ) : (
              <p className="mb-3 rounded-xl bg-amber-50 px-3 py-2 text-xs text-amber-800">
                Pagamento online disponível quando todos os itens tiverem preço
                definido. Use o WhatsApp para pedidos sob consulta.
              </p>
            )}

            <button
              type="button"
              onClick={handleWhatsAppCheckout}
              disabled={isSavingOrder}
              className="flex w-full items-center justify-center gap-2 rounded-xl bg-green-600 py-3.5 text-base font-bold text-white shadow-lg transition hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-green-400 focus:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-60"
            >
              <MessageCircle className="h-5 w-5" aria-hidden="true" />
              {isSavingOrder ? 'Salvando pedido...' : 'Finalizar via WhatsApp'}
            </button>
          </div>
        )}
      </aside>

      <PaymentCheckout
        isOpen={isPaymentOpen}
        onClose={() => setIsPaymentOpen(false)}
        amount={totalPrice}
        items={items}
        customerName={customerName}
        phone={phone}
        address={address}
        onPixResult={(result) => {
          setPixResult(result)
          handlePaymentSuccess()
        }}
        onCardApproved={(result) => {
          setSuccessResult(result)
          handlePaymentSuccess()
        }}
        onError={(message) => setPaymentError(message)}
      />

      {pixResult && (
        <PixPaymentModal
          pix={pixResult.pix}
          amount={pixResult.amount}
          onClose={() => setPixResult(null)}
        />
      )}

      {successResult && (
        <PaymentSuccess
          amount={successResult.amount}
          paymentId={successResult.paymentId}
          onClose={() => setSuccessResult(null)}
        />
      )}
    </>
  )
}
