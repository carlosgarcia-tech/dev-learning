#!/usr/bin/env bash
# test.sh — Ejercicio 05: Variables
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
QUERY="$DIR/query.graphql"
VARS="$DIR/variables.json"
EXPECTED="$DIR/expected.json"
PASS=0
FAIL=0

ok()   { echo "  ✓ $1"; PASS=$((PASS+1)); }
fail() { echo "  ✗ $1"; FAIL=$((FAIL+1)); }

echo "Ejercicio 05 — Variables"

# 1. Operación nombrada con variable
if grep -qE 'query[[:space:]]+GetUser[[:space:]]*\([[:space:]]*\$userId:[[:space:]]*ID!' "$QUERY"; then
  ok "query GetUser(\$userId: ID!) declarada"
else
  fail "query GetUser(\$userId: ID!) no declarada"
fi

# 2. Se usa $userId como argumento
if grep -qE 'user[[:space:]]*\([[:space:]]*id:[[:space:]]*\$userId' "$QUERY"; then
  ok "user(id: \$userId) usa la variable"
else
  fail "user no usa \$userId"
fi

# 3. Selecciona id, name, email
SEL_OK=1
grep -qi '\bid\b'   "$QUERY" || SEL_OK=0
grep -qi '\bname\b' "$QUERY" || SEL_OK=0
grep -qi '\bemail\b'"$QUERY" || SEL_OK=0
if [[ $SEL_OK -eq 1 ]]; then
  ok "query selecciona id, name, email"
else
  fail "query no selecciona id, name, email"
fi

# 4. variables.json existe y tiene userId
if [[ -f "$VARS" ]]; then
  ok "variables.json existe"
  if command -v python3 >/dev/null 2>&1; then
    if python3 -c "
import json
v = json.load(open('$VARS'))
assert v.get('userId') == '1'
" 2>/dev/null; then
      ok "variables.json tiene userId = '1'"
    else
      fail "variables.json no tiene userId = '1'"
    fi
  fi
else
  fail "variables.json no existe"
fi

# 5. expected.json válido
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
