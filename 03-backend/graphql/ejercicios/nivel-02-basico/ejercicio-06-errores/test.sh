#!/usr/bin/env bash
# test.sh — Ejercicio 06: Errores en GraphQL
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCHEMA="$DIR/schema.graphql"
QUERY="$DIR/query.graphql"
EXPECTED="$DIR/expected.json"
PASS=0
FAIL=0

ok()   { echo "  ✓ $1"; PASS=$((PASS+1)); }
fail() { echo "  ✗ $1"; FAIL=$((FAIL+1)); }

echo "Ejercicio 06 — Errores en GraphQL"

# 1. schema define user(id: ID!): User (nullable)
if grep -qE 'user[[:space:]]*\([[:space:]]*id:[[:space:]]*ID![[:space:]]*\)[[:space:]]*:[[:space:]]*User([^!]|$)' "$SCHEMA"; then
  ok "user(id: ID!): User definido como nullable"
else
  fail "user(id: ID!): User nullable no encontrado"
fi

# 2. query.graphql existe y pide user
if [[ -f "$QUERY" ]] && grep -qi 'user' "$QUERY"; then
  ok "query.graphql pide user"
else
  fail "query.graphql no pide user"
fi

# 3. expected.json válido y con estructura de error
if [[ -f "$EXPECTED" ]] && command -v python3 >/dev/null 2>&1; then
  if python3 -c "
import json
d = json.load(open('$EXPECTED'))
assert d.get('data') is None
assert isinstance(d.get('errors'), list) and len(d['errors']) >= 1
err = d['errors'][0]
assert 'message' in err
assert 'path' in err
assert 'extensions' in err and 'code' in err['extensions']
" 2>/dev/null; then
    ok "expected.json tiene data:null, errors con message, path y extensions.code"
    CODE=$(python3 -c "import json; print(json.load(open('$EXPECTED'))['errors'][0]['extensions']['code'])" 2>/dev/null || echo "")
    if [[ -n "$CODE" ]]; then
      ok "extensions.code = $CODE"
    else
      fail "extensions.code vacío"
    fi
  else
    fail "expected.json no tiene estructura de error válida"
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
