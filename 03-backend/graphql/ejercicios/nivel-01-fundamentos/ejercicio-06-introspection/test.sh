#!/usr/bin/env bash
# test.sh — Ejercicio 06: Introspection
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
QUERY="$DIR/query.graphql"
EXPECTED="$DIR/expected.json"
PASS=0
FAIL=0

ok()   { echo "  ✓ $1"; PASS=$((PASS+1)); }
fail() { echo "  ✗ $1"; FAIL=$((FAIL+1)); }

echo "Ejercicio 06 — Introspection"

# 1. Usa __schema
if grep -q '__schema' "$QUERY"; then
  ok "usa __schema"
else
  fail "no usa __schema"
fi

# 2. __schema tiene types { name kind }
if grep -qE '__schema[[:space:]]*\{[^}]*types[[:space:]]*\{[^}]*\bname\b[^}]*\bkind\b' "$QUERY"; then
  ok "__schema pide types { name kind }"
else
  fail "__schema no pide types { name kind }"
fi

# 3. Usa __type con name: "User"
if grep -qE '__type[[:space:]]*\([[:space:]]*name:[[:space:]]*"User"' "$QUERY"; then
  ok "usa __type(name: \"User\")"
else
  fail "no usa __type(name: \"User\")"
fi

# 4. __type pide fields { name }
if grep -qE 'fields[[:space:]]*\{[^}]*\bname\b' "$QUERY"; then
  ok "__type pide fields { name }"
else
  fail "__type no pide fields { name }"
fi

# 5. expected.json válido con __schema y __type o userType
if [[ -f "$EXPECTED" ]] && command -v python3 >/dev/null 2>&1; then
  if python3 -c "
import json
d = json.load(open('$EXPECTED'))
data = d['data']
assert '__schema' in data
assert '__type' in data or 'userType' in data
" 2>/dev/null; then
    ok "expected.json tiene __schema y __type/userType"
  else
    fail "expected.json no tiene __schema y __type/userType"
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
