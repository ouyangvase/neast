/**
 * `/landlord` (owner app) contract types — field names verified against the
 * Hyperf controllers/models in `services/neast-api`. The landlord API is
 * snake_case throughout (unlike /app's camelCase profile).
 */
import type { AuthTokens, MessageListResponse, PaginatedList } from './common';

// ---------------------------------------------------------------------------
// Auth
// ---------------------------------------------------------------------------

/** POST /landlord/auth/send-code body. */
export interface LandlordSendCodeBody {
  phone: string;
  scene: 'login' | 'register';
}

/** POST /landlord/auth/login body. */
export interface LandlordLoginBody {
  phone: string;
  code: string;
}

/**
 * POST /landlord/auth/login response (`LandlordAuthService::issueTokens`).
 * Exactly `{accessToken, refreshToken, expiresTime, landlordId}` — there is no
 * `profileCompleted` on the landlord audience.
 */
export interface LandlordLoginResponse extends AuthTokens {
  landlordId: string;
}

/** POST /landlord/auth/register response — same payload as login. */
export type LandlordRegisterResponse = LandlordLoginResponse;

/** POST /landlord/auth/register body. */
export interface LandlordRegisterBody {
  phone: string;
  code: string;
  first_name: string;
  last_name: string;
}

// ---------------------------------------------------------------------------
// Info / bank
// ---------------------------------------------------------------------------

/**
 * GET /landlord/info response (model `toArray()` + resolved bank header photo
 * URL). All varchar columns are `NOT NULL DEFAULT ''`, so unset values arrive
 * as empty strings, never null.
 */
export interface LandlordInfo {
  id: number;
  name: string;
  first_name: string;
  last_name: string;
  phone: string;
  email: string;
  bank_name: string;
  bank_account: string;
  account_holder_name: string;
  bank_header_photo: string;
  /** Absolute URL to the uploaded bank header photo (`''` when unset). */
  bank_header_photo_url: string;
  status: number;
  created_at: string;
  updated_at: string;
}

/** POST /landlord/bank-detail body. */
export interface UpdateBankDetailBody {
  bank_name: string;
  bank_account: string;
  account_holder_name: string;
  /** Uploaded file path from /landlord/upload/*. */
  bank_header_photo: string;
}

// ---------------------------------------------------------------------------
// Home dashboard
// ---------------------------------------------------------------------------

export interface LandlordDueItem {
  id: number;
  tenant_initials: string;
  tenant_name: string;
  unit_address: string;
  status_text: string;
  amount: string;
  property_name: string;
  property_address: string;
  rental_date: string;
  status: 'overdue' | 'due_soon';
  file_url: string;
}

export interface LandlordAckItem {
  id: number;
  initials: string;
  name: string;
  amount: string;
  paid_text: string;
  paid_date: string;
  property_name: string;
  property_address: string;
  rental_date: string;
  file_url: string;
}

/** GET /landlord/home/detail response. */
export interface LandlordHomeDashboard {
  has_unread_message: boolean;
  header: {
    collected: string;
    /** Integer percent (0–100) — arrives as a JSON number. */
    collection_rate: number;
    overdue_amount: string;
  };
  need_action: {
    overdue: number;
    due_soon: number;
    need_ack: number;
  };
  overdue_list: LandlordDueItem[];
  due_soon_list: LandlordDueItem[];
  need_ack: LandlordAckItem | null;
  portfolio: {
    properties: number;
    tenants: number;
    rent_roll: string;
  };
}

// ---------------------------------------------------------------------------
// Ack
// ---------------------------------------------------------------------------

/** GET /landlord/ack/list response — full list, NOT paginated. */
export interface AckListResponse {
  items: LandlordAckItem[];
}

/** POST /landlord/ack/confirm body. */
export interface ConfirmAckBody {
  id: number;
}

// ---------------------------------------------------------------------------
// Property
// ---------------------------------------------------------------------------

/** Landlord property (image resolved to an absolute URL by the backend). */
export interface LandlordProperty {
  id: number;
  landlord_id: number;
  sn: string;
  name: string;
  address: string;
  image: string;
  created_at: string;
  updated_at: string;
}
export type LandlordPropertyListResponse = PaginatedList<LandlordProperty>;

/** POST /landlord/property/create body. */
export interface CreatePropertyBody {
  name: string;
  address: string;
  /** Uploaded photo path from /landlord/upload/*. */
  image: string;
}

// ---------------------------------------------------------------------------
// Record / portfolio / rent detail
// ---------------------------------------------------------------------------

/** GET /landlord/record/list item (collected rent payments). */
export interface LandlordRecordItem {
  id: number;
  amount: string;
  created_at: string;
  user_name: string;
  initials: string;
  avatar: string;
}

/** GET /landlord/record/list response. */
export interface LandlordRecordListResponse extends PaginatedList<LandlordRecordItem> {
  /** Sum of the filtered records (decimal string). */
  amount_sum: string;
}

/** GET /landlord/portfolio/detail response. */
export interface LandlordPortfolio {
  rent_roll: string;
  tenant_count: number;
  tenants: Array<{
    id: number;
    initials: string;
    name: string;
    address: string;
    avatar: string;
  }>;
}

/** GET /landlord/rent/id/{id} response. */
export interface LandlordRentDetail {
  id: number;
  tenant_name: string;
  tenant_initials: string;
  tenant_avatar: string;
  property_name: string;
  property_address: string;
  amount: string;
  /** Rent payday as an integer day-of-month (1–31) — a JSON number, not a date. */
  paid_at: number;
  /** `Y-m`. */
  agreement_start: string;
  /** `Y-m`. */
  agreement_end: string;
  /** `Y-m`. First month billed on NEAST. */
  first_pay_month: string;
  /** Months from `first_pay_month` through `agreement_end`, inclusive. */
  lease_months: number;
  expire_date: string;
  created_at: string;
  file_url: string;
  status: number;
  can_terminate: boolean;
}

/** PUT /landlord/rent/id/{id}/terminate body. */
export interface LandlordTerminateRentBody {
  reason?: string;
}

// ---------------------------------------------------------------------------
// Messages / config
// ---------------------------------------------------------------------------

export type LandlordMessageListResponse = MessageListResponse;

/** GET /landlord/config response. */
export interface LandlordConfig {
  show_alpha_notice: boolean;
}
