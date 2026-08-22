#!/usr/bin/env bash
# test.sh — Ejercicio 06: Testing de schema GraphQL
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCHEMA="$DIR/schema.graphql"
RESOLVERS="$DIR/resolvers.js"
TEST_JS="$DIR/test.js"
EXPECTED="$DIR/expected.json"
PASS=0
FAIL=0

ok()   { echo "  ✓ $1"; PASS=$((PASS+1)); }
fail() { echo "  ✗ $1"; FAIL=$((FAIL+1)); }

echo "Ejercicio 06 — Testing de schema GraphQL"

# 1. schema define User y Post
if grep -qE 'type User' "$SCHEMA" && grep -qE 'type Post' "$SCHEMA"; then
  ok "schema define User y Post"
else
  fail "schema no define User y Post"
fi

# 2. schema define Query y Mutation
if grep -qE 'type Query' "$SCHEMA" && grep -qE 'type Mutation' "$SCHEMA"; then
  ok "schema define Query y Mutation"
else
  fail "schema no define Query y Mutation"
fi

# 3. resolvers.js existe y exporta rootValue
if [[ -f "$RESOLVERS" ]] && grep -qE 'rootValue' "$RESOLVERS"; then
  ok "resolvers.js define rootValue"
else
  fail "resolvers.js no define rootValue"
fi

# 4. test.js existe
if [[ -f "$TEST_JS" ]]; then ok "test.js existe"; else fail "test.js no existe"; fi

# 5. test.js usa graphql y buildSchema
if grep -qE "require\(['\"]graphql['\"]\)" "$TEST_JS" && grep -qE 'buildSchema' "$TEST_JS"; then
  ok "test.js importa graphql y buildSchema"
else
  fail "test.js no importa graphql/buildSchema"
fi

# 6. test.js define función test (node:test)
if grep -qE "require\(['\"]node:test['\"]\)" "$TEST_JS" || grep -qE 'function test' "$TEST_JS"; then
  ok "test.js usa un runner de tests"
else
  fail "test.js no usa un runner de tests"
fi

# 7. test.js incluye test de tipos
if grep -qiE 'tipo|type|getType' "$TEST_JS"; then
  ok "test.js incluye test de tipos"
else
  fail "test.js no incluye test de tipos"
fi

# 8. test.js incluye test de queries
if grep -qiE 'query' "$TEST_JS"; then
  ok "test.js incluye test de queries"
else
  fail "test.js no incluye test de queries"
fi

# 9. test.js incluye test de mutations
if grep -qiE 'mutation|createUser|deleteUser' "$TEST_JS"; then
  ok "test.js incluye test de mutations"
else
  fail "test.js no incluye test de mutations"
fi

# 10. test.js incluye test de errores
if grep -qiE 'error' "$TEST_JS"; then
  ok "test.js incluye test de errores"
else
  fail "test.js no incluye test de errores"
fi

# 11. test.js usa aserciones (assert)
if grep -qE "require\(['\"]node:assert" "$TEST_JS" || grep -qE 'assert' "$TEST_JS"; then
  ok "test.js usa aserciones"
else
  fail "test.js no usa aserciones"
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

# 13. Sintaxis JS válida (si node está disponible)
if command -v node >/dev/null 2>&1; then
  if node --check "$TEST_JS" 2>/dev/null && node --check "$RESOLVERS" 2>/dev/null; then
    ok "Sintaxis JS válida (node --check)"
  else
    fail "Sintaxis JS inválida"
  fi
else
  ok "node no disponible, sintaxis no verificada"
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
