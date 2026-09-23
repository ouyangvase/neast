import type {
  AgreementDetail,
  ConfirmGivePointsResponse,
  CreateMerchantTopupBody,
  CreateMerchantTopupResponse,
  CreateSettlementPaymentBody,
  CreateSettlementPaymentResponse,
  DailyClosingSummary,
  DailyClosingTransactionListResponse,
  GivePointsCustomer,
  GivePointsStats,
  MerchantConfig,
  MerchantInfo,
  MerchantLoginBody,
  MerchantLoginResponse,
  MerchantMessageListResponse,
  MerchantPointsSetting,
  MerchantPointsTransactionListResponse,
  MerchantRedeemedTransactionListResponse,
  MerchantTopupListResponse,
  PaySettlementWalletBody,
  RedeemMerchantCouponBody,
  RedeemMerchantCouponResponse,
  SettlementOverview,
  TodayCommission,
  VerifyCouponBody,
  VerifyCouponResponse,
} from '@neast/types';

import { api } from './api';

/**
 * Typed wrappers for the full `/merchant/*` API surface (24 endpoints — see
 * PARITY.md). `auth/refresh-token` and `upload/*` are handled inside
 * @neast/types (client + uploadFile); `push/*` via the FCM helpers.
 */

// ---- Auth ----

export const login = (body: MerchantLoginBody) =>
  api.post<MerchantLoginResponse>('auth/login', body);

// ---- Info ----

export const getMerchantInfo = () => api.get<MerchantInfo>('info');

// ---- Config ----

export const getMerchantConfig = () => api.get<MerchantConfig>('config');

// ---- Coupon (verify / redeem) ----

export const verifyCoupon = (code: string) =>
  api.post<VerifyCouponResponse>('coupon/verify', { code } satisfies VerifyCouponBody);

export const redeemCoupon = (code: string) =>
  api.post<RedeemMerchantCouponResponse>('coupon/redeem', {
    code,
  } satisfies RedeemMerchantCouponBody);

// ---- Give points ----

export const getTodayCommission = () => api.get<TodayCommission>('give-points/today-commission');

export const getGivePointsStats = () => api.get<GivePointsStats>('give-points/stats');

export const getGivePointsCustomer = (userId: number) =>
  api.get<GivePointsCustomer>('give-points/customer', { user_id: userId });

/**
 * Request body for POST /merchant/give-points/confirm.
 *
 * NOTE: the Hyperf controller validates `customer` as a string (max 128)
 * resolved against the user's account (phone), and `receipt_path` as REQUIRED
 * — @neast/types' ConfirmGivePointsBody (`customer: number`, optional
 * `receipt_path`) does not match the backend. See PARITY.md.
 */
export interface ConfirmGivePointsRequest {
  /** Customer account (phone) — from the QR lookup or manual entry. */
  customer: string;
  amount: string;
  points: number;
  merchant_id: number;
  notes?: string;
  receipt_number?: string;
  receipt_path: string;
}

export const confirmGivePoints = (body: ConfirmGivePointsRequest) =>
  api.post<ConfirmGivePointsResponse>('give-points/confirm', body);

// ---- Points setting ----

export const getPointsSetting = () => api.get<MerchantPointsSetting>('points-setting');

// ---- Settlement ----

export const getSettlementOverview = () => api.get<SettlementOverview>('settlement/overview');

/** The service returns the refreshed overview (SettlementService::payByWallet parity). */
export const paySettlementByWallet = (billId: number) =>
  api.post<SettlementOverview>('settlement/pay/wallet', {
    bill_id: billId,
    payment_method: 'wallet',
  } satisfies PaySettlementWalletBody);

export const createSettlementPayment = (body: CreateSettlementPaymentBody) =>
  api.post<CreateSettlementPaymentResponse>('settlement/pay/create', body);

// ---- Daily closing ----

export const getDailyClosingSummary = () => api.get<DailyClosingSummary>('daily-closing/summary');

export const getDailyClosingTransactions = (page: number, limit: number) =>
  api.get<DailyClosingTransactionListResponse>('daily-closing/transactions', { page, limit });

// ---- Wallet ----

export const getWalletTopups = (page: number, limit: number) =>
  api.get<MerchantTopupListResponse>('wallet/topup/list', { page, limit });

export const createWalletTopup = (body: CreateMerchantTopupBody) =>
  api.post<CreateMerchantTopupResponse>('wallet/topup/create', body);

// ---- Transactions ----

export const getPointsTransactions = (year: number, page: number, limit: number) =>
  api.get<MerchantPointsTransactionListResponse>('transaction/points', { year, page, limit });

export const getRedeemedTransactions = (year: number, page: number, limit: number) =>
  api.get<MerchantRedeemedTransactionListResponse>('transaction/redeemed', { year, page, limit });

// ---- Messages (notifications) ----

export const getMessages = (page: number, limit = 15) =>
  api.get<MerchantMessageListResponse>('message/list', { page, limit });

export const markAllMessagesRead = () => api.post('message/read-all');

// ---- Agreements ----

export const getAgreement = (title: string) =>
  api.get<AgreementDetail | null>('agreement/detail', { title });
