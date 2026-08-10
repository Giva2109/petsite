import { useRef, useState } from 'react'
import { ImagePlus, Loader2 } from 'lucide-react'
import { uploadAdminImage } from '../../utils/uploadApi'

/**
 * Campo de upload com preview no mesmo estilo do card de produto (aspect-square + object-contain).
 */
export default function ImageUploadField({
  label = 'Imagem',
  value = '',
  onChange,
  token,
  folder = 'products',
  category = 'caes',
  hint,
}) {
  const inputRef = useRef(null)
  const [isUploading, setIsUploading] = useState(false)
  const [error, setError] = useState('')
  const [previewError, setPreviewError] = useState(false)

  const handleFileChange = async (event) => {
    const file = event.target.files?.[0]
    if (!file) return

    setError('')
    setPreviewError(false)
    setIsUploading(true)

    try {
      const data = await uploadAdminImage({ file, token, folder })
      onChange(data.url)
    } catch (err) {
      setError(err.message)
    } finally {
      setIsUploading(false)
      event.target.value = ''
    }
  }

  return (
    <div className="space-y-2">
      <p className="text-sm font-medium text-gray-700">{label}</p>

      <div className="relative aspect-square w-full max-w-[220px] overflow-hidden rounded-2xl border border-gray-200 bg-gradient-to-br from-amber-50 to-emerald-50 p-2">
        {value && !previewError ? (
          <img
            src={value}
            alt="Pré-visualização"
            className="h-full w-full object-contain"
            onError={() => setPreviewError(true)}
          />
        ) : (
          <div className="flex h-full flex-col items-center justify-center gap-2 p-4 text-center text-emerald-700">
            <span className="text-4xl" aria-hidden="true">
              {category === 'gatos' ? '🐈' : '🐕'}
            </span>
            <p className="text-xs font-medium text-gray-500">
              {value && previewError ? 'Não foi possível carregar' : 'Sem imagem'}
            </p>
          </div>
        )}

        {isUploading && (
          <div className="absolute inset-0 flex items-center justify-center bg-white/80">
            <Loader2 className="h-8 w-8 animate-spin text-emerald-600" />
          </div>
        )}
      </div>

      <div className="flex flex-wrap gap-2">
        <button
          type="button"
          onClick={() => inputRef.current?.click()}
          disabled={isUploading || !token}
          className="inline-flex items-center gap-2 rounded-xl border border-emerald-200 bg-emerald-50 px-3 py-2 text-sm font-semibold text-emerald-800 hover:bg-emerald-100 disabled:opacity-50"
        >
          <ImagePlus className="h-4 w-4" />
          {isUploading ? 'Enviando...' : 'Enviar imagem'}
        </button>
        {value && (
          <button
            type="button"
            onClick={() => {
              onChange('')
              setPreviewError(false)
            }}
            className="rounded-xl border border-gray-200 px-3 py-2 text-sm text-gray-600 hover:bg-gray-50"
          >
            Remover
          </button>
        )}
      </div>

      <input
        ref={inputRef}
        type="file"
        accept="image/jpeg,image/png,image/webp,image/gif"
        className="hidden"
        onChange={handleFileChange}
      />

      <input
        placeholder="Ou cole uma URL (opcional)"
        value={value}
        onChange={(e) => {
          setPreviewError(false)
          onChange(e.target.value)
        }}
        className="w-full rounded-xl border border-gray-200 px-3 py-2.5 text-sm"
      />

      {hint && <p className="text-xs text-gray-500">{hint}</p>}
      {error && (
        <p className="rounded-xl bg-red-50 px-3 py-2 text-xs text-red-700">{error}</p>
      )}
    </div>
  )
}
