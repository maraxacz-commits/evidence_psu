# Git inicializace a první commit

## Krok 1: Stažení souborů

1. Stáhni všechny soubory z tohoto chatu
2. Rozbal je do složky `C:\projekty\pes-evidence\`

Struktura by měla vypadat:
```
C:\projekty\pes-evidence\
├── .gitignore
├── README.md
├── backend-migrations/     (migrace - později přesuneš do backend/database/migrations/)
├── database/              (SQL skripty)
├── deployment/            (deployment skripty pro VPS)
└── docs/                  (dokumentace)
```

## Krok 2: Git inicializace

Otevři PowerShell v `C:\projekty\pes-evidence\` a spusť:

```powershell
# Inicializace Git repository
git init

# Přidání remote repository
git remote add origin https://github.com/maraxacz-commits/evidence_psu.git

# Přidání všech souborů
git add .

# První commit
git commit -m "Initial commit: Project structure and database schema"

# Push na GitHub
git push -u origin main
```

Pokud GitHub očekává branch `master` místo `main`:
```powershell
git branch -M main
git push -u origin main
```

## Krok 3: Vytvoření Laravel backendu

```powershell
# Vytvoření Laravel projektu
composer create-project laravel/laravel backend
cd backend

# Instalace závislostí
composer require laravel/sanctum

# Zkopírování migračních souborů
# Zkopíruj soubory z ../backend-migrations/ do backend/database/migrations/

# Konfigurace .env
copy .env.example .env
# Uprav .env soubor s databázovými údaji

# Vygenerování app key
php artisan key:generate

# Spuštění migrací (nejdřív vytvoř databázi!)
php artisan migrate

# Zpět do root složky
cd ..
```

## Krok 4: Commit Laravel backendu

```powershell
git add backend/
git commit -m "Add Laravel backend with migrations"
git push
```

## Krok 5: Vytvoření React frontendu (další krok)

Po dokončení Laravel části ti vytvořím React frontend.

## Užitečné Git příkazy

```powershell
# Kontrola stavu
git status

# Přidání změn
git add .

# Commit
git commit -m "Popis změny"

# Push na GitHub
git push

# Pull z GitHubu
git pull

# Zobrazení historie
git log --oneline
```

## Tip pro budoucnost

Vytvoř si `.env` soubor pro VPS odděleně a nikdy ho necommituj na GitHub!
V `.gitignore` už je zahrnutý, takže se automaticky ignoruje.
