import { CheckCircle2, X } from 'lucide-react'
import { formatCurrency } from '../utils/currency'

export default function PaymentSuccess({ amount, paymentId, onClose }) {
  return (
    <div className="fixed inset-0 z-[60] flex items-center justify-center bg-black/50 p-4">
      <div
        className="relative w-full max-w-md rounded-2xl bg-white p-6 text-center shadow-2xl"
        role="dialog"
        aria-modal="true"
        aria-label="Pagamento aprovado"
      >
        <button
          type="button"
          onClick={onClose}
          className="absolute right-4 top-4 rounded-lg p-2 text-gray-500 hover:bg-gray-100"
          aria-label="Fechar"
        >
          <X className="h-5 w-5" />
        </button>

        <CheckCircle2 className="mx-auto h-16 w-16 text-emerald-600" />
        <h3 className="mt-4 text-2xl font-bold text-gray-900">
          Pagamento aprovado!
        </h3>
        <p className="mt-2 text-lg font-semibold text-emerald-700">
          {formatCurrency(amount)}
        </p>
        {paymentId && (
          <p className="mt-2 text-sm text-gray-500">ID: {paymentId}</p>
        )}
        <p className="mt-4 text-sm text-gray-600">
          Obrigado pela sua compra. Ao continuar, você será direcionado ao
          WhatsApp para enviar a confirmação do pedido.
        </p>
        <button
          type="button"
          onClick={onClose}
          className="mt-6 w-full rounded-xl bg-emerald-600 py-3 font-semibold text-white hover:bg-emerald-700"
        >
          Enviar confirmação e continuar
        </button>
      </div>
    </div>
  )
}
