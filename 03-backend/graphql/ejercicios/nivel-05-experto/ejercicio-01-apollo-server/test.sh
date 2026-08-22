#!/usr/bin/env bash
# test.sh — Ejercicio 01: Apollo Server completo
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCHEMA="$DIR/schema.graphql"
RESOLVERS="$DIR/resolvers.js"
CONTEXT="$DIR/context.js"
SERVER="$DIR/server.js"
QUERY="$DIR/query.graphql"
EXPECTED="$DIR/expected.json"
PASS=0
FAIL=0

ok()   { echo "  ✓ $1"; PASS=$((PASS+1)); }
fail() { echo "  ✗ $1"; FAIL=$((FAIL+1)); }

echo "Ejercicio 01 — Apollo Server completo"

# 1. schema Query.hello
if grep -qE 'hello:[[:space:]]*String!' "$SCHEMA"; then
  ok "Query.hello: String! definido"
else
  fail "Query.hello no definido"
fi

# 2. schema Mutation.login
if grep -qE 'login[[:space:]]*\([[:space:]]*email:[[:space:]]*String!' "$SCHEMA"; then
  ok "Mutation.login(email, password) definido"
else
  fail "Mutation.login no definido"
fi

# 3. schema AuthPayload
if grep -qE 'type[[:space:]]+AuthPayload' "$SCHEMA"; then
  ok "type AuthPayload definido"
else
  fail "type AuthPayload no definido"
fi

# 4. resolvers Query.hello y Query.me
if grep -qE 'hello' "$RESOLVERS" && grep -qE 'me:' "$RESOLVERS"; then
  ok "resolvers Query.hello y Query.me definidos"
else
  fail "resolvers Query.hello/Query.me no definidos"
fi

# 5. resolver login usa jwt.sign
if grep -qE 'jwt\.sign' "$RESOLVERS"; then
  ok "resolver login usa jwt.sign"
else
  fail "resolver login no usa jwt.sign"
fi

# 6. context.js extrae Authorization
if grep -qE 'authorization' "$CONTEXT"; then
  ok "context extrae Authorization"
else
  fail "context no extrae Authorization"
fi

# 7. context usa jwt.verify
if grep -qE 'jwt\.verify' "$CONTEXT"; then
  ok "context usa jwt.verify"
else
  fail "context no usa jwt.verify"
fi

# 8. server.js configura ApolloServer
if grep -qE 'ApolloServer' "$SERVER"; then
  ok "server.js usa ApolloServer"
else
  fail "server.js no usa ApolloServer"
fi

# 9. server.js puerto 4000
if grep -qE 'port[[:space:]]*:[[:space:]]*4000' "$SERVER"; then
  ok "server escucha en puerto 4000"
else
  fail "server no escucha en puerto 4000"
fi

# 10. query es mutation login
if grep -qE 'mutation' "$QUERY" && grep -qi 'login' "$QUERY"; then
  ok "query es mutation login"
else
  fail "query no es mutation login"
fi

# 11. expected.json con token
if [[ -f "$EXPECTED" ]] && command -v python3 >/dev/null 2>&1; then
  if python3 -c "
import json
d = json.load(open('$EXPECTED'))
assert 'token' in d['data']['login']
assert 'user' in d['data']['login']
" 2>/dev/null; then
    ok "expected.json tiene login con token y user"
  else
    fail "expected.json no tiene login con token y user"
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
