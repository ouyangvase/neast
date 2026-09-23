import type {
  AckListResponse,
  AgreementDetail,
  AuditBindRequestBody,
  BindRequestListResponse,
  ConfirmAckBody,
  CountryCode,
  CreatePropertyBody,
  LandlordHomeDashboard,
  LandlordInfo,
  LandlordLoginBody,
  LandlordLoginResponse,
  LandlordPortfolio,
  LandlordProperty,
  LandlordPropertyListResponse,
  LandlordRecordListResponse,
  LandlordRegisterBody,
  LandlordRentDetail,
  LandlordSendCodeBody,
  MessageListResponse,
  UpdateBankDetailBody,
} from '@neast/types';

import { api } from './api';

/**
 * Typed wrappers for the full `/landlord/*` API surface (see PARITY.md).
 * `auth/refresh-token` and `upload/*` are handled inside @neast/types (client
 * + uploadFile); `push/*` via the FCM helpers.
 */

// ---- Auth ----

export const getCountryCodes = () => api.get<CountryCode[]>('auth/country-codes');

export const sendCode = (body: LandlordSendCodeBody) => api.post('auth/send-code', body);

export const login = (body: LandlordLoginBody) =>
  api.post<LandlordLoginResponse>('auth/login', body);

export const register = (body: LandlordRegisterBody) =>
  api.post<LandlordLoginResponse>('auth/register', body);

// ---- Info / bank ----

export const getLandlordInfo = () => api.get<LandlordInfo>('info');

export const updateBankDetail = (body: UpdateBankDetailBody) => api.post('bank-detail', body);

export const deleteAccount = () => api.post('delete-account');

// ---- Home ----

export const getHomeDashboard = () => api.get<LandlordHomeDashboard>('home/detail');

// ---- Ack ----

/** Unpaginated — the backend returns the full settled/unconfirmed list. */
export const getAckList = () => api.get<AckListResponse>('ack/list');

export const confirmAck = (id: number) =>
  api.post('ack/confirm', { id } satisfies ConfirmAckBody);

// ---- Bind requests ----

/** Unpaginated — the backend returns the full pending-bind list. */
export const getBindRequestList = () => api.get<BindRequestListResponse>('bind-request/list');

export const auditBindRequest = (body: AuditBindRequestBody) =>
  api.post('bind-request/audit', body);

// ---- Properties ----

export const getPropertyList = (page: number, limit: number) =>
  api.get<LandlordPropertyListResponse>('property/list', { page, limit });

export const createProperty = (body: CreatePropertyBody) =>
  api.post<LandlordProperty>('property/create', body);

// ---- Records ----

export const getRecordList = (query: {
  year: number;
  month: number;
  page: number;
  limit: number;
}) => api.get<LandlordRecordListResponse>('record/list', query);

// ---- Portfolio / rent ----

export const getPortfolioDetail = () => api.get<LandlordPortfolio>('portfolio/detail');

export const getRentDetail = (id: number) => api.get<LandlordRentDetail>(`rent/id/${id}`);

export const terminateRent = (id: number) => api.put(`rent/id/${id}/terminate`);

// ---- Messages (notifications) ----

export const getMessages = (page: number, limit = 15) =>
  api.get<MessageListResponse>('message/list', { page, limit });

export const markAllMessagesRead = () => api.post('message/read-all');

// ---- Agreements ----

export const getAgreement = (title: string) =>
  api.get<AgreementDetail | null>('agreement/detail', { title });
