/**
 * Valida e normaliza os dados do checkout.
 */
export function normalizePhone(value) {
  return value.replace(/\D/g, '')
}

export function normalizeCep(value) {
  return value.replace(/\D/g, '').slice(0, 8)
}

export function isValidPhone(value) {
  const digits = normalizePhone(value)
  return digits.length >= 10 && digits.length <= 15
}

export function isValidCep(value) {
  return normalizeCep(value).length === 8
}

export function formatCepDisplay(value) {
  const digits = normalizeCep(value)
  if (digits.length <= 5) return digits
  return `${digits.slice(0, 5)}-${digits.slice(5)}`
}

export function formatDeliveryAddress({
  street,
  streetNumber,
  complement,
  neighborhood,
  city,
  state,
  zipCode,
}) {
  let address = `${street.trim()}, ${streetNumber.trim()}`

  if (complement?.trim()) {
    address += ` - ${complement.trim()}`
  }

  if (neighborhood?.trim()) {
    address += `, ${neighborhood.trim()}`
  }

  const location = `${city.trim()}/${state.trim().toUpperCase()}`
  const cep = formatCepDisplay(zipCode)
  return `${address} - ${location} - CEP ${cep}`
}

export function validateCheckoutFields({
  customerName,
  phone,
  zipCode,
  street,
  streetNumber,
  complement = '',
  city,
  state,
  neighborhood = '',
  sameDeliveryAddress,
  deliveryAddress,
}) {
  const errors = {}
  const trimmedName = customerName.trim()
  const trimmedPhone = phone.trim()
  const trimmedStreet = street.trim()
  const trimmedNumber = streetNumber.trim()
  const trimmedComplement = complement.trim()
  const trimmedCity = city.trim()
  const trimmedState = state.trim().toUpperCase()
  const trimmedNeighborhood = neighborhood.trim()
  const trimmedDelivery = deliveryAddress.trim()
  const normalizedCep = normalizeCep(zipCode)

  if (!trimmedName) {
    errors.customerName = 'Informe o nome do cliente'
  }

  if (!trimmedPhone) {
    errors.phone = 'Informe o telefone para contato'
  } else if (!isValidPhone(trimmedPhone)) {
    errors.phone = 'Telefone inválido (use DDD + número, 10 a 15 dígitos)'
  }

  if (!normalizedCep) {
    errors.zipCode = 'Informe o CEP'
  } else if (!isValidCep(normalizedCep)) {
    errors.zipCode = 'CEP inválido (8 dígitos)'
  }

  if (!trimmedStreet) {
    errors.street = 'Informe o logradouro'
  }

  if (!trimmedNumber) {
    errors.streetNumber = 'Informe o número'
  }

  if (!trimmedCity) {
    errors.city = 'Informe a cidade'
  }

  if (!trimmedState || trimmedState.length !== 2) {
    errors.state = 'Informe o estado (UF com 2 letras)'
  }

  if (!trimmedNeighborhood) {
    errors.neighborhood = 'Informe o bairro'
  }

  if (sameDeliveryAddress !== true && sameDeliveryAddress !== false) {
    errors.sameDeliveryAddress =
      'Marque se o endereço de entrega é o mesmo ou informe outro endereço'
  } else if (!sameDeliveryAddress && !trimmedDelivery) {
    errors.deliveryAddress = 'Informe o endereço de entrega'
  }

  const resolvedDeliveryAddress = sameDeliveryAddress
    ? formatDeliveryAddress({
        street: trimmedStreet,
        streetNumber: trimmedNumber,
        complement: trimmedComplement,
        neighborhood: trimmedNeighborhood,
        city: trimmedCity,
        state: trimmedState,
        zipCode: normalizedCep,
      })
    : trimmedDelivery

  return {
    errors,
    values: {
      customerName: trimmedName,
      phone: normalizePhone(trimmedPhone),
      zipCode: normalizedCep,
      street: trimmedStreet,
      streetNumber: trimmedNumber,
      complement: trimmedComplement,
      city: trimmedCity,
      state: trimmedState,
      neighborhood: trimmedNeighborhood,
      sameDeliveryAddress: Boolean(sameDeliveryAddress),
      deliveryAddress: resolvedDeliveryAddress,
    },
  }
}
