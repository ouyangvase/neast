# NEAST Monorepo

Monorepo containing the NEAST platform: 3 Flutter mobile apps and 1 PHP (Hyperf) backend API.

## Structure

```
neast-monorepo/
├── apps/
│   ├── neast-user/       # Flutter app — end users (tenants)
│   ├── neast-merchant/   # Flutter app — merchants
│   └── neast-owner/      # Flutter app — property owners / landlords
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
| Backend API | `services/neast-api` | PHP 8 / Hyperf, Docker | REST API serving all three apps |

## Getting Started

### Mobile apps (Flutter)

```bash
cd apps/neast-user      # or neast-merchant / neast-owner
flutter pub get
flutter run
```

### Backend API

```bash
cd services/neast-api
docker compose -f docker-compose.dev.yml up
```

See each project's own `README.md` for details.
