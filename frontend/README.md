# ⚛️ React Frontend - Evidence Psů

## 📦 Co jsme vytvořili:

### Stránky:
- **/login** - Přihlášení
- **/register** - Registrace
- **/dashboard** - Hlavní dashboard (po přihlášení)

### Komponenty:
- **Navbar** - Navigace s logout
- **ProtectedRoute** - Ochrana routes
- **AuthContext** - Správa autentizace

### Funkce:
- ✅ Registrace nových uživatelů
- ✅ Přihlášení (username nebo email)
- ✅ Uchování tokenu v localStorage
- ✅ Automatické přesměrování
- ✅ Odhlášení
- ✅ Ochrana routes (přístup jen pro přihlášené)

---

## 🚀 Instalace

### 1. Zkopíruj frontend složku do projektu

```powershell
# Na PC
cd D:\github\evidence_psu

# Zkopíruj celou složku frontend\
# Měla by vypadat:
# D:\github\evidence_psu\frontend\
```

### 2. Instaluj závislosti

```powershell
cd frontend
npm install
```

Toto nainstaluje:
- React 18
- TypeScript
- React Router
- Axios
- TailwindCSS
- Vite

---

## 💻 Spuštění (lokální vývoj)

```powershell
cd frontend
npm run dev
```

Aplikace poběží na: **http://localhost:3000**

---

## 🧪 Testování

### 1. Otevři prohlížeč
```
http://localhost:3000
```

### 2. Zaregistruj se
- Klikni "Registrace"
- Vyplň formulář
- Po úspěšné registraci budeš přesměrován na Dashboard

### 3. Odhlásit se a přihlásit znovu
- Klikni "Odhlásit se" v Navbaru
- Přihlas se s username/email a heslem

---

## 🏗️ Build pro produkci

```powershell
cd frontend
npm run build
```

Toto vytvoří `dist/` složku s optimalizovanými soubory.

---

## 📂 Struktura frontendu

```
frontend/
├── src/
│   ├── components/
│   │   ├── Navbar.tsx           # Navigace
│   │   └── ProtectedRoute.tsx   # Ochrana routes
│   ├── context/
│   │   └── AuthContext.tsx      # Auth state management
│   ├── pages/
│   │   ├── Login.tsx            # Přihlášení
│   │   ├── Register.tsx         # Registrace
│   │   └── Dashboard.tsx        # Dashboard
│   ├── services/
│   │   └── api.ts               # API komunikace
│   ├── App.tsx                  # Hlavní komponenta
│   ├── main.tsx                 # Entry point
│   └── index.css                # Styles
├── package.json
├── vite.config.ts
├── tailwind.config.js
├── tsconfig.json
└── .env
```

---

## 🔧 Konfigurace

### API URL

V `.env` souboru:
```
VITE_API_URL=https://pes.maraxa.cz/api
```

Pro lokální vývoj s lokálním backendem:
```
VITE_API_URL=http://localhost:8000/api
```

---

## 🌐 Deployment na server

### Varianta A: Build a nahraj

```powershell
# 1. Build
cd frontend
npm run build

# 2. Nahraj dist/ na server do:
# /var/www/pes.maraxa.cz/frontend/dist/

# 3. Na serveru nastav Apache/Nginx aby servíroval z dist/
```

### Varianta B: Build na serveru

```bash
# Na serveru
cd /var/www/pes.maraxa.cz/frontend

# Install (první krát)
npm install

# Build
npm run build

# Dist je připravený v frontend/dist/
```

### Varianta C: Přes GitHub

```powershell
# Na PC
cd D:\github\evidence_psu
git add frontend/
git commit -m "Add React frontend"
git push
```

```bash
# Na serveru
cd /var/www/pes.maraxa.cz
git pull
cd frontend
npm install
npm run build
```

---

## ⚙️ Konfigurace Apache pro SPA

Pokud chceš servírovat React z hlavní domény:

```apache
<VirtualHost *:80>
    ServerName pes.maraxa.cz
    
    # API (Laravel backend)
    ProxyPass /api http://localhost:8000/api
    ProxyPassReverse /api http://localhost:8000/api
    
    # React Frontend
    DocumentRoot /var/www/pes.maraxa.cz/frontend/dist
    
    <Directory /var/www/pes.maraxa.cz/frontend/dist>
        Options -Indexes +FollowSymLinks
        AllowOverride All
        Require all granted
        
        # React Router fallback
        FallbackResource /index.html
    </Directory>
</VirtualHost>
```

Nebo jednodušeji - React na subdoméně:

```apache
# app.pes.maraxa.cz pro React
# pes.maraxa.cz pro API
```

---

## 🧪 Testovací scénáře

### Test 1: Registrace
1. Otevři http://localhost:3000
2. Klikni "Registrace"
3. Vyplň:
   - Username: testuser
   - Email: test@test.cz
   - Heslo: heslo12345
   - Potvrzení: heslo12345
4. Klikni "Zaregistrovat se"
5. ✅ Měl bys být na Dashboard

### Test 2: Odhlášení
1. Klikni "Odhlásit se"
2. ✅ Měl bys být na /login

### Test 3: Přihlášení
1. Na /login zadej:
   - Login: testuser (nebo test@test.cz)
   - Heslo: heslo12345
2. Klikni "Přihlásit se"
3. ✅ Měl bys být na Dashboard

### Test 4: Protected Route
1. Odhlásit se
2. Zkus otevřít http://localhost:3000/dashboard
3. ✅ Měl bys být přesměrován na /login

---

## 🔧 Řešení problémů

### Chyba: "Cannot GET /api/..."

**Příčina:** API není dostupné nebo špatná URL

**Řešení:**
1. Zkontroluj `.env`: `VITE_API_URL`
2. Zkontroluj že backend běží: `curl https://pes.maraxa.cz/api/ping`
3. Zkontroluj CORS v Laravel

### Chyba: "Network Error"

**Příčina:** CORS nebo backend neběží

**Řešení:**
```php
// Laravel: config/cors.php
'paths' => ['api/*'],
'allowed_origins' => ['*'], // Pro vývoj
'supports_credentials' => true,
```

### Token nevyprší po odhlášení

**Příčina:** localStorage není vyčištěn

**Řešení:**
- Otevři DevTools → Application → Local Storage
- Smaž `token` a `user`

---

## 📊 Co funguje

- ✅ Registrace s validací
- ✅ Login (username nebo email)
- ✅ JWT token authentication
- ✅ Automatické přesměrování
- ✅ Protected routes
- ✅ Logout
- ✅ User info v Navbaru
- ✅ Responsive design (TailwindCSS)

---

## 🔜 Co přidat příště

Po dokončení Dog API můžeme přidat:
- 📝 Formulář pro přidání psa
- 📋 Seznam psů
- 🔍 Vyhledávání
- 🌳 Vizualizace rodokmenu
- 📄 PDF export
- 📸 Upload fotek

---

## 💡 Tips

### Hot Reload
Změny v kódu se automaticky projeví v prohlížeči (Vite HMR)

### TypeScript
Všechny komponenty mají typy - pomáhá předejít chybám

### TailwindCSS
Utility-first CSS - rychlé stylování bez psaní CSS

### React DevTools
Nainstaluj rozšíření pro lepší debugging

---

**Spusť `npm run dev` a otestuj frontend! 🎉**
