/**
 * `/merchant` contract types — field names verified against the Hyperf
 * controllers/models in `services/neast-api`.
 */
import type { AuthTokens, MessageListResponse, PaginatedList, TopupStatus } from './common';

// ---------------------------------------------------------------------------
// Auth
// ---------------------------------------------------------------------------

/** POST /merchant/auth/login body (email + password). */
export interface MerchantLoginBody {
  account: string;
  password: string;
}

/**
 * POST /merchant/auth/login response (`MerchantAuthService::issueTokens`).
 * Exactly `{accessToken, refreshToken, expiresTime, merchantId}` — there is no
 * `profileCompleted` on the merchant audience.
 */
export interface MerchantLoginResponse extends AuthTokens {
  merchantId: string;
}

// ---------------------------------------------------------------------------
// Info
// ---------------------------------------------------------------------------

/**
 * GET /merchant/info response (model `toArray()`, image rewritten to an
 * absolute URL). The email/phone/contact varchar columns are
 * `NOT NULL DEFAULT ''`, so unset values arrive as empty strings, never null.
 */
export interface MerchantInfo {
  id: number;
  latitude: string | null;
  longitude: string | null;
  name: string;
  category_id: number;
  address: string;
  image: string;
  registration_number: string;
  registration_no: string | null;
  points_per_rm: number;
  email: string;
  phone: string;
  contact_name: string;
  contact_phone: string;
  contact_email: string;
  /** Decimal string — wallet balance. */
  balance: string;
  status: number;
  is_recommended: number;
  created_at: string;
  updated_at: string;
}

// ---------------------------------------------------------------------------
// Coupon verify / redeem
// ---------------------------------------------------------------------------

/** POST /merchant/coupon/verify body. */
export interface VerifyCouponBody {
  /** Raw scanned string or 6-char manual code. */
  code: string;
}

/** POST /merchant/coupon/verify response. */
export interface VerifyCouponResponse {
  user_coupon_id: number;
  sn: string;
  name: string;
  discount_amount: string;
  used_points: number;
  /** `(string)`-cast by the backend — `''` when the coupon has no expiry. */
  expire_at: string;
  merchant_names: string[];
  customer_name: string;
  /** Masked phone/email for display. */
  contact: string;
}

/** POST /merchant/coupon/redeem body/response. */
export interface RedeemMerchantCouponBody {
  code: string;
}
export interface RedeemMerchantCouponResponse extends VerifyCouponResponse {
  redeemed_merchant_id: number;
  redeemed_at: string;
}

// ---------------------------------------------------------------------------
// Give points
// ---------------------------------------------------------------------------

/** GET /merchant/give-points/today-commission response. */
export interface TodayCommission {
  points: number;
  commission_rm: string;
}

/** GET /merchant/give-points/stats response. */
export interface GivePointsStats {
  customers_today: number;
  avg_spend: string;
  points_today: number;
  repeat_customers: number;
}

/** GET /merchant/give-points/customer?user_id= response. */
export interface GivePointsCustomer {
  account: string;
}

/**
 * POST /merchant/give-points/confirm body — mirrors the PHP validation rules
 * (`GivePoints.php`): customer is the customer's ACCOUNT string (phone, from
 * `GET /merchant/give-points/customer?user_id=` — NOT the numeric user id),
 * and `receipt_path` is REQUIRED.
 */
export interface ConfirmGivePointsBody {
  /** Customer account/phone (string, max 128); resolved via the user `account` column. */
  customer: string;
  /** Receipt amount (numeric, min 0.01) — send a decimal string. */
  amount: string;
  /** Integer, min 1. */
  points: number;
  /** Integer, min 1 — must equal the authenticated merchant's id. */
  merchant_id: number;
  /** Optional, max 500 chars. */
  notes?: string;
  /** Optional, max 64 chars. */
  receipt_number?: string;
  /** REQUIRED — uploaded receipt path from /merchant/upload/* (max 255 chars). */
  receipt_path: string;
}

/** POST /merchant/give-points/confirm response. */
export interface ConfirmGivePointsResponse {
  id: number;
  user_id: number;
  success: boolean;
}

// ---------------------------------------------------------------------------
// Points setting
// ---------------------------------------------------------------------------

/** GET /merchant/points-setting response. */
export interface MerchantPointsSetting {
  id: number;
  rent_points_multiplier: string;
  spend_points_multiplier: string;
  yuan_to_points: number;
  inviter_reward_points: number;
  invitee_reward_points: number;
}

// ---------------------------------------------------------------------------
// Settlement
// ---------------------------------------------------------------------------

/** GET /merchant/settlement/overview response. */
export interface SettlementOverview {
  id: number | null;
  /** `Y-m`. */
  bill_month: string;
  merchant_id: number;
  amount: string;
  points: number;
  /** Paid flag as a JSON integer (`(int) $bill->is_paid`), not a boolean. */
  is_paid: 0 | 1;
  redeemed: number;
  show_pay_now: boolean;
}

/** POST /merchant/settlement/pay/wallet body. */
export interface PaySettlementWalletBody {
  bill_id: number;
  payment_method: 'wallet';
}

/** POST /merchant/settlement/pay/create body. */
export interface CreateSettlementPaymentBody {
  bill_id: number;
  payment_method: string;
  payment_channel?: string;
}

/** POST /merchant/settlement/pay/create response. */
export interface CreateSettlementPaymentResponse {
  order_id: string;
  payment_url: string;
  bill_id: number;
}

// ---------------------------------------------------------------------------
// Daily closing
// ---------------------------------------------------------------------------

/** GET /merchant/daily-closing/summary response. */
export interface DailyClosingSummary {
  redeemed: number;
  points: number;
  customers: number;
  commission_rm: string;
}

/** GET /merchant/daily-closing/transactions item. */
export interface DailyClosingTransactionItem {
  id: number;
  /** `H:i`. */
  time: string;
  user_name: string;
  points: number;
  amount: string;
}
export type DailyClosingTransactionListResponse = PaginatedList<DailyClosingTransactionItem>;

// ---------------------------------------------------------------------------
// Wallet topup
// ---------------------------------------------------------------------------

/**
 * GET /merchant/wallet/topup/list item. `txn_id`/`channel` are
 * `NOT NULL DEFAULT ''` columns and `paid_at` falls back to `''` — all three
 * arrive as strings (empty when unset), never null.
 */
export interface MerchantTopupItem {
  id: number;
  merchant_id: number;
  amount: string;
  payment_method: string;
  order_id: string;
  status: TopupStatus;
  txn_id: string;
  channel: string;
  paid_at: string;
  created_at: string;
}
export type MerchantTopupListResponse = PaginatedList<MerchantTopupItem>;

/** POST /merchant/wallet/topup/create body/response. */
export interface CreateMerchantTopupBody {
  amount: string;
  payment_method: string;
  payment_channel?: string;
}
export interface CreateMerchantTopupResponse {
  order_id: string;
  payment_url: string;
}

// ---------------------------------------------------------------------------
// Transactions
// ---------------------------------------------------------------------------

/** GET /merchant/transaction/points item (query: year, page, limit). */
export interface MerchantPointsTransactionItem {
  id: number;
  amount: string;
  points: number;
  created_at: string;
}
export type MerchantPointsTransactionListResponse = PaginatedList<MerchantPointsTransactionItem>;

/** GET /merchant/transaction/redeemed item (query: year, page, limit). */
export interface MerchantRedeemedTransactionItem {
  id: number;
  name: string;
  redeemed_at: string;
}
export type MerchantRedeemedTransactionListResponse =
  PaginatedList<MerchantRedeemedTransactionItem>;

// ---------------------------------------------------------------------------
// Messages / config
// ---------------------------------------------------------------------------

export type MerchantMessageListResponse = MessageListResponse;

/** GET /merchant/config response. */
export interface MerchantConfig {
  show_alpha_notice: boolean;
  payment_processing_fees: Record<string, number>;
}
