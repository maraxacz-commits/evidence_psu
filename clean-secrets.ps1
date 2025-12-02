# PowerShell skript pro odstranění citlivých dat z Git repository
# Spusť toto PŘED prvním pushem na GitHub!

Write-Host "=== Čištění citlivých dat z Git ===" -ForegroundColor Red
Write-Host ""

# Kontrola, že jsme v Git repository
if (-not (Test-Path ".git")) {
    Write-Host "CHYBA: Nejsi v Git repository!" -ForegroundColor Red
    exit 1
}

Write-Host "POZOR: Tento skript odstraní všechny .env soubory s hesly z Gitu!" -ForegroundColor Yellow
Write-Host ""
$confirm = Read-Host "Pokračovat? (y/n)"
if ($confirm -ne "y") {
    Write-Host "Zrušeno." -ForegroundColor Yellow
    exit 0
}

Write-Host ""
Write-Host "1. Odstraňuji .env soubory z Git..." -ForegroundColor Cyan

# Odstranění všech .env souborů
git rm --cached backend.env.example -ErrorAction SilentlyContinue
git rm --cached backend.env.local -ErrorAction SilentlyContinue
git rm --cached "backend/.env" -ErrorAction SilentlyContinue
git rm --cached "backend/.env.example" -ErrorAction SilentlyContinue
git rm --cached "backend/.env.local" -ErrorAction SilentlyContinue

Write-Host "OK .env soubory odstraněny z Git" -ForegroundColor Green

Write-Host ""
Write-Host "2. Aktualizuji .gitignore..." -ForegroundColor Cyan

# Přidání do .gitignore (pokud tam již není)
$gitignoreContent = @"

# Environment files - NIKDY NENAHRÁVAT!
.env
.env.*
*.env
*.env.*
backend.env.example
backend.env.local
backend/.env
backend/.env.*

# Database credentials
*.sql
backup.sql
"@

Add-Content -Path ".gitignore" -Value $gitignoreContent
Write-Host "OK .gitignore aktualizován" -ForegroundColor Green

Write-Host ""
Write-Host "3. Vytvářím bezpečný .env.example..." -ForegroundColor Cyan

# Vytvoření bezpečného .env.example (BEZ skutečného hesla)
$safeEnvExample = @"
DB_CONNECTION=mysql
DB_HOST=db.dw230.webglobe.com
DB_PORT=3306
DB_DATABASE=maraxacz_pes
DB_USERNAME=maraxacz_pes
DB_PASSWORD=CHANGE_THIS_PASSWORD_BEFORE_USE

APP_NAME="Evidence Psu"
APP_ENV=production
APP_KEY=
APP_DEBUG=false
APP_URL=https://pes.maraxa.cz
"@

Set-Content -Path "backend.env.example.safe" -Value $safeEnvExample
Write-Host "OK Bezpečný .env.example vytvořen" -ForegroundColor Green

Write-Host ""
Write-Host "4. Commitování změn..." -ForegroundColor Cyan

git add .gitignore
git add backend.env.example.safe
git commit -m "Remove sensitive data and update .gitignore"

Write-Host "OK Změny commitnuty" -ForegroundColor Green

Write-Host ""
Write-Host "=== Čištění dokončeno ===" -ForegroundColor Green
Write-Host ""
Write-Host "Nyní můžeš bezpečně pushnout:" -ForegroundColor Yellow
Write-Host "  git push -u origin main" -ForegroundColor Cyan
Write-Host ""
Write-Host "DŮLEŽITÉ:" -ForegroundColor Red
Write-Host "- .env soubory s hesly jsou nyní ignorovány"
Write-Host "- Na serveru musíš vytvořit .env ručně"
Write-Host "- Použij backend.env.example.safe jako šablonu"
Write-Host "- ZMĚŇ heslo před použitím!"
