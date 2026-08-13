import { useTenant } from '../context/TenantContext'

export default function HeroBanner() {
  const { tenant } = useTenant()

  return (
    <section className="mx-auto mb-6 w-full max-w-2xl overflow-hidden rounded-2xl border border-teal-600 shadow-md sm:mb-8">
      <div className="flex items-stretch">
        <div className="flex min-w-0 flex-[1.2] flex-col justify-center bg-gradient-to-br from-[#008f68] to-[#007a5c] px-3 py-3 text-white sm:px-5 sm:py-4">
          <p className="text-[9px] font-semibold uppercase tracking-[0.12em] text-emerald-100/90 sm:text-[11px]">
            Catálogo 2026 · Pedido via WhatsApp
          </p>
          <h1 className="mt-0.5 text-lg font-extrabold leading-tight sm:mt-1 sm:text-2xl">
            {tenant.name}
          </h1>
          <p className="mt-1 text-[11px] leading-snug text-emerald-50/95 sm:mt-1.5 sm:text-xs">
            {tenant.tagline}. Navegue pelo catálogo, monte o pedido e finalize pelo WhatsApp,
            Cartão ou PIX.
          </p>
        </div>

        <div className="flex w-[38%] shrink-0 items-center justify-center bg-[#faf7f2] p-2 sm:w-[42%] sm:p-3">
          <img
            src={tenant.logoUrl || '/logo.webp'}
            alt={`${tenant.name} — Cães, Gatos e Companhia`}
            className="h-16 w-auto max-w-full object-contain sm:h-24"
            width={1024}
            height={576}
            decoding="async"
          />
        </div>
      </div>
    </section>
  )
}
