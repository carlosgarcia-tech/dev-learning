#!/usr/bin/env bash
# test.sh — Ejercicio 05: Query cost analysis
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCHEMA="$DIR/schema.graphql"
SERVER="$DIR/server.js"
QUERY="$DIR/query.graphql"
EXPENSIVE="$DIR/expensive-query.graphql"
EXPECTED="$DIR/expected.json"
PASS=0
FAIL=0

ok()   { echo "  ✓ $1"; PASS=$((PASS+1)); }
fail() { echo "  ✗ $1"; FAIL=$((FAIL+1)); }

echo "Ejercicio 05 — Query cost analysis"

# 1. schema define la directiva @cost
if grep -qE 'directive @cost' "$SCHEMA"; then
  ok "schema define la directiva @cost"
else
  fail "schema no define la directiva @cost"
fi

# 2. @cost sobre FIELD_DEFINITION
if grep -qE 'on FIELD_DEFINITION' "$SCHEMA"; then
  ok "@cost aplica sobre FIELD_DEFINITION"
else
  fail "@cost no aplica sobre FIELD_DEFINITION"
fi

# 3. @cost usa multipliers en algún campo de lista
if grep -qE 'multipliers' "$SCHEMA"; then
  ok "schema usa multipliers en @cost"
else
  fail "schema no usa multipliers en @cost"
fi

# 4. schema define tipos User, Post y Comment
if grep -qE 'type User' "$SCHEMA" && grep -qE 'type Post' "$SCHEMA" && grep -qE 'type Comment' "$SCHEMA"; then
  ok "schema define User, Post y Comment"
else
  fail "schema no define User, Post y Comment"
fi

# 5. server.js existe
if [[ -f "$SERVER" ]]; then ok "server.js existe"; else fail "server.js no existe"; fi

# 6. server usa costAnalysis
if grep -qE 'costAnalysis' "$SERVER"; then
  ok "server usa costAnalysis"
else
  fail "server no usa costAnalysis"
fi

# 7. server define maximumCost / MAX_COST 1000
if grep -qE 'maximumCost:[[:space:]]*1000|MAX_COST[[:space:]]*=[[:space:]]*1000' "$SERVER"; then
  ok "maximumCost 1000 configurado"
else
  fail "maximumCost 1000 no configurado"
fi

# 8. server crea GraphQLError al superar el máximo
if grep -qE 'GraphQLError' "$SERVER"; then
  ok "server crea GraphQLError al superar el coste"
else
  fail "server no crea GraphQLError"
fi

# 9. server pasa costAnalysis a validationRules
if grep -qE 'validationRules' "$SERVER"; then
  ok "server añade costAnalysis a validationRules"
else
  fail "server no usa validationRules"
fi

# 10. query válida pide user con posts
if grep -qE 'user' "$QUERY" && grep -qE 'posts' "$QUERY"; then
  ok "query válida pide user con posts"
else
  fail "query válida no encontrada"
fi

# 11. expensive-query existe y pide listas grandes con limit alto
if [[ -f "$EXPENSIVE" ]]; then
  ok "expensive-query.graphql existe"
  if grep -qE 'limit:[[:space:]]*100' "$EXPENSIVE"; then
    ok "expensive-query usa limit alto (100)"
  else
    fail "expensive-query no usa limit alto"
  fi
else
  fail "expensive-query.graphql no existe"
fi

# 12. expected.json existe y es JSON válido
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
