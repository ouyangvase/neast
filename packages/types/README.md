# @neast/types

Shared API contract types + typed fetch client for the NEAST Expo apps
(tenant `/app`, owner `/landlord`, merchant `/merchant`). Consumed as **source**
(`"main": "src/index.ts"`) — Metro/TypeScript compile it directly, no build step.

```ts
import {
  createApiClient,
  useSessionStore,
  useIsLoggedIn,
  uploadFile,
} from '@neast/types';
```

## API client

```ts
import { createApiClient } from '@neast/types';

const api = createApiClient({
  prefix: '/app', // '/app' | '/landlord' | '/merchant'
  // baseUrl defaults to process.env.EXPO_PUBLIC_API_URL ?? 'http://127.0.0.1:9512'
  onLogout: (reason) => router.replace('/login'), // 'refresh_failed' | 'session_expired' | 'unauthorized'
});

const profile = await api.get<UserProfile>('user/profile');
const history = await api.get<RentHistoryListResponse>('rent/history/list', { page: 1, limit: 20 });
await api.post('rent/create', body);
await api.put(`rent/id/${id}/terminate`, { reason });
```

Contract behavior (mirrors the Hyperf backend exactly):

- Envelope `{ code, message | msg, data }`; success is `code == 200`. Any other
  code rejects with `ApiError` (`error.code`, `error.kind`, `error.message`).
- `Authorization: <raw token>` — no `Bearer ` prefix.
- Business `code == 400` ("login expired") triggers a **single-flight** token
  refresh (`POST {prefix}/auth/refresh-token?refreshToken=<token>`), retries the
  original request once, and on failure clears the session and calls `onLogout`.
- Every GET has a legacy 200ms delay (`getDelayMs: 0` disables it).

## Session store

Zustand + `expo-secure-store`; keys `auth_token` / `refresh_token` / `expires_time`.
Logged-in === refresh token present.

```ts
import { sessionStore, useIsLoggedIn, useSessionStatus } from '@neast/types';

// once at app start (splash gate):
await sessionStore.getState().hydrate();

// after login / refresh (the client does this internally on refresh):
await sessionStore.getState().setSession({ accessToken, refreshToken, expiresTime });

// on logout:
await sessionStore.getState().clearSession();

// in components:
const isLoggedIn = useIsLoggedIn();
const status = useSessionStatus(); // 'idle' | 'hydrating' | 'ready'
```

Use `createSessionStore({ storage })` for tests or a non-SecureStore backend.

## Uploads

```ts
const result = await api.uploadFile(
  { uri: asset.uri, name: 'agreement.pdf', type: 'application/pdf', size: asset.fileSize },
  { onProgress: (p) => setPct(p.loadedBytes / p.totalBytes), signal: abortController.signal },
);
// → { url, path, name } — pass `path` as the `file` field of rent/property forms
```

Files ≤ one chunk go to `POST {prefix}/upload/file`; larger files are chunked
(`upload/chunk` → `upload/merge`). Profiles: `/app` + `/landlord` = 512KB × 4
workers, `/merchant` = 256KB × 8 workers. Cancellation rejects with
`UploadCancelledError`. Backend limits: 10MB, ≤ 100 chunks.

## Helpers

- `registerFcmToken(api, token, platform)` / `unregisterFcmToken(api, token)` —
  call after login / before logout; fire-and-forget (errors swallowed by default).
- `classifyFiuuResultUrl(url)` → `0 | 1 | 2 | null` and
  `createFiuuResultTracker({ onPhaseChange, onResult })` — the H5 WebView result
  state machine (2.5s grace → 0.5s processing, 10s for pending).
- Formatters: `formatRinggit`, `formatThousands`, `formatSimpleDate`,
  `formatMonthYear`, `formatReadableDateTime`, `formatRelativeTime`,
  `normalizePhoneDigits`, `joinPhoneAccount`, `toDate`.
- Pagination (TanStack Query): `createPaginatedQuery({ queryKey, fetchPage })`
  slots straight into `useInfiniteQuery`; `flattenPaginatedPages(data.pages)`.
- Constants: `PAYMENT_METHODS`, `FIUU_CHANNELS`, `FPX_BANKS` (17) are defined in
  `@neast/constant` and re-exported here. Also `NEARBY_MERCHANT_RADIUS_KM`,
  `DEFAULT_API_BASE_URL`.

## Contract types

`contracts/app` (UserProfile, RentListItem, RentHistoryItem, WalletBalance,
PaymentQuote, PointsDashboard, RewardDashboard, CouponListItem, UserCouponItem,
MerchantListItem, ReferInfo, TentScore, HomeDashboard, AppConfig, …),
`contracts/landlord` (LandlordInfo, LandlordHomeDashboard, LandlordDueItem,
LandlordAckItem, LandlordBindRequestItem, LandlordProperty, LandlordPortfolio,
LandlordRentDetail, …), `contracts/merchant` (MerchantInfo, VerifyCouponResponse,
GivePointsStats, SettlementOverview, DailyClosingSummary, MerchantTopupItem, …),
`contracts/common` (PaginatedList, AuthTokens, MessageItem, AgreementDetail,
UploadFileResult, …).

Fields marked `mock-only` exist only in the dev mock server, not the real API.
