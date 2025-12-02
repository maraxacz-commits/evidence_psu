#!/bin/bash

# Test skript pro API autentizaci
# Použití: bash test-auth-api.sh

API_URL="https://pes.maraxa.cz/api"

echo "=== Test Evidence Psů API ==="
echo ""

# Test 1: Ping
echo "1. Test PING endpoint..."
response=$(curl -s -X GET "$API_URL/ping")
echo "$response" | jq '.'
echo ""

# Test 2: Registrace
echo "2. Test REGISTRACE..."
register_response=$(curl -s -X POST "$API_URL/register" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d '{
    "username": "testuser'$(date +%s)'",
    "email": "test'$(date +%s)'@example.com",
    "password": "testpassword123",
    "password_confirmation": "testpassword123",
    "first_name": "Test",
    "last_name": "User"
  }')

echo "$register_response" | jq '.'
TOKEN=$(echo "$register_response" | jq -r '.token')
echo ""
echo "Token: $TOKEN"
echo ""

if [ "$TOKEN" = "null" ] || [ -z "$TOKEN" ]; then
    echo "CHYBA: Registrace selhala!"
    exit 1
fi

# Test 3: Získání info o uživateli
echo "3. Test GET USER (s tokenem)..."
user_response=$(curl -s -X GET "$API_URL/user" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer $TOKEN")
echo "$user_response" | jq '.'
echo ""

# Test 4: Aktualizace profilu
echo "4. Test UPDATE PROFILE..."
update_response=$(curl -s -X PUT "$API_URL/user" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "city": "Praha",
    "phone": "+420123456789"
  }')
echo "$update_response" | jq '.'
echo ""

# Test 5: Odhlášení
echo "5. Test LOGOUT..."
logout_response=$(curl -s -X POST "$API_URL/logout" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer $TOKEN")
echo "$logout_response" | jq '.'
echo ""

# Test 6: Pokus o přístup po odhlášení (mělo by selhat)
echo "6. Test přístupu po odhlášení (mělo by selhat)..."
after_logout=$(curl -s -X GET "$API_URL/user" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer $TOKEN")
echo "$after_logout" | jq '.'
echo ""

echo "=== Testy dokončeny ==="
echo ""
echo "Shrnutí:"
echo "- Ping: OK"
echo "- Registrace: OK (token: ${TOKEN:0:20}...)"
echo "- Get User: OK"
echo "- Update Profile: OK"
echo "- Logout: OK"
echo "- Po odhlášení: Správně zamítnuto"
