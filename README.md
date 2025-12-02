# Evidence psů a rodokmenů

Webová aplikace pro evidenci psů a generování rodokmenů.

## Technologie

### Backend
- PHP 8.4
- Laravel 11
- MariaDB
- Composer

### Frontend
- React 18
- TypeScript
- Vite
- TailwindCSS

## Struktura projektu

```
pes-evidence/
├── backend/          # Laravel API
├── frontend/         # React aplikace
├── database/         # SQL skripty
├── deployment/       # Deployment skripty
└── docs/            # Dokumentace
```

## Instalace

### Lokální vývoj

#### Backend
```bash
cd backend
composer install
cp .env.example .env
php artisan key:generate
php artisan migrate
php artisan serve
```

#### Frontend
```bash
cd frontend
npm install
npm run dev
```

### Produkce (VPS)

Použij deployment skripty v `deployment/` složce.

## Konfigurace

- Doména: pes.maraxa.cz
- Web server: Apache
- PHP: 8.4
- Databáze: MariaDB

## Autor

© 2024 - Evidence psů a rodokmenů
