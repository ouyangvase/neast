# NEAST Monorepo

Monorepo containing the NEAST platform: 3 Expo (React Native) mobile apps, 1 PHP (Hyperf) backend API, and a Next.js landing page. pnpm 9 + Turborepo workspace.

## Structure

```
neast-monorepo/
├── apps/
│   ├── neast-user/       # Expo RN app — end users (tenants)
│   ├── neast-merchant/   # Expo RN app — merchants
│   ├── neast-owner/      # Expo RN app — property owners / landlords
│   └── landing/          # Next.js landing page (placeholder)
│   └── ui/
│       └── mobile/       # @neast/ui-mobile — shared RN components/theme
├── packages/
│   └── types/            # @neast/types — shared API contracts + typed client
├── services/
│   └── neast-api/        # PHP (Hyperf) backend API
└── docs/
    ├── flows-and-issues.md    # System flows & known issues documentation
    ├── rn-migration-notes.md  # Flutter→RN omissions & known deviations
    └── *.md                   # Flutter-era inventories (historical reference)
```

## Projects

| Project | Path | Stack | Description |
|---|---|---|---|
| User app | `apps/neast-user` | Expo SDK 56 / RN 0.85 | Mobile app for end users (`com.neastusers.flutter`, scheme `neastuser`) |
| Merchant app | `apps/neast-merchant` | Expo SDK 56 / RN 0.85 | Mobile app for merchants (`com.neastMerchant.flutter`, scheme `neastmerchant`) |
| Owner app | `apps/neast-owner` | Expo SDK 56 / RN 0.85 | Mobile app for property owners/landlords (`com.neastLandlords.flutter`, scheme `neastowner`) |
| Landing | `apps/landing` | Next.js | Public landing page (placeholder) |
| Backend API | `services/neast-api` | PHP 8 / Hyperf, Docker | REST API serving all three apps |

All three apps use Expo Router + TanStack Query + Zustand. Routes live in `apps/<app>/app/`, feature code in `apps/<app>/src/features/`, API wiring in `apps/<app>/src/lib/` (`endpoints.ts`, `api.ts`). Per-app route/endpoint parity with the old Flutter apps is tracked in `apps/<app>/PARITY.md`.

## Getting Started

Prerequisites: Node ≥ 20, pnpm 9 (`corepack enable`), Docker (for the API stack).

```bash
pnpm install
```

Workspace-wide checks (Turbo runs them in every package/app):

```bash
pnpm typecheck
pnpm lint
```

### Mobile apps (Expo)

```bash
cd apps/neast-user      # or neast-merchant / neast-owner
pnpm start              # Expo dev server
```

The API base URL comes from `EXPO_PUBLIC_API_URL` (read by `@neast/types`), defaulting to `http://10.0.2.2:9512` — the Android-emulator loopback for the Docker API stack. On a physical device use your machine's LAN IP, e.g. `EXPO_PUBLIC_API_URL=http://192.168.1.10:9512 pnpm start`.

Two ways to run a backend locally:

1. **Mock API (user app only, no Docker):**
   ```bash
   cd apps/neast-user
   pnpm mock                                        # mock /app API on :8000
   EXPO_PUBLIC_API_URL=http://10.0.2.2:8000 pnpm start
   ```
2. **Full local stack (Docker):**
   ```bash
   cp services/neast-api/.env.example services/neast-api/.env  # first run only
   docker compose up --build
   ```
   - API → http://localhost:9512 (MySQL + Redis start alongside; `services/neast-api/sql` seeds the schema on first boot)
   - Landing → http://localhost:3000

### Landing (without Docker)

```bash
cd apps/landing
npm install
npm run dev
```

## Builds & deployment (EAS)

Mobile builds run on [EAS Build](https://expo.dev); each app has an `eas.json` with three profiles:

| Profile | Purpose | `EXPO_PUBLIC_API_URL` |
|---|---|---|
| `development` | Dev client, internal distribution | `http://10.0.2.2:9512` (local Docker stack) |
| `preview` | Internal-distribution release build | `https://api.neast.my` |
| `production` | Store build | `https://api.neast.my` |

```bash
cd apps/<app>
eas build --platform android --profile preview
```

Store deploys are CI-driven (`.github/workflows/deploy-android.yml`, `deploy-ios.yml`, `deploy-ios-app-store.yml`): EAS Build → EAS Submit (Play Internal / TestFlight / App Store review). They require the `EXPO_TOKEN` secret plus the existing Play / App Store Connect secrets.

See each project's own `README.md` for details.
