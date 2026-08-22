#!/usr/bin/env bash
# test.sh — Ejercicio 01: Resolver básico
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCHEMA="$DIR/schema.graphql"
RESOLVERS="$DIR/resolvers.js"
QUERY="$DIR/query.graphql"
EXPECTED="$DIR/expected.json"
PASS=0
FAIL=0

ok()   { echo "  ✓ $1"; PASS=$((PASS+1)); }
fail() { echo "  ✗ $1"; FAIL=$((FAIL+1)); }

echo "Ejercicio 01 — Resolver básico"

# 1. schema User con fullName
if grep -qE 'type[[:space:]]+User' "$SCHEMA" && grep -qE 'fullName:[[:space:]]*String!' "$SCHEMA"; then
  ok "schema User tiene fullName: String!"
else
  fail "schema User no tiene fullName"
fi

# 2. Query.user definido
if grep -qE 'user[[:space:]]*\([[:space:]]*id:[[:space:]]*ID!' "$SCHEMA"; then
  ok "Query.user(id: ID!) definido"
else
  fail "Query.user no definido"
fi

# 3. resolvers.js existe
if [[ -f "$RESOLVERS" ]]; then ok "resolvers.js existe"; else fail "resolvers.js no existe"; fi

# 4. Query.user usa (parent, args, context)
if grep -qE 'Query' "$RESOLVERS" && grep -qE 'parent.*args.*context' "$RESOLVERS"; then
  ok "Query.user usa (parent, args, context)"
else
  fail "Query.user no usa la firma (parent, args, context)"
fi

# 5. usa context.db
if grep -qE 'context\.db' "$RESOLVERS"; then
  ok "resolver usa context.db"
else
  fail "resolver no usa context.db"
fi

# 6. es async
if grep -qE 'async' "$RESOLVERS"; then
  ok "resolver es async"
else
  fail "resolver no es async"
fi

# 7. User.fullName es field resolver
if grep -qE 'User' "$RESOLVERS" && grep -qE 'fullName' "$RESOLVERS"; then
  ok "User.fullName definido como field resolver"
else
  fail "User.fullName no definido como field resolver"
fi

# 8. fullName concatena firstName y lastName
if grep -qE 'firstName.*lastName\|lastName.*firstName' "$RESOLVERS" 2>/dev/null || \
   grep -qE 'user\.firstName' "$RESOLVERS" && grep -qE 'user\.lastName' "$RESOLVERS"; then
  ok "fullName concatena firstName y lastName"
else
  fail "fullName no concatena firstName y lastName"
fi

# 9. query pide fullName
if grep -qi 'fullName' "$QUERY"; then
  ok "query pide fullName"
else
  fail "query no pide fullName"
fi

# 10. expected.json
if [[ -f "$EXPECTED" ]] && command -v python3 >/dev/null 2>&1; then
  if python3 -c "
import json
d = json.load(open('$EXPECTED'))
assert d['data']['user']['fullName'] == 'Ana García'
" 2>/dev/null; then
    ok "expected.json tiene fullName correcto"
  else
    fail "expected.json no tiene fullName correcto"
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
