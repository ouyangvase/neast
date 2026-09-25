/** Local Docker API (MySQL + Redis). iOS simulator and this Mac use the published port. */
export const DEFAULT_API_BASE_URL = 'http://127.0.0.1:9512';

/**
 * Secure-store keys. These exact strings are load-bearing: they mirror the
 * Flutter apps' SharedPreferences keys (`AppConstants`).
 */
export const SESSION_STORAGE_KEYS = {
  accessToken: 'auth_token',
  refreshToken: 'refresh_token',
  expiresTime: 'expires_time',
} as const;

/** Legacy parity: dio used 15s connect/receive timeouts. */
export const REQUEST_TIMEOUT_MS = 15_000;
/** Uploads get a larger per-request budget (chunk ≤ 512KB). */
export const UPLOAD_TIMEOUT_MS = 60_000;
/** Legacy parity: every GET in the Flutter clients has an artificial 200ms delay. */
export const GET_REQUEST_DELAY_MS = 200;

/** Payment methods accepted by topup / rent-pay / settlement order creation. */
export const PAYMENT_METHODS = ['fpx', 'tng', 'grab', 'visa'] as const;
export type PaymentMethod = (typeof PAYMENT_METHODS)[number];
/** Wallet-balance payment (rent pay + settlement pay). */
export const PAYMENT_METHOD_WALLET = 'wallet';

/**
 * Client method id → Fiuu channel (mirrors `config/autoload/fiuu.php`).
 * `fpx` resolves per-bank via `payment_channel`; the others are fixed.
 */
export const FIUU_CHANNELS: Readonly<Record<PaymentMethod, string>> = {
  fpx: 'fpx',
  tng: 'TNG-EWALLET',
  grab: 'GrabPay',
  visa: 'credit',
};

export interface FpxBank {
  name: string;
  channel: string;
}

/** The 17 FPX banks accepted by the backend (`fiuu.fpx_banks`). */
export const FPX_BANKS: readonly FpxBank[] = [
  { name: 'Affin Bank', channel: 'fpx_abb' },
  { name: 'Alliance Bank', channel: 'fpx_abmb' },
  { name: 'AmBank', channel: 'fpx_amb' },
  { name: 'BSN', channel: 'fpx_bsn' },
  { name: 'Bank Islam', channel: 'fpx_bimb' },
  { name: 'Bank Muamalat', channel: 'fpx_bmmb' },
  { name: 'Bank Rakyat', channel: 'fpx_bkrm' },
  { name: 'CIMB Clicks', channel: 'fpx_cimbclicks' },
  { name: 'HSBC Bank', channel: 'fpx_hsbc' },
  { name: 'Hong Leong Bank', channel: 'fpx_hlb' },
  { name: 'KFH', channel: 'fpx_kfh' },
  { name: 'Maybank2U', channel: 'fpx_mb2u' },
  { name: 'OCBC Bank', channel: 'fpx_ocbc' },
  { name: 'Public Bank', channel: 'fpx_pbb' },
  { name: 'RHB Bank', channel: 'fpx_rhb' },
  { name: 'Standard Chartered', channel: 'fpx_scb' },
  { name: 'UOB Bank', channel: 'fpx_uob' },
];

/** Server-side hardcoded radius for `/app/merchant/nearby` (MerchantService::NEARBY_RADIUS_KM). */
export const NEARBY_MERCHANT_RADIUS_KM = 20;
