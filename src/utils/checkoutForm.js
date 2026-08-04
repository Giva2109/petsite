/**
 * Valida e normaliza os dados do checkout (nome, telefone, endereço).
 */
export function normalizePhone(value) {
  return value.replace(/\D/g, '')
}

export function isValidPhone(value) {
  const digits = normalizePhone(value)
  return digits.length >= 10 && digits.length <= 15
}

export function validateCheckoutFields({ customerName, phone, address }) {
  const errors = {}
  const trimmedName = customerName.trim()
  const trimmedAddress = address.trim()
  const trimmedPhone = phone.trim()

  if (!trimmedName) {
    errors.customerName = 'Informe o nome do cliente'
  }

  if (!trimmedPhone) {
    errors.phone = 'Informe o telefone para contato'
  } else if (!isValidPhone(trimmedPhone)) {
    errors.phone = 'Telefone inválido (use DDD + número, 10 a 15 dígitos)'
  }

  if (!trimmedAddress) {
    errors.address = 'Informe o endereço de entrega'
  }

  return {
    errors,
    values: {
      customerName: trimmedName,
      phone: normalizePhone(trimmedPhone),
      address: trimmedAddress,
    },
  }
}
