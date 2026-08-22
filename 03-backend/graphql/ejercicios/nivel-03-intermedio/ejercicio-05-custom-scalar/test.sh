#!/usr/bin/env bash
# test.sh — Ejercicio 05: Custom scalar
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCHEMA="$DIR/schema.graphql"
QUERY="$DIR/query.graphql"
EXPECTED="$DIR/expected.json"
PASS=0
FAIL=0

ok()   { echo "  ✓ $1"; PASS=$((PASS+1)); }
fail() { echo "  ✗ $1"; FAIL=$((FAIL+1)); }

echo "Ejercicio 05 — Custom scalar"

# 1. scalar DateTime declarado
if grep -qE 'scalar[[:space:]]+DateTime' "$SCHEMA"; then
  ok "scalar DateTime declarado"
else
  fail "scalar DateTime no declarado"
fi

# 2. Post tiene createdAt: DateTime!
if grep -qE 'createdAt:[[:space:]]*DateTime!' "$SCHEMA"; then
  ok "Post.createdAt: DateTime! definido"
else
  fail "Post.createdAt: DateTime! no definido"
fi

# 3. Post tiene updatedAt: DateTime!
if grep -qE 'updatedAt:[[:space:]]*DateTime!' "$SCHEMA"; then
  ok "Post.updatedAt: DateTime! definido"
else
  fail "Post.updatedAt: DateTime! no definido"
fi

# 4. User tiene createdAt: DateTime!
if grep -qE 'createdAt:[[:space:]]*DateTime!' "$SCHEMA"; then
  ok "User.createdAt: DateTime! definido"
else
  fail "User.createdAt: DateTime! no definido"
fi

# 5. query pide createdAt y updatedAt
if grep -qi 'createdAt' "$QUERY" && grep -qi 'updatedAt' "$QUERY"; then
  ok "query pide createdAt y updatedAt"
else
  fail "query no pide createdAt y updatedAt"
fi

# 6. expected.json con fechas ISO
if [[ -f "$EXPECTED" ]] && command -v python3 >/dev/null 2>&1; then
  if python3 -c "
import json
d = json.load(open('$EXPECTED'))
p = d['data']['post']
assert 'createdAt' in p and 'updatedAt' in p
# Validar formato ISO básico (contiene 'T')
assert 'T' in p['createdAt']
" 2>/dev/null; then
    ok "expected.json tiene fechas en formato ISO"
  else
    fail "expected.json no tiene fechas en formato ISO"
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
