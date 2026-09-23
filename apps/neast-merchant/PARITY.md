# neast-merchant — Flutter → Expo RN parity map

Spec: `docs/owner&merchant.md` (MERCHANT section). Stack: Expo SDK 56 / RN 0.85 /
React 19.2.3, Expo Router + TanStack Query + Zustand. API client:
`createApiClient({ prefix: '/merchant' })` from `@neast/types` (envelope
`code/message|msg/data`, raw-token `Authorization`, business-400 → single-flight
refresh via `POST /merchant/auth/refresh-token?refreshToken=`, 200ms GET delay —
all inside `@neast/types`).

## Route tree (17 routes)

| Route | File | Flutter source | Notes |
|---|---|---|---|
| `/splash` | `app/splash.tsx` | `splash/splash_screen.dart` | 1.5s min display after session hydrate |
| `/login` | `app/login.tsx` | `auth/pages/login_screen.dart` | email + password only |
| `/` | `app/index.tsx` | `main/pages/main_screen.dart` | 4-tab shell (Scan / Give Points / Settlement / Account), double-back-to-exit |
| `/scanner` | `app/scanner.tsx` | `scan/pages/qr_scanner_screen.dart` | `QrScannerScreen` from `@neast/ui-mobile`; result via `openScanner(cb)` |
| `/redeem-voucher` | `app/redeem-voucher.tsx` | `redeem/pages/redeem_voucher_screen.dart` | args via `openRedeemVoucher` stash; missing-args fallback |
| `/give-points/receipt-details` | `app/give-points/receipt-details.tsx` | `give_points/pages/receipt_details_screen.dart` | Step 1; live points preview |
| `/give-points/confirm-points` | `app/give-points/confirm-points.tsx` | `give_points/pages/confirm_points_screen.dart` | Step 2; phone or customer QR |
| `/daily-closing` | `app/daily-closing.tsx` | `daily_closing/pages/daily_closing_screen.dart` | Export Report stub omitted |
| `/settlement/payment` | `app/settlement/payment.tsx` | `settlement/pages/settlement_payment_screen.dart` | wallet or Fiuu H5 |
| `/wallet` | `app/wallet/index.tsx` | `wallet/pages/wallet_screen.dart` | presets 500/1000/1500/2000 + custom |
| `/wallet/payment` | `app/wallet/payment.tsx` | `wallet/pages/wallet_payment_screen.dart` | no wallet method; RM500 default arg |
| `/pay-h5-webview` | `app/pay-h5-webview.tsx` | `wallet/pages/wallet_pay_h5_webview_page.dart` | `FiuuH5WebView` from `@neast/ui-mobile` |
| `/transaction-history` | `app/transaction-history.tsx` | `transaction/pages/transaction_history_screen.dart` | Points / Redeemed tabs + year filter |
| `/account/store-profile` | `app/account/store-profile.tsx` | `account/pages/store_profile_screen.dart` | read-only |
| `/notification` | `app/notification.tsx` | `notification/pages/notification_screen.dart` | read-all + badge clear on focus |
| `/rich-text` | `app/rich-text.tsx` | `rich_text/pages/rich_text_screen.dart` | `?title=Legal` |
| `+not-found` | `app/+not-found.tsx` | `common/not_found_screen.dart` | router errorBuilder |

Tab screens live in `src/features/{scan,give-points,settlement,account}/` (tabs are
app state, not routes — IndexedStack parity).

## Endpoint coverage (24 `/merchant/*`)

| Endpoint | Hooked in |
|---|---|
| `POST auth/login` | `app/login.tsx` |
| `POST auth/refresh-token` | inside `@neast/types` client (single-flight) |
| `GET info` | `src/hooks/use-merchant.ts` (`useMerchantInfo`) |
| `GET config` | `src/hooks/use-merchant.ts` (`useMerchantConfig`) — processing fees |
| `POST coupon/verify` | `src/features/scan/ScanTab.tsx` |
| `POST coupon/redeem` | `app/redeem-voucher.tsx` |
| `GET give-points/today-commission` | `src/features/give-points/GivePointsTab.tsx` |
| `GET give-points/stats` | `src/features/give-points/GivePointsTab.tsx` |
| `GET give-points/customer` | `app/give-points/confirm-points.tsx` |
| `POST give-points/confirm` | `app/give-points/confirm-points.tsx` |
| `GET points-setting` | `GivePointsTab.tsx`, `app/give-points/receipt-details.tsx` |
| `GET settlement/overview` | `src/features/settlement/SettlementTab.tsx`, `app/settlement/payment.tsx` |
| `POST settlement/pay/wallet` | `app/settlement/payment.tsx` |
| `POST settlement/pay/create` | `app/settlement/payment.tsx` |
| `GET daily-closing/summary` | `app/daily-closing.tsx` |
| `GET daily-closing/transactions` | `app/daily-closing.tsx` |
| `GET wallet/topup/list` | `app/wallet/index.tsx` |
| `POST wallet/topup/create` | `app/wallet/payment.tsx` |
| `GET transaction/points` | `app/transaction-history.tsx` |
| `GET transaction/redeemed` | `app/transaction-history.tsx` |
| `GET message/list` | `app/notification.tsx` |
| `POST message/read-all` | `app/notification.tsx` |
| `GET agreement/detail` | `app/rich-text.tsx` |
| `POST push/add-fcm-token` | `src/lib/push.ts` via `registerFcmToken` |
| `POST push/delete-fcm-token` | `src/lib/push.ts` via `unregisterFcmToken` (before session clear) |
| `POST upload/file` · `upload/chunk` · `upload/merge` | inside `@neast/types` `uploadFile` (merchant profile 256KB × 8), driven by `src/hooks/use-upload.ts` |

## Intentionally omitted (Flutter stubs / dead code — no API behind them)

- **Invoice & Billing** (`/invoice`, `invoice_screen.dart`) — pure stub ("Please
  stay tuned." toasts); menu item removed from the Account tab.
- **Delete Account** dialog (`delete_account_dialog.dart`) — 10s countdown UI with
  no endpoint; menu item removed.
- **Export Report** (`daily_closing_screen.dart:127`) — no-op button; not rendered.
- Mock defaults (`give_points_constants.dart`: outlet `Sunway Pyramid`, receipt
  `R-2604-1108` / `48.60`) — not ported; real `/merchant/info` data is shown.
- `isRedeemToken` 32-hex pattern (`voucher_code_util.dart`) — defined but unused in
  the Flutter scan path; any scanned code goes straight to `coupon/verify`.
- Alpha-notice flow (`show_alpha_notice` from `/merchant/config`) — commented out
  everywhere in Flutter; only `payment_processing_fees` is consumed.
- `features/home/pages/home_screen.dart` (orphaned), `sms_scene_enum.dart`,
  `location_service.dart`, `auth_utils.dart` — dead code, not ported.
- Cashier line in the scan outlet card — commented out in Flutter.

## Contract discrepancies (found verifying against `services/neast-api` PHP)

1. **`POST give-points/confirm` body** — `@neast/types` `ConfirmGivePointsBody`
   declares `customer: number` (scanned user id) and optional `receipt_path`. The
   Hyperf controller validates `customer` as **string ≤128** and resolves it
   against `t_user.account` (phone); `receipt_path` is **required**. Sending the
   user id would 100% fail with "Customer not found". The app therefore sends the
   confirmed shape via a local `ConfirmGivePointsRequest` (`customer: string`,
   `receipt_path: string`) in `src/lib/endpoints.ts`. End-to-end path: customer QR
   `{"user_id": n}` → `GET give-points/customer?user_id=` → `data.account` fills
   the phone field → confirm posts that account string.
2. **`SettlementOverview.is_paid`** — contract says `boolean`; PHP returns int
   `0|1`. The app branches on truthiness only, which is correct for both.
3. **`MerchantLoginResponse.profileCompleted`** — contract field is absent from
   the PHP login payload (only `accessToken/refreshToken/expiresTime/merchantId`).
   Unused by the client (no profile-completion flow exists in the Flutter app).

## Spec ambiguities resolved

- **Points formula** — `docs/apps-overview.md` §6.2/§8.3 name `yuan_to_points` as
  "the admin-set rate"; `spend_points_multiplier` is never consumed server-side.
  Preview + confirm use `points = floor(amount_cents × yuan_to_points / 100)`
  (cents math avoids IEEE drift on values like 48.60).
- **Scan-tab branching** — `docs/apps-overview.md` §6.2 shows the scan tab
  branching user-QR vs voucher; `docs/owner&merchant.md` (from the Flutter source)
  says any scanned code → `coupon/verify`, with customer QR scanned only inside
  confirm-points. The latter is implemented.
- **Receipt upload timing** — `receipt_capture_service.dart` groups capture →
  compress → chunked upload; upload happens at capture time (progress dialog),
  before the details form. Retake = back to the tab.
- **Document scanner** — `cunning_document_scanner` has no Expo SDK equivalent;
  the documented Flutter fallback (camera/gallery via image_picker) is the only
  path. Compression keeps `image_compress_util.dart` semantics (skip <512KB,
  longest side 1920, JPEG q85) via `expo-image-manipulator`.
- **Gallery QR** — `scan_gallery_util.dart` → `expo-camera`'s `scanFromURLAsync`
  (QR only), empty result → "No QR code found" toast.
- **FCM on iOS** — `getDevicePushTokenAsync` returns the APNs token on iOS (no
  @react-native-firebase in this rebuild); Android gets the native FCM token via
  `google-services.json`. Same tradeoff as `apps/neast-user`.
- **Due date** — client-computed "10th of the month after `bill_month`"
  (`src/lib/format.ts` `settlementDueLabel`), per `docs/apps-overview.md` §6.2.
- **Wallet top-up success** — no dedicated success artwork exists for wallet
  (unlike redeem/give-points/settlement); an `Alert` is shown (user-app
  convention).

## Verification gates

- `pnpm install` (mutex) — OK
- `pnpm --filter neast-merchant typecheck` — OK
- `pnpm --filter neast-merchant lint` — OK
- `npx expo export --platform android` — OK (bundle + all assets)
