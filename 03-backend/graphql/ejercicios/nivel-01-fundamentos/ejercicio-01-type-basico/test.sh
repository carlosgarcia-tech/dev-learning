#!/usr/bin/env bash
# test.sh — Ejercicio 01: Definir un type básico
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCHEMA="$DIR/schema.graphql"
QUERY="$DIR/query.graphql"
EXPECTED="$DIR/expected.json"
PASS=0
FAIL=0

ok()   { echo "  ✓ $1"; PASS=$((PASS+1)); }
fail() { echo "  ✗ $1"; FAIL=$((FAIL+1)); }

echo "Ejercicio 01 — Definir un type básico"

# 1. schema.graphql existe
if [[ -f "$SCHEMA" ]]; then ok "schema.graphql existe"; else fail "schema.graphql no existe"; fi

# 2. type User definido
if grep -qE 'type[[:space:]]+User[[:space:]]*\{' "$SCHEMA"; then
  ok "type User definido"
else
  fail "type User no definido"
fi

# 3. type Query definido
if grep -qE 'type[[:space:]]+Query[[:space:]]*\{' "$SCHEMA"; then
  ok "type Query definido"
else
  fail "type Query no definido"
fi

# 4. campo id: ID!
if grep -qE 'id:[[:space:]]*ID!' "$SCHEMA"; then
  ok "campo id: ID! presente"
else
  fail "campo id: ID! no encontrado"
fi

# 5. campo name: String!
if grep -qE 'name:[[:space:]]*String!' "$SCHEMA"; then
  ok "campo name: String! presente"
else
  fail "campo name: String! no encontrado"
fi

# 6. campo email: String (nullable, sin !)
if grep -qE 'email:[[:space:]]*String([^!]|$)' "$SCHEMA"; then
  ok "campo email: String (nullable)"
else
  fail "campo email: String (nullable) no encontrado"
fi

# 7. campo age: Int
if grep -qE 'age:[[:space:]]*Int([^!]|$)' "$SCHEMA"; then
  ok "campo age: Int presente"
else
  fail "campo age: Int no encontrado"
fi

# 8. me: User!
if grep -qE 'me:[[:space:]]*User!' "$SCHEMA"; then
  ok "Query.me: User! presente"
else
  fail "Query.me: User! no encontrado"
fi

# 9. query.graphql pide id, name, email
if [[ -f "$QUERY" ]]; then
  ok "query.graphql existe"
  grep -qi 'id'    "$QUERY" && ok "query pide id"    || fail "query no pide id"
  grep -qi 'name'  "$QUERY" && ok "query pide name"  || fail "query no pide name"
  grep -qi 'email' "$QUERY" && ok "query pide email" || fail "query no pide email"
else
  fail "query.graphql no existe"
fi

# 10. expected.json válido
if [[ -f "$EXPECTED" ]]; then
  if command -v python3 >/dev/null 2>&1; then
    if python3 -c "import json,sys; json.load(open('$EXPECTED'))" 2>/dev/null; then
      ok "expected.json es JSON válido"
    else
      fail "expected.json no es JSON válido"
    fi
  else
    ok "expected.json existe (python3 no disponible, skip validación JSON)"
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
