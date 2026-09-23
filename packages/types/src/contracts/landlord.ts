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

/** POST /landlord/auth/login response. */
export interface LandlordLoginResponse extends AuthTokens {
  profileCompleted: boolean;
  landlordId: string;
}

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

/** GET /landlord/info response (model + resolved bank header photo URL). */
export interface LandlordInfo {
  id: number;
  name: string;
  first_name: string;
  last_name: string;
  phone: string;
  email: string | null;
  bank_name: string | null;
  bank_account: string | null;
  account_holder_name: string | null;
  bank_header_photo: string | null;
  /** Absolute URL to the uploaded bank header photo. */
  bank_header_photo_url: string | null;
  status: number;
  created_at: string;
  updated_at: string;
}

/** POST /landlord/info/bank-detail body. */
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

export interface LandlordBindRequestItem {
  id: number;
  initials: string;
  user_name: string;
  rent: string;
  /** e.g. `Day 5`. */
  payday: string;
  property_name: string;
  property_address: string;
  rental_date: string;
  file_url: string;
}

/** GET /landlord/home/dashboard response. */
export interface LandlordHomeDashboard {
  has_unread_message: boolean;
  header: {
    collected: string;
    collection_rate: string;
    overdue_amount: string;
  };
  need_action: {
    overdue: number;
    due_soon: number;
    need_ack: number;
    bind_req: number;
  };
  overdue_list: LandlordDueItem[];
  due_soon_list: LandlordDueItem[];
  need_ack: LandlordAckItem | null;
  bind_request: LandlordBindRequestItem | null;
  portfolio: {
    properties: number;
    tenants: number;
    rent_roll: string;
  };
}

// ---------------------------------------------------------------------------
// Ack / bind requests
// ---------------------------------------------------------------------------

/** POST /landlord/ack/confirm body. */
export interface ConfirmAckBody {
  id: number;
}

/** GET /landlord/bind-request/list response (unpaginated). */
export interface BindRequestListResponse {
  items: LandlordBindRequestItem[];
}

/** POST /landlord/bind-request/audit body. */
export interface AuditBindRequestBody {
  id: number;
  result: 'approved' | 'rejected';
}

// ---------------------------------------------------------------------------
// Property
// ---------------------------------------------------------------------------

/** Landlord property (image/file resolved to absolute URLs by the backend). */
export interface LandlordProperty {
  id: number;
  landlord_id: number;
  sn: string;
  name: string;
  address: string;
  image: string;
  file: string;
  created_at: string;
  updated_at: string;
}
export type LandlordPropertyListResponse = PaginatedList<LandlordProperty>;

/** POST /landlord/property/create body. */
export interface CreatePropertyBody {
  name: string;
  address: string;
  /** Uploaded file paths from /landlord/upload/*. */
  image: string;
  file: string;
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

/** GET /landlord/portfolio response. */
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

/** GET /landlord/rent/detail?id= response. */
export interface LandlordRentDetail {
  id: number;
  tenant_name: string;
  tenant_initials: string;
  tenant_avatar: string;
  property_name: string;
  property_address: string;
  amount: string;
  paid_at: string;
  first_pay_month: string;
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
