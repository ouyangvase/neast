import type {
  AgreementDetail,
  AppLoginBody,
  AppLoginResponse,
  CountryCode,
  CouponCategoryListResponse,
  CouponLatestItem,
  CouponListResponse,
  CreateRentBody,
  CreateRentResponse,
  CreateTopupBody,
  CreateTopupResponse,
  HasUnreadResponse,
  HomeDashboard,
  MerchantCategoryListResponse,
  MerchantDetail,
  MerchantListResponse,
  MessageListResponse,
  NearbyMerchantResponse,
  PaginatedList,
  PaymentQuote,
  PointsLogListResponse,
  RedeemCouponResponse,
  ReferInfo,
  RentListResponse,
  RentProperty,
  RewardDashboard,
  SendCodeBody,
  TentScore,
  UpdateProfileBody,
  UserCouponCount,
  UserCouponListResponse,
  UserProfile,
  CouponStatus,
  WalletBalance,
  WalletTopupListResponse,
} from '@neast/types';

import { api } from './api';
import type { Coords } from './location';
import type { RentHistoryEntry } from './types';

/**
 * Typed wrappers for the full `/app/*` API surface (49 endpoints — see
 * PARITY.md). `auth/refresh-token` and `upload/*` are handled inside
 * @neast/types (client + uploadFile); `push/*` via the FCM helpers.
 */

// ---- Auth ----

export const getCountryCodes = () => api.get<CountryCode[]>('auth/country-codes');

export const sendCode = (account: string) =>
  api.post<{ sent?: boolean }>('auth/send-code', { account } satisfies SendCodeBody);

export const login = (body: AppLoginBody) => api.post<AppLoginResponse>('auth/login', body);

// ---- User ----

export const getUserProfile = () => api.get<UserProfile>('user/profile');

export const updateUserProfile = (body: UpdateProfileBody) => api.post('user/profile', body);

export const deleteAccount = () => api.post('user/delete-account');

export const getTentScore = () => api.get<TentScore>('user/tent-score');

// ---- Home ----

export const getHomeDashboard = (coords: Coords | null) =>
  api.get<HomeDashboard>('home/dashboard', {
    latitude: coords?.latitude,
    longitude: coords?.longitude,
  });

// ---- Rent ----

export const getRentList = () => api.get<RentListResponse>('rent/list');

export const getRentPropertyBySn = (sn: string) => api.get<RentProperty>('rent/property', { sn });

export const createRent = (body: CreateRentBody) =>
  api.post<CreateRentResponse>('rent/create', body);

export const updateRent = (rentId: number, body: CreateRentBody) =>
  api.put<CreateRentResponse>(`rent/id/${rentId}`, body);

export const getRentHistory = (query: {
  page?: number;
  limit?: number;
  year?: number;
  rent_id?: number;
}) => api.get<PaginatedList<RentHistoryEntry>>('rent/history/list', query);

export const linkRent = (rentId: number, sn: string) =>
  api.put<CreateRentResponse>(`rent/id/${rentId}/link`, { sn });

export const saveOwnerContact = (
  rentId: number,
  body: { owner_name: string; owner_email: string; owner_phone: string },
) =>
  api.put<{ owner_name: string; owner_email: string; owner_phone: string }>(
    `rent/id/${rentId}/owner-contact`,
    body,
  );

export const payRentByWallet = (rentId: number) =>
  api.post<RentHistoryEntry>('rent/pay/wallet', {
    rent_id: rentId,
    payment_method: 'wallet',
  });

export const terminateRent = (id: number, reason?: string) =>
  api.put(`rent/id/${id}/terminate`, { reason });

// ---- Wallet ----

export const getWalletBalance = () => api.get<WalletBalance>('wallet/balance');

export const getWalletTopups = (query: {
  page?: number;
  limit?: number;
  year?: number;
  month?: number;
}) => api.get<WalletTopupListResponse>('wallet/topup/list', query);

export const createWalletTopup = (body: CreateTopupBody) =>
  api.post<CreateTopupResponse>('wallet/topup/create', body);

// ---- Payment quote ----

export const getPaymentQuote = (amount: string) =>
  api.get<PaymentQuote>('payment/quote', { amount });

// ---- Points ----

export const getPointsLogs = (page: number, limit = 15) =>
  api.get<PointsLogListResponse>('points/logs', { page, limit });

// ---- Reward ----

export const getRewardDashboard = (coords: Coords | null) =>
  api.get<RewardDashboard>('reward/dashboard', {
    latitude: coords?.latitude,
    longitude: coords?.longitude,
  });

// ---- Coupons ----

export const getCouponCategories = () => api.get<CouponCategoryListResponse>('coupon/categories');

export const getCouponList = (page: number, limit: number, categoryId?: number) =>
  api.get<CouponListResponse>('coupon/list', { page, limit, category_id: categoryId });

export const getMerchantCoupons = (merchantId: number) =>
  api.get<CouponListResponse>('coupon/merchant-list', { merchant_id: merchantId });

export const getMyCouponCount = () => api.get<UserCouponCount>('coupon/my-count');

export const getMyCoupons = (page: number, limit: number, status: CouponStatus) =>
  api.get<UserCouponListResponse>('coupon/my-list', { page, limit, status });

export const getLatestCoupon = () => api.get<CouponLatestItem | null>('coupon/latest');

export const redeemCoupon = (couponId: number) =>
  api.post<RedeemCouponResponse>('coupon/redeem', { coupon_id: couponId });

// ---- Merchants (browse) ----

interface MerchantListQuery {
  [key: string]: string | number | undefined;
  page?: number;
  limit?: number;
  category_id?: number;
  latitude?: number;
  longitude?: number;
}

export const getMerchantList = (query: MerchantListQuery) =>
  api.get<MerchantListResponse>('merchant/list', query);

export const getRecommendedMerchants = (query: MerchantListQuery) =>
  api.get<MerchantListResponse>('merchant/recommended', query);

export const getNearbyMerchantList = (query: MerchantListQuery) =>
  api.get<MerchantListResponse>('merchant/nearby/list', query);

export const getMerchantCategories = () =>
  api.get<MerchantCategoryListResponse>('merchant/categories');

export const getMerchantDetail = (id: number, coords: Coords | null) =>
  api.get<MerchantDetail>('merchant/detail', {
    id,
    latitude: coords?.latitude,
    longitude: coords?.longitude,
  });

export const getNearbyMerchants = (coords: Coords, categoryId?: number) =>
  api.get<NearbyMerchantResponse>('merchant/nearby', {
    latitude: coords.latitude,
    longitude: coords.longitude,
    category_id: categoryId,
  });

// ---- Messages (notifications) ----

export const getMessages = (page: number, limit = 15) =>
  api.get<MessageListResponse>('message/list', { page, limit });

export const markAllMessagesRead = () => api.post('message/read-all');

export const getHasUnread = () => api.get<HasUnreadResponse>('message/has-unread');

// ---- Refer ----

export const getReferDashboard = () => api.get<ReferInfo>('refer/dashboard');

// ---- Agreements ----

export const getAgreement = (title: string) =>
  api.get<AgreementDetail | null>('agreement/detail', { title });
