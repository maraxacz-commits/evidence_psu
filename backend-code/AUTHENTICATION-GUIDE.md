# 🔐 Autentizace API - Instalace a testování

## 📦 Co jsme vytvořili:

1. **User Model** s Sanctum tokeny
2. **AuthController** - registrace, login, logout
3. **API Routes** - /api/register, /api/login, /api/logout
4. **CORS konfigurace** - pro frontend

---

## 🚀 Instalace na serveru

### 1. Nahraj soubory na server

**Možnost A: Přes GitHub (doporučeno)**

Na PC:
```powershell
cd D:\github\evidence_psu

# Vytvoř složky pokud neexistují
mkdir -p backend\app\Models
mkdir -p backend\app\Http\Controllers
mkdir -p backend\routes
mkdir -p backend\config

# Zkopíruj soubory z backend-code\ do backend\
copy backend-code\app\Models\User.php backend\app\Models\
copy backend-code\app\Http\Controllers\AuthController.php backend\app\Http\Controllers\
copy backend-code\routes\api.php backend\routes\
copy backend-code\config\cors.php backend\config\

# Push na GitHub
git add .
git commit -m "Add authentication API"
git push
```

Na serveru:
```bash
ssh tvuj_user@pes.maraxa.cz
cd /var/www/pes.maraxa.cz
./deployment/update-from-github.sh
```

**Možnost B: Přes FTP/SFTP**

1. Nahraj soubory ručně přes FileZilla/WinSCP
2. Umísti je do odpovídajících složek

---

### 2. Instalace Sanctum (pokud ještě není)

```bash
cd /var/www/pes.maraxa.cz/backend

# Instalace Sanctum
composer require laravel/sanctum

# Publikování konfigurace
php artisan vendor:publish --provider="Laravel\Sanctum\SanctumServiceProvider"

# Migrace (vytvoří tabulku personal_access_tokens)
php artisan migrate

# Vyčištění cache
php artisan config:clear
php artisan cache:clear
```

---

### 3. Konfigurace .env

Zkontroluj v `backend/.env`:

```env
# API prefix (mělo by být 'api')
# Není potřeba měnit, Laravel používá /api automaticky

# Session pro Sanctum
SESSION_DRIVER=database
SESSION_DOMAIN=pes.maraxa.cz

# CORS
SANCTUM_STATEFUL_DOMAINS=pes.maraxa.cz
```

Po změně:
```bash
php artisan config:cache
```

---

## 🧪 Testování API

### Test 1: Ping endpoint (bez autentizace)

```bash
curl https://pes.maraxa.cz/api/ping
```

Očekávaný výstup:
```json
{
  "message": "API běží!",
  "timestamp": "2024-12-03 10:30:00"
}
```

---

### Test 2: Registrace nového uživatele

```bash
curl -X POST https://pes.maraxa.cz/api/register \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d '{
    "username": "testuser",
    "email": "test@example.com",
    "password": "heslo12345",
    "password_confirmation": "heslo12345",
    "first_name": "Jan",
    "last_name": "Novák"
  }'
```

Očekávaný výstup:
```json
{
  "message": "Registrace úspěšná",
  "user": {
    "id": 1,
    "username": "testuser",
    "email": "test@example.com",
    "first_name": "Jan",
    "last_name": "Novák",
    "full_name": "Jan Novák"
  },
  "token": "1|abcdef123456..."
}
```

**💾 Ulož token!** Budeš ho potřebovat pro další requesty.

---

### Test 3: Přihlášení

```bash
curl -X POST https://pes.maraxa.cz/api/login \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d '{
    "login": "testuser",
    "password": "heslo12345"
  }'
```

Nebo přes email:
```bash
curl -X POST https://pes.maraxa.cz/api/login \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d '{
    "login": "test@example.com",
    "password": "heslo12345"
  }'
```

---

### Test 4: Získání info o uživateli (vyžaduje token)

```bash
curl https://pes.maraxa.cz/api/user \
  -H "Accept: application/json" \
  -H "Authorization: Bearer 1|abcdef123456..."
```

**Pozor:** Nahraď `1|abcdef123456...` svým tokenem z registrace/loginu!

---

### Test 5: Aktualizace profilu

```bash
curl -X PUT https://pes.maraxa.cz/api/user \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer 1|abcdef123456..." \
  -d '{
    "first_name": "Petr",
    "last_name": "Svoboda",
    "city": "Praha",
    "phone": "+420123456789"
  }'
```

---

### Test 6: Odhlášení

```bash
curl -X POST https://pes.maraxa.cz/api/logout \
  -H "Accept: application/json" \
  -H "Authorization: Bearer 1|abcdef123456..."
```

---

## 🌐 Testování v prohlížeči (Postman/Insomnia)

### Postman setup:

1. **Vytvoř Collection:** "Evidence Psů API"

2. **Přidej requesty:**

**Register:**
```
POST https://pes.maraxa.cz/api/register
Headers:
  Content-Type: application/json
  Accept: application/json
Body (JSON):
{
  "username": "jan123",
  "email": "jan@example.com",
  "password": "bezpecneHeslo123",
  "password_confirmation": "bezpecneHeslo123",
  "first_name": "Jan",
  "last_name": "Novák"
}
```

**Login:**
```
POST https://pes.maraxa.cz/api/login
Headers:
  Content-Type: application/json
  Accept: application/json
Body (JSON):
{
  "login": "jan123",
  "password": "bezpecneHeslo123"
}
```

**Get User:**
```
GET https://pes.maraxa.cz/api/user
Headers:
  Accept: application/json
  Authorization: Bearer {tvůj_token}
```

---

## 🔧 Řešení problémů

### Chyba: "Route not found"

```bash
# Vyčisti cache
cd /var/www/pes.maraxa.cz/backend
php artisan route:clear
php artisan cache:clear
php artisan config:clear

# Zkontroluj routes
php artisan route:list
```

### Chyba: "CORS policy"

Zkontroluj `config/cors.php` a ujisti se, že obsahuje:
```php
'paths' => ['api/*', 'sanctum/csrf-cookie'],
'allowed_origins' => ['*'],
```

### Chyba: "Unauthenticated"

- Zkontroluj, že posíláš správný token
- Token musí být v hlavičce: `Authorization: Bearer {token}`
- Token musí být platný (neodhlášený)

### Chyba: "validation failed"

- Zkontroluj, že posíláš všechny povinné pole
- `password` musí mít min. 8 znaků
- `password_confirmation` musí být stejné jako `password`
- `username` a `email` musí být unikátní

---

## 📊 Struktura databáze po registraci

Po úspěšné registraci máš v databázi:

**Tabulka `users`:**
```
id | username | email | password | first_name | last_name | created_at
1  | testuser | test@  | $2y$... | Jan        | Novák     | 2024-12-03
```

**Tabulka `personal_access_tokens`:**
```
id | tokenable_id | name       | token      | created_at
1  | 1            | auth-token | abc123...  | 2024-12-03
```

---

## ✅ Kontrolní seznam

- [ ] Sanctum nainstalován
- [ ] Migrace spuštěny
- [ ] Soubory nahrány na server
- [ ] Cache vyčištěna
- [ ] `/api/ping` funguje
- [ ] Registrace funguje
- [ ] Login funguje
- [ ] Token authentication funguje
- [ ] Logout funguje

---

## 🎯 Další kroky

Po dokončení testování autentizace můžeme pokračovat:

1. ✅ **Dog Model a CRUD** - správa psů
2. **Frontend** - React komponenty pro login/register
3. **Relationship management** - propojení psů (rodičové)
4. **Pedigree API** - generování rodokmenu

---

**Otestuj API a napiš mi jestli vše funguje! 🚀**
