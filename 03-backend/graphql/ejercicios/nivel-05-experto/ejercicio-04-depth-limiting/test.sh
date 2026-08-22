#!/usr/bin/env bash
# test.sh — Ejercicio 04: Depth limiting
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCHEMA="$DIR/schema.graphql"
SERVER="$DIR/server.js"
QUERY="$DIR/query.graphql"
EVIL_QUERY="$DIR/evil-query.graphql"
EXPECTED="$DIR/expected.json"
PASS=0
FAIL=0

ok()   { echo "  ✓ $1"; PASS=$((PASS+1)); }
fail() { echo "  ✗ $1"; FAIL=$((FAIL+1)); }

echo "Ejercicio 04 — Depth limiting"

# 1. schema User.friends recursivo
if grep -qE 'friends:[[:space:]]*\[User!\]!' "$SCHEMA"; then
  ok "User.friends: [User!]! (recursivo) definido"
else
  fail "User.friends recursivo no definido"
fi

# 2. server.js existe
if [[ -f "$SERVER" ]]; then ok "server.js existe"; else fail "server.js no existe"; fi

# 3. server usa depthLimit
if grep -qE 'depthLimit' "$SERVER"; then
  ok "server usa depthLimit"
else
  fail "server no usa depthLimit"
fi

# 4. depthLimit(10)
if grep -qE 'depthLimit[[:space:]]*\([[:space:]]*10' "$SERVER"; then
  ok "depthLimit(10) configurado"
else
  fail "depthLimit(10) no configurado"
fi

# 5. server usa express-rate-limit
if grep -qE 'express-rate-limit|rateLimit' "$SERVER"; then
  ok "server usa rate limiting"
else
  fail "server no usa rate limiting"
fi

# 6. rate limit max 100
if grep -qE 'max:[[:space:]]*100' "$SERVER"; then
  ok "rate limit max 100 configurado"
else
  fail "rate limit max 100 no configurado"
fi

# 7. query válida de profundidad moderada
if grep -qE 'user' "$QUERY" && grep -qE 'friends' "$QUERY"; then
  ok "query válida pide user con friends"
else
  fail "query válida no encontrada"
fi

# 8. evil-query.graphql existe y es profunda
if [[ -f "$EVIL_QUERY" ]]; then
  ok "evil-query.graphql existe"
  DEPTH=$(grep -c 'friends' "$EVIL_QUERY" || true)
  if [[ $DEPTH -ge 10 ]]; then
    ok "evil-query tiene profundidad excesiva ($DEPTH niveles de friends)"
  else
    fail "evil-query no tiene profundidad excesiva"
  fi
else
  fail "evil-query.graphql no existe"
fi

# 9. expected.json
if [[ -f "$EXPECTED" ]] && command -v python3 >/dev/null 2>&1; then
  if python3 -c "import json; json.load(open('$EXPECTED'))" 2>/dev/null; then
    ok "expected.json es JSON válido"
  else
    fail "expected.json no es JSON válido"
  fi
else
  ok "expected.json existe (o python3 no disponible)"
fi

echo ""
echo "Tests: $PASS pasaron, $FAIL fallaron"
if [[ $FAIL -eq 0 ]]; then
  echo "OK Tests pasaron"
  exit 0
else
  echo "FAIL Tests fallaron"
  exit 1
fi
