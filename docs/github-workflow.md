# 🚀 Workflow: PC → GitHub → Server

## ✅ Ano! GitHub je nejlepší způsob!

```
PC (Windows) → GitHub → Server (VPS)
     ↓           ↓          ↓
  Vytváříš   Verzování  Běží web
```

---

## 📋 První nastavení (jednou)

### 1. Na PC - Nahraj projekt na GitHub

```powershell
# V PowerShell v D:\github\evidence_psu\
cd D:\github\evidence_psu

# Inicializace
git init
git remote add origin https://github.com/maraxacz-commits/evidence_psu.git

# První nahrání
git add .
git commit -m "Initial commit"
git branch -M main
git push -u origin main
```

### 2. Na serveru - Naklonuj z GitHub

```bash
# Připoj se přes SSH
ssh tvuj_user@pes.maraxa.cz

# Přejdi do složky
cd /var/www/pes.maraxa.cz

# Naklonuj projekt
git clone https://github.com/maraxacz-commits/evidence_psu.git .

# Spusť setup
bash quick-server-setup.sh
```

✅ **Hotovo! První nastavení dokončeno.**

---

## 🔄 Každodenní práce

### Na PC - Vytváříš/upravuješ soubory

#### Manuálně:
```powershell
# 1. Udělej změny v souborech...

# 2. Nahraj na GitHub
cd D:\github\evidence_psu
git add .
git commit -m "Přidal jsem novou funkci XYZ"
git push
```

#### Automaticky (jednodušší):
```powershell
# Spusť skript
cd D:\github\evidence_psu
.\push-to-github.ps1 "Popis změny"
```

Skript za tebe:
- ✅ Zobrazí změny
- ✅ Zeptá se na potvrzení
- ✅ Přidá, commitne a pushne
- ✅ Zobrazí další kroky

---

### Na serveru - Aktualizuješ aplikaci

#### Manuálně:
```bash
# Připoj se
ssh tvuj_user@pes.maraxa.cz

# Stáhni změny
cd /var/www/pes.maraxa.cz
git pull

# Aktualizuj Laravel (pokud je)
cd backend
composer install --no-dev
php artisan migrate
php artisan cache:clear
php artisan config:cache
```

#### Automaticky (jednodušší):
```bash
# Připoj se
ssh tvuj_user@pes.maraxa.cz

# Spusť update skript
cd /var/www/pes.maraxa.cz
./deployment/update-from-github.sh
```

Skript za tebe:
- ✅ Stáhne změny z GitHub
- ✅ Aktualizuje Composer
- ✅ Spustí migrace (pokud chceš)
- ✅ Vyčistí cache
- ✅ Restartuje Apache (pokud chceš)

---

## 🎯 Praktický příklad

### Scénář: Přidáš novou funkci pro psy

**1. Na PC - Vytvoříš controller:**
```powershell
# Vytvoříš soubor: backend/app/Http/Controllers/DogController.php
# Upravíš routes...
# Uložíš změny

# Nahraješ na GitHub
.\push-to-github.ps1 "Přidán DogController"
```

**2. Na serveru - Aktualizuješ:**
```bash
ssh tvuj_user@pes.maraxa.cz
cd /var/www/pes.maraxa.cz
./deployment/update-from-github.sh
```

**3. Otevřeš prohlížeč:**
```
https://pes.maraxa.cz
```

✅ **Hotovo! Změny jsou live!**

---

## 📁 Co dát/nedávat na GitHub?

### ✅ DAT na GitHub:
- Všechny `.php` soubory
- Všechny `.js`, `.jsx`, `.ts`, `.tsx` soubory
- Migrace databáze
- Dokumentace `.md`
- Konfigurační `.json`, `.yaml`
- Skripty `.sh`, `.ps1`

### ❌ NEDÁVAT na GitHub:
- `.env` soubor (hesla!)
- `node_modules/` složka
- `vendor/` složka
- Nahrané obrázky uživatelů
- Databázové backupy
- Log soubory

**Tyto jsou už v `.gitignore`, takže se automaticky ignorují.**

---

## 🔐 Bezpečnost .env souboru

`.env` obsahuje hesla a **NESMÍ** být na GitHubu!

### Jak to funguje:

**Na PC:**
```
D:\github\evidence_psu\backend\.env  ← Lokální hesla (NEdává se na Git)
```

**Na serveru:**
```
/var/www/pes.maraxa.cz/backend/.env  ← Produkční hesla (NEdává se na Git)
```

**Na GitHubu:**
```
backend.env.example  ← Šablona bez hesel (DÁ se na Git)
```

### První nastavení .env na serveru:
```bash
# Na serveru:
cd /var/www/pes.maraxa.cz/backend
cp ../backend.env.example .env
nano .env  # Upravíš hesla
php artisan key:generate
```

Pak už `.env` necháváš na serveru a **nikdy** ho nedáváš na GitHub!

---

## 🚨 Co když .env omylem nahraješ?

```bash
# Na PC - OKAMŽITĚ smaž z Git:
git rm --cached backend/.env
git commit -m "Remove .env from git"
git push

# A ZMĚŇ všechna hesla v .env!
```

---

## 🛠️ Užitečné příkazy

### Zobrazit změny před pushem:
```powershell
git status
git diff
```

### Vrátit změny (před commitem):
```powershell
git checkout -- soubor.php
```

### Vrátit poslední commit (lokálně):
```powershell
git reset --soft HEAD~1
```

### Zobrazit historii:
```powershell
git log --oneline
```

### Nastavit Git jméno/email:
```powershell
git config --global user.name "Tvoje Jmeno"
git config --global user.email "tvuj@email.cz"
```

---

## 📊 Výhody tohoto workflow

✅ **Verzování** - Každá změna je uložená  
✅ **Backup** - GitHub = záloha kódu  
✅ **Historie** - Můžeš se vrátit k staré verzi  
✅ **Bezpečnost** - .env není na GitHubu  
✅ **Jednoduchý deployment** - Jeden příkaz  
✅ **Týmová práce** - Můžete být víc lidí  

---

## 🎯 Shrnutí

### Každý den:

**Na PC:**
```powershell
# Udělej změny...
.\push-to-github.ps1 "Popis změny"
```

**Na serveru:**
```bash
ssh tvuj_user@pes.maraxa.cz
cd /var/www/pes.maraxa.cz
./deployment/update-from-github.sh
```

**To je vše! 🎉**

---

## 📞 Další kroky

1. ✅ Nahraj projekt na GitHub (první nastavení)
2. ✅ Naklonuj na server
3. ✅ Používaj skripty pro update
4. ✅ Nikdy nenahrávej .env na GitHub

---

**GitHub je nejlepší způsob! Jednoduchý, bezpečný, profesionální. 🚀**
