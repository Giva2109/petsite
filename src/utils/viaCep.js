/**
 * Consulta endereço pelo CEP via ViaCEP (API pública brasileira, sem chave).
 * Documentação: https://viacep.com.br
 */
export function normalizeCep(value) {
  return value.replace(/\D/g, '').slice(0, 8)
}

export function formatCepDisplay(value) {
  const digits = normalizeCep(value)
  if (digits.length <= 5) return digits
  return `${digits.slice(0, 5)}-${digits.slice(5)}`
}

export async function fetchAddressByCep(cep) {
  const digits = normalizeCep(cep)
  if (digits.length !== 8) {
    return null
  }

  const response = await fetch(`https://viacep.com.br/ws/${digits}/json/`)
  if (!response.ok) {
    return null
  }

  const data = await response.json()
  if (data.erro) {
    return null
  }

  return {
    street: data.logradouro || '',
    neighborhood: data.bairro || '',
    city: data.localidade || '',
    state: data.uf || '',
  }
}
