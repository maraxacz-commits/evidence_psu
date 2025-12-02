# 📋 Přehled souborů projektu

## 📁 Struktura projektu

```
pes-evidence/
├── 📄 README.md                  # Hlavní dokumentace projektu
├── 📄 QUICKSTART.md              # Rychlý průvodce spuštěním
├── 📄 .gitignore                 # Git ignore pravidla
├── 📄 init-project.ps1           # Windows automatizační skript
│
├── 📂 docs/                      # Dokumentace
│   ├── backend-setup.md          # Návod na nastavení Laravel backendu
│   ├── database-schema.md        # Popis databázového schématu
│   └── git-setup.md              # Návod na Git inicializaci
│
├── 📂 database/                  # SQL skripty
│   └── schema.sql                # SQL schéma pro přímé vytvoření DB
│
├── 📂 backend-migrations/        # Laravel migrace (přesunout do backend/)
│   ├── 2024_01_01_000001_create_users_table.php
│   ├── 2024_01_01_000002_create_dogs_table.php
│   ├── 2024_01_01_000003_create_user_dogs_table.php
│   ├── 2024_01_01_000004_create_pedigree_templates_table.php
│   └── 2024_01_01_000005_create_pedigree_exports_table.php
│
└── 📂 deployment/                # Deployment skripty pro VPS
    ├── init-vps.sh               # Inicializace VPS serveru
    └── deploy.sh                 # Automatický deployment z GitHubu

```

---

## 🚀 Jak začít

### Varianta A: Automaticky (doporučeno)
```powershell
# Ve složce projektu spusť:
.\init-project.ps1
```

### Varianta B: Manuálně
1. Přečti si `QUICKSTART.md`
2. Následuj `docs/git-setup.md`
3. Pak `docs/backend-setup.md`

---

## 📚 Dokumenty podle účelu

### Pro vývojáře (Windows PC)
- **QUICKSTART.md** - Začni tady!
- **init-project.ps1** - Automatický setup skript
- **docs/git-setup.md** - Návod na Git
- **docs/backend-setup.md** - Návod na Laravel

### Pro databázi
- **docs/database-schema.md** - Popis tabulek a vztahů
- **database/schema.sql** - SQL skript pro přímé vytvoření
- **backend-migrations/*.php** - Laravel migrace

### Pro VPS server
- **deployment/init-vps.sh** - První nastavení serveru
- **deployment/deploy.sh** - Aktualizace aplikace z GitHubu

---

## 🔄 Workflow

### 1. Lokální vývoj (tvůj PC)
```
┌─────────────────┐
│ Upravíš soubory │
│    v projektu   │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   git add .     │
│   git commit    │
│   git push      │
└────────┬────────┘
         │
         ▼
```

### 2. GitHub
```
┌─────────────────┐
│  GitHub Repo    │
│  (vzdálené)     │
└────────┬────────┘
         │
         ▼
```

### 3. Produkce (VPS)
```
┌─────────────────┐
│ ./deploy.sh     │
│ (stáhne z Git)  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ pes.maraxa.cz   │
│   (funguje!)    │
└─────────────────┘
```

---

## ✅ Co už máme hotové

- [x] Databázové schéma
- [x] SQL skripty
- [x] Laravel migrace
- [x] Git struktura
- [x] Deployment skripty
- [x] Dokumentace

## 🔜 Co bude následovat

- [ ] Laravel modely (User, Dog, Pedigree...)
- [ ] API Controllers
- [ ] API Routes
- [ ] Autentizace (JWT)
- [ ] React frontend
- [ ] PDF generátor rodokmenů
- [ ] Nahrávání fotek

---

## 🆘 Potřebuješ pomoc?

### Chyby při instalaci?
Zkontroluj:
- Git je nainstalován
- Composer je nainstalován
- PHP 8.4 běží
- MySQL/MariaDB běží

### Git problémy?
```powershell
git config --global user.email "tvuj@email.cz"
git config --global user.name "Tvoje Jmeno"
```

### Databázové chyby?
1. Vytvoř databázi: `CREATE DATABASE evidence_psu;`
2. Zkontroluj `.env` soubor
3. Spusť migrace: `php artisan migrate`

---

## 🎯 Další kroky

Po dokončení inicializace mi napiš a pokračujeme:
1. **Modely a vztahy** v Laravel
2. **API endpointy** pro CRUD operace
3. **React frontend** s TypeScript
4. **PDF generování** rodokmenů
5. **Autentizace** a oprávnění

---

**GitHub:** https://github.com/maraxacz-commits/evidence_psu  
**Doména:** pes.maraxa.cz  
**Verze:** 1.0.0 (initial)
