# Flutter → React Native Rebuild Inventory

> **⚠️ Flutter-era inventory (historical reference).** This was the spec for the rebuild and is kept for traceability. Both apps are now Expo / React Native: routes in `apps/<app>/app/`, features in `apps/<app>/src/features/`, API wiring in `apps/<app>/src/lib/endpoints.ts`. Route-by-route parity status: `apps/neast-owner/PARITY.md` and `apps/neast-merchant/PARITY.md`. Omissions/deviations: `docs/rn-migration-notes.md`.

Base paths used below:
- `OWNER` = `/Users/hanxiangwong/Desktop/Neast/neast-monorepo/apps/neast-owner`
- `MERCHANT` = `/Users/hanxiangwong/Desktop/Neast/neast-monorepo/apps/neast-merchant`

Both apps are near-identical in architecture (Riverpod 3, go_router 17, dio 5, freezed, SharedPreferences). The dio client, pagination infra, `AppRefresher`, toast/notifier utils, push service, and chunked upload service are copy-paste twins differing only in the `/landlord` vs `/merchant` API prefix and a few constants.

---

# OWNER (landlord app)

## 0. Identity / size
- pubspec (`OWNER/pubspec.yaml`): package `neast_landlords`, version **1.0.6+14**. No flavors / no `--dart-define` env config anywhere.
- Android (`OWNER/android/app/build.gradle.kts`): `applicationId = "com.neastLandlords.flutter"`, label `Neast Owner` (AndroidManifest). iOS (`OWNER/ios/Runner.xcodeproj/project.pbxproj`): `PRODUCT_BUNDLE_IDENTIFIER = com.neastLandlords.flutter`, `CFBundleDisplayName = Neast Owner`.
- Firebase (`OWNER/lib/firebase_options.dart`): project `neast-73f05` (shared with merchant app).
- `MaterialApp.title` is oddly `'YaGuo'` (`OWNER/lib/core/app.dart:31`).
- Size: **170 dart files** under `lib/` (144 excluding `.freezed.dart`/`.g.dart`), **20 screens**.

## 1. lib/core layer

### Network — `OWNER/lib/core/network/dio_client.dart`
- Base URL constant in `OWNER/lib/core/constants/app_constants.dart`: `apiBaseUrl = 'http://10.0.2.2:9512'` (Android emulator loopback; hardcoded, no env switching). Timeouts 15s connect/receive.
- Envelope: every response must be `{code: int, message|msg: String, data: ...}`. `code == 200` → success; `code == 400` → treated as token-expired → refresh flow; anything else → reject with `message`/`msg`.
- Auth header: `Authorization: <accessToken>` (raw token, **no `Bearer` prefix**), read from SharedPreferences on every request.
- Token refresh: `POST /landlord/auth/refresh-token` with query param `refreshToken` (constant `_refreshPath`, dio_client.dart:22), using a bare Dio instance to bypass interceptors; in-flight requests are suspended on a `Completer` (single-refresh dedupe); retried once with `extra['_retried'] = true`; on failure → toast + `authProvider.logout()`. HTTP 401 → logout if logged in. Note: `get()` has an artificial `Future.delayed(200ms)`.
- Storage keys (app_constants.dart): `auth_token`, `refresh_token`, `expires_time` (SharedPreferences).

### Router — `OWNER/lib/core/router/`
`app_router.dart`: `initialLocation: /splash`, redirect → `/login` when not logged in (except `/login`, `/verify`, `/splash`). Full route list (paths from `routes.dart`, mappings from `routes/*.dart`):

| Path | Name | Screen | Notes |
|---|---|---|---|
| `/splash` | splash | `SplashScreen` | |
| `/` | main | `MainScreen` | 4-tab shell; `?fromSplash=true` triggers fade-scale transition |
| `/login` | login | `LoginScreen` | |
| `/verify` | verify | `VerifyScreen` | query params: `phone`, `mode` (login/signup), `firstName`, `lastName` |
| `/rich-text` | richText | `RichTextScreen` | `extra`: title string |
| `/notification` | notification | `NotificationScreen` | |
| `/rent-detail` | rentDetail | `RentDetailScreen` | `extra`: `RentItemModel` (has hardcoded fallback dummy data) |
| `/ack-list` | ackList | `AckListScreen` | |
| `/ack-detail` | ackDetail | `AckDetailScreen` | `extra`: `AckItemModel` (hardcoded fallback dummy) |
| `/bind-request-list` | bindRequestList | `BindRequestListScreen` | |
| `/bind-request-detail` | bindRequestDetail | `BindRequestDetailScreen` | `extra`: `BindRequestItemModel` (required) |
| `/add-property` | addProperty | `AddPropertyScreen` | |
| `/bank-detail` | bankDetail | `BankDetailScreen` | |
| `/portfolio-snapshot` | portfolioSnapshot | `PortfolioSnapshotScreen` | |
| `/portfolio-tenant-detail` | portfolioTenantDetail | `PortfolioTenantDetailScreen` | `extra`: rentId int (or `?id=`) |

### Theme
- `OWNER/lib/core/theme/app_colors.dart` — `AppColors` ThemeExtension: brandBlue `0xFF0851AA`, darkGreen `0xFF3EBF7A`, blackText `0xFF0F172A` (light + dark variants).
- `OWNER/lib/core/theme/app_theme.dart` — `AppTheme.lightTheme/darkTheme`, primaryColor `0xFF4ADB77`, Cupertino page transitions on all platforms, `themeModeProvider`.

### core/widgets
Only one: `OWNER/lib/core/widgets/app_refresher.dart` — `AppRefresher` (EasyRefresh wrapper, English pull texts, accent `0xFF234FA5`) with static `buildHeader`/`buildFooter`.

### Utils / services / providers / pagination
- `core/utils/`: `toast_util.dart` (fluttertoast, 1.5s debounce), `notifier_utils.dart` (`runGuarded` Ref/WidgetRef extensions — central error→toast), `date_format_utils.dart`, `eph_extension.dart` (`int.eph`/`ewp` SizedBox), `price_extension.dart` (thousands separator), `landlord_session_reset.dart` (logout state cleanup), `auth_utils.dart` (**mostly dead/commented**).
- `core/services/location_service.dart` — Geolocator wrapper; **defined but never used**.
- `core/providers/shared_providers.dart` — `sharedPreferencesProvider` (overridden in `main.dart`), `loggerProvider`.
- `core/pagination/` — generic Riverpod paginated-list infra: `paginated_list_state.dart`, `paginated_list_notifier.dart`, `paginated_list_family_notifier.dart`, `paginated_list_logic.dart`.

## 2. Feature inventory (`OWNER/lib/features/`)

### auth
- Screens: `pages/login_screen.dart` (TabController: Log in = phone only; Sign up = first/last name + phone; country code picker sheet, default `+60`; phone = dial code + digits e.g. `60123456`), `pages/verify_screen.dart` (6-digit Pinput, resend sheet).
- `provider/login_provider.dart`: `AuthMode { login, signup }` with `scene => 'login' | 'register'`.
- `services/auth_service.dart` endpoints:
  - `GET /landlord/auth/country-codes`
  - `POST /landlord/auth/send-code` — `{phone, scene: 'login'|'register'}`
  - `POST /landlord/auth/login` — `{phone, code}`
  - `POST /landlord/auth/register` — `{phone, code, first_name, last_name}`
- Models: `LoginResponse {landlordId, accessToken, refreshToken, expiresTime}`, `CountryCodeModel`, `sms_scene_enum.dart` (**dead code** — unused legacy enum).
- Logout: deletes FCM token (3s timeout), clears session state, clears 3 prefs keys, `go(/login)`.

### home (tab 1)
- Screens: `pages/home_screen.dart` (dashboard: collected/collection-rate/overdue header, need-action cards, portfolio snapshot card, quick actions), `ack_list_screen.dart`, `ack_detail_screen.dart` (confirm receipt of rent payment), `bind_request_list_screen.dart`, `bind_request_detail_screen.dart` (audit tenant bind requests), `rent_detail_screen.dart` (view lease + open agreement file via url_launcher), `portfolio_snapshot_screen.dart`, `portfolio_tenant_detail_screen.dart` (lease detail + terminate).
- Services / endpoints:
  - `home_service.dart`: `GET /landlord/home/detail`
  - `ack_service.dart`: `GET /landlord/ack/list`; `POST /landlord/ack/confirm` `{id}`
  - `bind_request_service.dart`: `GET /landlord/bind-request/list`; `POST /landlord/bind-request/audit` `{id, result}`
  - `portfolio_service.dart`: `GET /landlord/portfolio/detail`
  - `landlord_rent_service.dart`: `GET /landlord/rent/id/{id}`; `PUT /landlord/rent/id/{id}/terminate` `{reason?}`
- Models: `HomeDashboardModel` (header/needAction/portfolio + nested items), `AckItemModel`, `BindRequestItemModel`, `RentItemModel`, `LandlordRentDetailModel`, `PortfolioDetailModel` (`portfolio_snapshot_models.dart`).

### properties (tab 2)
- Screens: `pages/properties_screen.dart` (paginated list; QR button per property; "Add Property" gated — refreshes `landlordInfoProvider`, shows `BankDetailRequiredDialog` if `bank_account` empty), `pages/add_property_screen.dart` (name, address, photo upload, document upload, create → success dialog).
- `services/property_service.dart`: `GET /landlord/property/list?page&limit`; `POST /landlord/property/create` `{name, address, image, file}`.
- Model: `PropertyModel {id, sn, name, address, image, file, landlordId, ...}` + `PropertyListResponse`.
- Utils: `property_file_picker.dart` (image_picker / file_picker), `property_file_actions.dart` (`openRemoteFileUrl` via url_launcher).

### records (tab 3)
- Screen: `pages/records_screen.dart` (month picker `record_month_picker.dart`, paginated list, **"Generate PDF" button is a no-op stub**, records_screen.dart:156).
- `services/record_service.dart`: `GET /landlord/record/list?year&month&page&limit`. Model: `RecordItemModel` + `RecordListResponse`.

### account (tab 4)
- Screens: `pages/account_screen.dart` (header + operations menu: Bank detail, About Us, Terms and Conditions, Privacy Policy, Delete Account, Log Out), `pages/bank_detail_screen.dart` (bank name/account/holder + bank-header photo upload).
- `services/landlord_service.dart`: `GET /landlord/info`; `POST /landlord/bank-detail` `{bank_name, bank_account, account_holder_name, bank_header_photo}`; `POST /landlord/delete-account`.
- Model: `LandlordInfoModel` (id, name, first/last_name, phone, email, bank_*, status; `hasBankAccount` getter).

### notification
- `pages/notification_screen.dart`; `services/notification_service.dart`: `GET /landlord/message/list?page&limit` (default limit 15); `POST /landlord/message/read-all`. Model: `NotificationModel`/`NotificationListResponse`.

### rich_text
- `pages/rich_text_screen.dart` (flutter_html); `services/agreement_service.dart`: `GET /landlord/agreement/detail?title=<title>`.

### app_config
- `services/app_config_service.dart`: `GET /landlord/config` → `AppConfigModel {showAlphaNotice}`. **Currently unused** — all `appConfigProvider` call sites in `main_screen.dart`/`splash_screen.dart` are commented out.

### push
- `services/push_notification_service.dart`: FCM init on main-screen post-frame when logged in; APNs wait/retry (max 8 retries); `POST /landlord/push/add-fcm-token` `{token, platform: ios|android'}`; on logout `POST /landlord/push/delete-fcm-token` `{token}`; foreground → local notification (Android channel `high_importance_channel`) + refresh notification list; tap → push `/notification`; badge clear via app_badge_plus.
- Background handler: `OWNER/lib/firebase_messaging_background.dart` — `@pragma('vm:entry-point')`, **logs only, no processing**.

### common
- `services/upload_service.dart` — **chunked upload**: files ≤ 512KB (`chunkSize = 512 * 1024`) go single-shot `POST /landlord/upload/file` (multipart `file`); larger files: generate `upload_id` (`<millis>_<hex6>`), upload chunks concurrently (**maxConcurrency = 4**) via `POST /landlord/upload/chunk` (multipart fields `upload_id, chunk_index, total_chunks, filename, file`), then `POST /landlord/upload/merge` `{upload_id, total_chunks, filename}`. Result `UploadFileResult {url, path, name}`. Cancellable via CancelToken (`UploadCancelledException`).
- `not_found_screen.dart` (router errorBuilder); widgets: `neast_brand_header.dart`, `neast_subpage_header_section.dart`, `upload_progress_dialog.dart` (`uploadFileWithProgressDialog` helper used by add-property and bank-detail).

### main / splash
- `main/pages/main_screen.dart`: tabs **Home, Properties, Records, Account** (`IndexedStack`); double-back-to-exit toast (Chinese text "再按一次返回键退出应用"); `kShowBetaTag = true` overlay (`main/widgets/beta_tag.dart`); alpha-notice banner/dialog exist but are commented out.
- `splash/splash_screen.dart`: 1.5s min display, native-splash preservation, routes to `/` or `/login` with `?fromSplash=true`.

## 3. Auth flow summary (owner)
Phone OTP. `send-code` with `scene=login` or `scene=register`; login → `POST /landlord/auth/login`; signup → `POST /landlord/auth/register`. Tokens saved to SharedPreferences keys `auth_token` / `refresh_token` / `expires_time`; `isLoggedIn` = refresh token present. Refresh: `POST /landlord/auth/refresh-token?refreshToken=...`.

## 4. QR (owner)
`OWNER/lib/features/properties/widgets/property_qrcode_dialog.dart` — generates QR **client-side** with `qr_flutter`'s `QrImageView(data: sn, errorCorrectionLevel: M)`. **Payload is the raw property `sn` string, nothing else** (no JSON, no prefix). Shown from `properties_screen.dart:164`.

## 5. Stubs / dead code (owner)
- "Generate PDF" button — `records/pages/records_screen.dart:156` (`onTap: () {}`).
- "Whatsapp" button — `home/pages/rent_detail_screen.dart:83` (`onTap: () {}`).
- Home quick actions (`home/widgets/home_quick_actions_section.dart`): only **Add Property** navigates; **Send Reminder, Agreements, Maintenance, Export Report, Risk Center** have no route/no-op.
- `ack_routes.dart` / `rent_routes.dart` contain hardcoded dummy fallback data when `extra` is missing.
- Dead: `core/utils/auth_utils.dart` (commented out), `core/services/location_service.dart` (unused), `features/auth/models/sms_scene_enum.dart` (unused), alpha-notice flow (commented out everywhere; `/landlord/config` still has a service).

---

# MERCHANT (shop app)

## 0. Identity / size
- pubspec (`MERCHANT/pubspec.yaml`): package `neast`, version **1.0.6+17**. No flavors/env config.
- Android: `applicationId = "com.neastMerchant.flutter"`, label `neast_merchant`. iOS: bundle `com.neastMerchant.flutter`, `CFBundleDisplayName = Neast Merchant`.
- Firebase: same project `neast-73f05`. `MaterialApp.title` also `'YaGuo'`.
- Extra deps vs owner: `webview_flutter`, `mobile_scanner`, `cunning_document_scanner`, `permission_handler`, `flutter_image_compress`, `photo_view`; no `qr_flutter`, no `file_picker`.
- Size: **201 dart files** under `lib/` (179 non-generated), **23 screens** (22 reachable; `features/home/pages/home_screen.dart` is orphaned — not imported anywhere).

## 1. lib/core layer

### Network — `MERCHANT/lib/core/network/dio_client.dart`
Byte-for-byte the same as owner except `_refreshPath = '/merchant/auth/refresh-token'`. Same base URL constant `http://10.0.2.2:9512` (`core/constants/app_constants.dart`), same envelope (`code/message|msg/data`, 200 ok, 400 → refresh), same raw-token `Authorization` header, same prefs keys `auth_token` / `refresh_token` / `expires_time`, same 200ms GET delay.

### Router — `MERCHANT/lib/core/router/`
`app_router.dart`: initial `/splash`; redirect → `/login` when logged out (only `/login`, `/splash` exempt — no verify route). Full route list (`routes.dart` + `routes/*.dart`):

| Path | Name | Screen | Notes |
|---|---|---|---|
| `/splash` | splash | `SplashScreen` | |
| `/` | main | `MainScreen` | 4-tab shell |
| `/login` | login | `LoginScreen` | |
| `/rich-text` | richText | `RichTextScreen` | `extra`: title (e.g. `'Legal'`) |
| `/notification` | notification | `NotificationScreen` | |
| `/daily-closing` | dailyClosing | `DailyClosingScreen` | entered from Give Points outlet card |
| `/give-points/receipt-details` | receiptDetails | `ReceiptDetailsScreen` | `extra`: `ReceiptCaptureResult` (fallback `ReceiptDetailsMissingScreen`) |
| `/give-points/confirm-points` | confirmPoints | `ConfirmPointsScreen` | `extra`: `ReceiptConfirmPayload` (fallback `ConfirmPointsMissingScreen`) |
| `/settlement/payment` | settlementPayment | `SettlementPaymentScreen` | |
| `/account/store-profile` | storeProfile | `StoreProfileScreen` | |
| `/wallet` | wallet | `WalletScreen` | |
| `/wallet/payment` | walletPayment | `WalletPaymentScreen` | nested under `/wallet`; `extra`: `WalletPaymentArgs` (fallback RM 500 default) |
| `/pay-h5-webview` | payH5WebView | `WalletPayH5WebViewPage` | `extra`: `{url, title}` map |
| `/invoice` | invoice | `InvoiceScreen` | stub (see §11) |
| `/transaction-history` | transactionHistory | `TransactionHistoryScreen` | |
| `/scanner` | scanner | `QrScannerScreen` | full-screen scanner, returns String via `context.push<String>` |
| `/redeem-voucher` | redeemVoucher | `RedeemVoucherScreen` | `extra`: `RedeemVoucherRouteArgs {preview, code}` |

### Theme
- `core/theme/app_colors.dart` — same as owner plus `brandBlueLight = 0xFF234FA5`.
- `core/theme/app_theme.dart` — same as owner (primaryColor `0xFF4ADB77`, Cupertino transitions, `themeModeProvider`).

### core/widgets
Only one: `core/widgets/app_refresher.dart` — same `AppRefresher` as owner but accent `0xFF4ADE80`.

### Utils / services / pagination
- `core/utils/`: `toast_util.dart`, `notifier_utils.dart`, `date_format_utils.dart`, `eph_extension.dart`, `merchant_session_reset.dart`, `number_format_extension.dart` (`withComma` etc.), `image_compress_util.dart` (flutter_image_compress: max dimension 1920, quality 85, skip < 512KB), `auth_utils.dart` (dead).
- `core/services/location_service.dart` — **unused**, same as owner.
- `core/pagination/` — same 4-file generic pagination infra as owner.
- `core/providers/shared_providers.dart` — same.

## 2. Feature inventory (`MERCHANT/lib/features/`)

### auth
- Screen: `pages/login_screen.dart` — **email + password** only (`account`, `password`; no register, no OTP, no forgot password).
- `services/auth_service.dart`: `POST /merchant/auth/login` — `{account: trimmed, password}`. Model `LoginResponse {merchantId, accessToken, refreshToken, expiresTime}`. Logout mirrors owner (delete FCM token → clear session → `go(/login)`).
- `models/sms_scene_enum.dart` — **dead code** (copied from a member app; never referenced).

### scan (tab 1, default tab)
- `pages/scan_screen.dart`: idle page with tap-to-scan frame, "Manual" (6-char voucher code dialog, regex `^[A-Z0-9]{6}$`, auto-uppercase) and "Photos" (gallery QR via `scan_gallery_util.dart`) actions, outlet info card. Any code (scanned or manual) → `POST /merchant/coupon/verify {code}` → push `/redeem-voucher`.
- `pages/qr_scanner_screen.dart`: full-screen `mobile_scanner` scanner w/ scan-line animation + gallery pick; returns raw string.
- `utils/qr_scanner_launcher.dart` (`openQrScanner` — camera permission gate via `CameraPermissionUtil`, then push `/scanner`), `utils/scan_gallery_util.dart` (`pickQrFromGallery`).
- `redeem/utils/voucher_code_util.dart`: manual SN pattern `^[A-Z0-9]{6}$`; also `isRedeemToken` pattern `^[a-f0-9]{32}$` (defined, not used in the scan path).

### redeem
- `pages/redeem_voucher_screen.dart` ("Confirm Redeem": voucher card, detail card, valid banner, confirm).
- `services/redeem_service.dart`: `POST /merchant/coupon/verify` `{code}`; `POST /merchant/coupon/redeem` `{code}`. Model: `RedeemVoucherPreviewModel`.

### give_points (tab 2)
- Screens: `pages/give_points_screen.dart` (header, today stats card, receipt card, earn-rule card, outlet card → `/daily-closing`), `pages/receipt_details_screen.dart` (Step 1: receipt number, amount, notes; live points preview from points setting; retake), `pages/confirm_points_screen.dart` (Step 2: identify customer by **phone input or customer QR scan**, then confirm).
- Services / endpoints:
  - `give_points_service.dart`: `GET /merchant/give-points/today-commission`; `GET /merchant/give-points/stats`; `GET /merchant/give-points/customer?user_id=<id>` (returns `data.account`); `POST /merchant/give-points/confirm` `{customer, amount, points, merchant_id, notes, receipt_number, receipt_path}`
  - `points_setting_service.dart`: `GET /merchant/points-setting`
  - `receipt_capture_service.dart`: document scan via `cunning_document_scanner` (fallback to camera/gallery via image_picker) → compress via `ImageCompressUtil` → chunked upload (`uploadFileWithProgressDialog`). No API calls itself.
- **Customer QR payload** (`widgets/confirm_points_customer_card.dart:38`): expects **JSON string `{"user_id": <int or numeric string>}`**; invalid JSON → toast "Invalid customer QR code". Then `GET /merchant/give-points/customer?user_id=` fills the phone field.
- `give_points_constants.dart` holds **mock defaults**: `defaultOutlet 'Sunway Pyramid'`, `defaultReceiptNumber 'R-2604-1108'`, `defaultReceiptAmount '48.60'`.

### daily_closing
- `pages/daily_closing_screen.dart` (summary card + paginated transactions; **"Export Report" button is a no-op stub**, daily_closing_screen.dart:127).
- `services/daily_closing_service.dart`: `GET /merchant/daily-closing/summary`; `GET /merchant/daily-closing/transactions?page&limit`.

### settlement (tab 3)
- Screens: `pages/settlement_screen.dart` (overview stats, "How charges" card, Pay Now when `showPayNow`), `pages/settlement_payment_screen.dart` (methods: FPX w/ bank picker, TNG, GRAB, Visa/Master, Wallet; processing fees from `/merchant/config`).
- `services/settlement_service.dart`: `GET /merchant/settlement/overview`; `POST /merchant/settlement/pay/wallet` `{bill_id, payment_method}` (pay from balance, instant success dialog); `POST /merchant/settlement/pay/create` `{bill_id, payment_method, payment_channel?}` → `SettlementPayOrder {paymentUrl, ...}` → H5 WebView.
- `settlement_constants.dart` defines `SettlementPaymentMethod` apiIds; FPX bank list in `wallet/data/fpx_bank_config.dart` (17 Malaysian banks, channels `fpx_abb`, `fpx_mb2u`, …).

### wallet
- Screens: `pages/wallet_screen.dart` (balance card from `/merchant/info`, preset amounts 500/1000/1500/2000 + custom, top-up record list), `pages/wallet_payment_screen.dart` (payment method section, no wallet option), `pages/wallet_pay_h5_webview_page.dart` (see §6).
- `services/wallet_service.dart`: `GET /merchant/wallet/topup/list?page&limit`; `POST /merchant/wallet/topup/create` `{amount, payment_method, payment_channel?}` → `WalletTopupOrder {paymentUrl, ...}`.
- `data/wallet_config.dart`: preset amounts, payment methods (`fpx`, `tng`, `grab`, `visa`, `wallet`), fee label/amount formatters.

### transaction
- `pages/transaction_history_screen.dart` (tabs: Points / Redeemed, year filter, paginated).
- `services/transaction_service.dart`: `GET /merchant/transaction/points?year&page&limit`; `GET /merchant/transaction/redeemed?year&page&limit`. Model: `TransactionRecord` (+ `TransactionPointsItemModel`, `TransactionRedeemedItemModel`).

### account (tab 4)
- Screens: `pages/account_screen.dart` (balance card + menu: Store Profile / Wallet Top Up / Invoice & Billing / Transaction History / Legal / Delete Account / Log Out), `pages/store_profile_screen.dart` (read-only store info from `/merchant/info`), `pages/invoice_screen.dart` (**pure stub**: year selector + fixed 12 month tiles, each tap → toast "Please stay tuned."; no API).
- `services/merchant_service.dart`: `GET /merchant/info` only. Model `MerchantInfoModel` (id, name, address, image, email, phone, contact_*, balance, lat/long, registration_number).
- `widgets/delete_account_dialog.dart`: 10-second countdown confirm dialog, but `account_menu_list.dart` calls `DeleteAccountDialog.show()` **without onConfirm and there is no delete endpoint** — UI-only stub.

### notification
- `services/notification_service.dart`: `GET /merchant/message/list?page&limit`; `POST /merchant/message/read-all`. Same screen/widgets pattern as owner.

### rich_text
- `services/agreement_service.dart`: `GET /merchant/agreement/detail?title=<title>` (used for "Legal").

### app_config
- `services/app_config_service.dart`: `GET /merchant/config` → `AppConfigModel {showAlphaNotice, payment_processing_fees}` with default fees `{fpx: 0.0, tng: 1.6, grab: 1.6, visa: 3.5}`; fees are consumed by `settlement/widgets/settlement_payment_method_card.dart` and `wallet/widgets/wallet_payment_method_section.dart`. Alpha notice itself is commented out everywhere.

### push
- `services/push_notification_service.dart`: same implementation as owner; `POST /merchant/push/add-fcm-token` `{token, platform}`; `POST /merchant/push/delete-fcm-token` `{token}`; tap → `/notification`; badge clear.
- `MERCHANT/lib/firebase_messaging_background.dart`: `@pragma('vm:entry-point')` handler, **logs only**.

### common
- `services/upload_service.dart` — **chunked upload**, same design as owner but `chunkSize = 256KB` and `maxConcurrency = 8`: `POST /merchant/upload/file` (single, ≤256KB), `POST /merchant/upload/chunk` (multipart `upload_id, chunk_index, total_chunks, filename, file`), `POST /merchant/upload/merge` `{upload_id, total_chunks, filename}`.
- Utils: `camera_permission_util.dart`, `permission_denied_dialog.dart`. Widgets: `hero_image_thumbnail.dart` (photo_view zoom), `neast_brand_header.dart`, `neast_subpage_header_section.dart`, `success_result_dialog.dart`, `upload_progress_dialog.dart`.

### main / splash / home
- `main/pages/main_screen.dart`: tabs **Scan, Give Points, Settlement, Account**; double-back-to-exit; `kShowBetaTag = true`.
- `features/home/pages/home_screen.dart` — **orphaned/dead** (no imports).
- `splash/splash_screen.dart`: same as owner (1.5s, fromSplash transition).

## 3. Auth flow summary (merchant)
Email + password only: `POST /merchant/auth/login` `{account, password}` → `{merchantId, accessToken, refreshToken, expiresTime}` → same three SharedPreferences keys (`auth_token`, `refresh_token`, `expires_time`). Refresh: `POST /merchant/auth/refresh-token?refreshToken=...`. No registration, no OTP.

## 4. Push/FCM (merchant)
Same as owner: register `POST /merchant/push/add-fcm-token` `{token, platform: 'ios'|'android'}`, unregister `POST /merchant/push/delete-fcm-token` `{token}`; background handler logs only; Android foreground shows local notification channel `high_importance_channel`.

## 5. QR (merchant)
- Scans **user/coupon QR** in two places: scan tab (any QR content → treated as voucher code → `/merchant/coupon/verify`) and give-points confirm (`{"user_id": N}` JSON → `/merchant/give-points/customer`).
- Voucher codes: scanned raw string, or manual 6-char `[A-Z0-9]`; a 32-char hex "redeem token" pattern exists in `voucher_code_util.dart` but is unused in the flow.
- Files: `scan/pages/scan_screen.dart`, `scan/pages/qr_scanner_screen.dart`, `scan/utils/qr_scanner_launcher.dart`, `scan/utils/scan_gallery_util.dart`, `redeem/utils/voucher_code_util.dart`, `give_points/widgets/confirm_points_customer_card.dart`.

## 6. WebView Fiuu H5 flow (merchant only)
- Screen: `wallet/pages/wallet_pay_h5_webview_page.dart` (route `/pay-h5-webview`), launched from `wallet_payment_screen.dart` (top-up) and `settlement_payment_screen.dart` (platform-fee payment).
- Order creation endpoints: `POST /merchant/wallet/topup/create` and `POST /merchant/settlement/pay/create` → `paymentUrl` loaded in `webview_flutter` with a browser-like UA and a `FlutterSchemeHandler` JS channel that intercepts `window.open` for non-http(s) schemes; `intent://` URLs are parsed and launched externally with `S.browser_fallback_url` fallback.
- **Success detection is purely URL-based** (`onPageStarted`/`onNavigationRequest`): URL containing `/pay_success.html` → result `0`; `/pay_pending.html` → result `1` (10s "processing" timer); `/pay_failed.html` → result `2`. After a 2.5s grace period it pops with the int result. **There is no polling endpoint** — callers just re-fetch state (`GET /merchant/info`, topup list, `GET /merchant/settlement/overview`) on result 0/1 and show success/pending/failed UI.

## 7. Chunked upload (merchant)
`features/common/services/upload_service.dart` — 256KB chunks, 8-way concurrency, endpoints `POST /merchant/upload/file` | `/merchant/upload/chunk` | `/merchant/upload/merge` (field names identical to owner). Used for receipt images in the give-points flow.

## 8. Fonts / assets (merchant)
- Fonts: **only `FD` (Funnel Display)** declared (`assets/fonts/FunnelDisplay-VariableFont_wght.ttf`).
- Asset folders: `assets/images/`, `main/`, `give_points/`, `daily_closing/`, `settlement/`, `account/`, `wallet/`, `scan/`, `redeem/` (+ `assets/icon/` for launcher icon, not declared as asset).

(Owner for contrast: `FD` Funnel Display + `HG` Host Grotesk; folders `images/`, `main/`, `home/`, `home/quick_actions/`, `account/`, `property/`.)

## 9. Stubs / dead code (merchant)
- `account/pages/invoice_screen.dart` — entire Invoice & Billing page is a stub (month tiles → "Please stay tuned." toast).
- Delete Account — dialog with 10s countdown but no API behind it (`account_menu_list.dart`, `delete_account_dialog.dart`).
- "Export Report" — `daily_closing/pages/daily_closing_screen.dart:127` (`onPressed: () {}`).
- `give_points/give_points_constants.dart` — mock outlet/receipt defaults.
- Commented-out cashier line in scan outlet card (`scan_screen.dart:510`).
- Dead files: `features/home/pages/home_screen.dart` (orphaned), `features/auth/models/sms_scene_enum.dart`, `core/services/location_service.dart`, `core/utils/auth_utils.dart`; alpha-notice flow commented out (though `/merchant/config` is still live for payment fees).
- `wallet/data/wallet_config.dart` hardcodes `Wallet` method trailing text `'Remaining: RM3000'` (display string, real balance comes from `/merchant/info`).

## Cross-app notes for the rebuild
- The two dio clients are identical except the refresh path prefix — one shared RN networking module with a per-app prefix (`/landlord` vs `/merchant`) covers both.
- Envelope contract (`code/message|msg/data`, business `400` = refresh, raw-token `Authorization` header, refresh via query param) is unusual — preserve exactly.
- Owner QR payload = bare property `sn`; merchant customer QR = `{"user_id": n}` JSON; merchant voucher = raw code or 6-char manual entry. Three different QR contracts to port.
- Fiuu H5 result detection is URL-substring based (`pay_success|pay_failed|pay_pending.html`) with no server polling — the RN WebView must replicate navigation-URL interception plus `intent://`/external-scheme handling.