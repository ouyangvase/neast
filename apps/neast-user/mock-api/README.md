# NEAST customer mock API

Local `/app/*` server for the Flutter customer app. No production backend.

```bash
node mock-api/server.mjs
```

Listens on `0.0.0.0:8000`. The Android emulator uses `http://10.0.2.2:8000`.

## Demo account

- Phone: `123456789` (country `+60` → account `60123456789`)
- OTP: `123456`

Any other phone + OTP `123456` creates an empty tenant (Add Tenancy from scratch).

## Seeded tenancies (demo account)

1. Bukit Indah Apartment — owner **Alex Tan** is on NEAST (`landlord_id` set, bank `****8890`). Pay Now → payout queued (status only).
2. Southkey Suites — owner **Lim Wei** is not on NEAST. Pay Now asks for owner bank, then Held + invite.

Connect-with-owner demo SNs: `NEAST-BUKIT-01`, `NEAST-PARK-02`.
