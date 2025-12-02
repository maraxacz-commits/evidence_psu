#!/bin/bash

# Deployment skript pro pes.maraxa.cz
# Stáhne nejnovější kód z GitHub a nasadí na server

set -e  # Ukončit při chybě

echo "=== Deployment pes.maraxa.cz ==="

# Konfigurace
PROJECT_DIR="/var/www/pes.maraxa.cz"
BACKEND_DIR="$PROJECT_DIR/backend"
FRONTEND_DIR="$PROJECT_DIR/frontend"
GIT_REPO="https://github.com/maraxacz-commits/evidence_psu.git"
BRANCH="main"

# Barvy pro výpisy
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Funkce pro logování
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Kontrola, zda existuje projekt
if [ ! -d "$PROJECT_DIR" ]; then
    log_info "První deployment - klonování repository..."
    git clone $GIT_REPO $PROJECT_DIR
    cd $PROJECT_DIR
else
    log_info "Aktualizace z GitHub..."
    cd $PROJECT_DIR
    
    # Uložení lokálních změn (pokud nějaké jsou)
    if [[ -n $(git status -s) ]]; then
        log_warning "Nalezeny lokální změny, ukládám..."
        git stash
    fi
    
    # Pull nejnovější změny
    git fetch origin
    git checkout $BRANCH
    git pull origin $BRANCH
fi

# Backend deployment
if [ -d "$BACKEND_DIR" ]; then
    log_info "Nasazení backendu..."
    cd $BACKEND_DIR
    
    # Composer install
    log_info "Instalace PHP závislostí..."
    composer install --no-dev --optimize-autoloader
    
    # Kontrola .env souboru
    if [ ! -f .env ]; then
        log_error ".env soubor neexistuje! Zkopíruj .env.example a nakonfiguruj."
        exit 1
    fi
    
    # Laravel optimizace
    log_info "Optimalizace Laravel..."
    php artisan config:cache
    php artisan route:cache
    php artisan view:cache
    
    # Migrace databáze
    read -p "Spustit migrace databáze? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        php artisan migrate --force
    fi
    
    # Nastavení oprávnění
    log_info "Nastavení oprávnění..."
    chown -R www-data:www-data $BACKEND_DIR/storage
    chown -R www-data:www-data $BACKEND_DIR/bootstrap/cache
    chmod -R 775 $BACKEND_DIR/storage
    chmod -R 775 $BACKEND_DIR/bootstrap/cache
else
    log_warning "Backend adresář nenalezen"
fi

# Frontend deployment
if [ -d "$FRONTEND_DIR" ]; then
    log_info "Nasazení frontendu..."
    cd $FRONTEND_DIR
    
    # npm install a build
    log_info "Instalace npm závislostí..."
    npm ci
    
    log_info "Building React aplikace..."
    npm run build
    
    # Nastavení oprávnění
    chown -R www-data:www-data $FRONTEND_DIR/dist
else
    log_warning "Frontend adresář nenalezen"
fi

# Restart služeb
log_info "Restart Apache..."
systemctl restart apache2

# Vyčištění cache
log_info "Vyčištění cache..."
if [ -d "$BACKEND_DIR" ]; then
    cd $BACKEND_DIR
    php artisan cache:clear
    php artisan config:clear
fi

log_info "=== Deployment dokončen úspěšně! ==="
log_info "Aplikace je dostupná na: http://pes.maraxa.cz"

# Zobrazení Git info
echo ""
echo "Aktuální verze:"
git log -1 --pretty=format:"%h - %s (%cr) <%an>"
echo ""
