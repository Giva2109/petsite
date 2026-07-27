import { STORE_NAME, STORE_TAGLINE } from '../config/constants'

export default function HeroBanner() {
  return (
    <section className="mb-10 overflow-hidden rounded-3xl border-2 border-teal-600 shadow-xl lg:flex lg:items-stretch">
      {/* Texto — lado esquerdo */}
      <div className="flex flex-[1.15] flex-col justify-center bg-gradient-to-br from-[#008f68] to-[#007a5c] px-6 py-10 text-white sm:px-10 sm:py-12 lg:px-12 lg:py-14">
        <p className="text-xs font-semibold uppercase tracking-[0.15em] text-emerald-100/90 sm:text-sm">
          Catálogo 2026 · Pedido via WhatsApp
        </p>
        <h1 className="mt-3 text-4xl font-extrabold leading-tight sm:text-5xl lg:text-6xl">
          {STORE_NAME}
        </h1>
        <p className="mt-4 max-w-lg text-sm leading-relaxed text-emerald-50/95 sm:text-base lg:text-lg">
          {STORE_TAGLINE}. Navegue pelo catálogo completo, monte seu pedido e
          finalize pelo WhatsApp com cotação de preços via PIX.
        </p>
      </div>

      {/* Logotipo — lado direito */}
      <div className="flex flex-1 items-center justify-center self-stretch bg-[#faf7f2] p-2 sm:p-3">
        <img
          src="/logo.webp"
          alt={`${STORE_NAME} — Cães, Gatos e Companhia`}
          className="h-auto w-[98%] max-w-none object-contain sm:w-[97%] lg:max-h-[96%] lg:w-[98%]"
          width={1024}
          height={576}
          decoding="async"
        />
      </div>
    </section>
  )
}
