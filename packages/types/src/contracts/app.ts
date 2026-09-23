/**
 * `/app` (tenant app) contract types — field names verified against the
 * Hyperf controllers/models in `services/neast-api`.
 *
 * Fields marked `mock-only` exist in `apps/neast-user/mock-api/server.mjs`
 * but NOT in the real PHP API; they are optional so screens can be developed
 * against the mock, but must render sensibly when they are absent.
 */
import type {
  AgreementDetail,
  AuthTokens,
  MessageListResponse,
  PaginatedList,
  TopupStatus,
} from './common';

// ---------------------------------------------------------------------------
// Auth
// ---------------------------------------------------------------------------

/** POST /app/auth/login body (passwordless OTP login). */
export interface AppLoginBody {
  /** Full international number, digits only (`60123456789`). */
  account: string;
  code: string;
}

/** POST /app/auth/login response. */
export interface AppLoginResponse extends AuthTokens {
  profileCompleted: boolean;
  /** Numeric id serialized as string by the backend. */
  userId: string;
}

/** POST /app/auth/send-code body. */
export interface SendCodeBody {
  account: string;
}

// ---------------------------------------------------------------------------
// User profile
// ---------------------------------------------------------------------------

export type IdType = 'id_card' | 'passport';

/** GET /app/user/profile response (camelCase). */
export interface UserProfile {
  userId: string;
  account: string;
  email: string | null;
  firstName: string;
  lastName: string;
  idType: IdType | null;
  idNumber: string | null;
  /** `Y-m-d` or null. */
  idValidUntil: string | null;
  address: string | null;
  profileCompleted: boolean;
  points: number;
  /** Points expressed as an approximate RM value (server-formatted). */
  pointsApproxRm: string;
  /** Opaque string encoded into the user's QR (merchant scans it as JSON). */
  qrCode: string;
}

/** POST /app/user/profile body (snake_case — the wire format differs from GET). */
export interface UpdateProfileBody {
  first_name: string;
  last_name: string;
  id_type?: IdType;
  id_number?: string;
  /** `Y-m-d`. */
  id_valid_until?: string;
  address?: string;
  email?: string;
  invitation_code?: string;
}

// ---------------------------------------------------------------------------
// Rent
// ---------------------------------------------------------------------------

export const RENT_STATUS = {
  pending: 0,
  approved: 1,
  rejected: 2,
  pendingBind: 3,
  terminated: 4,
} as const;
export type RentStatus = (typeof RENT_STATUS)[keyof typeof RENT_STATUS];

/** GET /app/rent/list item (`RentModel::formatAppListItem`). */
export interface RentListItem {
  id: number;
  /** Decimal string, e.g. `"1200.00"`. */
  amount: string;
  file: string;
  file_url: string;
  /** Payday label (`Y-m-d` of month or day-of-month label per backend). */
  paid_at: string;
  /** `Y-m`. */
  first_pay_month: string;
  lease_months: number;
  /** `Y-m-d`. */
  expire_date: string;
  status: RentStatus;
  landlord_id: number;
  landlord_name: string;
  landlord_account_name: string;
  property_name: string;
  earn_points: number;
  created_at: string;
  can_pay: boolean;
  due_text: string;
  date_label: string;
  /** mock-only: present in the mock server, absent from the real API. */
  landlord_bank_name?: string;
  /** mock-only */
  landlord_bank_last4?: string;
  /** mock-only */
  payout_status?: string;
  /** mock-only */
  invite_sent?: boolean;
}

/** GET /app/rent/list response. */
export interface RentListResponse {
  items: RentListItem[];
  /** Global rent-points multiplier applied to rent payments. */
  rent_points_multiplier: string;
}

/** POST /app/rent/create body. */
export interface CreateRentBody {
  amount: string;
  /** Uploaded agreement path from /app/upload/*. */
  file: string;
  paid_at: string;
  /** `Y-m`. */
  first_pay_month: string;
  lease_months: number;
  property_name: string;
  property_id?: number;
  owner_name?: string;
}

/**
 * POST /app/rent/create response — intentionally slimmer than RentListItem
 * (`formatAppItem`: no file_url / landlord fields yet).
 */
export interface CreateRentResponse {
  id: number;
  amount: string;
  file: string;
  paid_at: string;
  first_pay_month: string;
  lease_months: number;
  expire_date: string;
  status: RentStatus;
  property_name: string;
  earn_points: number;
  created_at: string;
  can_pay: boolean;
  due_text: string;
  date_label: string;
}

/** GET /app/rent/property?sn= response. */
export interface RentProperty {
  id: number;
  name: string;
  landlord_name: string;
}

export const RENT_HISTORY_STATUS = {
  pending: 0,
  paid: 1,
  settled: 2,
  cancelled: 3,
} as const;
export type RentHistoryStatus = (typeof RENT_HISTORY_STATUS)[keyof typeof RENT_HISTORY_STATUS];

export type RentPayStatus = 'on_time' | 'late' | 'upcoming';

/** GET /app/rent/history/list item (full model + computed display fields). */
export interface RentHistoryItem {
  id: number;
  rent_id: number;
  user_id: number;
  amount: string;
  status: RentHistoryStatus;
  payment_method: string | null;
  /** e.g. `INV-0000001`. */
  payment_no: string;
  /** e.g. `October 2026` (`F Y`). */
  rental_period: string;
  paid_at: string | null;
  created_at: string;
  landlord_account_name: string;
  property_address: string;
  pay_status: RentPayStatus;
  /** Same value as pay_status (kept for the Flutter model parity). */
  display_status: RentPayStatus;
}

/** GET /app/rent/history/list query. */
export interface RentHistoryQuery {
  page?: number;
  limit?: number;
  year?: number;
  rent_id?: number;
}

/** POST /app/rent/pay/wallet body. */
export interface PayRentWalletBody {
  rent_id: number;
  payment_method: string;
}

/** POST /app/rent/pay/wallet response — the created/updated history item. */
export type PayRentWalletResponse = RentHistoryItem;

/** POST /app/rent/pay/create body. */
export interface CreateRentPaymentBody {
  rent_id: number;
  payment_method: string;
  /** FPX bank channel (`fpx_mb2u`, …) when method is fpx. */
  payment_channel?: string;
}

/** POST /app/rent/pay/create response. */
export interface CreateRentPaymentResponse {
  order_id: string;
  payment_url: string;
  history_id: number;
}

/** PUT /app/rent/id/{id}/terminate body. */
export interface TerminateRentBody {
  reason?: string;
}

// ---------------------------------------------------------------------------
// Wallet
// ---------------------------------------------------------------------------

/** GET /app/wallet/balance response. */
export interface WalletBalance {
  /** Decimal string. */
  balance: string;
}

/** GET /app/wallet/topup/list item. */
export interface WalletTopupItem {
  id: number;
  user_id: number;
  amount: string;
  payment_method: string;
  order_id: string;
  status: TopupStatus;
  txn_id: string | null;
  channel: string | null;
  paid_at: string | null;
  created_at: string;
}
export type WalletTopupListResponse = PaginatedList<WalletTopupItem>;

/** POST /app/wallet/topup/create body. */
export interface CreateTopupBody {
  amount: string;
  payment_method: string;
  payment_channel?: string;
}

/** POST /app/wallet/topup/create response. */
export interface CreateTopupResponse {
  order_id: string;
  payment_url: string;
}

/** POST /app/wallet/topup/verify body/response (return-from-H5 reconciliation). */
export interface VerifyTopupBody {
  order_id: string;
}
export interface VerifyTopupResponse {
  balance: string;
  topup: WalletTopupItem;
}

// ---------------------------------------------------------------------------
// Payment quote
// ---------------------------------------------------------------------------

/** Per-method quote: processing fee percent and charged total (decimal strings). */
export interface PaymentMethodQuote {
  fee_percent: number;
  total_amount: string;
}

/** GET /app/payment/quote?amount= response. */
export interface PaymentQuote {
  amount: string;
  methods: Partial<Record<string, PaymentMethodQuote>>;
}

// ---------------------------------------------------------------------------
// Points
// ---------------------------------------------------------------------------

export interface RewardTier {
  id: number;
  name: string;
  min_points: number;
  max_points: number;
}

/** GET /app/points/dashboard response. */
export interface PointsDashboard {
  points: number;
  tier: {
    current: RewardTier;
  };
  expiring: {
    points: number;
    expired_date: string;
  } | null;
  voucher_count: number;
  inviter_reward_points: number;
  invitee_reward_points: number;
}

/** GET /app/points/logs item. */
export interface PointsLogItem {
  id: number;
  user_id: number;
  points: number;
  title: string;
  subtitle: string;
  /** `d M Y`. */
  created_at: string;
}
export type PointsLogListResponse = PaginatedList<PointsLogItem>;

// ---------------------------------------------------------------------------
// Reward
// ---------------------------------------------------------------------------

/** GET /app/reward/dashboard response. */
export interface RewardDashboard {
  points: number;
  pointsExpiringText: string;
  tier: {
    current: RewardTier;
    next: RewardTier | null;
    pointsToNextTier: number;
    progressCurrent: number;
    progressTarget: number;
  };
  tiers: RewardTier[];
  featuredRewards: CouponListItem[];
  nearbyRewards: MerchantListItem[];
}

// ---------------------------------------------------------------------------
// Coupons
// ---------------------------------------------------------------------------

export type CouponActionStatus = 'redeem' | 'use_now' | 'fully_redeemed';
export type VoucherStatus = 'active' | 'used' | 'expired';

/** GET /app/coupon/list item. */
export interface CouponListItem {
  id: number;
  name: string;
  required_points: number;
  valid_days: number;
  category_id: number;
  category_name: string;
  image: string;
  usage_condition: string;
  /** Decimal string. */
  discount_amount: string;
  merchant_names: string[];
  expire_at: string | null;
  sn: string;
  qrcode: string;
  action_status: CouponActionStatus;
}
export type CouponListResponse = PaginatedList<CouponListItem>;

/** GET /app/coupon/my-list item. */
export interface UserCouponItem extends CouponListItem {
  user_coupon_id: number;
  redeemed_at: string | null;
  voucher_status: VoucherStatus;
}
export type UserCouponListResponse = PaginatedList<UserCouponItem>;

/** GET /app/coupon/my-count response. */
export interface UserCouponCount {
  count: number;
}

/** GET /app/coupon/latest response (`null` when nothing redeemable). */
export interface CouponLatestItem {
  id: number;
  name: string;
  required_points: number;
  image: string;
}

/** POST /app/coupon/redeem body/response. */
export interface RedeemCouponBody {
  coupon_id: number;
}
export interface RedeemCouponResponse {
  item: UserCouponItem;
}

/** GET /app/coupon/categories response (unpaginated). */
export interface CouponCategoryListResponse {
  items: Array<{ id: number; name: string }>;
}

// ---------------------------------------------------------------------------
// Merchants (tenant browse)
// ---------------------------------------------------------------------------

/** GET /app/merchant/list item. */
export interface MerchantListItem {
  id: number;
  name: string;
  address: string;
  image: string;
  category_id: number;
  /** km, when the caller supplied coordinates. */
  distance: number | null;
  /** mock-only */
  latitude?: string;
  /** mock-only */
  longitude?: string;
  /** mock-only */
  special_deal?: string;
  /** mock-only */
  min_spend?: string;
}
export type MerchantListResponse = PaginatedList<MerchantListItem>;

/** GET /app/merchant/nearby item + response. */
export interface NearbyMerchantItem {
  id: number;
  name: string;
  image: string;
  latitude: string;
  longitude: string;
  category_id: number;
  distance: number | null;
}
export interface NearbyMerchantResponse {
  items: NearbyMerchantItem[];
  /** Server-fixed radius (km). */
  radius: number;
}

/** GET /app/merchant/detail?id= response. */
export interface MerchantDetail {
  id: number;
  name: string;
  address: string;
  image: string;
  latitude: string | null;
  longitude: string | null;
  distance: number | null;
  nearest_merchant: MerchantListItem | null;
}

/** GET /app/merchant/categories response (unpaginated). */
export interface MerchantCategoryListResponse {
  items: Array<{ id: number; name: string }>;
}

// ---------------------------------------------------------------------------
// Refer
// ---------------------------------------------------------------------------

/** GET /app/refer/dashboard response. */
export interface ReferInfo {
  total_earned_points: number;
  invited_count: number;
  /** Hard cap on rewarded invites. */
  max_invite_limit: number;
  next_reward_points: number;
  invitation_code: string;
  invitee_reward_points: number;
  invite_url: string;
}

// ---------------------------------------------------------------------------
// Tent score
// ---------------------------------------------------------------------------

/** GET /app/user/tent-score response. */
export interface TentScore {
  score: number;
  maxScore: number;
  ratingLabel: string;
  maxStreakMonths: number;
  streakLabel: string;
  streakStatus: string;
  onTimePayments: number;
  latePayments: number;
  /** Server-formatted currency string, e.g. `RM5,400.00` — display as-is. */
  totalPaid: string;
  verifiedLeases: number;
  /** `M Y`. */
  since: string;
}

// ---------------------------------------------------------------------------
// Home
// ---------------------------------------------------------------------------

export interface HomeBanner {
  id: number;
  image: string;
  image_url: string;
  link: string;
}

/** GET /app/home/dashboard response. */
export interface HomeDashboard {
  nextRent: RentListItem | null;
  todayReward: CouponLatestItem | null;
  nearbyDeals: MerchantListItem[];
  journey: {
    maxStreakMonths: number;
    streakLabel: string;
    streakStatus: string;
  };
  banners: HomeBanner[];
}

// ---------------------------------------------------------------------------
// Messages / agreements / config
// ---------------------------------------------------------------------------

export type AppMessageListResponse = MessageListResponse;

/** GET /app/message/has-unread response (/app only). */
export interface HasUnreadResponse {
  has_unread: boolean;
}

export type AppAgreementDetail = AgreementDetail;

/** GET /app/config response. */
export interface AppConfig {
  show_alpha_notice: boolean;
  /** method id → fee percent (e.g. `{ fpx: 0, tng: 1.8, grab: 1.6, visa: 3.5 }`). */
  payment_processing_fees: Record<string, number>;
  payment_h5_base_url: string;
}
