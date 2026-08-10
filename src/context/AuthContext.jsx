import {
  createContext,
  useCallback,
  useContext,
  useMemo,
  useState,
} from 'react'
import {
  adminFetch,
  clearAuthSession,
  loadAuthSession,
  loginAdmin,
  saveAuthSession,
} from '../utils/authApi'
import { DEFAULT_TENANT_SLUG } from '../config/constants'

const AuthContext = createContext(null)

export function AuthProvider({ children }) {
  const [session, setSession] = useState(() => loadAuthSession())

  const login = useCallback(async ({ email, password, tenantSlug }) => {
    const data = await loginAdmin({
      tenantSlug: tenantSlug || DEFAULT_TENANT_SLUG,
      email,
      password,
    })
    const nextSession = {
      token: data.token,
      userId: data.userId,
      tenantId: data.tenantId,
      tenantSlug: data.tenantSlug,
      email: data.email,
      name: data.name,
    }
    saveAuthSession(nextSession)
    setSession(nextSession)
    return nextSession
  }, [])

  const logout = useCallback(() => {
    clearAuthSession()
    setSession(null)
  }, [])

  const authorizedFetch = useCallback(
    (path, options = {}) => {
      if (!session?.token) {
        throw new Error('Sessão expirada. Faça login novamente.')
      }
      return adminFetch(path, { ...options, token: session.token })
    },
    [session]
  )

  const value = useMemo(
    () => ({
      session,
      isAuthenticated: Boolean(session?.token),
      login,
      logout,
      authorizedFetch,
    }),
    [session, login, logout, authorizedFetch]
  )

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>
}

export function useAuth() {
  const context = useContext(AuthContext)
  if (!context) {
    throw new Error('useAuth deve ser usado dentro de AuthProvider')
  }
  return context
}
