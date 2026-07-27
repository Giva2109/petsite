import {
  createContext,
  useContext,
  useMemo,
  useCallback,
  useState,
} from 'react'

const CartContext = createContext(null)

/**
 * Provider do carrinho — estado isolado para facilitar migração futura
 * para API/backend (substituir persistência local por chamadas HTTP).
 */
export function CartProvider({ children }) {
  const [items, setItems] = useState([])

  const addItem = useCallback((product, quantity = 1) => {
    if (quantity < 1) return

    setItems((prev) => {
      const existing = prev.find((item) => item.product.id === product.id)
      if (existing) {
        return prev.map((item) =>
          item.product.id === product.id
            ? { ...item, quantity: item.quantity + quantity }
            : item
        )
      }
      return [...prev, { product, quantity }]
    })
  }, [])

  const removeItem = useCallback((productId) => {
    setItems((prev) => prev.filter((item) => item.product.id !== productId))
  }, [])

  const updateQuantity = useCallback((productId, quantity) => {
    if (quantity < 1) {
      setItems((prev) => prev.filter((item) => item.product.id !== productId))
      return
    }

    setItems((prev) =>
      prev.map((item) =>
        item.product.id === productId ? { ...item, quantity } : item
      )
    )
  }, [])

  const clearCart = useCallback(() => setItems([]), [])

  const totalItems = useMemo(
    () => items.reduce((sum, item) => sum + item.quantity, 0),
    [items]
  )

  const totalPrice = useMemo(() => {
    const hasUnknown = items.some(({ product }) => product.price == null)
    if (hasUnknown) return null

    return items.reduce(
      (sum, item) => sum + item.product.price * item.quantity,
      0
    )
  }, [items])

  const value = useMemo(
    () => ({
      items,
      addItem,
      removeItem,
      updateQuantity,
      clearCart,
      totalItems,
      totalPrice,
    }),
    [
      items,
      addItem,
      removeItem,
      updateQuantity,
      clearCart,
      totalItems,
      totalPrice,
    ]
  )

  return <CartContext.Provider value={value}>{children}</CartContext.Provider>
}

export function useCart() {
  const context = useContext(CartContext)
  if (!context) {
    throw new Error('useCart deve ser usado dentro de CartProvider')
  }
  return context
}
