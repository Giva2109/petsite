import { Buffer } from 'buffer'
import { createStaticPix, hasError } from 'pix-utils'
import QRCode from 'qrcode'
import { normalizePixKey } from './pixKey'

if (typeof globalThis.Buffer === 'undefined') {
  globalThis.Buffer = Buffer
}

function sanitizeMerchantName(name = 'LOJA') {
  return String(name)
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .replace(/[^a-zA-Z0-9 ]/g, '')
    .trim()
    .slice(0, 25)
    .toUpperCase() || 'LOJA'
}

/**
 * Gera payload Pix estático (copia e cola) e QR Code em base64.
 */
export async function buildStaticPixPayload({
  pixKeyType,
  pixKey,
  amount,
  merchantName = 'LOJA',
  merchantCity = 'BRASIL',
}) {
  const normalizedKey = normalizePixKey(pixKeyType, pixKey)
  if (!normalizedKey) {
    throw new Error('Chave Pix da loja não configurada.')
  }

  const pix = createStaticPix({
    merchantName: sanitizeMerchantName(merchantName),
    merchantCity: sanitizeMerchantName(merchantCity).slice(0, 15) || 'BRASIL',
    pixKey: normalizedKey,
    transactionAmount: Number(amount),
  })

  if (hasError(pix)) {
    throw new Error('Não foi possível gerar o código Pix para esta loja.')
  }

  const qrCode = pix.toBRCode()
  const qrCodeBase64 = await QRCode.toDataURL(qrCode, {
    margin: 1,
    width: 280,
  })

  return {
    qr_code: qrCode,
    qr_code_base64: qrCodeBase64.replace(/^data:image\/png;base64,/, ''),
    pix_key: normalizedKey,
    pix_key_type: pixKeyType,
  }
}
