#!/bin/bash

# Inicializační skript pro VPS - Evidence psů
# Spustit jako root nebo s sudo

echo "=== Inicializace VPS pro pes.maraxa.cz ==="

# Aktualizace systému
echo "1. Aktualizace systému..."
apt update && apt upgrade -y

# Instalace potřebných balíčků
echo "2. Kontrola závislostí..."
apt install -y git curl unzip

# Kontrola PHP
echo "3. Kontrola PHP..."
php -v
if [ $? -ne 0 ]; then
    echo "CHYBA: PHP není nainstalováno!"
    exit 1
fi

# Kontrola Composeru
echo "4. Kontrola Composeru..."
composer --version
if [ $? -ne 0 ]; then
    echo "CHYBA: Composer není nainstalován!"
    exit 1
fi

# Kontrola MariaDB
echo "5. Kontrola MariaDB..."
mysql --version
if [ $? -ne 0 ]; then
    echo "CHYBA: MariaDB není nainstalována!"
    exit 1
fi

# Instalace Node.js a npm (pokud není)
echo "6. Kontrola Node.js..."
node -v
if [ $? -ne 0 ]; then
    echo "Instalace Node.js 20.x..."
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
    apt install -y nodejs
fi

# Vytvoření adresářové struktury
echo "7. Vytvoření adresářů..."
mkdir -p /var/www/pes.maraxa.cz
mkdir -p /var/www/pes.maraxa.cz/logs
mkdir -p /var/www/pes.maraxa.cz/storage

# Nastavení oprávnění
echo "8. Nastavení oprávnění..."
chown -R www-data:www-data /var/www/pes.maraxa.cz
chmod -R 755 /var/www/pes.maraxa.cz

# Vytvoření databáze
echo "9. Nastavení databáze..."
read -p "Zadej MySQL root heslo: " -s MYSQL_ROOT_PASSWORD
echo
read -p "Zadej nové heslo pro databázi evidence_psu: " -s DB_PASSWORD
echo

mysql -u root -p${MYSQL_ROOT_PASSWORD} <<EOF
CREATE DATABASE IF NOT EXISTS evidence_psu CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS 'evidence_user'@'localhost' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON evidence_psu.* TO 'evidence_user'@'localhost';
FLUSH PRIVILEGES;
EOF

if [ $? -eq 0 ]; then
    echo "Databáze úspěšně vytvořena!"
    echo "Databáze: evidence_psu"
    echo "Uživatel: evidence_user"
    echo "Heslo: ${DB_PASSWORD}"
    echo ""
    echo "POZNAMENEJ SI TYTO ÚDAJE!"
else
    echo "CHYBA: Nepodařilo se vytvořit databázi!"
    exit 1
fi

# Konfigurace Apache Virtual Host
echo "10. Konfigurace Apache..."
cat > /etc/apache2/sites-available/pes.maraxa.cz.conf <<'VHOST'
<VirtualHost *:80>
    ServerName pes.maraxa.cz
    ServerAdmin admin@maraxa.cz
    
    DocumentRoot /var/www/pes.maraxa.cz/backend/public
    
    <Directory /var/www/pes.maraxa.cz/backend/public>
        Options -Indexes +FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
    
    # React frontend (pokud build)
    Alias /app /var/www/pes.maraxa.cz/frontend/dist
    <Directory /var/www/pes.maraxa.cz/frontend/dist>
        Options -Indexes +FollowSymLinks
        AllowOverride None
        Require all granted
        FallbackResource /index.html
    </Directory>
    
    ErrorLog /var/www/pes.maraxa.cz/logs/error.log
    CustomLog /var/www/pes.maraxa.cz/logs/access.log combined
</VirtualHost>
VHOST

# Povolení modulu rewrite
a2enmod rewrite
a2enmod headers

# Aktivace site
a2ensite pes.maraxa.cz.conf

# Restart Apache
systemctl restart apache2

echo ""
echo "=== Inicializace dokončena ==="
echo ""
echo "Další kroky:"
echo "1. Nahraj kód z GitHub (použij deploy.sh skript)"
echo "2. Nakonfiguruj .env soubor"
echo "3. Spusť migrace: php artisan migrate"
echo "4. Nastav SSL certifikát"
echo ""
echo "Databázové přístupy:"
echo "- Databáze: evidence_psu"
echo "- Uživatel: evidence_user"
echo "- Heslo: ${DB_PASSWORD}"
