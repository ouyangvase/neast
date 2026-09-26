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

export {
  FIUU_CHANNELS,
  FPX_BANKS,
  PAYMENT_METHODS,
  PAYMENT_METHOD_WALLET,
  type FpxBank,
  type PaymentMethod,
} from '@neast/constant';

/** Server-side hardcoded radius for `/app/merchant/nearby` (MerchantService::NEARBY_RADIUS_KM). */
export const NEARBY_MERCHANT_RADIUS_KM = 20;
