import { useState } from 'react'
import { Loader2 } from 'lucide-react'
import { fetchAddressByCep, formatCepDisplay } from '../utils/viaCep'

function fieldClass(hasError) {
  return `w-full rounded-xl border px-3 py-2.5 text-base focus:outline-none focus:ring-2 ${
    hasError
      ? 'border-red-300 focus:border-red-400 focus:ring-red-200'
      : 'border-gray-200 focus:border-emerald-400 focus:ring-emerald-200'
  }`
}

export default function CheckoutAddressForm({
  zipCode,
  onZipCodeChange,
  street,
  onStreetChange,
  streetNumber,
  onStreetNumberChange,
  complement,
  onComplementChange,
  city,
  onCityChange,
  state,
  onStateChange,
  neighborhood,
  onNeighborhoodChange,
  sameDeliveryAddress,
  onSameDeliveryAddressChange,
  deliveryAddress,
  onDeliveryAddressChange,
  fieldErrors,
  onClearError,
}) {
  const [isLoadingCep, setIsLoadingCep] = useState(false)
  const [cepLookupError, setCepLookupError] = useState('')

  const handleCepBlur = async () => {
    const digits = zipCode.replace(/\D/g, '')
    if (digits.length !== 8) {
      return
    }

    setIsLoadingCep(true)
    setCepLookupError('')

    try {
      const result = await fetchAddressByCep(digits)
      if (!result) {
        setCepLookupError('CEP não encontrado')
        return
      }

      onStreetChange(result.street)
      onCityChange(result.city)
      onStateChange(result.state)
      onNeighborhoodChange(result.neighborhood)
      onClearError('street')
      onClearError('city')
      onClearError('state')
      onClearError('zipCode')
    } catch {
      setCepLookupError('Não foi possível buscar o CEP. Tente novamente.')
    } finally {
      setIsLoadingCep(false)
    }
  }

  return (
    <div className="space-y-3">
      <div>
        <label htmlFor="zip-code" className="mb-1 block text-sm font-medium text-gray-700">
          CEP <span className="text-red-500">*</span>
        </label>
        <div className="relative">
          <input
            id="zip-code"
            type="text"
            inputMode="numeric"
            autoComplete="postal-code"
            value={zipCode}
            onChange={(e) => {
              onZipCodeChange(formatCepDisplay(e.target.value))
              onClearError('zipCode')
              setCepLookupError('')
            }}
            onBlur={handleCepBlur}
            placeholder="00000-000"
            maxLength={9}
            required
            aria-invalid={Boolean(fieldErrors.zipCode)}
            className={fieldClass(fieldErrors.zipCode)}
          />
          {isLoadingCep && (
            <Loader2
              className="absolute right-3 top-1/2 h-4 w-4 -translate-y-1/2 animate-spin text-emerald-600"
              aria-hidden="true"
            />
          )}
        </div>
        {fieldErrors.zipCode && (
          <p className="mt-1 text-xs text-red-600">{fieldErrors.zipCode}</p>
        )}
        {cepLookupError && !fieldErrors.zipCode && (
          <p className="mt-1 text-xs text-amber-700">{cepLookupError}</p>
        )}
        <p className="mt-1 text-xs text-gray-500">
          Logradouro, cidade e estado são preenchidos automaticamente via ViaCEP.
        </p>
      </div>

      <div>
        <label htmlFor="street" className="mb-1 block text-sm font-medium text-gray-700">
          Logradouro <span className="text-red-500">*</span>
        </label>
        <input
          id="street"
          type="text"
          autoComplete="street-address"
          value={street}
          onChange={(e) => {
            onStreetChange(e.target.value)
            onClearError('street')
          }}
          placeholder="Rua, avenida..."
          required
          aria-invalid={Boolean(fieldErrors.street)}
          className={fieldClass(fieldErrors.street)}
        />
        {fieldErrors.street && (
          <p className="mt-1 text-xs text-red-600">{fieldErrors.street}</p>
        )}
      </div>

      <div className="grid grid-cols-2 gap-3">
        <div>
          <label
            htmlFor="street-number"
            className="mb-1 block text-sm font-medium text-gray-700"
          >
            Número <span className="text-red-500">*</span>
          </label>
          <input
            id="street-number"
            type="text"
            inputMode="numeric"
            autoComplete="address-line2"
            value={streetNumber}
            onChange={(e) => {
              onStreetNumberChange(e.target.value)
              onClearError('streetNumber')
            }}
            placeholder="123"
            required
            aria-invalid={Boolean(fieldErrors.streetNumber)}
            className={fieldClass(fieldErrors.streetNumber)}
          />
          {fieldErrors.streetNumber && (
            <p className="mt-1 text-xs text-red-600">{fieldErrors.streetNumber}</p>
          )}
        </div>

        <div>
          <label
            htmlFor="complement"
            className="mb-1 block text-sm font-medium text-gray-700"
          >
            Complemento
          </label>
          <input
            id="complement"
            type="text"
            value={complement}
            onChange={(e) => onComplementChange(e.target.value)}
            placeholder="Apto, bloco, sala..."
            className={fieldClass(false)}
          />
        </div>
      </div>

      <div className="grid grid-cols-2 gap-3">
        <div>
          <label htmlFor="city" className="mb-1 block text-sm font-medium text-gray-700">
            Cidade <span className="text-red-500">*</span>
          </label>
          <input
            id="city"
            type="text"
            autoComplete="address-level2"
            value={city}
            onChange={(e) => {
              onCityChange(e.target.value)
              onClearError('city')
            }}
            placeholder="Cidade"
            required
            aria-invalid={Boolean(fieldErrors.city)}
            className={fieldClass(fieldErrors.city)}
          />
          {fieldErrors.city && (
            <p className="mt-1 text-xs text-red-600">{fieldErrors.city}</p>
          )}
        </div>

        <div>
          <label htmlFor="state" className="mb-1 block text-sm font-medium text-gray-700">
            Estado <span className="text-red-500">*</span>
          </label>
          <input
            id="state"
            type="text"
            autoComplete="address-level1"
            value={state}
            onChange={(e) => {
              onStateChange(e.target.value.toUpperCase().slice(0, 2))
              onClearError('state')
            }}
            placeholder="UF"
            maxLength={2}
            required
            aria-invalid={Boolean(fieldErrors.state)}
            className={fieldClass(fieldErrors.state)}
          />
          {fieldErrors.state && (
            <p className="mt-1 text-xs text-red-600">{fieldErrors.state}</p>
          )}
        </div>
      </div>

      <div className="rounded-xl border border-gray-100 bg-gray-50 p-3">
        <label className="flex cursor-pointer items-start gap-3">
          <input
            type="checkbox"
            checked={sameDeliveryAddress}
            onChange={(e) => {
              onSameDeliveryAddressChange(e.target.checked)
              onClearError('sameDeliveryAddress')
              onClearError('deliveryAddress')
            }}
            className="mt-1 h-4 w-4 rounded border-gray-300 text-emerald-600 focus:ring-emerald-500"
          />
          <span className="text-sm text-gray-700">
            Endereço de entrega é o mesmo informado acima
          </span>
        </label>
        {fieldErrors.sameDeliveryAddress && (
          <p className="mt-2 text-xs text-red-600">{fieldErrors.sameDeliveryAddress}</p>
        )}
      </div>

      {!sameDeliveryAddress && (
        <div>
          <label
            htmlFor="delivery-address"
            className="mb-1 block text-sm font-medium text-gray-700"
          >
            Endereço de Entrega <span className="text-red-500">*</span>
          </label>
          <textarea
            id="delivery-address"
            value={deliveryAddress}
            onChange={(e) => {
              onDeliveryAddressChange(e.target.value)
              onClearError('deliveryAddress')
            }}
            placeholder="Rua, número, bairro, cidade, CEP..."
            rows={3}
            required
            aria-invalid={Boolean(fieldErrors.deliveryAddress)}
            className={`resize-none ${fieldClass(fieldErrors.deliveryAddress)}`}
          />
          {fieldErrors.deliveryAddress && (
            <p className="mt-1 text-xs text-red-600">{fieldErrors.deliveryAddress}</p>
          )}
        </div>
      )}
    </div>
  )
}
