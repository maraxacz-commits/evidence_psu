# PowerShell skript pro push změn na GitHub
# Použití: .\push-to-github.ps1 "popis změny"

param(
    [string]$Message = "Update"
)

Write-Host "=== Push na GitHub ===" -ForegroundColor Green
Write-Host ""

# Kontrola, že jsme v Git repository
if (-not (Test-Path ".git")) {
    Write-Host "CHYBA: Nejsi v Git repository!" -ForegroundColor Red
    Write-Host "Přejdi do: D:\github\evidence_psu\" -ForegroundColor Yellow
    exit 1
}

# Zobrazení změn
Write-Host "Změněné soubory:" -ForegroundColor Cyan
git status -s

# Potvrzení
Write-Host ""
$confirm = Read-Host "Chceš nahrát tyto změny na GitHub? (y/n)"
if ($confirm -ne "y") {
    Write-Host "Zrušeno." -ForegroundColor Yellow
    exit 0
}

# Git add
Write-Host ""
Write-Host "Přidávám soubory..." -ForegroundColor Cyan
git add .

# Git commit
Write-Host "Vytvářím commit..." -ForegroundColor Cyan
git commit -m "$Message"

if ($LASTEXITCODE -ne 0) {
    Write-Host "Žádné změny k commitnutí." -ForegroundColor Yellow
    exit 0
}

# Git push
Write-Host "Nahrávám na GitHub..." -ForegroundColor Cyan
git push

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "OK Změny nahrány na GitHub!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Další kroky:" -ForegroundColor Yellow
    Write-Host "1. Připoj se na server: ssh tvuj_user@pes.maraxa.cz"
    Write-Host "2. Přejdi do složky: cd /var/www/pes.maraxa.cz"
    Write-Host "3. Aktualizuj: ./deployment/update-from-github.sh"
    Write-Host ""
    Write-Host "Nebo použij automatický deployment (pokud je nastaven)."
} else {
    Write-Host ""
    Write-Host "CHYBA při nahrávání na GitHub!" -ForegroundColor Red
    Write-Host "Zkontroluj připojení a GitHub přístup." -ForegroundColor Yellow
}
