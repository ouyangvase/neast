/**
 * Contract types shared by all three API prefixes (`/app`, `/landlord`, `/merchant`).
 * Field names mirror the Hyperf JSON payloads exactly (mixed snake_case/camelCase
 * is intentional — the backend is inconsistent by design).
 */

/** Standard list envelope used by every paginated endpoint. */
export interface PaginatedList<T> {
  items: T[];
  total: number;
  page: number;
  limit: number;
}

/** GET {prefix}/auth/country-codes item (app + landlord only). */
export interface CountryCode {
  code: string;
}

/** Token triple persisted in secure storage after login / refresh. */
export interface AuthTokens {
  accessToken: string;
  refreshToken: string;
  /** Unix timestamp (seconds) returned by the API. */
  expiresTime: number;
}

/**
 * POST {prefix}/auth/refresh-token response. The backend re-issues the full
 * login payload (including the audience id field), but the client only
 * consumes these three fields.
 */
export type RefreshTokenResponse = AuthTokens;

/** Topup status shared by user + merchant topup models (0 待支付 1 成功 2 失败). */
export const TOPUP_STATUS = {
  pending: 0,
  success: 1,
  failed: 2,
} as const;
export type TopupStatus = (typeof TOPUP_STATUS)[keyof typeof TOPUP_STATUS];

/** Message (notification) list item — identical shape for all three audiences. */
export interface MessageItem {
  id: number;
  title: string;
  content: string;
  is_read: number;
  created_at: string;
}
export type MessageListResponse = PaginatedList<MessageItem>;

/** GET {prefix}/agreement/detail?title= — `null` when no agreement matches. */
export interface AgreementDetail {
  id: number;
  title: string;
  content: string;
  created_at: string;
  updated_at: string;
}

/** Upload result (`POST {prefix}/upload/file` and `POST {prefix}/upload/merge`). */
export interface UploadFileResult {
  url: string;
  path: string;
  name: string;
}

/** POST {prefix}/push/add-fcm-token body. */
export interface AddFcmTokenBody {
  token: string;
  platform?: 'ios' | 'android';
}

/** POST {prefix}/push/delete-fcm-token body. */
export interface DeleteFcmTokenBody {
  token: string;
}
