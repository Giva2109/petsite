import { useEffect, useMemo, useRef, useState } from 'react'
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
import { openWhatsAppOrder, openWhatsAppPaymentConfirmation } from '../utils/whatsapp'
import { saveOrder } from '../utils/ordersApi'
import { createIdempotencyKey } from '../utils/idempotency'
import { validateCheckoutFields, formatDeliveryAddress } from '../utils/checkoutForm'
import { getCheckoutAction } from '../utils/checkoutFlow'
import { calculateOrderTotals } from '../utils/discount'
import CheckoutAddressForm from './CheckoutAddressForm'
import PaymentCheckout from './PaymentCheckout'
import PixPaymentModal from './PixPaymentModal'
import PaymentSuccess from './PaymentSuccess'

const EMPTY_FIELD_ERRORS = {
  customerName: '',
  phone: '',
  zipCode: '',
  street: '',
  streetNumber: '',
  neighborhood: '',
  city: '',
  state: '',
  sameDeliveryAddress: '',
  deliveryAddress: '',
}

export default function CartDrawer({ isOpen, onClose }) {
  const { items, updateQuantity, removeItem, totalPrice, clearCart } = useCart()
  const [customerName, setCustomerName] = useState('')
  const [phone, setPhone] = useState('')
  const [zipCode, setZipCode] = useState('')
  const [street, setStreet] = useState('')
  const [streetNumber, setStreetNumber] = useState('')
  const [complement, setComplement] = useState('')
  const [city, setCity] = useState('')
  const [state, setState] = useState('')
  const [neighborhood, setNeighborhood] = useState('')
  const [sameDeliveryAddress, setSameDeliveryAddress] = useState(true)
  const [deliveryAddress, setDeliveryAddress] = useState('')
  const [isPaymentOpen, setIsPaymentOpen] = useState(false)
  const [isSavingOrder, setIsSavingOrder] = useState(false)
  const [pixResult, setPixResult] = useState(null)
  const [successResult, setSuccessResult] = useState(null)
  const [paymentError, setPaymentError] = useState('')
  const [checkoutError, setCheckoutError] = useState('')
  const [fieldErrors, setFieldErrors] = useState(EMPTY_FIELD_ERRORS)
  const checkoutInFlightRef = useRef(false)
  const idempotencyKeyRef = useRef(null)
  const pendingWhatsAppRef = useRef(null)

  const checkoutAction = getCheckoutAction(items)

  const orderTotals = useMemo(
    () => calculateOrderTotals(totalPrice, neighborhood),
    [totalPrice, neighborhood]
  )

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
    const result = validateCheckoutFields({
      customerName,
      phone,
      zipCode,
      street,
      streetNumber,
      complement,
      city,
      state,
      neighborhood,
      sameDeliveryAddress,
      deliveryAddress,
    })

    if (Object.keys(result.errors).length > 0) {
      setFieldErrors((prev) => ({ ...prev, ...result.errors }))
      setCheckoutError(
        'Preencha os dados obrigatórios e confirme o endereço de entrega.'
      )
      return null
    }

    setFieldErrors(EMPTY_FIELD_ERRORS)
    setCheckoutError('')
    return result.values
  }

  const resetCheckoutSession = () => {
    checkoutInFlightRef.current = false
    idempotencyKeyRef.current = null
    setIsSavingOrder(false)
  }

  const persistOrder = async (channel) => {
    if (checkoutInFlightRef.current) return null

    const values = getValidatedCheckout()
    if (!values) return null

    if (!idempotencyKeyRef.current) {
      idempotencyKeyRef.current = createIdempotencyKey()
    }

    checkoutInFlightRef.current = true
    setIsSavingOrder(true)

    try {
      const saved = await saveOrder({
        items,
        ...values,
        idempotencyKey: idempotencyKeyRef.current,
        channel,
        totalAmount: orderTotals.total,
      })
      return { ...values, orderId: saved.id }
    } catch (error) {
      resetCheckoutSession()
      setCheckoutError(
        error.message || 'Não foi possível salvar o pedido. Tente novamente.'
      )
      return null
    }
  }

  const handleWhatsAppCheckout = async () => {
    if (items.length === 0 || checkoutInFlightRef.current) return

    const saved = await persistOrder('WHATSAPP')
    if (!saved) return

    openWhatsAppOrder({
      items,
      customerName: saved.customerName,
      phone: saved.phone,
      address: saved.deliveryAddress,
      neighborhood: saved.neighborhood,
    })

    resetCheckoutForm()
    resetCheckoutSession()
  }

  const handleOpenPayment = async () => {
    if (checkoutInFlightRef.current) return
    setPaymentError('')

    const saved = await persistOrder('MERCADOPAGO')
    if (!saved) return

    setIsSavingOrder(false)
    setIsPaymentOpen(true)
  }

  const handleFinalizeOrder = async () => {
    if (items.length === 0 || checkoutInFlightRef.current) return

    if (checkoutAction.mode === 'online') {
      await handleOpenPayment()
      return
    }

    await handleWhatsAppCheckout()
  }

  const resolvedDeliveryAddress = sameDeliveryAddress
    ? formatDeliveryAddress({
        street,
        streetNumber,
        complement,
        neighborhood,
        city,
        state,
        zipCode,
      })
    : deliveryAddress

  const capturePaymentForWhatsApp = (paymentInfo) => {
    pendingWhatsAppRef.current = {
      items: items.map(({ product, quantity }) => ({
        product: { ...product },
        quantity,
      })),
      customerName,
      phone,
      address: resolvedDeliveryAddress,
      totalAmount: orderTotals.total,
      subtotalAmount: orderTotals.subtotal,
      discountPercent: orderTotals.discountPercent,
      discountAmount: orderTotals.discountAmount,
      ...paymentInfo,
    }
    resetCheckoutSession()
  }

  const finalizePostPayment = () => {
    const pending = pendingWhatsAppRef.current
    if (pending) {
      openWhatsAppPaymentConfirmation(pending)
      pendingWhatsAppRef.current = null
    }
    clearCart()
    resetCheckoutForm()
  }

  const resetCheckoutForm = () => {
    setCustomerName('')
    setPhone('')
    setZipCode('')
    setStreet('')
    setStreetNumber('')
    setComplement('')
    setCity('')
    setState('')
    setNeighborhood('')
    setSameDeliveryAddress(true)
    setDeliveryAddress('')
    setFieldErrors(EMPTY_FIELD_ERRORS)
    setCheckoutError('')
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
                  className={`w-full rounded-xl border px-3 py-2.5 text-base focus:outline-none focus:ring-2 ${
                    fieldErrors.customerName
                      ? 'border-red-300 focus:border-red-400 focus:ring-red-200'
                      : 'border-gray-200 focus:border-emerald-400 focus:ring-emerald-200'
                  }`}
                />
                {fieldErrors.customerName && (
                  <p className="mt-1 text-xs text-red-600">
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
                  className={`w-full rounded-xl border px-3 py-2.5 text-base focus:outline-none focus:ring-2 ${
                    fieldErrors.phone
                      ? 'border-red-300 focus:border-red-400 focus:ring-red-200'
                      : 'border-gray-200 focus:border-emerald-400 focus:ring-emerald-200'
                  }`}
                />
                {fieldErrors.phone && (
                  <p className="mt-1 text-xs text-red-600">{fieldErrors.phone}</p>
                )}
              </div>

              <CheckoutAddressForm
                zipCode={zipCode}
                onZipCodeChange={setZipCode}
                street={street}
                onStreetChange={setStreet}
                streetNumber={streetNumber}
                onStreetNumberChange={setStreetNumber}
                complement={complement}
                onComplementChange={setComplement}
                city={city}
                onCityChange={setCity}
                state={state}
                onStateChange={setState}
                neighborhood={neighborhood}
                onNeighborhoodChange={setNeighborhood}
                sameDeliveryAddress={sameDeliveryAddress}
                onSameDeliveryAddressChange={setSameDeliveryAddress}
                deliveryAddress={deliveryAddress}
                onDeliveryAddressChange={setDeliveryAddress}
                fieldErrors={fieldErrors}
                onClearError={clearFieldError}
              />
            </div>
          )}
        </div>

        {items.length > 0 && (
          <div className="border-t border-gray-100 px-5 py-4">
            {orderTotals.subtotal != null ? (
              <div className="mb-4 space-y-2">
                <div className="flex items-center justify-between text-sm text-gray-600">
                  <span>Subtotal</span>
                  <span>{formatCurrency(orderTotals.subtotal)}</span>
                </div>
                {orderTotals.hasDiscount && (
                  <div className="flex items-center justify-between text-sm font-medium text-emerald-700">
                    <span>Desconto Parque Cecap (10%)</span>
                    <span>- {formatCurrency(orderTotals.discountAmount)}</span>
                  </div>
                )}
                <div className="flex items-center justify-between border-t border-gray-100 pt-2">
                  <span className="text-base font-medium text-gray-600">Total</span>
                  <span className="text-2xl font-bold text-emerald-700">
                    {formatCurrency(orderTotals.total)}
                  </span>
                </div>
              </div>
            ) : (
              <div className="mb-4 flex items-center justify-between">
                <span className="text-base font-medium text-gray-600">Total</span>
                <span className="text-2xl font-bold text-amber-600">
                  {formatCurrency(orderTotals.total)}
                </span>
              </div>
            )}

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

            <p className="mb-3 rounded-xl bg-gray-50 px-3 py-2 text-xs text-gray-600">
              {checkoutAction.hint}
            </p>

            <button
              type="button"
              onClick={handleFinalizeOrder}
              disabled={isSavingOrder}
              className={`flex w-full items-center justify-center gap-2 rounded-xl py-3.5 text-base font-bold text-white shadow-lg transition focus:outline-none focus:ring-2 focus:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-60 ${checkoutAction.buttonClass}`}
            >
              {checkoutAction.mode === 'online' ? (
                <CreditCard className="h-5 w-5" aria-hidden="true" />
              ) : (
                <MessageCircle className="h-5 w-5" aria-hidden="true" />
              )}
              {isSavingOrder ? 'Salvando pedido...' : checkoutAction.label}
            </button>
          </div>
        )}
      </aside>

      <PaymentCheckout
        isOpen={isPaymentOpen}
        onClose={() => {
          setIsPaymentOpen(false)
          resetCheckoutSession()
        }}
        amount={orderTotals.total}
        items={items}
        customerName={customerName}
        phone={phone}
        address={resolvedDeliveryAddress}
        onPixResult={(result) => {
          capturePaymentForWhatsApp({
            paymentId: result.paymentId,
            paymentMethod: 'PIX (Mercado Pago — aguardando confirmação)',
          })
          setPixResult(result)
        }}
        onCardApproved={(result) => {
          capturePaymentForWhatsApp({
            paymentId: result.paymentId,
            paymentMethod: 'Cartão (Mercado Pago — aprovado)',
          })
          setSuccessResult(result)
        }}
        onError={(message) => setPaymentError(message)}
      />

      {pixResult && (
        <PixPaymentModal
          pix={pixResult.pix}
          amount={pixResult.amount}
          onClose={() => {
            setPixResult(null)
            finalizePostPayment()
          }}
        />
      )}

      {successResult && (
        <PaymentSuccess
          amount={successResult.amount}
          paymentId={successResult.paymentId}
          onClose={() => {
            setSuccessResult(null)
            finalizePostPayment()
          }}
        />
      )}
    </>
  )
}
