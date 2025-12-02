# 🔐 GitHub blokuje push - Detekce hesel

## 🚨 Problém

```
remote: error: GH013: Repository rule violations found
Push cannot contain secrets
```

GitHub detekoval **heslo v souborech** a blokuje push!

---

## ✅ Rychlé řešení (3 kroky)

### 1️⃣ Spusť čistící skript

```powershell
cd D:\github\evidence_psu
.\clean-secrets.ps1
```

Skript:
- ✅ Odstraní .env soubory z Gitu
- ✅ Aktualizuje .gitignore
- ✅ Vytvoří bezpečný .env.example

### 2️⃣ Push na GitHub

```powershell
git push -u origin main
```

### 3️⃣ Na serveru vytvoř .env ručně

```bash
ssh tvuj_user@pes.maraxa.cz
cd /var/www/pes.maraxa.cz/backend
nano .env
```

A vlož:
```env
DB_CONNECTION=mysql
DB_HOST=db.dw230.webglobe.com
DB_PORT=3306
DB_DATABASE=maraxacz_pes
DB_USERNAME=maraxacz_pes
DB_PASSWORD=tvoje_nove_heslo  # ZMĚŇ!

APP_NAME="Evidence Psu"
APP_ENV=production
APP_KEY=
APP_DEBUG=false
APP_URL=https://pes.maraxa.cz
```

Ulož: `Ctrl+X`, `Y`, `Enter`

Vygeneruj APP_KEY:
```bash
php artisan key:generate
```

✅ **Hotovo!**

---

## 🔧 Manuální řešení (pokud skript nefunguje)

### Krok 1: Odstraň .env soubory z Gitu

```powershell
cd D:\github\evidence_psu

# Smaž z Gitu (ne z disku!)
git rm --cached backend.env.example
git rm --cached backend.env.local
git rm --cached backend/.env
```

### Krok 2: Aktualizuj .gitignore

Otevři `.gitignore` a přidej:
```
# Environment - NIKDY!
.env
.env.*
*.env
*.env.*
backend.env.example
backend.env.local
backend/.env
```

### Krok 3: Commit změny

```powershell
git add .gitignore
git commit -m "Remove sensitive .env files"
```

### Krok 4: Force push (pokud je nutné)

```powershell
git push -f origin main
```

⚠️ **Pozor:** Force push přepíše historii na GitHubu!

---

## 📋 Co se NIKDY nedává na GitHub?

❌ **NIKDY:**
- `.env` soubory s hesly
- Databázová hesla
- API klíče
- SSH klíče
- Tokeny
- Certifikáty

✅ **ANO:**
- `.env.example` (šablona BEZ hesel)
- Kód (.php, .js, .jsx)
- Dokumentace (.md)
- Konfigurace (.json, .yaml)
- Migrace databáze

---

## 🔐 Správný způsob práce s .env

### Na PC:
```
D:\github\evidence_psu\
├── backend.env.example.safe  ← Na GitHub (šablona)
├── backend.env.local         ← LOKÁLNĚ (ignorováno)
└── .gitignore                ← Ignoruje .env
```

### Na serveru:
```
/var/www/pes.maraxa.cz/
└── backend/.env              ← Vytvoř ručně, NIKDY na GitHub
```

### Na GitHubu:
```
github.com/maraxacz-commits/evidence_psu/
├── backend.env.example.safe  ← BEZ skutečného hesla
└── .gitignore                ← Blokuje .env soubory
```

---

## 🎯 Workflow po vyčištění

### Každý push:

```powershell
# 1. Udělej změny...

# 2. Zkontroluj co pushuješ
git status
git diff

# 3. Ujisti se, že NEJSOU tam .env soubory!
# Pokud jsou, přidej je do .gitignore

# 4. Push
git add .
git commit -m "Popis změny"
git push
```

---

## 🆘 Co když jsem už nahrál heslo?

### 1. Odstraň z historie (pokročilé)

```powershell
# POZOR: Toto přepíše historii!
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch backend.env.example" \
  --prune-empty --tag-name-filter cat -- --all

git push --force
```

### 2. ZMĚŇ VŠECHNA HESLA!

- Změň databázové heslo
- Změň všechny API klíče
- Vygeneruj nový APP_KEY

### 3. Rotuj secrets

V Webglobe administraci:
- Změň heslo k databázi
- Vytvoř nového uživatele
- Aktualizuj .env na serveru

---

## ✅ Bezpečnostní checklist

- [ ] `.env` soubory jsou v `.gitignore`
- [ ] Na GitHubu nejsou žádná hesla
- [ ] `backend.env.example.safe` má placeholder heslo
- [ ] Server má vlastní `.env` s jinými hesly
- [ ] Všechna hesla jsou silná (16+ znaků)
- [ ] APP_DEBUG=false v produkci

---

## 📞 Shrnutí

1. **Spusť:** `.\clean-secrets.ps1`
2. **Push:** `git push -u origin main`
3. **Na serveru:** Vytvoř `.env` ručně
4. **ZMĚŇ:** Všechna hesla!

---

**Nikdy nenahrávej .env soubory na GitHub! 🔒**
