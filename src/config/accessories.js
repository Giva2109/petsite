export const ACCESSORY_TYPES = [
  { id: 'todos', label: 'Todos os acessórios' },
  { id: 'areia-gato', label: 'Areia de Gato' },
]

export function getAccessoryTypeLabel(typeId) {
  return ACCESSORY_TYPES.find((item) => item.id === typeId)?.label || typeId
}

export function getAccessoryTypeEmoji(typeId) {
  if (typeId === 'areia-gato') return '🪣'
  return '🛍️'
}
