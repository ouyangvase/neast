# Parity Checklist — neast-user (Flutter → Expo RN)

Maps every route and every `/app/*` endpoint from `docs/users.md` to its implementation.
Spec source: `docs/users.md` (30 routes, 49 endpoints, 4 tabs).

## Routes (30)

| #   | Route (go_router)          | File                                                                     | Status / notes                                                                                                   |
| --- | -------------------------- | ------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------- |
| 1   | `/splash`                  | `app/splash.tsx`                                                         | ✅ 1500ms → `navigateAfterSplash`                                                                                |
| 2   | `/` (tab shell)            | `app/index.tsx` + `src/features/{home,pay-rent,reward,account}/*Tab.tsx` | ✅ 4 tabs; state-based tab switch (IndexedStack parity); double-back-to-exit; home tab rebuilt to web-parity sections (see "Home tab" below) |
| 3   | `/login`                   | `app/login.tsx`                                                          | ✅ phone + country-code picker                                                                                   |
| 4   | `/verify`                  | `app/verify.tsx`                                                         | ✅ OtpInput, 60s resend countdown                                                                                |
| 5   | `/full-data`               | `app/full-data.tsx`                                                      | ✅ first-profile form (snake_case wire body)                                                                     |
| 6   | `/pay-rent/payment`        | `app/pay-rent/payment.tsx`                                               | ✅ wallet/H5, owner-bank fields when unbound, polls history 5×@1s → replace to history/detail                    |
| 7   | `/pay-rent/create`         | `app/pay-rent/create/index.tsx`                                          | ✅ choice screen; connect and manual are separate pages                                                          |
| 7a  | `/pay-rent/create/connect` | `app/pay-rent/create/connect.tsx`                                        | ✅ scan owner QR, agreement upload w/ progress dialog                                                            |
| 7b  | `/pay-rent/create/manual`  | `app/pay-rent/create/manual.tsx`                                         | ✅ typed property and owner, agreement upload w/ progress dialog                                                 |
| 8   | `/pay-rent/detail`         | `app/pay-rent/detail.tsx`                                                | ✅ info + Property Journey grid + agreement view (image preview / external) + terminate (5s countdown)           |
| 9   | `/pay-rent/history`        | `app/pay-rent/history/index.tsx`                                         | ✅ year chips (current − 0..9)                                                                                   |
| 10  | `/pay-rent/history/detail` | `app/pay-rent/history/detail.tsx`                                        | ✅ status screen + owner-invite entry when payout held (mock-only field)                                         |
| 11  | `/pay-rent/invite-owner`   | `app/pay-rent/invite-owner.tsx`                                          | ✅ mock-only endpoint tolerated; wa.me share                                                                     |
| 12  | `/wallet`                  | `app/wallet/index.tsx`                                                   | ✅ balance, presets [500/1000/1500/2000] + custom, records + MonthPicker                                         |
| 13  | `/wallet/payment`          | `app/wallet/payment.tsx`                                                 | ✅ quote w/ local fallback, FPX picker, create → H5 → success dialog                                             |
| 14  | `/pay-h5-webview`          | `app/pay-h5-webview.tsx`                                                 | ✅ shared `FiuuH5WebView` + callback store (pop-with-result parity)                                              |
| 15  | `/points`                  | `app/points/index.tsx`                                                   | ✅ dashboard, tier, expiring, voucher count                                                                      |
| 16  | `/points/history`          | `app/points/history.tsx`                                                 | ✅ paginated logs                                                                                                |
| 17  | `/reward/tier`             | `app/reward/tier.tsx`                                                    | ✅ current progress + tier list (icons id 1–5)                                                                   |
| 18  | `/coupon`                  | `app/coupon/index.tsx`                                                   | ✅ category chips + paginated list (guest-browsable)                                                             |
| 19  | `/coupon/detail`           | `app/coupon/detail.tsx`                                                  | ✅ redeem / use-now QR / fully-redeemed; coupon via selection store (go_router `extra` parity)   |
| 20  | `/coupon/my-vouchers`      | `app/coupon/my-vouchers.tsx`                                             | ✅ active/used/expired tabs; active → QR dialog                                                                  |
| 21  | `/merchant/:id`            | `app/merchant/[id].tsx`                                                  | ✅ detail, coupon sheet, external map, share, nearest alternative                                                |
| 22  | `/merchants`               | `app/merchants/index.tsx`                                                | ✅ `?kind=all\|recommended\|nearby&header=`                                                                      |
| 23  | `/merchants/map`           | `app/merchants/map.tsx`                                                  | ✅ react-native-maps + OSM `UrlTile`, category chips incl. hardcoded "5X Points" (id=5), collapsible deals sheet |
| 24  | `/scanner`                 | `app/scanner.tsx`                                                        | ✅ shared `QrScannerScreen`; result via `openScanner` callback                                                   |
| 25  | `/refer`                   | `app/refer.tsx`                                                          | ✅ refer/dashboard stats, copy code, Share H5 link                                                               |
| 26  | `/notification`            | `app/notification.tsx`                                                   | ✅ paginated; on focus: clear badge + read-all + invalidate                                                      |
| 27  | `/personal-data`           | `app/personal-data/index.tsx`                                            | ✅ read-only field list → edit                                                                                   |
| 28  | `/personal-data/edit`      | `app/personal-data/edit.tsx`                                             | ✅ `?field=` single-field edit incl. ID valid-until date wheel                                                   |
| 29  | `/account/my-qr`           | `app/account/my-qr.tsx`                                                  | ✅ `qrCode` payload + view-shot → MediaLibrary save                                                              |
| 30  | `/account/tent-score`      | `app/account/tent-score.tsx`                                             | ✅ Navy/gold gauge; score is `clamp(500 + onTime×10 − late×20, 0, 1000)`; current on-time month streak; `totalPaid` as-is |
| —   | `/properties`              | `app/properties.tsx`                                                     | ✅ Shared `ComingSoon` (navy header, no photo); guest-allowed; entry from home property promo |
| —   | `/rich-text`               | `app/rich-text.tsx`                                                      | ✅ `?title=` → agreement/detail → RichText                                                                       |
| —   | 404                        | `app/+not-found.tsx`                                                     | ✅                                                                                                               |

Cross-cutting in `app/_layout.tsx`: font gate, session hydrate, guest-mode allowlist
(`/login /splash /verify /full-data / /rich-text /merchants/map /merchants /coupon` — exact
doc parity — plus `/properties`, added with the web-parity home), merchant deep-link stash +
post-auth replay, ToastHost.

## Home tab (web-parity redesign)

`src/features/home/HomeTab.tsx` mirrors the tenant web home (`NEAST-source/apps/neast`) as a
thin composition of `src/features/home/components/`, top → bottom:

1. **Header** (deepBlue `#031B58` + metallic background art): NEAST text wordmark,
   one-line `Hello, {firstName}` greeting, then bell and scan (both `#0851AA` circles).
   Guests tap either icon to go to `/login`. Logged in: bell (unread badge) → `/notification`,
   scan looks up `getRentPropertyBySn` and opens
   `/pay-rent/create/connect` with that property filled in (otherwise “Property not found”).
2. **AmountCard** — guest: "Rent, made simple." / "Sign in to pay rent" → `/login`; logged in
   with `nextRent`: "Next Rent" / "Pay Rent Now" → `/pay-rent/detail`; logged in without
   `nextRent`: "Payment schedule pending" → payRent tab.
3. **CampaignCarousel** — full-bleed photos from `dashboard.banners` (admin `t_banner`:
   image, required `https://` link, sort, status, optional `starts_at`/`ends_at`).
   Auto-advances about every 4s. When no banner is active, three local samples slide
   instead (YOYO×LUCKIN plus two generated photos).
4. **NearbyDealsGrid** — "Nearby Deals" + "View all" → `/merchants` (replaces "View map" →
   `/merchants/map`); 3-tile grid from `dashboard.nearbyDeals` (guests:
   `getNearbyMerchantList`).
5. **JourneyPromo** — navy card: tier badge, streak sentence on top
   (`14 Month Streak, don't stop!`, or `Pay on time and your streak starts here.` at 0),
   then "Check out your tenant score", and a chevron → `/account/tent-score`
   (guests: "Review payment history" / "Sign in to check this out" → `/login`).
6. **PropertyPromo** — "Find a home" / "View properties" → `/properties`
   (shared `ComingSoon`: navy header, cream “Coming soon” label, message; no photo).

Removed from home: Today's Reward card, My Vouchers card, old `PromoCarousel`,
`GuestLoginPlaceholder` (guest sign-in now lives in AmountCard). Home renders
`dashboard.banners` again.

## Endpoints (49)

App-level wrappers live in `src/lib/endpoints.ts`; upload/push/refresh are inside
`@neast/types` helpers (`uploadFile`, `registerFcmToken`/`unregisterFcmToken`, client refresh).

| #   | Endpoint                          | Wrapper / helper                                    | Used by                                                        |
| --- | --------------------------------- | --------------------------------------------------- | -------------------------------------------------------------- |
| 1   | `GET /app/auth/country-codes`     | `getCountryCodes`                                   | `app/login.tsx`                                                |
| 2   | `POST /app/auth/send-code`        | `sendCode`                                          | `app/login.tsx`, `app/verify.tsx`                              |
| 3   | `POST /app/auth/login`            | `login`                                             | `app/verify.tsx`                                               |
| 4   | `POST /app/auth/refresh-token`    | `@neast/types` client (single-flight, business-400) | automatic                                                      |
| 5   | `GET /app/user/profile`           | `getUserProfile`                                    | `useUserProfile` (Account, Home, personal-data, my-qr)         |
| 6   | `POST /app/user/profile`          | `updateUserProfile`                                 | `app/full-data.tsx`, `app/personal-data/edit.tsx`              |
| 7   | `POST /app/user/delete-account`   | `deleteAccount`                                     | `AccountTab` (10s CountdownConfirmDialog)                      |
| 8   | `GET /app/user/tent-score`        | `getTentScore`                                      | `app/account/tent-score.tsx`                                   |
| 9   | `GET /app/config`                 | `getAppConfig`                                      | `useAppConfig` (fee fallback, alpha notice)                    |
| 10  | `GET /app/home/dashboard`         | `getHomeDashboard`                                  | `HomeTab`                                                      |
| 11  | `GET /app/rent/list`              | `getRentList`                                       | `PayRentTab`                       |
| 12  | `GET /app/rent/property`          | `getRentPropertyBySn`                               | `pay-rent/create/connect` (scan owner QR)                      |
| 13  | `POST /app/rent/create`           | `createRent`                                        | `pay-rent/create/connect`, `pay-rent/create/manual`            |
| 14  | `GET /app/rent/history/list`      | `getRentHistory`                                    | `PayRentTab`, history screens, payment polling                 |
| 15  | `POST /app/rent/invite`           | `sendRentInvite`                                    | `pay-rent/invite-owner` — **mock-only**, failure tolerated     |
| 16  | `POST /app/rent/pay/wallet`       | `payRentByWallet`                                   | `pay-rent/payment`                                             |
| 18  | `POST /app/rent/pay/create`       | `createRentPayment`                                 | `pay-rent/payment`                                             |
| 19  | `PUT /app/rent/id/{id}/terminate` | `terminateRent`                                     | `pay-rent/detail`                                              |
| 20  | `GET /app/wallet/balance`         | `getWalletBalance`                                  | `wallet`, `pay-rent/payment`, `AccountTab`                     |
| 21  | `GET /app/wallet/topup/list`      | `getWalletTopups`                                   | `wallet` (month filter)                                        |
| 22  | `POST /app/wallet/topup/create`   | `createWalletTopup`                                 | `wallet/payment`                                               |
| 23  | `GET /app/payment/quote`          | `getPaymentQuote`                                   | `wallet/payment`, `pay-rent/payment` (local fallback on error) |
| 24  | `GET /app/points/dashboard`       | `getPointsDashboard`                                | `points`                                                       |
| 25  | `GET /app/points/logs`            | `getPointsLogs`                                     | `points/history`                                               |
| 26  | `GET /app/reward/dashboard`       | `getRewardDashboard`                                | `RewardTab`, `reward/tier`                                     |
| 27  | `GET /app/coupon/categories`      | `getCouponCategories`                               | `coupon`                                                       |
| 28  | `GET /app/coupon/list`            | `getCouponList`                                     | `coupon`                             |
| 29  | `GET /app/coupon/merchant-list`   | `getMerchantCoupons`                                | `merchant/[id]` coupon sheet                                   |
| 30  | `GET /app/coupon/my-count`        | `getMyCouponCount`                                  | wrapped; unused (dropped from home with the My Vouchers card)  |
| 31  | `GET /app/coupon/my-list`         | `getMyCoupons`                                      | `coupon/my-vouchers`                                           |
| 32  | `GET /app/coupon/latest`          | `getLatestCoupon`                                   | wrapped; unused (home dashboard carries `todayReward`)         |
| 33  | `POST /app/coupon/redeem`         | `redeemCoupon`                                      | `useCouponActions` (confirm → redeem → QR)                     |
| 34  | `GET /app/merchant/list`          | `getMerchantList`                                   | `merchants?kind=all`                                           |
| 35  | `GET /app/merchant/recommended`   | `getRecommendedMerchants`                           | `merchants?kind=recommended`                                   |
| 36  | `GET /app/merchant/nearby/list`   | `getNearbyMerchantList`                             | `merchants?kind=nearby`, `HomeTab`                             |
| 37  | `GET /app/merchant/categories`    | `getMerchantCategories`                             | `merchants/map` chips                                          |
| 38  | `GET /app/merchant/detail`        | `getMerchantDetail`                                 | `merchant/[id]`                                                |
| 39  | `GET /app/merchant/nearby`        | `getNearbyMerchants`                                | `merchants/map`                                                |
| 40  | `GET /app/message/list`           | `getMessages`                                       | `notification`                                                 |
| 41  | `POST /app/message/read-all`      | `markAllMessagesRead`                               | `notification` (on focus)                                      |
| 42  | `GET /app/message/has-unread`     | `getHasUnread`                                      | `HomeTab` bell dot, `AccountTab` menu dot                      |
| 43  | `GET /app/refer/dashboard`        | `getReferDashboard`                                 | `refer`                                                        |
| 44  | `GET /app/agreement/detail`       | `getAgreement`                                      | `rich-text`                                                    |
| 45  | `POST /app/push/add-fcm-token`    | `@neast/types` `registerFcmToken`                   | `src/lib/push.ts` (on login)                                   |
| 46  | `POST /app/push/delete-fcm-token` | `@neast/types` `unregisterFcmToken`                 | `src/lib/push.ts` (on logout)                                  |
| 47  | `POST /app/upload/file`           | `@neast/types` `uploadFile` (≤512KB single shot)    | `useFileUpload` (agreement)                                    |
| 48  | `POST /app/upload/chunk`          | `@neast/types` `uploadFile` (512KB × 4 workers)     | `useFileUpload`                                                |
| 49  | `POST /app/upload/merge`          | `@neast/types` `uploadFile`                         | `useFileUpload`                                                |

## Known stubs / deviations

- `rent/invite` is **mock-only** (Agent T contract note): UI is implemented per spec;
  failures against the real API are tolerated and never block flows.
- Mock-only fields rendered when present, absent tolerated: rent list
  `landlord_bank_name/landlord_bank_last4/payout_status/invite_sent`; merchant list
  `latitude/longitude/special_deal/min_spend`; history `user_paid_at/payout_status`.
- Payment quote: real shape `{amount, methods: Record<method,{fee_percent,total_amount}>}`;
  on request failure the app falls back to `buildLocalPaymentQuote` with `/app/config` fee
  percents (Flutter `paymentQuoteProvider` parity).
- Scanner gallery-pick fallback (`MobileScannerController.analyzeImage`) is **not**
  implemented — `@neast/ui-mobile` `QrScannerScreen` has no gallery affordance.
- `Chevron` is imported from `@neast/ui-mobile` (integration landed; local copy removed).
- Merchants map is location-gated: no fallback map center — loading shows a spinner, denied
  location shows an error state with retry (matches the other location-gated providers).
- iOS push uses the `expo-notifications` device token (APNs) rather than FCM-on-iOS; Android
  uses FCM via `google-services.json`.
- Tab screens render conditionally instead of Flutter's keep-alive IndexedStack (tab state is
  preserved in Zustand; queries stay warm via TanStack cache).
- Copy is English (Flutter Chinese strings were not recovered).
