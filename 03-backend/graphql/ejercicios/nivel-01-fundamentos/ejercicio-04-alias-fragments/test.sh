#!/usr/bin/env bash
# test.sh — Ejercicio 04: Alias y fragments
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
QUERY="$DIR/query.graphql"
EXPECTED="$DIR/expected.json"
PASS=0
FAIL=0

ok()   { echo "  ✓ $1"; PASS=$((PASS+1)); }
fail() { echo "  ✗ $1"; FAIL=$((FAIL+1)); }

echo "Ejercicio 04 — Alias y fragments"

# 1. Fragment UserFields definido
if grep -qE 'fragment[[:space:]]+UserFields[[:space:]]+on[[:space:]]+User' "$QUERY"; then
  ok "fragment UserFields on User definido"
else
  fail "fragment UserFields on User no definido"
fi

# 2. Fragment incluye id, name, email
FRAG_OK=1
awk '/fragment[[:space:]]+UserFields[[:space:]]+on[[:space:]]+User[[:space:]]*\{/,/\}/' "$QUERY" > /tmp/frag04.txt 2>/dev/null || true
grep -qi '\bid\b'   /tmp/frag04.txt || FRAG_OK=0
grep -qi '\bname\b' /tmp/frag04.txt || FRAG_OK=0
grep -qi '\bemail\b'/tmp/frag04.txt || FRAG_OK=0
if [[ $FRAG_OK -eq 1 ]]; then
  ok "fragment incluye id, name, email"
else
  fail "fragment no incluye id, name, email"
fi

# 3. Alias admin
if grep -qE 'admin:[[:space:]]*user' "$QUERY"; then
  ok "alias admin: user(...) presente"
else
  fail "alias admin no encontrado"
fi

# 4. Alias editor
if grep -qE 'editor:[[:space:]]*user' "$QUERY"; then
  ok "alias editor: user(...) presente"
else
  fail "alias editor no encontrado"
fi

# 5. Se usa ...UserFields al menos dos veces
COUNT=$(grep -c '\.\.\.UserFields' "$QUERY" || true)
if [[ $COUNT -ge 2 ]]; then
  ok "...UserFields aplicado $COUNT veces"
else
  fail "...UserFields aplicado solo $COUNT veces (necesitas 2)"
fi

# 6. expected.json con admin y editor
if [[ -f "$EXPECTED" ]] && command -v python3 >/dev/null 2>&1; then
  if python3 -c "
import json
d = json.load(open('$EXPECTED'))
assert 'admin' in d['data']
assert 'editor' in d['data']
" 2>/dev/null; then
    ok "expected.json tiene admin y editor"
  else
    fail "expected.json no tiene admin y editor"
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
