# NEAST User App (`neast-user`)

Flagship tenant app — Expo SDK 56 / React Native 0.85 rebuild of the Flutter `neast-users` app.
Stack: **Expo Router + TanStack Query + Zustand**, consuming `@neast/types` (API client,
contracts, session, upload, FCM helpers) and `@neast/ui-mobile` (theme + shared components)
as read-only workspace packages.

## Run

```bash
pnpm install                 # at the monorepo root
pnpm --filter neast-user start
```

### Backend URL

The base URL comes from `EXPO_PUBLIC_API_URL` and defaults to `http://10.0.2.2:9512`
(Android emulator → host machine). Create `.env` in this folder to override:

```bash
# Bundled mock backend (recommended for dev):
EXPO_PUBLIC_API_URL=http://10.0.2.2:8000
```

Start the mock backend with:

```bash
pnpm --filter neast-user mock     # serves on http://localhost:8000
```

Mock demo login: phone `123456789` (country code `+60`), OTP `123456`.

On a physical device use your machine's LAN IP, e.g. `EXPO_PUBLIC_API_URL=http://192.168.1.10:8000`.

## Scripts

| Script                    | What it does                         |
| ------------------------- | ------------------------------------ |
| `start`                   | Expo dev server                      |
| `android` / `ios` / `web` | Run on a platform                    |
| `mock`                    | Start the mock API on port 8000      |
| `typecheck`               | `tsc -p tsconfig.json`               |
| `lint`                    | `eslint .`                           |
| `export`                  | `expo export` (bundle compile check) |

## Structure

- `app/` — Expo Router routes (30 routes, see `PARITY.md` for the route ↔ spec mapping).
- `src/lib/` — API client, typed endpoint wrappers, deep links, push, upload pickers, formatters.
- `src/stores/` — Zustand stores (tab state, pending deep link, go_router-`extra` selections).
- `src/hooks/` — pagination, countdown, chunked upload, profile/config queries.
- `src/features/` — tab screens + feature widgets (home, pay-rent, reward, account, merchant, coupon).
- `assets/` — recovered Flutter image/SVG assets (SVGs load via `react-native-svg-transformer`).
- `mock-api/` — dev backend (port 8000).

## Notes

- Deep links: `neastuser://merchant/{id}` and `https://api.neast.my/merchant/{id}` open the
  merchant detail; when logged out the link is stashed and replayed after login.
- Push: FCM via `google-services.json` / `GoogleService-Info.plist` (Firebase project
  `neast-73f05`); token registers on login and is deleted on logout.
- Payment H5 flows (wallet top-up, rent pay) run through the shared `FiuuH5WebView`;
  result detection is URL-based (`/pay_success.html` etc.), matching the Flutter app.
