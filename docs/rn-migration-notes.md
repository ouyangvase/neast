# RN Migration Notes — Omissions & Known Deviations

Flutter → Expo RN rebuild (Wave 1–4). This file records what was **intentionally not rebuilt** and where the RN apps **knowingly deviate** from the Flutter originals. Route-by-route parity lives in `apps/<app>/PARITY.md`; the Flutter-era inventories (`docs/users.md`, `docs/owner&merchant.md`, `docs/apps-overview.md`) are the spec sources.

## Intentionally omitted Flutter stubs

These existed in the Flutter apps as dead ends, placeholders, or non-functional UI. Dropped on purpose:

**neast-owner**
- **Generate PDF** — statement/record PDF generation stub.
- **WhatsApp** entry points — deep-link stubs without a working flow.
- **Dead quick actions** — home-screen quick actions with no destination.

**neast-merchant**
- **Invoice page** — placeholder screen.
- **Delete Account dialog** — dialog UI with no backend endpoint behind it.
- **Export Report** — stub action.

## Known deviations (chosen, not specified)

- **Lease-month picker values** — the RN picker offers `[3, 6, 12, 18, 24, 36]` months. The Flutter spec did not confirm the exact option set; these values are a deliberate choice, not a recovered constant.
- **Login terms** — login shows inline terms/privacy links instead of the Flutter `agreement_dialog`, whose exact content/behavior could not be confirmed from the spec.
- **Payment-method icons** — the icon assets were lost with the Flutter asset bundle, so payment-method rows are label-only.
- **Scanner gallery-pick** — no parity for picking a QR image from the gallery on scanner screens; camera scan only.
- **iOS push tokens** — iOS push uses the APNs device token via `expo-notifications` (not the FCM token path the Flutter app used). Android remains on FCM. Firebase project `neast-73f05` and bundle IDs are unchanged, so FCM/APNs continuity is preserved server-side.
