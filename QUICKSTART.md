# Quick Start Guide - Evidence psů

## 🚀 Rychlý start (5 kroků)

### 1️⃣ Stáhni a rozbal projekt
- Stáhni všechny soubory z tohoto chatu
- Rozbal do `C:\projekty\pes-evidence\`

### 2️⃣ Inicializuj Git
```powershell
cd C:\projekty\pes-evidence
git init
git remote add origin https://github.com/maraxacz-commits/evidence_psu.git
git add .
git commit -m "Initial commit"
git push -u origin main
```

### 3️⃣ Vytvoř Laravel backend
```powershell
composer create-project laravel/laravel backend
cd backend
composer require laravel/sanctum
copy .env.example .env
php artisan key:generate
```

Uprav `.env`:
```env
DB_DATABASE=evidence_psu
DB_USERNAME=root
DB_PASSWORD=
```

Zkopíruj migrace z `../backend-migrations/` do `backend/database/migrations/`

```powershell
php artisan migrate
php artisan serve
```

✅ Backend běží na: http://localhost:8000

### 4️⃣ Vytvoř React frontend (příště)
Po dokončení backendu ti vytvořím React frontend s TypeScript.

### 5️⃣ Deploy na VPS (když bude hotové)
```bash
# Na VPS spusť:
chmod +x deployment/init-vps.sh
sudo ./deployment/init-vps.sh

# Pak pro každý update:
chmod +x deployment/deploy.sh
sudo ./deployment/deploy.sh
```

---

## 📋 Kontrolní seznam

- [ ] Git repository inicializován
- [ ] Soubory na GitHubu
- [ ] Laravel backend vytvořen
- [ ] Databáze vytvořena
- [ ] Migrace spuštěny
- [ ] Backend běží lokálně
- [ ] React frontend vytvořen (příště)
- [ ] VPS nakonfigurován (příště)
- [ ] Aplikace nasazena (příště)

---

## 🆘 Pomoc

### Problém: "composer not found"
Nainstaluj Composer: https://getcomposer.org/download/

### Problém: "php artisan migrate" chyba
1. Zkontroluj, že databáze `evidence_psu` existuje
2. Zkontroluj `.env` soubor
3. Zkontroluj, že MySQL/MariaDB běží

### Problém: Git push selhává
1. Přihlásit se do GitHubu: `git config --global user.email "email@example.com"`
2. Případně použij Personal Access Token

---

## 📞 Další kroky

Po dokončení tohoto quick startu mi napiš a vytvořím:
1. ✅ **Modely** (User, Dog, Pedigree...)
2. ✅ **Controllers** (API endpointy)
3. ✅ **Routes** (API routing)
4. ✅ **React frontend** (kompletní UI)
5. ✅ **PDF generátor** (rodokmen)
6. ✅ **Autentizace** (JWT)

Držím palce! 🐕
