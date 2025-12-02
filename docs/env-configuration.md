# 🔧 Konfigurace .env souborů

## 📋 Přehled souborů

Vytvořil jsem ti **3 .env soubory**:

### 1. `backend.env.local` 
**Pro lokální vývoj na tvém PC**
- Připojení k lokální MySQL databázi (localhost)
- Debug mode zapnutý
- Pro testování na Windows

### 2. `backend.env.example`
**Pro produkční server (VPS)**
- Připojení k Webglobe databázi
- Debug mode vypnutý
- Bezpečnostní nastavení pro produkci

### 3. `.env` (vytvoříš z jednoho z výše)
**Aktuální použitý soubor** (tento soubor NIKDY necommituj na Git!)

---

## 🚀 Jak použít

### Pro lokální vývoj (Windows)

1. **Zkopíruj soubor:**
   ```powershell
   cd C:\projekty\pes-evidence\backend
   copy ..\backend.env.local .env
   ```

2. **Vygeneruj APP_KEY:**
   ```powershell
   php artisan key:generate
   ```

3. **Vytvoř lokální databázi:**
   ```sql
   CREATE DATABASE evidence_psu CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   ```

4. **Spusť migrace:**
   ```powershell
   php artisan migrate
   ```

5. **Spusť server:**
   ```powershell
   php artisan serve
   ```

---

### Pro produkci (VPS - pes.maraxa.cz)

1. **Na VPS zkopíruj soubor:**
   ```bash
   cd /var/www/pes.maraxa.cz/backend
   cp ../backend.env.example .env
   ```

2. **Vygeneruj APP_KEY:**
   ```bash
   php artisan key:generate
   ```

3. **Nastav správná oprávnění:**
   ```bash
   chmod 600 .env
   chown www-data:www-data .env
   ```

4. **Spusť migrace:**
   ```bash
   php artisan migrate --force
   ```

5. **Optimalizace:**
   ```bash
   php artisan config:cache
   php artisan route:cache
   php artisan view:cache
   ```

---

## 🔐 Produkční databázové údaje

```env
DB_CONNECTION=mysql
DB_HOST=db.dw230.webglobe.com
DB_PORT=3306
DB_DATABASE=maraxacz_pes
DB_USERNAME=maraxacz_pes
DB_PASSWORD=aKokotik123
```

**⚠️ DŮLEŽITÉ BEZPEČNOSTNÍ UPOZORNĚNÍ:**
- **NIKDY** necommituj `.env` soubor na GitHub!
- `.env` je již v `.gitignore`, takže by se neměl nahrát
- Heslo `aKokotik123` je viditelné v tomto chatu - zvař změnit!

---

## 🔄 Změna hesla (doporučeno)

### V administraci Webglobe:
1. Přihlas se do administrace
2. Najdi databázi `maraxacz_pes`
3. Změň heslo uživatele `maraxacz_pes`
4. Aktualizuj heslo v `.env` souboru na VPS

### Nebo přímo SQL:
```sql
ALTER USER 'maraxacz_pes'@'%' IDENTIFIED BY 'nove_bezpecne_heslo_123';
FLUSH PRIVILEGES;
```

---

## 📝 Důležité poznámky

### APP_KEY
- Generuje se automaticky příkazem `php artisan key:generate`
- Je to 32-znakový klíč pro šifrování
- Musí být různý pro lokální a produkční prostředí

### APP_DEBUG
- **Lokálně:** `APP_DEBUG=true` (zobrazuje detailní chyby)
- **Produkčně:** `APP_DEBUG=false` (bezpečnost!)

### APP_ENV
- **Lokálně:** `APP_ENV=local`
- **Produkčně:** `APP_ENV=production`

### SESSION_DOMAIN
- **Lokálně:** `SESSION_DOMAIN=localhost`
- **Produkčně:** `SESSION_DOMAIN=.maraxa.cz`

---

## ✅ Kontrolní seznam

### Lokální vývoj:
- [ ] Zkopírován `backend.env.local` na `.env`
- [ ] Spuštěno `php artisan key:generate`
- [ ] Vytvořena databáze `evidence_psu`
- [ ] Spuštěny migrace
- [ ] Server běží na localhost:8000

### Produkce:
- [ ] Zkopírován `backend.env.example` na `.env`
- [ ] Spuštěno `php artisan key:generate`
- [ ] Změněno heslo databáze (doporučeno)
- [ ] Nastavena oprávnění na `.env` (chmod 600)
- [ ] Spuštěny migrace
- [ ] Aplikace běží na pes.maraxa.cz

---

## 🆘 Řešení problémů

### Chyba: "SQLSTATE[HY000] [2002] Connection refused"
- Zkontroluj, že MySQL běží
- Zkontroluj DB_HOST, DB_PORT v .env
- Zkontroluj, že databáze existuje

### Chyba: "Access denied for user"
- Zkontroluj DB_USERNAME a DB_PASSWORD
- Zkontroluj, že uživatel má oprávnění k databázi

### Chyba: "No application encryption key"
- Spusť: `php artisan key:generate`

### Cache problémy
```bash
php artisan config:clear
php artisan cache:clear
php artisan route:clear
php artisan view:clear
```

---

## 📞 Další kroky

Po dokončení konfigurace:
1. Otestuj připojení k databázi: `php artisan migrate:status`
2. Spusť migrace: `php artisan migrate`
3. Vytvoř testovacího uživatele (připravím ti seeder)
4. Napiš mi a pokračujeme s API!

---

**Databázové údaje jsou připravené! 🎉**
