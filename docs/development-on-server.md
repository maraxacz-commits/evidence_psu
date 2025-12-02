# 🚀 Vývoj přímo na serveru (bez lokálního prostředí)

## ✅ Výhody
- Není potřeba lokální PHP, MySQL, Apache
- Vše běží rovnou na produkčním serveru
- Změny jsou okamžitě viditelné
- Jednodušší pro začátečníky

## ⚠️ Nevýhody
- Chyby se zobrazují návštěvníkům
- Nebezpečnější (můžeš omylem smazat data)
- Pomalejší vývoj (upload přes FTP/Git)

---

## 📋 Postup - Vývoj přímo na VPS

### Varianta A: Přes SSH (Doporučeno)

#### 1. Připoj se na VPS přes SSH
```bash
ssh uzivatel@pes.maraxa.cz
# nebo
ssh uzivatel@IP_ADRESA
```

#### 2. Přejdi do webové složky
```bash
cd /var/www/pes.maraxa.cz
```

#### 3. Naklonuj GitHub repository
```bash
git clone https://github.com/maraxacz-commits/evidence_psu.git .
```

#### 4. Vytvoř Laravel backend
```bash
composer create-project laravel/laravel backend
cd backend
composer require laravel/sanctum
```

#### 5. Zkopíruj migrace
```bash
cp ../backend-migrations/*.php database/migrations/
```

#### 6. Nastav .env
```bash
cp ../backend.env.example .env
nano .env  # Edituj soubor (Ctrl+X pro uložení)
```

V .env nastav:
```env
DB_HOST=db.dw230.webglobe.com
DB_DATABASE=maraxacz_pes
DB_USERNAME=maraxacz_pes
DB_PASSWORD=tvoje_heslo  # ZMĚŇ!
```

#### 7. Vygeneruj APP_KEY
```bash
php artisan key:generate
```

#### 8. Spusť migrace
```bash
php artisan migrate
```

#### 9. Nastav oprávnění
```bash
chmod -R 775 storage bootstrap/cache
chown -R www-data:www-data storage bootstrap/cache
```

✅ **Hotovo!** Aplikace běží na `https://pes.maraxa.cz`

---

### Varianta B: Přes FTP/SFTP (Jednodušší)

#### 1. Připoj se přes FTP klient
- **FileZilla** (zdarma): https://filezilla-project.org/
- **WinSCP** (zdarma): https://winscp.net/

Údaje:
```
Host: pes.maraxa.cz
Port: 22 (SFTP) nebo 21 (FTP)
Uživatel: tvůj SSH/FTP user
Heslo: tvoje heslo
```

#### 2. Nahraj soubory
- Stáhni ZIP z našeho chatu
- Rozbal na PC
- Nahraj celou složku `pes-evidence` na server do `/var/www/pes.maraxa.cz/`

#### 3. Přes SSH nebo webové rozhraní:
- Vytvoř Laravel projekt (přes SSH composer)
- Nebo použij **Webglobe administraci** pokud podporuje Composer

---

### Varianta C: Automatický deployment (Nejlepší)

#### 1. Připrav vše na GitHubu
```powershell
# Na tvém PC
cd D:\github\evidence_psu
git add .
git commit -m "Initial setup"
git push
```

#### 2. Na serveru spusť deployment skript
```bash
ssh uzivatel@pes.maraxa.cz
cd /var/www/pes.maraxa.cz
chmod +x deployment/deploy.sh
./deployment/deploy.sh
```

#### 3. Při každé změně
```powershell
# Na PC udělej změny, pak:
git add .
git commit -m "Popis změny"
git push

# Na serveru:
ssh uzivatel@pes.maraxa.cz
cd /var/www/pes.maraxa.cz
./deployment/deploy.sh
```

---

## 🔧 Workflow pro vývoj přímo na serveru

### 1. Malé změny (HTML, CSS, PHP)
Použij **online editor** nebo edituj přes **FTP/SFTP**:
- WinSCP má vestavěný editor
- FileZilla má "View/Edit" funkci
- Nebo přes SSH: `nano backend/routes/api.php`

### 2. Větší změny
Dělej lokálně na PC a pak:
```powershell
# Pushni na GitHub
git add .
git commit -m "Nova funkce XYZ"
git push

# Na serveru pull
ssh uzivatel@pes.maraxa.cz
cd /var/www/pes.maraxa.cz
git pull
php artisan config:clear
```

---

## 📂 Struktura na serveru

```
/var/www/pes.maraxa.cz/
├── backend/              ← Laravel aplikace
│   ├── app/
│   ├── public/          ← Apache DocumentRoot
│   ├── .env             ← Konfigurace (NIKDY na Git!)
│   └── ...
├── frontend/            ← React (příště)
├── deployment/          ← Skripty
└── ...
```

---

## 🔐 Bezpečnostní tipy

### 1. Vypni debug v produkci
V `.env`:
```env
APP_DEBUG=false
APP_ENV=production
```

### 2. Ochrana .env souboru
```bash
chmod 600 backend/.env
```

### 3. Nikdy necommituj .env na GitHub
Je to už v `.gitignore`, ale zkontroluj:
```bash
cat .gitignore | grep .env
```

### 4. Zálohuj databázi pravidelně
```bash
mysqldump -h db.dw230.webglobe.com -u maraxacz_pes -p maraxacz_pes > backup.sql
```

---

## 🛠️ Užitečné příkazy na serveru

### Aktualizace z GitHubu
```bash
cd /var/www/pes.maraxa.cz
git pull
cd backend
composer install --no-dev
php artisan migrate
php artisan config:cache
php artisan route:cache
```

### Restart Apache
```bash
sudo systemctl restart apache2
```

### Zobrazení logů
```bash
tail -f backend/storage/logs/laravel.log
tail -f /var/www/pes.maraxa.cz/logs/error.log
```

### Vyčištění cache
```bash
cd backend
php artisan cache:clear
php artisan config:clear
php artisan route:clear
php artisan view:clear
```

---

## 📞 Co potřebuješ vědět od providera (Webglobe)?

1. **SSH přístup:**
   - IP adresa serveru
   - SSH port (obvykle 22)
   - Uživatelské jméno
   - Heslo nebo SSH klíč

2. **Webové adresáře:**
   - Cesta k webroot (např. `/var/www/pes.maraxa.cz/`)
   - Apache DocumentRoot

3. **PHP a Composer:**
   - Je Composer nainstalovaný?
   - Jaká verze PHP?
   - Máš práva spouštět composer?

---

## 🚀 Rychlý start - 3 kroky

```bash
# 1. SSH na server
ssh tvuj_user@pes.maraxa.cz

# 2. Spusť init skript
cd /var/www/pes.maraxa.cz
chmod +x deployment/init-vps.sh
sudo ./deployment/init-vps.sh

# 3. Deploy projektu
chmod +x deployment/deploy.sh
./deployment/deploy.sh
```

✅ **Aplikace běží!**

---

## ❓ Častá otázky

### Můžu editovat soubory přímo na serveru?
Ano, přes SSH editorem `nano` nebo `vim`, nebo přes FTP klient.

### Jak aktualizuju aplikaci?
```bash
git pull
php artisan migrate
php artisan cache:clear
```

### Co když něco rozbiju?
```bash
git log  # Zobraz historii
git reset --hard HEAD~1  # Vrať poslední commit
```

### Potřebuju lokální prostředí?
Ne! Můžeš dělat vše na serveru. Ale testování je bezpečnější lokálně.

---

**Doporučuji začít přímo na serveru a později přidat lokální vývoj! 🎉**
