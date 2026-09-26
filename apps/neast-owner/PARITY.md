# Parity Checklist — neast-owner (Flutter → Expo RN)

Maps every route and every `/landlord/*` endpoint from `docs/owner&merchant.md` (OWNER
section) to its implementation. All endpoint paths verified against the Hyperf PHP
(`services/neast-api/app/Controller/Http/Landlord/*`) and smoke-tested live against the
docker stack on `:9512`.

## Routes (14)

| #   | Route (go_router)            | File                                                              | Status / notes                                                                                          |
| --- | ---------------------------- | ----------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- |
| 1   | `/splash`                    | `app/splash.tsx`                                                  | ✅ 1500ms → `navigateAfterSplash` (logged-in → `/`, else `/login`)                                      |
| 2   | `/` (tab shell)              | `app/index.tsx` + `src/features/{home,properties,records,account}/*Tab.tsx` | ✅ 4 tabs (Home/Properties/Records/Account); state-based switch (IndexedStack parity); double-back-to-exit; FCM init post-frame |
| 3   | `/login`                     | `app/login.tsx`                                                   | ✅ Log In / Sign Up tabs; country-code picker; `send-code` with `scene=login\|register`                  |
| 4   | `/verify`                    | `app/verify.tsx`                                                  | ✅ OtpInput, 60s resend; `mode=login` → login, `mode=signup` → register (first/last name)               |
| 5   | `/rent-detail`               | `app/rent-detail.tsx`                                             | ✅ item via selection store (go_router `extra` parity); agreement view (image preview / external)       |
| 6   | `/ack-list`                  | `app/ack-list.tsx`                                                | ✅ unpaginated list → detail                                                                            |
| 7   | `/ack-detail`                | `app/ack-detail.tsx`                                              | ✅ confirm → `ack/confirm` → invalidate → back                                                          |
| 10  | `/add-property`              | `app/add-property.tsx`                                            | ✅ name, address, and photo (chunked upload via @neast/types) → `property/create` → success dialog      |
| 11  | `/bank-detail`               | `app/bank-detail.tsx`                                             | ✅ prefilled from `landlord/info`; header photo upload; save → `bank-detail`                            |
| 12  | `/portfolio-snapshot`        | `app/portfolio-snapshot.tsx`                                      | ✅ `portfolio/detail` summary + tenant rows → drill-down                                                |
| 13  | `/portfolio-tenant-detail`   | `app/portfolio-tenant-detail.tsx`                                 | ✅ `?id=` → `rent/id/{id}`; terminate w/ 5s countdown when `can_terminate`                              |
| 14  | `/notification`              | `app/notification.tsx`                                            | ✅ paginated `message/list`; on focus: clear badge + `message/read-all` + invalidate                    |
| 15  | `/rich-text`                 | `app/rich-text.tsx`                                               | ✅ `?title=` → `agreement/detail` → RichText (About Us / Terms / Privacy)                               |
| 16  | 404                          | `app/+not-found.tsx`                                              | ✅                                                                                                      |

Cross-cutting in `app/_layout.tsx`: font gate (`useBrandFonts`), session hydrate, auth guard
(`PUBLIC_PATHS = /splash /login /verify` — owner app has no guest mode), ToastHost.
Bank gate for add-property lives in `src/features/properties/AddPropertyGate.tsx`
(fetch `landlord/info` fresh → `bank_account` truthy ? push `/add-property` : dialog → `/bank-detail`).
Property QR dialog (Properties tab) encodes the raw `sn` string, client-side only.

## Endpoints

App-level wrappers live in `src/lib/endpoints.ts`; upload/refresh/push are inside
`@neast/types` helpers (`uploadFile` chunked 512KB×4, client single-flight refresh,
`registerFcmToken`/`unregisterFcmToken`).

| #   | Endpoint                                   | Wrapper / helper                     | Used by                                             |
| --- | ------------------------------------------ | ------------------------------------ | --------------------------------------------------- |
| 1   | `GET /landlord/auth/country-codes`         | `getCountryCodes`                    | `app/login.tsx`                                     |
| 2   | `POST /landlord/auth/send-code`            | `sendCode`                           | `app/login.tsx`, `app/verify.tsx`                   |
| 3   | `POST /landlord/auth/login`                | `login`                              | `app/verify.tsx`                                    |
| 4   | `POST /landlord/auth/register`             | `register`                           | `app/verify.tsx`                                    |
| 5   | `POST /landlord/auth/refresh-token`        | `@neast/types` client (single-flight) | automatic                                          |
| 6   | `GET /landlord/home/detail`                | `getHomeDashboard`                   | `HomeTab`                                           |
| 7   | `GET /landlord/ack/list`                   | `getAckList`                         | `ack-list.tsx` (unpaginated `{items}`)              |
| 8   | `POST /landlord/ack/confirm`               | `confirmAck`                         | `ack-detail.tsx`                                    |
| 11  | `GET /landlord/portfolio/detail`           | `getPortfolioDetail`                 | `portfolio-snapshot.tsx`                            |
| 12  | `GET /landlord/rent/id/{id}`               | `getRentDetail`                      | `portfolio-tenant-detail.tsx`                       |
| 13  | `PUT /landlord/rent/id/{id}/terminate`     | `terminateRent` (no body)            | `portfolio-tenant-detail.tsx`                       |
| 14  | `GET /landlord/property/list?page&limit`   | `getPropertyList`                    | `PropertiesTab`                                     |
| 15  | `POST /landlord/property/create`           | `createProperty`                     | `add-property.tsx`                                  |
| 16  | `GET /landlord/record/list?year&month&page&limit` | `getRecordList`               | `RecordsTab` (MonthPicker + `amount_sum`)           |
| 17  | `GET /landlord/info`                       | `getLandlordInfo`                    | `AccountTab`, `AddPropertyGate`, `bank-detail.tsx`  |
| 18  | `POST /landlord/bank-detail`               | `updateBankDetail`                   | `bank-detail.tsx`                                   |
| 19  | `POST /landlord/delete-account`            | `deleteAccount`                      | `AccountTab` (ConfirmDialog, 10s countdown)         |
| 20  | `GET /landlord/message/list?page&limit`    | `getMessages`                        | `notification.tsx`                                  |
| 21  | `POST /landlord/message/read-all`          | `markAllMessagesRead`                | `notification.tsx`                                  |
| 22  | `GET /landlord/agreement/detail?title=`    | `getAgreement`                       | `rich-text.tsx`                                     |
| 23  | `POST /landlord/push/add-fcm-token`        | `registerFcmToken` (@neast/types)    | `src/lib/push.ts` (post-frame on tab shell)         |
| 24  | `POST /landlord/push/delete-fcm-token`     | `unregisterFcmToken` (@neast/types)  | `src/lib/auth.ts` (logout)                          |
| 25  | `POST /landlord/upload/file` (+chunk/merge) | `uploadFile` (@neast/types)         | `add-property.tsx`, `bank-detail.tsx`               |

## Intentionally omitted (known stubs / dead code in Flutter)

| Item                                             | Reason                                                                                  |
| ------------------------------------------------ | --------------------------------------------------------------------------------------- |
| Generate PDF button (records)                    | Stub — no implementation behind it in Flutter                                           |
| WhatsApp button (rent detail)                    | Stub                                                                                    |
| Quick actions: Send Reminder / Agreements / Maintenance / Export Report / Risk Center | Dead buttons (no handler); only **Add Property** is real                   |
| `GET /landlord/config` + alpha notice            | All Flutter call sites commented out                                                    |
| Dummy fallback data in ack/rent screens          | Hardcoded placeholders shown on API failure — off the confirmed path                    |
| Beta tag overlay                                 | Debug-only widget                                                                       |
| APNs wait/retry loop (max 8)                     | expo-notifications owns token retrieval; iOS yields an APNs token (same as user app)    |
