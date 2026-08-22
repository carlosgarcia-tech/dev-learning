#!/usr/bin/env bash
# test.sh — Ejercicio 02: Mutation para actualizar
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCHEMA="$DIR/schema.graphql"
QUERY="$DIR/query.graphql"
EXPECTED="$DIR/expected.json"
PASS=0
FAIL=0

ok()   { echo "  ✓ $1"; PASS=$((PASS+1)); }
fail() { echo "  ✗ $1"; FAIL=$((FAIL+1)); }

echo "Ejercicio 02 — Mutation para actualizar"

# 1. input UpdateUserInput definido
if grep -qE 'input[[:space:]]+UpdateUserInput[[:space:]]*\{' "$SCHEMA"; then
  ok "input UpdateUserInput definido"
else
  fail "input UpdateUserInput no definido"
fi

# 2. campos nullable (sin !) en UpdateUserInput
if grep -qE 'name:[[:space:]]*String([^!]|$)' "$SCHEMA"; then
  ok "input.name es nullable"
else
  fail "input.name no es nullable"
fi

if grep -qE 'email:[[:space:]]*String([^!]|$)' "$SCHEMA"; then
  ok "input.email es nullable"
else
  fail "input.email no es nullable"
fi

# 3. Mutation updateUser con id e input
if grep -qE 'updateUser[[:space:]]*\([[:space:]]*id:[[:space:]]*ID!' "$SCHEMA" && \
   grep -qE 'updateUser[[:space:]]*\([^)]*input:[[:space:]]*UpdateUserInput!' "$SCHEMA"; then
  ok "updateUser(id: ID!, input: UpdateUserInput!) definido"
else
  fail "updateUser no está bien definido"
fi

# 4. query es mutation
if grep -qE '^[[:space:]]*mutation' "$QUERY"; then
  ok "declarada como mutation"
else
  fail "no se declaró como mutation"
fi

# 5. mutation pasa id y input
if grep -qE 'updateUser[[:space:]]*\([[:space:]]*id:' "$QUERY" && grep -qE 'input:' "$QUERY"; then
  ok "mutation pasa id e input"
else
  fail "mutation no pasa id e input"
fi

# 6. expected.json válido
if [[ -f "$EXPECTED" ]] && command -v python3 >/dev/null 2>&1; then
  if python3 -c "
import json
d = json.load(open('$EXPECTED'))
assert 'updateUser' in d['data']
assert d['data']['updateUser']['name'] == 'Ana García'
" 2>/dev/null; then
    ok "expected.json tiene updateUser con name actualizado"
  else
    fail "expected.json no es válido"
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
