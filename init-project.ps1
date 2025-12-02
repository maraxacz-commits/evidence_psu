# PowerShell skript pro inicializaci projektu Evidence psu
# Spust v PowerShell jako: .\init-project.ps1

Write-Host "=== Inicializace projektu Evidence psu ===" -ForegroundColor Green
Write-Host ""

# Kontrola, zda jsme ve spravne slozce
$currentDir = Get-Location
Write-Host "Aktualni slozka: $currentDir" -ForegroundColor Yellow

# Kontrola Git
Write-Host "`nKontrola Git..." -ForegroundColor Cyan
$gitVersion = git --version 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "CHYBA: Git neni nainstalovan!" -ForegroundColor Red
    Write-Host "Stahni Git z: https://git-scm.com/download/win"
    exit 1
}
Write-Host "OK $gitVersion" -ForegroundColor Green

# Kontrola Composer
Write-Host "`nKontrola Composer..." -ForegroundColor Cyan
$composerVersion = composer --version 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "CHYBA: Composer neni nainstalovan!" -ForegroundColor Red
    Write-Host "Stahni Composer z: https://getcomposer.org/download/"
    exit 1
}
Write-Host "OK Composer nalezen" -ForegroundColor Green

# Kontrola PHP
Write-Host "`nKontrola PHP..." -ForegroundColor Cyan
$phpVersion = php -v 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "CHYBA: PHP neni nainstalovan!" -ForegroundColor Red
    exit 1
}
Write-Host "OK PHP nalezen" -ForegroundColor Green

# Git inicializace
Write-Host "`n=== Git inicializace ===" -ForegroundColor Green
$initGit = Read-Host "Chces inicializovat Git repository? (y/n)"
if ($initGit -eq "y") {
    git init
    git remote add origin https://github.com/maraxacz-commits/evidence_psu.git
    
    # Nastaveni user (pokud neni)
    $gitUser = git config user.name 2>$null
    if ([string]::IsNullOrEmpty($gitUser)) {
        $userName = Read-Host "Zadej sve jmeno pro Git"
        $userEmail = Read-Host "Zadej svuj email pro Git"
        git config user.name "$userName"
        git config user.email "$userEmail"
    }
    
    Write-Host "OK Git repository inicializovan" -ForegroundColor Green
}

# Prvni commit
$firstCommit = Read-Host "`nChces vytvorit prvni commit a pushnout na GitHub? (y/n)"
if ($firstCommit -eq "y") {
    git add .
    git commit -m "Initial commit: Project structure and documentation"
    git branch -M main
    
    Write-Host "`nPushuju na GitHub..." -ForegroundColor Cyan
    git push -u origin main
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "OK Kod uspesne nahran na GitHub!" -ForegroundColor Green
    } else {
        Write-Host "POZOR: Push selhal. Zkontroluj pristup k GitHub." -ForegroundColor Yellow
    }
}

# Vytvoreni Laravel backendu
Write-Host "`n=== Laravel Backend ===" -ForegroundColor Green
$createBackend = Read-Host "Chces vytvorit Laravel backend? (y/n)"
if ($createBackend -eq "y") {
    Write-Host "`nVytvarim Laravel projekt (muze trvat par minut)..." -ForegroundColor Cyan
    composer create-project laravel/laravel backend --no-interaction
    
    if (Test-Path "backend") {
        Write-Host "OK Laravel backend vytvoren" -ForegroundColor Green
        
        # Instalace zavislosti
        Write-Host "`nInstaluji zavislosti..." -ForegroundColor Cyan
        Set-Location backend
        composer require laravel/sanctum --no-interaction
        
        # Kopirovani .env
        Write-Host "`nVyber prostredi:" -ForegroundColor Cyan
        Write-Host "1. Lokalni vyvoj (localhost, MySQL na PC)"
        Write-Host "2. Produkcni server (Webglobe databaze)"
        $envChoice = Read-Host "Vyber (1/2)"
        
        if ($envChoice -eq "2") {
            if (Test-Path "../backend.env.example") {
                Copy-Item ../backend.env.example .env
                Write-Host "OK Pouzit produkcni .env (Webglobe)" -ForegroundColor Green
            }
        } else {
            if (Test-Path "../backend.env.local") {
                Copy-Item ../backend.env.local .env
                Write-Host "OK Pouzit lokalni .env" -ForegroundColor Green
            } elseif (Test-Path ".env.example") {
                Copy-Item .env.example .env
                Write-Host "OK Pouzit standardni .env.example" -ForegroundColor Yellow
            }
        }
        
        if (Test-Path ".env") {
            php artisan key:generate
            Write-Host "OK APP_KEY vygenerovan" -ForegroundColor Green
            Write-Host "`nPOZOR: NEZAPOMEN UPRAVIT .env soubor s databazovymi udaji!" -ForegroundColor Yellow
        }
        
        # Navrat zpet
        Set-Location ..
        
        # Kopirovani migraci
        Write-Host "`nKopiruji migracni soubory..." -ForegroundColor Cyan
        if (Test-Path "backend-migrations") {
            Copy-Item "backend-migrations\*.php" "backend\database\migrations\" -Force
            Write-Host "OK Migrace zkopirovany" -ForegroundColor Green
        }
        
        Write-Host "`nUPOZORNENI: Uprav backend\.env soubor s databazovymi udaji!" -ForegroundColor Yellow
        Write-Host "Pak spust: cd backend" -ForegroundColor Yellow
        Write-Host "          php artisan migrate" -ForegroundColor Yellow
    }
}

Write-Host "`n=== Inicializace dokoncena ===" -ForegroundColor Green
Write-Host "`nDalsi kroky:" -ForegroundColor Cyan
Write-Host "1. Uprav backend\.env soubor"
Write-Host "2. Vytvor databazi: CREATE DATABASE evidence_psu;"
Write-Host "3. Spust: cd backend"
Write-Host "4. Spust: php artisan migrate"
Write-Host "5. Spust: php artisan serve"
Write-Host ""
Write-Host "Projekt na GitHubu: https://github.com/maraxacz-commits/evidence_psu" -ForegroundColor Green