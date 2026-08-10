import { PIX_KEY_TYPES } from '../../utils/pixKey'

export default function PaymentSettingsFields({ form, setForm, hasAccessToken = false }) {
  return (
    <div className="space-y-4">
      <div className="rounded-xl border border-gray-100 bg-gray-50 p-4 space-y-3">
        <p className="text-sm font-semibold text-gray-800">
          Mercado Pago (Pix automático e cartão)
        </p>
        <input
          placeholder="Chave pública (Public Key)"
          value={form.mercadoPagoPublicKey}
          onChange={(e) =>
            setForm({ ...form, mercadoPagoPublicKey: e.target.value })
          }
          className="w-full rounded-xl border border-gray-200 px-3 py-2.5"
        />
        <input
          type="password"
          placeholder={
            hasAccessToken
              ? 'Access Token já configurado — digite para substituir'
              : 'Access Token (privado — só no painel)'
          }
          value={form.mercadoPagoAccessToken}
          onChange={(e) =>
            setForm({ ...form, mercadoPagoAccessToken: e.target.value })
          }
          className="w-full rounded-xl border border-gray-200 px-3 py-2.5"
        />
        <p className="text-xs text-gray-500">
          Credenciais em mercadopago.com.br/developers para esta loja.
        </p>
      </div>

      <div className="rounded-xl border border-gray-100 bg-gray-50 p-4 space-y-3">
        <p className="text-sm font-semibold text-gray-800">Pix manual (chave da loja)</p>
        <select
          value={form.pixKeyType}
          onChange={(e) => setForm({ ...form, pixKeyType: e.target.value })}
          className="w-full rounded-xl border border-gray-200 px-3 py-2.5"
        >
          <option value="">Tipo da chave Pix (opcional)</option>
          {PIX_KEY_TYPES.map((type) => (
            <option key={type.value} value={type.value}>
              {type.label}
            </option>
          ))}
        </select>
        <input
          placeholder="Chave Pix (telefone, CPF, CNPJ, e-mail ou aleatória)"
          value={form.pixKey}
          onChange={(e) => setForm({ ...form, pixKey: e.target.value })}
          className="w-full rounded-xl border border-gray-200 px-3 py-2.5"
        />
        <p className="text-xs text-gray-500">
          Use quando não tiver Mercado Pago. O cliente verá QR Code Pix com o
          valor do pedido.
        </p>
      </div>
    </div>
  )
}
