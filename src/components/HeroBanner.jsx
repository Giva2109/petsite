import { useTenant } from '../context/TenantContext'

export default function HeroBanner() {
  const { tenant } = useTenant()

  return (
    <section className="mb-6 overflow-hidden rounded-2xl border-2 border-teal-600 shadow-lg sm:mb-10 sm:rounded-3xl sm:shadow-xl md:flex md:items-stretch">
      {/* Texto — lado esquerdo */}
      <div className="flex flex-col justify-center bg-gradient-to-br from-[#008f68] to-[#007a5c] px-4 py-4 text-white sm:px-8 sm:py-8 md:flex-[1.15] md:px-10 md:py-12 lg:px-12 lg:py-14">
        <p className="text-[10px] font-semibold uppercase tracking-[0.12em] text-emerald-100/90 sm:text-xs lg:text-sm">
          Catálogo 2026 · Pedido via WhatsApp
        </p>
        <h1 className="mt-1 text-2xl font-extrabold leading-tight sm:mt-3 sm:text-4xl lg:text-6xl">
          {tenant.name}
        </h1>
        <p className="mt-2 max-w-lg text-xs leading-relaxed text-emerald-50/95 sm:mt-4 sm:text-sm lg:text-lg">
          {tenant.tagline}. Navegue pelo catálogo completo, monte seu pedido e
          finalize pelo WhatsApp com cotação de preços, pagamento via Cartão de crédito ou PIX.
        </p>
      </div>

      {/* Logotipo — lado direito */}
      <div className="flex items-center justify-center bg-[#faf7f2] px-4 py-3 sm:p-3 md:flex-1 md:self-stretch">
        <img
          src={tenant.logoUrl || '/logo.webp'}
          alt={`${tenant.name} — Cães, Gatos e Companhia`}
          className="mx-auto h-auto w-1/2 max-w-[220px] object-contain sm:w-2/3 sm:max-w-[320px] md:w-[90%] md:max-h-[96%] md:max-w-none lg:w-[98%]"
          width={1024}
          height={576}
          decoding="async"
        />
      </div>
    </section>
  )
}
