import { useEffect, useState } from 'react'
import { initMercadoPago, Payment } from '@mercadopago/sdk-react'
import { X, Loader2 } from 'lucide-react'
import { MERCADOPAGO_PUBLIC_KEY } from '../config/constants'
import { processPayment } from '../utils/payment'

let mercadoPagoInitialized = false

function ensureMercadoPagoInit() {
  if (!mercadoPagoInitialized && MERCADOPAGO_PUBLIC_KEY) {
    initMercadoPago(MERCADOPAGO_PUBLIC_KEY, { locale: 'pt-BR' })
    mercadoPagoInitialized = true
  }
}

export default function PaymentCheckout({
  isOpen,
  onClose,
  amount,
  items,
  customerName,
  address,
  onPixResult,
  onCardApproved,
  onError,
}) {
  const [isProcessing, setIsProcessing] = useState(false)

  useEffect(() => {
    if (isOpen) {
      ensureMercadoPagoInit()
      document.body.style.overflow = 'hidden'
    } else {
      document.body.style.overflow = ''
    }
    return () => {
      document.body.style.overflow = ''
    }
  }, [isOpen])

  if (!isOpen) return null

  if (!MERCADOPAGO_PUBLIC_KEY) {
    return (
      <div className="fixed inset-0 z-[60] flex items-center justify-center bg-black/50 p-4">
        <div className="max-w-md rounded-2xl bg-white p-6 shadow-2xl">
          <p className="text-sm text-red-600">
            Configure a variável <code>VITE_MERCADOPAGO_PUBLIC_KEY</code> para
            habilitar pagamentos online.
          </p>
          <button
            type="button"
            onClick={onClose}
            className="mt-4 w-full rounded-xl bg-gray-100 py-2 font-medium"
          >
            Fechar
          </button>
        </div>
      </div>
    )
  }

  const handleSubmit = async ({ formData }) => {
    setIsProcessing(true)
    try {
      const result = await processPayment({
        formData,
        items,
        customerName,
        address,
      })

      if (result.pix) {
        onPixResult?.({ pix: result.pix, amount, paymentId: result.id })
        onClose()
        return
      }

      if (result.status === 'approved') {
        onCardApproved?.({ amount, paymentId: result.id })
        onClose()
        return
      }

      if (result.status === 'pending' || result.status === 'in_process') {
        onError?.('Pagamento em processamento. Aguarde a confirmação.')
        return
      }

      onError?.('Pagamento não aprovado. Tente outro método.')
    } catch (error) {
      onError?.(error.message)
    } finally {
      setIsProcessing(false)
    }
  }

  return (
    <div className="fixed inset-0 z-[60] flex items-end justify-center bg-black/50 sm:items-center sm:p-4">
      <div
        className="relative flex max-h-[92vh] w-full max-w-lg flex-col overflow-hidden rounded-t-2xl bg-white shadow-2xl sm:rounded-2xl"
        role="dialog"
        aria-modal="true"
        aria-label="Pagamento Mercado Pago"
      >
        <div className="flex items-center justify-between border-b border-gray-100 px-5 py-4">
          <div>
            <h3 className="text-lg font-bold text-gray-900">Pagamento</h3>
            <p className="text-sm text-gray-500">Pix ou Cartão de Crédito</p>
          </div>
          <button
            type="button"
            onClick={onClose}
            disabled={isProcessing}
            className="rounded-lg p-2 text-gray-500 hover:bg-gray-100 disabled:opacity-50"
            aria-label="Fechar pagamento"
          >
            <X className="h-5 w-5" />
          </button>
        </div>

        <div className="overflow-y-auto px-4 py-4">
          {isProcessing && (
            <div className="mb-3 flex items-center gap-2 rounded-xl bg-emerald-50 px-3 py-2 text-sm text-emerald-800">
              <Loader2 className="h-4 w-4 animate-spin" />
              Processando pagamento...
            </div>
          )}

          <Payment
            initialization={{
              amount: Number(amount),
            }}
            customization={{
              paymentMethods: {
                creditCard: 'all',
                bankTransfer: 'all',
              },
            }}
            onSubmit={handleSubmit}
            onError={(error) => {
              console.error('Payment Brick error:', error)
              onError?.('Erro ao carregar o formulário de pagamento.')
            }}
          />
        </div>
      </div>
    </div>
  )
}
