#!/bin/bash

# Zjednodušený setup skript pro vývoj přímo na serveru
# Spusť jako: bash quick-server-setup.sh

echo "=== Quick Server Setup - Evidence psu ==="
echo ""


# Zjištění aktuální složky
CURRENT_DIR=$(pwd)
echo "Aktuální složka: $CURRENT_DIR"
echo ""

PROJECT_PATH=/home/html/maraxacz.savana-hosting.cz/public_html/pes
cd $PROJECT_PATH

# Dotaz na Git clone
read -p "Chceš naklonovat z GitHubu? (y/n): " CLONE_GIT
if [ "$CLONE_GIT" = "y" ]; then
    echo "Klonuji repository..."
    git clone https://github.com/maraxacz-commits/evidence_psu.git .
    
    if [ $? -ne 0 ]; then
        echo "CHYBA: Git clone selhal!"
        echo "Alternativa: Nahraj soubory přes FTP/SFTP"
        exit 1
    fi
    echo "✓ Repository naklonován"
fi

# Kontrola Composeru
echo ""
echo "Kontrola Composeru..."
if ! command -v composer &> /dev/null; then
    echo "CHYBA: Composer není nainstalován!"
    echo "Nainstaluj Composer: https://getcomposer.org/download/"
    exit 1
fi
echo "✓ Composer je k dispozici"

# Vytvoření Laravel projektu
echo ""
read -p "Chceš vytvořit Laravel backend? (y/n): " CREATE_BACKEND
if [ "$CREATE_BACKEND" = "y" ]; then
    echo "Vytvářím Laravel projekt (může trvat pár minut)..."
    composer create-project laravel/laravel backend --no-interaction
    
    cd backend
    echo "Instaluji Sanctum..."
    composer require laravel/sanctum --no-interaction
    
    # Kopírování migrací
    if [ -d "../backend-migrations" ]; then
        echo "Kopíruji migrace..."
        cp ../backend-migrations/*.php database/migrations/
        echo "✓ Migrace zkopírovány"
    fi
    
    # Nastavení .env
    echo ""
    echo "Nastavení .env souboru..."
    if [ -f "../backend.env.example" ]; then
        cp ../backend.env.example .env
        echo "✓ Použit produkční .env"
    else
        cp .env.example .env
        echo "⚠ Použit standardní .env.example"
    fi
    
    # Generování APP_KEY
    echo "Generuji APP_KEY..."
    php artisan key:generate
    
    echo ""
    echo "⚠️  DŮLEŽITÉ: Uprav .env soubor s databázovými údaji!"
    echo "Edituj: nano .env"
    echo ""
    echo "Nastavení databáze:"
    echo "DB_HOST=db.dw230.webglobe.com"
    echo "DB_DATABASE=maraxacz_pes"
    echo "DB_USERNAME=maraxacz_pes"
    echo "DB_PASSWORD=tvoje_heslo"
    echo ""
    read -p "Chceš editovat .env TEĎ? (y/n): " EDIT_ENV
    if [ "$EDIT_ENV" = "y" ]; then
        nano .env
    fi
    
    # Migrace
    echo ""
    read -p "Spustit migrace databáze? (y/n): " RUN_MIGRATE
    if [ "$RUN_MIGRATE" = "y" ]; then
        echo "Spouštím migrace..."
        php artisan migrate --force
        
        if [ $? -eq 0 ]; then
            echo "✓ Migrace úspěšné!"
        else
            echo "⚠ Migrace selhaly - zkontroluj .env a databázi"
        fi
    fi
    
    # Nastavení oprávnění
    echo ""
    echo "Nastavuji oprávnění..."
    sudo chown -R www-data:www-data storage bootstrap/cache
    sudo chmod -R 775 storage bootstrap/cache
    echo "✓ Oprávnění nastavena"
    
    # Optimalizace
    echo ""
    echo "Optimalizuji Laravel..."
    php artisan config:cache
    php artisan route:cache
    echo "✓ Laravel optimalizován"
    
    cd ..
fi

# Nastavení Apache
echo ""
read -p "Restartovat Apache? (y/n): " RESTART_APACHE
if [ "$RESTART_APACHE" = "y" ]; then
    sudo systemctl restart apache2
    echo "✓ Apache restartován"
fi

echo ""
echo "=== Setup dokončen ==="
echo ""
echo "Aplikace by měla být dostupná na: https://pes.maraxa.cz"
echo ""
echo "Další kroky:"
echo "1. Zkontroluj .env soubor: nano backend/.env"
echo "2. Pokud jsi nespustil migrace: cd backend && php artisan migrate"
echo "3. Otevři aplikaci v prohlížeči"
echo ""
echo "Pro aktualizaci použij: ./deployment/deploy.sh"
