# ⚠️ BEZPEČNOSTNÍ UPOZORNĚNÍ

## 🔐 Databázové heslo je veřejné!

Heslo `aKokotik123` bylo sdíleno v tomto chatu a je tedy **veřejně dostupné**.

### ✅ Doporučené kroky:

1. **ZMĚŇ HESLO** v administraci Webglobe HNED!
   
2. **V administraci Webglobe:**
   - Přihlas se do správy databází
   - Najdi databázi `maraxacz_pes`
   - Změň heslo uživatele `maraxacz_pes`
   - Použij silné heslo (min. 16 znaků, kombinace písmen, číslic, symbolů)

3. **Aktualizuj .env na serveru:**
   ```bash
   # Na VPS edituj soubor
   nano /var/www/pes.maraxa.cz/backend/.env
   
   # Změň řádek:
   DB_PASSWORD=tvoje_nove_silne_heslo
   
   # Ulož a restartuj
   php artisan config:clear
   ```

4. **Nikdy nesdílej .env soubor:**
   - `.env` obsahuje citlivé údaje
   - Je již v `.gitignore`
   - Nikdy ho nenahávej na GitHub
   - Nesdílej ho v chatech ani emailech

---

## 🔒 Generování silného hesla

### Online generátor:
- https://passwordsgenerator.net/
- Nastav: 20+ znaků, velká/malá písmena, čísla, symboly

### V terminálu (Linux/Mac):
```bash
openssl rand -base64 32
```

### V PowerShell (Windows):
```powershell
Add-Type -AssemblyName System.Web
[System.Web.Security.Membership]::GeneratePassword(20,5)
```

---

## 📋 Checklist bezpečnosti

- [ ] Změněno databázové heslo
- [ ] `.env` má oprávnění 600 (pouze vlastník může číst)
- [ ] `.env` není na GitHubu
- [ ] `APP_DEBUG=false` v produkci
- [ ] `APP_ENV=production` v produkci
- [ ] Silné heslo (min. 16 znaků)
- [ ] Heslo nikde nesdíleno

---

## 🚨 Co dělat při kompromitaci

Pokud si myslíš, že někdo získal přístup k databázi:

1. **Okamžitě změň heslo**
2. **Zkontroluj databázi** na neobvyklé záznamy
3. **Zkontroluj logy** serveru
4. **Zvaž vytvoření nové databáze** s novými přístupy
5. **Informuj Webglobe support** pokud je podezření na narušení

---

## ✅ Bezpečná hesla pro budoucnost

### Pro databázi:
```
Př: mK9#xL2$pQ7@nF5&wR8*vT3!bN6^
```

### Pro API tokeny:
```
Př: sk_live_51M2p3Q4r5S6t7U8v9W0x1Y2z3A4b5C6
```

### Pro admin účty:
```
Př: Pj$8mN#2qL@9wK!5xR&7tF*3vB^
```

---

**Změň heslo HNED po přečtení tohoto dokumentu!** 🔒
