# NEAST Monorepo

Monorepo containing the NEAST platform: 3 Flutter mobile apps, 1 PHP (Hyperf) backend API, and a Next.js landing page.

## Structure

```
neast-monorepo/
├── apps/
│   ├── neast-user/       # Flutter app — end users (tenants)
│   ├── neast-merchant/   # Flutter app — merchants
│   ├── neast-owner/      # Flutter app — property owners / landlords
│   └── landing/          # Next.js landing page (placeholder)
├── services/
│   └── neast-api/        # PHP (Hyperf) backend API
└── docs/
    └── flows-and-issues.md  # System flows & known issues documentation
```

## Projects

| Project | Path | Stack | Description |
|---|---|---|---|
| User app | `apps/neast-user` | Flutter | Mobile app for end users |
| Merchant app | `apps/neast-merchant` | Flutter | Mobile app for merchants |
| Owner app | `apps/neast-owner` | Flutter | Mobile app for property owners/landlords |
| Landing | `apps/landing` | Next.js | Public landing page (placeholder) |
| Backend API | `services/neast-api` | PHP 8 / Hyperf, Docker | REST API serving all three apps |

## Getting Started

### Full local stack (Docker)

```bash
cp services/neast-api/.env.example services/neast-api/.env  # first run only
docker compose up --build
```

- API → http://localhost:9512 (MySQL + Redis start alongside; `services/neast-api/sql` seeds the schema on first boot)
- Landing → http://localhost:3000

### Mobile apps (Flutter)

```bash
cd apps/neast-user      # or neast-merchant / neast-owner
flutter pub get
flutter run
```

### Landing (without Docker)

```bash
cd apps/landing
npm install
npm run dev
```

See each project's own `README.md` for details.
