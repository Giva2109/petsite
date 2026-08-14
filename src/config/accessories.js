export const ACCESSORY_TYPES = [
  { id: 'todos', label: 'Todos os acessórios' },
  { id: 'areia-gato', label: 'Areia de Gato' },
  { id: 'escova-secadora', label: 'Escova Secadora' },
  { id: 'bebedouro-pet', label: 'Bebedouro Pet' },
  { id: 'garrafa-bebedouro', label: 'Garrafa Bebedouro' },
  { id: 'luvas-pelos', label: 'Luvas Removedoras de Pelos' },
]

export function getAccessoryTypeLabel(typeId) {
  return ACCESSORY_TYPES.find((item) => item.id === typeId)?.label || typeId
}

export function getAccessoryTypeEmoji(typeId) {
  if (typeId === 'areia-gato' || typeId === 'Areia de Gato') return '🪣'
  if (typeId === 'escova-secadora' || typeId === 'Escova Secadora') return '💨'
  if (typeId === 'bebedouro-pet' || typeId === 'Bebedouro Pet') return '💧'
  if (typeId === 'garrafa-bebedouro' || typeId === 'Garrafa Bebedouro') return '🍼'
  if (typeId === 'luvas-pelos' || typeId === 'Luvas Removedoras de Pelos') return '🧤'
  return '🛍️'
}
