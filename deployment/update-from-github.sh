#!/bin/bash

# Jednoduchý deployment skript
# Použití: ./update-from-github.sh "popis změny"

echo "=== Aktualizace z GitHubu ==="
echo ""

# Kontrola, že jsme ve správné složce
if [ ! -d ".git" ]; then
    echo "CHYBA: Nejsi v Git repository!"
    echo "Přejdi do: /var/www/pes.maraxa.cz"
    exit 1
fi

# Uložení lokálních změn (pokud jsou)
if [[ -n $(git status -s) ]]; then
    echo "⚠️  Nalezeny lokální změny, ukládám..."
    git stash
fi

# Pull z GitHubu
echo "Stahuji změny z GitHubu..."
git pull origin main

if [ $? -ne 0 ]; then
    echo "❌ Git pull selhal!"
    exit 1
fi

echo "✅ Kód aktualizován z GitHubu"

# Aktualizace Composeru (pokud existuje backend)
if [ -d "backend" ]; then
    echo ""
    echo "Aktualizuji Composer závislosti..."
    cd backend
    composer install --no-dev --optimize-autoloader
    
    # Laravel optimizace
    echo "Vyčisťuji cache..."
    php artisan config:clear
    php artisan cache:clear
    php artisan route:clear
    php artisan view:clear
    
    # Nové migrace (pokud jsou)
    echo ""
    read -p "Spustit nové migrace? (y/n): " RUN_MIGRATE
    if [ "$RUN_MIGRATE" = "y" ]; then
        php artisan migrate --force
    fi
    
    # Cache pro produkci
    echo "Optimalizuji pro produkci..."
    php artisan config:cache
    php artisan route:cache
    php artisan view:cache
    
    # Nastavení oprávnění
    echo "Nastavuji oprávnění..."
    sudo chown -R www-data:www-data storage bootstrap/cache
    sudo chmod -R 775 storage bootstrap/cache
    
    cd ..
fi

# Aktualizace frontendu (pokud existuje)
if [ -d "frontend" ]; then
    echo ""
    echo "Aktualizuji frontend..."
    cd frontend
    npm install
    npm run build
    cd ..
fi

# Restart Apache
echo ""
read -p "Restartovat Apache? (y/n): " RESTART
if [ "$RESTART" = "y" ]; then
    sudo systemctl restart apache2
    echo "✅ Apache restartován"
fi

echo ""
echo "=== Aktualizace dokončena ==="
echo ""
echo "Poslední commit:"
git log -1 --pretty=format:"%h - %s (%cr) <%an>"
echo ""
echo ""
echo "Aplikace: https://pes.maraxa.cz"
