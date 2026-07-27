import { MessageCircle, Truck, Shield } from 'lucide-react'
import { STORE_NAME, STORE_TAGLINE, WHATSAPP_NUMBER } from '../config/constants'
import BrandIcon from './BrandIcon'

export default function Footer() {
  const whatsappLink = `https://wa.me/${WHATSAPP_NUMBER}`

  return (
    <footer className="mt-16 border-t border-emerald-100 bg-emerald-900 text-emerald-50">
      <div className="mx-auto max-w-7xl px-4 py-12 sm:px-6 lg:px-8">
        <div className="grid gap-8 sm:grid-cols-2 lg:grid-cols-4">
          <div>
            <div className="flex items-center gap-2">
              <BrandIcon size="sm" />
              <span className="text-lg font-bold">{STORE_NAME}</span>
            </div>
            <p className="mt-3 text-sm text-emerald-200">{STORE_TAGLINE}</p>
          </div>

          <div>
            <h3 className="font-semibold text-white">Diferenciais</h3>
            <ul className="mt-3 space-y-2 text-sm text-emerald-200">
              <li className="flex items-center gap-2">
                <Truck className="h-4 w-4 shrink-0" aria-hidden="true" />
                Entrega rápida na região
              </li>
              <li className="flex items-center gap-2">
                <Shield className="h-4 w-4 shrink-0" aria-hidden="true" />
                Produtos originais e lacrados
              </li>
            </ul>
          </div>

          <div>
            <h3 className="font-semibold text-white">Pagamento</h3>
            <p className="mt-3 text-sm text-emerald-200">
              Finalize seu pedido pelo WhatsApp e pague via PIX ou QR Code com
              total segurança.
            </p>
          </div>

          <div>
            <h3 className="font-semibold text-white">Contato</h3>
            <a
              href={whatsappLink}
              target="_blank"
              rel="noopener noreferrer"
              className="mt-3 inline-flex items-center gap-2 rounded-xl bg-green-600 px-4 py-2.5 text-sm font-semibold text-white transition hover:bg-green-500"
            >
              <MessageCircle className="h-4 w-4" aria-hidden="true" />
              Fale conosco
            </a>
          </div>
        </div>

        <div className="mt-10 border-t border-emerald-800 pt-6 text-center text-sm text-emerald-300">
          © {new Date().getFullYear()} {STORE_NAME}. Todos os direitos reservados.
        </div>
      </div>
    </footer>
  )
}
