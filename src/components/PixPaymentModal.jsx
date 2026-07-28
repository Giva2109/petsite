import { useState } from 'react'
import { X, Copy, Check } from 'lucide-react'
import { formatCurrency } from '../utils/currency'

export default function PixPaymentModal({ pix, amount, onClose }) {
  const [copied, setCopied] = useState(false)

  if (!pix) return null

  const handleCopy = async () => {
    try {
      await navigator.clipboard.writeText(pix.qr_code)
      setCopied(true)
      setTimeout(() => setCopied(false), 2500)
    } catch {
      setCopied(false)
    }
  }

  return (
    <div className="fixed inset-0 z-[60] flex items-center justify-center bg-black/50 p-4">
      <div
        className="max-h-[90vh] w-full max-w-md overflow-y-auto rounded-2xl bg-white p-6 shadow-2xl"
        role="dialog"
        aria-modal="true"
        aria-label="Pagamento Pix"
      >
        <div className="mb-4 flex items-start justify-between gap-3">
          <div>
            <h3 className="text-xl font-bold text-gray-900">Pague com Pix</h3>
            <p className="mt-1 text-sm text-gray-500">
              Escaneie o QR Code ou copie o código abaixo.
            </p>
          </div>
          <button
            type="button"
            onClick={onClose}
            className="rounded-lg p-2 text-gray-500 hover:bg-gray-100"
            aria-label="Fechar"
          >
            <X className="h-5 w-5" />
          </button>
        </div>

        <p className="mb-4 text-center text-2xl font-bold text-emerald-700">
          {formatCurrency(amount)}
        </p>

        {pix.qr_code_base64 && (
          <div className="mx-auto mb-4 flex justify-center rounded-xl border border-gray-100 bg-gray-50 p-4">
            <img
              src={`data:image/png;base64,${pix.qr_code_base64}`}
              alt="QR Code Pix"
              className="h-56 w-56 object-contain"
            />
          </div>
        )}

        <button
          type="button"
          onClick={handleCopy}
          className="flex w-full items-center justify-center gap-2 rounded-xl bg-emerald-600 py-3 font-semibold text-white transition hover:bg-emerald-700"
        >
          {copied ? (
            <>
              <Check className="h-5 w-5" />
              Código copiado!
            </>
          ) : (
            <>
              <Copy className="h-5 w-5" />
              Copiar Código Pix
            </>
          )}
        </button>

        <p className="mt-4 text-center text-xs text-gray-500">
          Após o pagamento, a confirmação pode levar alguns instantes.
        </p>
      </div>
    </div>
  )
}
