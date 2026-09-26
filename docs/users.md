# NEAST User App (`apps/neast-user`) — Full Inventory for RN Rebuild

> **⚠️ Flutter-era inventory (historical reference).** This was the spec for the rebuild and is kept for traceability. The app is now Expo / React Native: routes in `apps/neast-user/app/`, features in `apps/neast-user/src/features/`, API wiring in `apps/neast-user/src/lib/endpoints.ts`. Route-by-route parity status: `apps/neast-user/PARITY.md`. Omissions/deviations: `docs/rn-migration-notes.md`.

Flutter app, package `neast`, Riverpod 3 + go_router 17 + dio 5. All paths below are relative to `/Users/hanxiangwong/Desktop/Neast/neast-monorepo/apps/neast-user`.

---

## 1. `lib/core` layer

### 1.1 `core/constants`
- `app_constants.dart` — `AppConstants`:
  - `apiBaseUrl = 'http://10.0.2.2:9512'` (hardcoded Android-emulator loopback; **no env switching**, no `--dart-define` anywhere in the app)
  - `apiConnectTimeout` / `apiReceiveTimeout` = 15000 ms
  - SharedPreferences keys: `accessTokenKey = 'auth_token'`, `refreshTokenKey = 'refresh_token'`, `expiresTimeKey = 'expires_time'`
  - Pagination defaults: `defaultPageSize = 20`, `defaultInitialPage = 1`
  - Animation durations: 200/400/800 ms
- `map_tile_config.dart` — `MapTileConfig`: OSM tiles `https://tile.openstreetmap.org/{z}/{x}/{y}.png`, `userAgentPackageName = 'com.neastusers.flutter'`, default viewport radius 30 km, zoom 3–18, fling + double-tap-zoom disabled (workaround for flutter_map 8.3.x NaN crash), helpers `boundsForRadiusKm` / `zoomForRadiusKm`.

### 1.2 `core/network/dio_client.dart`
Single `DioClient` class wrapping Dio, provided via `dioClientProvider`. Three interceptors in order:
1. **Auth interceptor** — reads `auth_token` from SharedPreferences, sets header `Authorization: <token>` (**raw token, no `Bearer ` prefix**).
2. **Log interceptor** — logger request/response dumps.
3. **Response interceptor** — envelope handling:
   - Response must be a `Map` with an `int code`, else reject "invalid response format".
   - Message extracted from `message` first, fallback `msg` (`_extractMessage`).
   - `code == 200` → pass through; **`code == 400` → token refresh flow**; anything else → reject with the message.
   - Refresh: POST `/app/auth/refresh-token` with **query param** `refreshToken`, using a **separate bare Dio instance** (bypasses interceptors). Single-flight via `_isRefreshing` + `Completer`; saves `accessToken`/`refreshToken`/`expiresTime` from `data`; retries original request once with `extra['_retried'] = true`; second 400 or refresh failure → toast + `authProvider.notifier.logout()`.
   - `onError`: maps timeout/connection errors to friendly strings; HTTP 401 → logout if logged in (guests just get rejection); 404/500 mapped; otherwise extracts message from error body.
   - Quirk: **every GET has an artificial `Future.delayed(200ms)`** before executing.
   - Exposes `get/post/put/delete/uploadFile(FormData, onSendProgress, cancelToken)`.

### 1.3 `core/router`
`routes.dart` — `AppRoutes` path constants (complete):

| Path | Name | Notes |
|---|---|---|
| `/splash` | splash | `SplashScreen` |
| `/` | main | `MainScreen` (4 tabs); `?fromSplash=true` triggers fade/scale transition |
| `/login` | login | `LoginScreen`; `?fromSplash=true` variant |
| `/register` | — | **constant exists but no route registered** |
| `/verify` | verify | `VerifyScreen(contact:)` via `?contact=` query |
| `/full-data` | fullData | `FullDataScreen` (post-signup profile form) |
| `/rich-text` | richText | `RichTextScreen`, extra = title `String` |
| `/notification` | notification | `NotificationScreen` |
| `/personal-data` | personalData | `PersonalDataScreen` |
| `/personal-data/edit` | personalDataEdit | extra = `PersonalDataField` enum |
| `/account/my-qr` | myQr | `MyQrScreen` |
| `/account/tent-score` | tentScore | `TentScoreScreen` |
| `/points` | points | `PointsScreen` |
| `/points/history` | pointsHistory | `PointsHistoryScreen` |
| `/reward/tier` | rewardTier | `RewardTierScreen` |
| `/merchant/:id` | merchant | `MerchantScreen(merchantId)` |
| `/merchants` | merchantList | `?kind=all\|recommended\|nearby&header=merchants\|nearbyMerchants` |
| `/merchants/map` | merchantMap | `MerchantMapScreen` (demo screen commented out) |
| `/coupon` | coupon | `CouponScreen`; sub-routes: `detail` (extra `CouponDetailArgs` or `CouponListItemModel`), `my-coupons` (`MyCouponsScreen`) |
| `/wallet` | wallet | `WalletScreen`; sub-route `payment` (extra `WalletPaymentArgs`, default RM 500 fallback) |
| `/pay-h5-webview` | payH5WebView | `WalletPayH5WebViewPage`, extra `Map{url, title}` |
| `/pay-rent/payment` | payRentPayment | extra `RentModel` |
| `/pay-rent/create` | payRentCreate | `PayRentCreateScreen` |
| `/pay-rent/detail` | payRentDetail | extra `RentModel` |
| `/pay-rent/history` | rentHistory | `RentHistoryScreen` |
| `/pay-rent/history/detail` | rentHistoryDetail | `RentPaymentStatusScreen`, extra `RentHistoryModel` |
| `/pay-rent/invite-owner` | ownerInvite | `OwnerInviteScreen`, extra `OwnerInviteArgs` |
| `/scanner` | scanner | `QrScannerScreen` (returns scanned string via `pop`) |
| `/refer` | refer | `ReferScreen` |

`app_router.dart` — `appRouterProvider` builds the `GoRouter` (`initialLocation: /splash`, `debugLogDiagnostics: true`, `errorBuilder` → `NotFoundScreen`). **Guest-mode allowlist** in `redirect`: when logged out, only `/login`, `/splash`, `/verify`, `/full-data`, `/`, `/rich-text`, `/merchants/map`, `/merchants`, `/coupon` are reachable; everything else redirects to `/login`. Redirect also calls `DeepLinkParser.repairBrokenMerchantRoute` (go_router mangles `neastuser://merchant/2` into `/2`) and stashes merchant-detail deep links into `pendingRouteProvider` when logged out.

`auth_navigation.dart` — `navigateAfterAuth` (drain pending deep link, else select Home tab + `go('/')`) and `navigateAfterSplash` (pending link → login if logged out; else `go('/?fromSplash=true')`).

### 1.4 `core/theme`
- `app_colors.dart` — `AppColors extends ThemeExtension`: `brandBlue 0xFF0851AA`, `brandBlueLight 0xFF234FA5`, `darkGreen 0xFF3EBF7A`, `blackText 0xFF0F172A` (light + dark variants; dark only overrides brandBlue to `0xFF0D2567`). `context.appColors` extension.
- `app_theme.dart` — `AppTheme.lightTheme`/`darkTheme`: `useMaterial3: false`, primary `0xFF4ADB77` (green), light scaffold white / dark `0xFF17171B`, AppBar `0xFFF5F5F5` centered black 18pt titles, cards radius 12 elevation 2, ElevatedButton green radius 8, **CupertinoPageTransitionsBuilder on all platforms**. `themeModeProvider` (StateProvider, default light). Checkbox SVG asset paths also live here. **No central text theme** — screens inline `fontFamily: 'FD'` (Funnel Display) / `'HG'` (Host Grotesk) with `FontVariation('wght', …)`.

### 1.5 `core/widgets`
Only one file: `app_refresher.dart` — `AppRefresher`, the standard pull-refresh/load-more wrapper around `easy_refresh` (`ClassicHeader`/`ClassicFooter`, English copy, accent `0xFF4ADE80`, triggerOffset 60, `safeArea` convention documented, `onLoad` returns `bool hasMore`). All paginated lists use it.

### 1.6 `core/services`
`location_service.dart` — `LocationService.getCurrentPosition()` via geolocator (service check → permission request → last-known → low-accuracy 8s timeout). **In `kDebugMode` returns hardcoded Johor Bahru coords `(1.4862, 103.6565)`.** Throws `LocationUnavailableException`. Providers: `locationServiceProvider`, `currentLocationProvider` (shared FutureProvider).

### 1.7 `core/utils`
- `auth_utils.dart` — `AuthUtils.handleLogout` / `handleAuthError` (mostly legacy; clears state, resets tab, `go('/login')`).
- `date_format_utils.dart` — `formatToReadableDateTime` ("At 3:30 pm on March 15th, 2025"), `formatToRelativeTime`, `formatToSimpleDate`.
- `eph_extension.dart` — `int.eph` / `int.ewp` SizedBox spacers.
- `notifier_utils.dart` — `runGuarded` extensions on `Ref`/`WidgetRef`: catches `DioException` → toast `e.error`, other errors → `onError` callback.
- `price_extension.dart` — `int.priceFormat` thousands separator.
- `toast_util.dart` — `ToastUtil.show/showSuccess/showError/showWarning` via fluttertoast, center gravity, **1.5s global debounce**.
- `user_session_reset.dart` — `clearUserSessionState` (profile/login form reset), `invalidateUserSessionCache` (invalidates ~25 providers on logout), `scheduleUserSessionCacheInvalidation` (post-frame).

### 1.8 `core/pagination`
- `paginated_list_state.dart` — `PaginatedListState<T>{list, isLoading, isFetching, hasMore, pageNo, pageSize(10)}`.
- `paginated_list_logic.dart` — `PaginatedListLogic<T>` mixin: `fetchPage(page,pageSize)` contract, `initialLoad/refresh/loadMore/applyFilter/removeWhere`, generation counter to discard stale in-flight responses, concurrency guard.
- `paginated_list_notifier.dart` — `PaginatedListNotifier<T>` base (plain Notifier).
- `paginated_list_family_notifier.dart` — `PaginatedListFamilyNotifier<T, Arg>` base (family arg).

### 1.9 `core/providers`
`shared_providers.dart` — `sharedPreferencesProvider` (overridden in `main`), `loggerProvider`.

### 1.10 `core/deep_link`
- `deep_link_parser.dart` — scheme `neastuser` (`neastuser://merchant/2` and `neastuser:///merchant/2`) plus `http(s)://<any-host>/merchant/<id>`; **only merchant detail is deep-linkable**; `repairBrokenMerchantRoute` for the go_router mangling case; `merchantShareUrl(id)` = `{apiBaseUrl}/merchant/{id}`.
- `deep_link_service.dart` — `AppLinks` initial link + `uriLinkStream`; cold start or logged-out → stash in `pendingRouteProvider` (+ go `/login`); logged in → open immediately.
- `pending_route_provider.dart` — `NotifierProvider<String?>` stash.
- `deep_link_navigation.dart` — `openDeepLinkRoute*` helpers (merchant detail: `go('/')` then post-frame `push(route)` for a sane back stack), `flushPendingDeepLinkOnMain`.
- `deep_link_bootstrap.dart` — widget that starts the service post-frame; wraps the app in `core/app.dart`.

---

## 2. Feature inventory (`lib/features/`)

### account
- **Pages**: `account_screen.dart` (Account tab: header w/ avatar+name+badge or guest login card, menu card), `personal_data_screen.dart` (read-only profile field list), `personal_data_edit_screen.dart` (single-field edit: first/last name, email, address, ID valid-until), `my_qr_screen.dart` (user identity QR via `qr_flutter`, "Download QR" saves to gallery via RepaintBoundary + image_gallery_saver_plus).
- **Services** (`services/user_service.dart`): `GET /app/user/profile`, `POST /app/user/profile` (both update and initial-complete variants; fields `first_name,last_name,id_type,id_number,id_valid_until,address,email,invitation_code`), `POST /app/user/delete-account`.
- **Models**: `UserProfileModel` (userId, account, email, firstName, lastName, idType `id_card|passport`, idNumber, idValidUntil, address, profileCompleted, points, pointsApproxRm, qrCode), `PersonalDataField` enum.
- **Providers**: `userProfileProvider` (AsyncNotifier, `fetchIfNeeded`, `deleteAccount` → logout).
- **Widgets**: `account_header`, `account_guest_login_card`, `account_menu_card` (menu: Personal Information, Notifications, Wallet w/ balance trailing, Privacy & Security → rich-text "Privacy Policy", Terms & Conditions → rich-text "Terms and Conditions", Delete Account, Log Out), `account_profile_card`, `delete_account_dialog` (10s countdown OK), `logout_confirm_dialog`, `personal_data_field_row`, `user_qrcode_dialog` (qr_flutter).
- **Utils**: `utils/` holds profile date format helpers (referenced as `formatProfileDisplayDate`).

### app_config
- **Service**: `GET /app/config` → `AppConfigModel{showAlphaNotice, paymentProcessingFees}`.
- **Provider**: `appConfigProvider` (AsyncNotifier, fails closed to `showAlphaNotice: false`). Currently **commented out** in splash/main (alpha notice flow disabled).

### auth
- **Pages**: `login_screen.dart` (phone-only login, country code picker, default +60), `verify_screen.dart` (pinput OTP, resend sheet, 60s countdown), `full_data_screen.dart` (first/last name, email, address, invitation code, ID document section w/ passport valid-until).
- **Services** (`services/auth_service.dart`): `GET /app/auth/country-codes`, `POST /app/auth/send-code` `{account}`, `POST /app/auth/login` `{account, code}` → saves tokens. Also houses `AuthNotifier` (`authProvider`), `isLoggedInProvider` (logged in = refresh token exists), `completeProfile` → user service, logout (clears session, resets tab to Account, deletes FCM token async).
- **Models**: `LoginResponse{userId, accessToken, refreshToken, expiresTime, profileCompleted}`, `CountryCodeModel{code}`, `SmsSceneEnum`.
- **Providers**: `loginProvider` (phone+countryCode form state, `fullPhoneAccount` = dial+digits), `countdownProvider` (family by phone, 60s), `personalProfileProvider` (full-data form state).
- **Widgets**: `login_header` (gradient header), `country_code_picker_sheet`, `verify_resend_sheet`, `agreement_dialog` (SmartDialog, Chinese title 用户协议及隐私政策）, `profile_form_card`, `profile_id_document_section`, `profile_date_picker_sheet` (Cupertino wheel).

### common
- `not_found_screen.dart` — router error builder (Chinese copy).
- **Services**: `member_service.dart` — **legacy `/member` prefix**: `GET /member/info`, `POST /member/change_avatar_type`; `sms_service.dart` — `POST /member/auth/send-sms-code` (legacy, appears unused by current OTP flow); `upload_service.dart` — see §9.
- **Models**: `MemberModel{id,name,phone,avatar,points,avatarType}` (legacy).
- **Widgets**: `guest_login_placeholder`, `how_to_earn_card`, `merchant_detail_hero`, `merchant_info_card`, `neast_brand_header` (brand header w/ `neastRichTitle`/`plainTitle`), `upload_progress_dialog` (progress bar + cancel; drives `uploadServiceProvider`).
- **Utils**: `camera_permission_util.dart` (permission_handler wrapper).

### coupon
- **Pages**: `coupon_screen.dart` (Rewards catalog: category tabs + paginated list, skeletons), `coupon_detail_screen.dart` (hero, body, points banner; actions Redeem / Use Now / Fully Redeemed; share stub), `my_coupons_screen.dart` (Active/Used/Expired 3-tab via extended_tabs).
- **Service** (`coupon_service.dart`): `GET /app/coupon/categories`, `GET /app/coupon/list` (page, limit, category_id), `GET /app/coupon/merchant-list` (merchant_id), `GET /app/coupon/my-count`, `GET /app/coupon/my-list` (status), `GET /app/coupon/latest`, `POST /app/coupon/redeem` `{coupon_id}`.
- **Models**: `CouponModel{id,name,requiredPoints,image}`, `CouponListItemModel` (userCouponId, requiredPoints, validDays, categoryId/Name, usageCondition, discountAmount, merchantNames, expireAt, redeemedAt, couponStatus, sn, qrcode, actionStatus), `CouponCategoryModel{id,name}`, `CouponDetailArgs`, enums `MyCouponStatus`, `CouponActionStatus`.
- **Providers**: `couponListProvider` (family by categoryId, paginated), `couponCategoriesProvider`, `latestCouponProvider`, `myCouponListProvider`, `myCouponCountProvider`, `couponRedeemProvider`.
- **Widgets**: category tabs, reward card/list view, detail hero/body/section/points banner, action button, `coupon_qrcode_dialog` (qr_flutter redemption QR), `coupon_redeem_confirm_dialog`, my-coupon card/tabs/list panel, skeletons.
- **Utils**: `coupon_icon_utils`, `coupon_redeem_actions` (`redeemCoupon` confirm→redeem→toast; `showCouponQrcode`).

### home
- **Page**: `home_screen.dart` — Home tab: dark-blue `home_bg` header (logo, notification bell w/ unread dot, QR button → `/account/my-qr`), greeting, `NextRentCard`, `TodaysRewardCard`, white rounded content: `NearbyDealsSection`, `JourneyStreakCard` ("Your Journey"), `MyCouponCard`, "For Rent" promo carousel.
- **Service** (`home_service.dart`): `GET /app/home/dashboard` (optional latitude/longitude).
- **Models**: `HomeDashboardModel{nextRent: RentModel?, todayReward: CouponModel?, nearbyDeals: MerchantModel[], journey: HomeJourneyModel{maxStreakMonths,streakLabel,streakStatus}, banners: HomeBannerModel{id,image,imageUrl,link}}`.
- **Providers**: `homeDashboardProvider` (AsyncNotifier, location-aware), `home_merchants_provider.dart` (`homeAllMerchantsProvider` / `homeRecommendedMerchantsProvider` / `homeNearbyListMerchantsProvider` — paginated, location-gated), `nearbyMerchantsProvider` (FutureProvider for map distribution).
- **Widgets**: `deal_card`, `home_address_tag` (marquee), `home_merchant_section_skeleton`, `home_section_header`, `horizontal_deal_section`, `journey_streak_card`, `my_coupon_card`, `nearby_deals_section`, `next_rent_card`, `promo_carousel`, `suggested_merchant_item`, `todays_reward_card`.
- `data/` directory exists but is **empty**.

### main
- **Page**: `main_screen.dart` — `MainScreen`: `IndexedStack` of 4 tabs (`MainTab` enum: home, payRent, reward, account), `selectedIndexProvider`, SVG tab icons, double-back-to-exit (2s, Chinese toast), initializes push notifications post-frame if logged in, flushes pending deep links, optional `BetaTag` overlay (`kShowBetaTag`), alpha-notice code commented out.
- `main_tab_assets.dart` — tab SVG paths. **Widgets**: `alpha_notice_banner`, `alpha_notice_dialog` (both currently unused), `beta_tag`.

### merchant
- **Pages**: `merchant_screen.dart` (detail: hero, info card, Redeem/Map action row, coupon bottom sheet, nearby card, skeleton/error states), `merchant_list_screen.dart` (paginated list w/ kind=all/recommended/nearby, location-unavailable hint), `merchant_map_screen.dart` (category chips incl. hardcoded "5X Points" chip id=5, flutter_map + collapsible "Deals Near You" bottom sheet), `merchant_map_demo_screen.dart` (debug-only, not routed).
- **Service** (`merchant_service.dart`): `GET /app/merchant/list`, `GET /app/merchant/recommended`, `GET /app/merchant/nearby/list` (all: latitude, longitude, page, limit, category_id?), `GET /app/merchant/categories`, `GET /app/merchant/detail` (id, lat/lng?), `GET /app/merchant/nearby` (lat, lng, category_id? — radius hardcoded server-side, 20km per provider comment).
- **Models**: `MerchantModel{id,name,address,image,categoryId,specialDeal,minSpend,nearestMerchant,...}` + `MerchantListResponse{items,total,page,limit}`, `MerchantCategoryModel{id,name}`, `MerchantListKind`/`MerchantListHeaderTitle` enums.
- **Providers**: `merchantListProvider` (family by kind), `merchantDetailProvider` (family by id), `merchantCouponListProvider`, `merchantMapProvider` (+ `merchantCategoriesProvider`, `merchantMapCategoryChipsProvider`).
- **Widgets**: `merchant_action_row`, `merchant_coupon_sheet`, `merchant_map_marker` (incl. user-location marker), `merchant_nearby_card`, `merchant_screen_skeleton`.
- **Utils**: `merchant_map_actions` (open external map), `merchant_share_actions` (share_plus: "Check out {name} on neast\n{apiBaseUrl}/merchant/{id}").
- **Data**: `merchant_detail_constants.dart` (earn-steps copy).

### notification
- **Page**: `notification_screen.dart` — paginated list; on open: clears app badge, `markAllRead`, refreshes unread + list.
- **Service** (`notification_service.dart`): `GET /app/message/list` (page, limit=15), `POST /app/message/read-all`, `GET /app/message/has-unread` (`has_unread`, `unread_count`).
- **Models**: `NotificationModel{id,title,content,isRead,createdAt}`, `NotificationListResponse`, `NotificationUnreadStatus{hasUnread}`.
- **Providers**: `notificationListProvider` (paginated), `notificationUnreadProvider` (AsyncNotifier<bool>).
- **Widgets**: `notification_item_card`. `data/` empty.

### pay_rent
- **Pages**: `pay_rent_screen.dart` (Pay Rent tab: tenancy cards, recent history section ≤5, Add Tenancy tile, guest placeholder), `pay_rent_create_screen.dart` (create form), `pay_rent_detail_screen.dart` (property info + amount + Property Journey grid + terminate), `pay_rent_payment_screen.dart` (payment method + owner-bank fields when unbound; wallet or H5), `rent_history_screen.dart` (full history, year filter chips — current year − 0..9), `rent_payment_status_screen.dart` (payment status detail; owner invite entry), `owner_invite_screen.dart` (name/email/phone form + WhatsApp-style draft message).
- **Service** (`rent_service.dart`): `GET /app/rent/list`, `GET /app/rent/property` (sn), `POST /app/rent/create` (amount, file, paid_at, first_pay_month, lease_months, property_name, property_id?|owner_name?), `GET /app/rent/history/list` (page, limit, year?, rent_id?), `GET /app/rent/connect-options`, `POST /app/rent/invite` (rent_id, history_id, name, email, phone), `POST /app/rent/pay/wallet` (rent_id, payment_method, owner bank fields?), `POST /app/rent/pay/create` (+ payment_channel), `PUT /app/rent/id/{id}/terminate` (reason?).
- **Models**: `RentModel` (id, amount, file/fileUrl, paidAt, firstPayMonth, leaseMonths, expireDate, status, landlordId/Name/AccountName/BankName/BankLast4, payoutStatus, inviteSent, propertyName, earnPoints, createdAt, canPay, dueText, dateLabel; `RentStatus` constants approved/rejected/pendingBind/pending), `RentHistoryModel` (rentId, lastPaidDate, userPaidAt, status, displayStatus, payStatus, amount, propertyAddress, landlord*, payoutStatus, paymentMethod, paymentNo, rentalPeriod), `RentPayOrder{orderId, paymentUrl, historyId}`, `RentPropertyModel{id,sn,name,landlordName}`.
- **Providers**: `payRentProvider` (create-form state machine + validation + `bindPropertyBySn`), `payRentListProvider`, `payRentRecentHistoryProvider`, `rentHistoryListProvider` (family by year), `rentHistoryYearProvider`, `rentDetailHistoryProvider` (family by rentId).
- **Widgets**: form card (scan-SN connect, demo-owner picker, agreement upload), day picker (1–31), first-pay-month picker, tenancy card/sections, item card, status tag, history item/section, property journey card, add-tenancy tile, card shadow, terminate dialog (5s countdown).
- **Utils**: `first_pay_month_util`, `pay_rent_agreement_picker` (image_picker gallery or file_picker), `rent_file_actions` (resolve file URL vs apiBaseUrl, image → dialog preview, else external launch; status labels/colors).

### points
- **Pages**: `points_screen.dart` (summary card, action section, "How to Earn Faster", "Merchant Reward" grid), `points_history_screen.dart` (paginated logs).
- **Service** (`points_service.dart`): `GET /app/points/dashboard`, `GET /app/points/logs` (page, limit=15).
- **Models**: `PointsDashboardModel{points, couponCount, tier, inviterRewardPoints, inviteeRewardPoints,...}`, `PointsLogModel{id,userId,points,title,subtitle,createdAt}` + list response.
- **Providers**: `pointsDashboardProvider`, `pointsLogListProvider` (paginated).
- **Widgets**: summary/action/earn/history/merchant-reward cards & sections. **Data**: `points_assets.dart` (image paths).

### push
- `services/push_notification_service.dart` — see §4.

### refer
- **Page**: `refer_screen.dart` (collapsing SliverAppBar header, promo banner, code card, stats, milestones, how-it-works; referrals section commented out).
- **Service** (`refer_service.dart`): `GET /app/refer/dashboard`.
- **Model**: `ReferDashboardModel{totalEarnedPoints, invitedCount, maxInviteLimit(4), nextRewardPoints, invitationCode, inviteeRewardPoints, inviteUrl}`.
- **Provider**: `referDashboardProvider`. **Utils**: `refer_share_actions` (WhatsApp via `wa.me/?text=`). **Widgets**: header, code/stats/milestones/how-it-works cards, promo banner, referral item/section.

### reward
- **Pages**: `reward_screen.dart` (Reward tab: my-points card, tier progress, featured rewards, nearby rewards; guest placeholder), `reward_tier_screen.dart` ("Tier Ranking": current tier card + full tier progress list).
- **Service** (`reward_service.dart`): `GET /app/reward/dashboard` (optional lat/lng).
- **Models**: `RewardDashboardModel{points, pointsExpiringText, tierProgress{current, pointsToNextTier, progressCurrent, progressTarget}, tiers[], featuredRewards[], nearbyRewards[]}`, `RewardTierItemModel{id,name,minPoints,maxPoints}`.
- **Provider**: `rewardDashboardProvider`. **Data**: `reward_tier_constants.dart` (tier icon assets by id 1–5: bronze/silver/gold/platinum/diamond). **Widgets**: current tier card, featured coupon card/section, my points card, nearby section, tier progress card/list.

### rich_text
- **Page**: `rich_text_screen.dart` (agreement HTML display by title; used for Privacy Policy / Terms and Conditions).
- **Service** (`agreement_service.dart`): `GET /app/agreement/detail?title=...`.
- **Model**: `AgreementModel{id,title,content}`. **Provider**: `agreementContentProvider` (family by title). **Widgets**: `rich_text_header` (gradient header reused by wallet/personal-data screens), `agreement_html_content` (flutter_html).

### scan
- **Page**: `qr_scanner_screen.dart` — full-screen `mobile_scanner` camera scan (back camera, animated cyan scan-line frame overlay), "Choose from gallery" via image_picker + `controller.analyzeImage`, returns string via `Navigator.pop`.
- **Utils**: `qr_scanner_launcher.dart` — `openQrScanner(context)`: camera permission via `CameraPermissionUtil`, then `context.push<String>('/scanner')`. **Only consumer**: pay-rent form "Connect with owner" (scans property SN).

### splash
- `splash_screen.dart` — mirrors native splash (iOS: `launch_ios.png` on `0xFF4A78BD`; Android: `launch_android.png` centered on white), removes `FlutterNativeSplash` post-frame, waits 1500ms, then `navigateAfterSplash`.

### tent_score
- **Page**: `tent_score_screen.dart` (tenant credit score: animated semicircle gauge, streak banner, stats list).
- **Service** (`tent_score_service.dart`): `GET /app/user/tent-score`.
- **Model**: `TentScoreModel{score, maxScore(1000), ratingLabel, streakLabel, streakStatus, onTimePayments, latePayments, totalPaid, verifiedLeases, since}`.
- **Provider**: `tentScoreProvider`. **Widgets**: `tent_score_gauge`, `tent_score_stats_list`, `tent_score_streak_banner`.

### wallet
- **Pages**: `wallet_screen.dart` (balance card, preset amounts [500,1000,1500,2000] + custom, top-up records w/ month picker, pull-refresh), `wallet_payment_screen.dart` (amount summary + payment method + FPX bank picker → create order → H5), `wallet_pay_h5_webview_page.dart` (see §8).
- **Services**: `wallet_service.dart` — `GET /app/wallet/balance`, `GET /app/wallet/topup/list` (page, limit=10, year?, month?), `POST /app/wallet/topup/create` (amount, payment_method, payment_channel?); `payment_service.dart` — `GET /app/payment/quote?amount=`.
- **Models**: `WalletTopupModel{id,userId,amount,paymentMethod,orderId,status,txnId,channel,paidAt,createdAt}` + list response, `WalletTopupOrder{orderId,paymentUrl}`, `PaymentQuoteModel{feePercent,totalAmount,amount,methods: Map<String,PaymentMethodQuoteModel>}` (+ `buildLocalPaymentQuote` fallback), `WalletPaymentArgs{amount, amountLabel}`.
- **Providers**: `walletBalanceProvider` (AsyncNotifier<String>, `silentRefresh`), `walletTopupListProvider` (paginated + selectedMonth), `paymentQuoteProvider` (family by amount, falls back to local quote on error).
- **Data**: `wallet_config.dart` — payment methods `fpx/tng/grab/visa` → Fiuu channels `fpx / TNG-EWALLET / GrabPay / credit`, preset amounts, `WalletAssets`, amount/fee formatters; `fpx_bank_config.dart` — 17 FPX banks (Affin `fpx_abb`, Alliance `fpx_abmb`, AmBank `fpx_amb`, BSN `fpx_bsn`, Bank Islam `fpx_bimb`, Bank Muamalat `fpx_bmmb`, Bank Rakyat `fpx_bkrm`, CIMB `fpx_cimbclicks`, HSBC `fpx_hsbc`, Hong Leong `fpx_hlb`, KFH `fpx_kfh`, Maybank2U `fpx_mb2u`, OCBC `fpx_ocbc`, Public `fpx_pbb`, RHB `fpx_rhb`, Standard Chartered `fpx_scb`, UOB `fpx_uob`).
- **Utils**: `wallet_topup_month_util` (rolling 12 months). **Widgets**: balance card, topup amount section/summary card, month picker sheet, record section, payment method section (shared with pay-rent), payment success dialog, FPX bank picker sheet/selector hint.

---

## 3. Local persistence

**SharedPreferences — only 3 keys exist** (all in `AppConstants`, used by `dio_client.dart`, `auth_service.dart`, `push_notification_service.dart`):
- `auth_token` (String) — access token, sent as `Authorization` header
- `refresh_token` (String) — presence = logged in
- `expires_time` (int)

**No secure storage** (no flutter_secure_storage / Keychain usage). No other persisted state — everything else is in-memory Riverpod.

---

## 4. Push notifications

- `lib/main.dart` — `Firebase.initializeApp(DefaultFirebaseOptions.currentPlatform)` + `FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler)`.
- `lib/firebase_messaging_background.dart` — `@pragma('vm:entry-point')` handler, logs only.
- `lib/firebase_options.dart` — project `neast-73f05`, sender `233970307760`; Android appId `1:233970307760:android:82242bacbb616f7070a175`; iOS appId `1:233970307760:ios:8716b2577aeb816570a175`, bundle `com.neastusers.flutter`.
- `features/push/services/push_notification_service.dart` — initialized from `MainScreen.initState` when logged in:
  - Local notifications via `flutter_local_notifications` (Android icon `@mipmap/ic_launcher`, channel `high_importance_channel`); foreground messages shown as local notifications on **Android only** (iOS uses `setForegroundNotificationPresentationOptions(alert/badge/sound)`).
  - Permission request (alert/badge/sound); iOS waits for APNs token (10×2s) before FCM token, retry up to 8× with backoff.
  - **Token registration: `POST /app/push/add-fcm-token` `{token, platform: ios|android}`** (skipped when logged out); onTokenRefresh re-saves. Logout: `POST /app/push/delete-fcm-token` `{token}` then `deleteToken()` (3s timeout, non-blocking).
  - Tap/foreground handling: clears badge (`app_badge_plus` → `updateBadge(0)`), refreshes notification list/unread, navigates by `data['type']`: `PointAdd` → `/points`, `Coupon` → `/coupon/my-coupons`, default → `/notification`.
  - Badge also cleared when `NotificationScreen` opens. iOS `UIBackgroundModes` includes `remote-notification`.

---

## 5. Deep links

- Package: `app_links` 6.4.1. Schemes registered: Android `AndroidManifest.xml` intent-filter `scheme="neastuser"` (BROWSABLE); iOS `Info.plist` `CFBundleURLSchemes = [neastuser]`.
- Handled inputs (`deep_link_parser.dart`): `neastuser://merchant/<id>`, `neastuser:///merchant/<id>`, and `http(s)://<any-host>/merchant/<id>` → route `/merchant/<id>`. **No other routes are deep-linkable.** Plus the `repairBrokenMerchantRoute('/<id>')` workaround in the router redirect.
- Pending-route stash: `pendingRouteProvider`; consumed by `navigateAfterAuth`, `navigateAfterSplash`, and `flushPendingDeepLinkOnMain` (called from `MainScreen`).

## 6. QR

- **Scanning** (`mobile_scanner` 7.2.1): `QrScannerScreen` (`/scanner`) only; launched via `openQrScanner` with permission_handler camera check; used solely by the pay-rent create form ("Connect with owner" → scan property SN → `GET /app/rent/property?sn=`). Gallery-pick fallback uses `MobileScannerController.analyzeImage`.
- **Generation** (`qr_flutter` 4.1.0, `QrImageView`): `account/pages/my_qr_screen.dart` (profile `qrCode` payload, save-to-gallery), `account/widgets/user_qrcode_dialog.dart`, `coupon/widgets/coupon_qrcode_dialog.dart` (coupon redemption QR from `qrcode`/`sn`).

## 7. Maps

- `flutter_map` **pinned to 8.2.2** (8.3.0+ fling NaN crash) + `latlong2`. Tile provider: **OpenStreetMap** (`tile.openstreetmap.org`), userAgent `com.neastusers.flutter` (`core/constants/map_tile_config.dart`).
- Screens: `merchant/pages/merchant_map_screen.dart` (production) and `merchant_map_demo_screen.dart` (debug, unrouted); marker widget `merchant/widgets/merchant_map_marker.dart`.
- `geolocator` 13: only in `core/services/location_service.dart` (`currentLocationProvider` shared future; debug builds hardcode `(1.4862, 103.6565)` Bukit Indah, JB). Consumed by home dashboard, home/recommended/nearby merchant lists, merchant map, reward dashboard.

## 8. WebView — Fiuu H5 flow

- `webview_flutter` 4.10.0; single screen `wallet/pages/wallet_pay_h5_webview_page.dart` (route `/pay-h5-webview`, extra `{url, title}`), pushed (not `go`) so result returns via `pop<int>`:
  - Browser-like UA (iPhone Safari / Pixel Chrome), JS unrestricted, JS channel `FlutterSchemeHandler` + injected `window.open` override to forward non-http(s) schemes.
  - Navigation delegate: non `http/https/about/blob` schemes → `url_launcher` external (incl. Android `intent://` parsing with `scheme=` extraction and `S.browser_fallback_url` fallback) and `NavigationDecision.prevent`.
  - **Success detection is purely URL-based**: URL containing `/pay_success.html` → result `0`; `/pay_failed.html` → `2`; `/pay_pending.html` → `1`. After detecting, waits 2.5s grace (lets result page render), shows EasyLoading "Processing..." for 0.5s (10s for pending), then pops the code. "Back" button pops `null` (cancelled); `PopScope canPop: false`.
- Callers:
  - `wallet_payment_screen.dart` — `POST /app/wallet/topup/create` → `paymentUrl` → push H5 → on `0`: refresh balance + topup list, success dialog, pop; `1`: "Payment is pending"; `null`: cancelled.
  - `pay_rent_payment_screen.dart` — two paths: wallet balance payment (`POST /app/rent/pay/wallet`, no H5) or H5 (`POST /app/rent/pay/create` → `paymentUrl`). **Polling**: `_waitForPaidHistory` polls `GET /app/rent/history/list?rent_id=` up to 5× at 1s intervals until the history item `isPaidDetailAvailable`, then `pushReplacement` to `/pay-rent/history/detail`. Also used when `paymentUrl` is empty (already-paid race).

## 9. Uploads (chunked)

- `features/common/services/upload_service.dart` (`uploadServiceProvider`):
  - **Chunk size 512 KB** (`512 * 1024`); files ≤ chunk size → single `POST /app/upload/file` (multipart field `file`, progress via `onSendProgress`).
  - Larger → chunked: client-generated `upload_id` (`<millis>_<hex6>`), `totalChunks = ceil(len/512KB)`, **4 concurrent workers**; each chunk `POST /app/upload/chunk` (form: `upload_id`, `chunk_index`, `total_chunks`, `filename`, `file` bytes); then `POST /app/upload/merge` `{upload_id, total_chunks, filename}`. Returns `data.path`. Supports `CancelToken` (`UploadCancelledException`).
- Driven by `features/common/widgets/upload_progress_dialog.dart` (progress bar + cancel). **Only consumer**: pay-rent create form tenancy-agreement upload (`pay_rent_form_card.dart` + `pay_rent_agreement_picker.dart` — image_picker gallery or file_picker any-file). Viewing the agreement later: image → in-app dialog; other types → external browser (`rent_file_actions.dart`).

## 10. Environment / config

- Base URL: hardcoded `http://10.0.2.2:9512` in `lib/core/constants/app_constants.dart` (Android emulator loopback to host). **No env switching / flavors / dart-define.** The bundled `mock-api` serves on port **8000** instead (see §12).
- App version: `1.0.13+22` (pubspec). `MaterialApp` title is **`'YaGuo'`** (leftover). Locale locked to `en`, text scale locked to 1.0, portrait-only.
- Package/bundle IDs: **Android** `applicationId`/`namespace` = `com.neastusers.flutter` (`android/app/build.gradle.kts`; compileSdk/minSdk/targetSdk from Flutter defaults); **iOS** `PRODUCT_BUNDLE_IDENTIFIER = com.neastusers.flutter`, deployment target **15.0**.
- Permissions — Android: fine/coarse location, camera, read external storage (≤SDK32); iOS: location when-in-use + always, camera, photo library (read + add), background mode `remote-notification`.
- Android uses `ImagePickerAndroid.useAndroidPhotoPicker = true`.

## 11. Assets

- **Fonts** (2 TTF, variable): `assets/fonts/FunnelDisplay-VariableFont_wght.ttf` → family **`FD`**; `assets/fonts/HostGrotesk-VariableFont_wght.ttf` → family **`HG`**. Used inline with `FontVariation('wght', …)`.
- **Image assets: 66 files under `assets/images/` + 2 in `assets/icon/`** (49 PNG + 19 SVG total, plus 2 TTF). SVGs rendered via `flutter_svg` (tab icons, account menu icons, checkboxes, success art). Folders declared in pubspec: `assets/images/`, `assets/icon/`, and subfolders `main/ home/ account/ wallet/ points/ refer/ merchant/ pay_rent/ reward/`.
  - `main/` 10 SVG tab icons; `home/` 16 PNG (home_bg, banner, logos, icons); `account/` 9 (6 SVG + del-tip.png); `wallet/` 2 PNG (note: `payment-success.png` referenced in `wallet_config.dart` but folder currently contains only `balance-icon.png`); `points/` 7; `refer/` 4; `reward/` 7 (5 tier icons); `pay_rent/` 8; `merchant/` 2; root: 2 launch images. `assets/icon/`: `app_icon.png`, `share.png`.
- Launcher icons via `flutter_launcher_icons`; native splash via `flutter_native_splash` (Android white bg, iOS `#4A78BD`).

## 12. `test/` and `mock-api/`

- `test/` contains exactly **one test**: `test/core/deep_link/deep_link_parser_test.dart` (uses `package:test`, covers `DeepLinkParser.parseRoute` for custom scheme / path-prefix / https share link / unsupported link, and `repairBrokenMerchantRoute`). No widget tests, no mocks.
- `mock-api/` — self-contained Node server (`server.mjs`, ~880 lines, `node mock-api/server.mjs`, listens `0.0.0.0:8000`, emulator uses `http://10.0.2.2:8000`). Implements the full `/app/*` surface (all 49 endpoints incl. `/pay_success.html` etc.), seeded merchants (4 categories, 6 merchants around JB), demo account phone `123456789` (+60 → `60123456789`) with OTP `123456`; any other phone + OTP `123456` creates an empty tenant. Seeded tenancies: Bukit Indah Apartment (owner Alex Tan on NEAST, bank ****8890) and Southkey Suites (owner Lim Wei not on NEAST → held + invite flow); connect-with-owner demo SNs `NEAST-BUKIT-01`, `NEAST-PARK-02`. Useful as the RN dev backend contract reference.

## 13. Size

- **369 dart files under `lib/`** = 281 hand-written + 44 generated (`.freezed.dart`/`.g.dart` for 22 freezed models) + **44 stray duplicate generated files named `* 2.dart`** (accidental copies, e.g. `user_profile_model.freezed 2.dart` — safe to delete, not imported).
- **37 screen/page files** (`lib/features/*/pages/*.dart` + splash + not_found); **30 routes registered** in go_router (merchant-map demo and `/register` exist as code/constants but are not routed). 4 main tabs: Home, Pay rent, Reward, Account.
- **API surface: 49 distinct `/app/*` endpoints** (listed per-feature above) + 3 legacy `/member/*` calls (`GET /member/info`, `POST /member/change_avatar_type`, `POST /member/auth/send-sms-code`) that appear to be dead template code.

### Notable quirks to carry into the RN rebuild
- Auth header is the **raw token without `Bearer `**; token refresh triggers on **business code 400** (not HTTP 401), refresh token sent as **query param**.
- Every GET has an artificial 200 ms delay; toasts are globally debounced 1.5 s.
- Debug builds fake the location to Johor Bahru.
- Payment result detection is URL-substring based (`/pay_success|failed|pending.html`) — the RN WebView must replicate this plus the `intent://` fallback handling.
- Logged-in check = refresh token exists locally; logout wipes 3 prefs keys and invalidates ~25 providers.