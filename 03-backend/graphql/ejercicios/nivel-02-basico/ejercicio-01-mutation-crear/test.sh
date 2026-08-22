#!/usr/bin/env bash
# test.sh — Ejercicio 01: Mutation para crear
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCHEMA="$DIR/schema.graphql"
QUERY="$DIR/query.graphql"
EXPECTED="$DIR/expected.json"
PASS=0
FAIL=0

ok()   { echo "  ✓ $1"; PASS=$((PASS+1)); }
fail() { echo "  ✗ $1"; FAIL=$((FAIL+1)); }

echo "Ejercicio 01 — Mutation para crear"

# 1. input CreateUserInput definido
if grep -qE 'input[[:space:]]+CreateUserInput[[:space:]]*\{' "$SCHEMA"; then
  ok "input CreateUserInput definido"
else
  fail "input CreateUserInput no definido"
fi

# 2. input tiene name y email non-null
if grep -qE 'name:[[:space:]]*String!' "$SCHEMA" && grep -qE 'email:[[:space:]]*String!' "$SCHEMA"; then
  ok "input tiene name: String! y email: String!"
else
  fail "input no tiene name: String! y email: String!"
fi

# 3. type Mutation definido
if grep -qE 'type[[:space:]]+Mutation[[:space:]]*\{' "$SCHEMA"; then
  ok "type Mutation definido"
else
  fail "type Mutation no definido"
fi

# 4. createUser(input: CreateUserInput!): User!
if grep -qE 'createUser[[:space:]]*\([[:space:]]*input:[[:space:]]*CreateUserInput![[:space:]]*\)[[:space:]]*:[[:space:]]*User!' "$SCHEMA"; then
  ok "createUser(input: CreateUserInput!): User! definido"
else
  fail "createUser no está bien definido"
fi

# 5. query es una mutation
if grep -qE '^[[:space:]]*mutation' "$QUERY"; then
  ok "query declarada como mutation"
else
  fail "no se declaró como mutation"
fi

# 6. mutation usa createUser con input
if grep -qE 'createUser[[:space:]]*\([[:space:]]*input:' "$QUERY"; then
  ok "mutation llama a createUser con input"
else
  fail "mutation no llama a createUser con input"
fi

# 7. Selecciona id, name, email
if grep -qi '\bid\b' "$QUERY" && grep -qi '\bname\b' "$QUERY" && grep -qi '\bemail\b' "$QUERY"; then
  ok "mutation selecciona id, name, email"
else
  fail "mutation no selecciona id, name, email"
fi

# 8. expected.json válido con createUser
if [[ -f "$EXPECTED" ]] && command -v python3 >/dev/null 2>&1; then
  if python3 -c "
import json
d = json.load(open('$EXPECTED'))
assert 'createUser' in d['data']
assert 'id' in d['data']['createUser']
" 2>/dev/null; then
    ok "expected.json tiene createUser con id"
  else
    fail "expected.json no tiene createUser con id"
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
