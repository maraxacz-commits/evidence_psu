# 🚀 RYCHLÝ START - Vývoj přímo na serveru

## ✅ Ano, můžeš dělat vše přímo na serveru!

Není potřeba lokální prostředí. Všechno nastavíš přímo na VPS.

---

## 📦 1. Stáhni ZIP a nahraj na server

[Stáhnout pes-evidence.zip](computer:///mnt/user-data/outputs/pes-evidence.zip)

**Možnost A: Přes FTP/SFTP**
1. Stáhni ZIP na PC
2. Připoj se přes FileZilla/WinSCP na server
3. Nahraj rozbalený obsah do `/var/www/pes.maraxa.cz/`

**Možnost B: Přes Git (jednodušší)**
```bash
# Připoj se přes SSH
ssh tvuj_user@pes.maraxa.cz

# Přejdi do složky
cd /var/www/pes.maraxa.cz

# Naklonuj z GitHubu
git clone https://github.com/maraxacz-commits/evidence_psu.git .
```

---

## ⚡ 2. Spusť automatický setup

```bash
# Na serveru přes SSH:
cd /var/www/pes.maraxa.cz
chmod +x quick-server-setup.sh
bash quick-server-setup.sh
```

Skript se tě zeptá na vše potřebné a nastaví:
- ✅ Laravel backend
- ✅ Databázové migrace
- ✅ Oprávnění souborů
- ✅ Apache konfiguraci

---

## 🔧 3. Uprav .env soubor

```bash
cd /var/www/pes.maraxa.cz/backend
nano .env
```

Změň tyto řádky:
```env
DB_HOST=db.dw230.webglobe.com
DB_DATABASE=maraxacz_pes
DB_USERNAME=maraxacz_pes
DB_PASSWORD=tvoje_nove_heslo  # ZMĚŇ!

APP_DEBUG=false
APP_ENV=production
```

Ulož: `Ctrl + X`, pak `Y`, pak `Enter`

---

## 🗄️ 4. Spusť migrace

```bash
cd /var/www/pes.maraxa.cz/backend
php artisan migrate
```

---

## ✅ 5. Hotovo!

Otevři prohlížeč: **https://pes.maraxa.cz**

---

## 📝 Jak dělat změny?

### Malé úpravy (soubory na serveru):
```bash
# Připoj se přes SSH
ssh tvuj_user@pes.maraxa.cz
cd /var/www/pes.maraxa.cz/backend

# Edituj soubor
nano app/Http/Controllers/DogController.php

# Vyčisti cache
php artisan cache:clear
```

### Větší změny (přes Git):
```bash
# Na PC:
git add .
git commit -m "Nova funkce"
git push

# Na serveru:
ssh tvuj_user@pes.maraxa.cz
cd /var/www/pes.maraxa.cz
git pull
cd backend
php artisan config:clear
```

---

## 🛠️ Užitečné příkazy

```bash
# Aktualizace z GitHubu
cd /var/www/pes.maraxa.cz
git pull
cd backend && php artisan cache:clear

# Restart Apache
sudo systemctl restart apache2

# Zobrazení logů
tail -f backend/storage/logs/laravel.log

# Vyčištění cache
cd backend
php artisan cache:clear
php artisan config:clear
php artisan route:clear
```

---

## ❓ Co když nemám SSH přístup?

Kontaktuj **Webglobe support** a požádej o:
1. SSH přístup k serveru
2. Práva na spouštění Composer
3. Možnost nahrávat soubory

Nebo použij jejich **webové rozhraní** pokud podporuje:
- Git clone
- Composer install
- Spouštění příkazů

---

## 📞 Potřebuješ pomoc?

Přečti si: `docs/development-on-server.md` (kompletní návod)

---

**Spusť `quick-server-setup.sh` a máš hotovo za 5 minut! 🎉**
