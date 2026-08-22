#!/usr/bin/env bash
# test.sh — Ejercicio 02: Query simple con selección de campos
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCHEMA="$DIR/schema.graphql"
QUERY="$DIR/query.graphql"
EXPECTED="$DIR/expected.json"
PASS=0
FAIL=0

ok()   { echo "  ✓ $1"; PASS=$((PASS+1)); }
fail() { echo "  ✗ $1"; FAIL=$((FAIL+1)); }

echo "Ejercicio 02 — Query simple con selección de campos"

# 1. query.graphql existe
if [[ -f "$QUERY" ]]; then ok "query.graphql existe"; else fail "query.graphql no existe"; fi

# 2. La query usa el campo post con argumento id
if grep -qE 'post[[:space:]]*\([[:space:]]*id' "$QUERY"; then
  ok "query usa post(id: ...)"
else
  fail "query no usa post(id: ...)"
fi

# 3. Selecciona id y title del post
if grep -qi 'id'    "$QUERY" && grep -qi 'title' "$QUERY"; then
  ok "query selecciona id y title"
else
  fail "query no selecciona id y title"
fi

# 4. Selecciona author { name }
if grep -qE 'author[[:space:]]*\{' "$QUERY"; then
  ok "query anida author"
else
  fail "query no anida author"
fi

if grep -qE 'author[[:space:]]*\{[^}]*name' "$QUERY"; then
  ok "query pide name dentro de author"
else
  fail "query no pide name dentro de author"
fi

# 5. La query empieza con query
if grep -qE '^[[:space:]]*query' "$QUERY"; then
  ok "operación declarada como query"
else
  fail "no se declaró como query"
fi

# 6. expected.json válido
if [[ -f "$EXPECTED" ]]; then
  ok "expected.json existe"
  if command -v python3 >/dev/null 2>&1; then
    if python3 -c "import json; json.load(open('$EXPECTED'))" 2>/dev/null; then
      ok "expected.json es JSON válido"
      # Verifica estructura data.post.author.name
      if python3 -c "
import json
d = json.load(open('$EXPECTED'))
assert d['data']['post']['author']['name']
" 2>/dev/null; then
        ok "expected.json tiene estructura data.post.author.name"
      else
        fail "expected.json no tiene estructura data.post.author.name"
      fi
    else
      fail "expected.json no es JSON válido"
    fi
  else
    ok "expected.json existe (python3 no disponible)"
  fi
else
  fail "expected.json no existe"
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
