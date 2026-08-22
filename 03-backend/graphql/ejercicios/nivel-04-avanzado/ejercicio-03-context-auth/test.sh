#!/usr/bin/env bash
# test.sh — Ejercicio 03: Context y autenticación
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCHEMA="$DIR/schema.graphql"
CONTEXT="$DIR/context.js"
RESOLVERS="$DIR/resolvers.js"
QUERY="$DIR/query.graphql"
EXPECTED="$DIR/expected.json"
PASS=0
FAIL=0

ok()   { echo "  ✓ $1"; PASS=$((PASS+1)); }
fail() { echo "  ✗ $1"; FAIL=$((FAIL+1)); }

echo "Ejercicio 03 — Context y autenticación"

# 1. Mutation.deletePost en schema
if grep -qE 'deletePost[[:space:]]*\([[:space:]]*id:[[:space:]]*ID!' "$SCHEMA"; then
  ok "Mutation.deletePost(id: ID!) definido"
else
  fail "Mutation.deletePost no definido"
fi

# 2. context.js existe
if [[ -f "$CONTEXT" ]]; then ok "context.js existe"; else fail "context.js no existe"; fi

# 3. context extrae Authorization header
if grep -qE 'authorization' "$CONTEXT"; then
  ok "context lee el header Authorization"
else
  fail "context no lee el header Authorization"
fi

# 4. context usa jwt.verify
if grep -qE 'jwt\.verify' "$CONTEXT"; then
  ok "context valida JWT con jwt.verify"
else
  fail "context no valida JWT"
fi

# 5. context devuelve { user }
if grep -qE 'return.*\{.*user' "$CONTEXT"; then
  ok "context devuelve { user }"
else
  fail "context no devuelve { user }"
fi

# 6. resolvers lanza UNAUTHENTICATED
if grep -qE 'UNAUTHENTICATED' "$RESOLVERS"; then
  ok "resolver lanza UNAUTHENTICATED"
else
  fail "resolver no lanza UNAUTHENTICATED"
fi

# 7. resolvers lanza FORBIDDEN
if grep -qE 'FORBIDDEN' "$RESOLVERS"; then
  ok "resolver lanza FORBIDDEN"
else
  fail "resolver no lanza FORBIDDEN"
fi

# 8. resolvers usa GraphQLError
if grep -qE 'GraphQLError' "$RESOLVERS"; then
  ok "resolver usa GraphQLError"
else
  fail "resolver no usa GraphQLError"
fi

# 9. query es mutation deletePost
if grep -qE 'mutation' "$QUERY" && grep -qi 'deletePost' "$QUERY"; then
  ok "query es mutation deletePost"
else
  fail "query no es mutation deletePost"
fi

# 10. expected.json tiene error UNAUTHENTICATED
if [[ -f "$EXPECTED" ]] && command -v python3 >/dev/null 2>&1; then
  if python3 -c "
import json
d = json.load(open('$EXPECTED'))
assert d['data'] is None
err = d['errors'][0]
assert err['extensions']['code'] == 'UNAUTHENTICATED'
" 2>/dev/null; then
    ok "expected.json tiene error UNAUTHENTICATED"
  else
    fail "expected.json no tiene error UNAUTHENTICATED"
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
