# Instalace Laravel backendu

## Krok 1: Vytvoření Laravel projektu

V PowerShell v adresáři `C:\projekty\pes-evidence\`:

```bash
composer create-project laravel/laravel backend
cd backend
```

## Krok 2: Konfigurace .env

Zkopíruj `.env.example` na `.env` a uprav:

```env
APP_NAME="Evidence Psů"
APP_ENV=local
APP_KEY=
APP_DEBUG=true
APP_URL=http://localhost:8000

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=evidence_psu
DB_USERNAME=root
DB_PASSWORD=

# Pro produkci na VPS:
# DB_HOST=localhost
# DB_DATABASE=evidence_psu
# DB_USERNAME=evidence_user
# DB_PASSWORD=tvoje_heslo
```

## Krok 3: Vygenerování app key

```bash
php artisan key:generate
```

## Krok 4: Instalace závislostí

```bash
composer require laravel/sanctum
composer require intervention/image
php artisan vendor:publish --provider="Laravel\Sanctum\SanctumServiceProvider"
```

## Krok 5: Vytvoření databáze lokálně

V MySQL/MariaDB:
```sql
CREATE DATABASE evidence_psu CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

## Krok 6: Vytvoření migračních souborů

V následujících souborech najdeš migrace pro databázové tabulky.
Umísti je do `backend/database/migrations/`

Pak spusť:
```bash
php artisan migrate
```

## Struktura Laravel projektu

```
backend/
├── app/
│   ├── Http/
│   │   └── Controllers/
│   │       ├── AuthController.php
│   │       ├── DogController.php
│   │       ├── PedigreeController.php
│   │       └── UserController.php
│   ├── Models/
│   │   ├── User.php
│   │   ├── Dog.php
│   │   ├── UserDog.php
│   │   ├── PedigreeTemplate.php
│   │   └── PedigreeExport.php
│   └── Services/
│       └── PedigreeService.php (pro generování PDF)
├── routes/
│   └── api.php
└── database/
    └── migrations/
```

## Další kroky

Po vytvoření Laravel projektu ti vytvořím:
1. Migrační soubory
2. Modely
3. Controllers
4. API routes
5. Service pro generování PDF
