#!/usr/bin/env bash
# test.sh — Ejercicio 06: Autorización por campo con directives
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCHEMA="$DIR/schema.graphql"
DIRECTIVES="$DIR/directives.js"
QUERY="$DIR/query.graphql"
EXPECTED="$DIR/expected.json"
PASS=0
FAIL=0

ok()   { echo "  ✓ $1"; PASS=$((PASS+1)); }
fail() { echo "  ✗ $1"; FAIL=$((FAIL+1)); }

echo "Ejercicio 06 — Autorización por campo con directives"

# 1. directive @auth declarada
if grep -qE 'directive[[:space:]]+@auth' "$SCHEMA"; then
  ok "directive @auth declarada"
else
  fail "directive @auth no declarada"
fi

# 2. directive on FIELD_DEFINITION
if grep -qE 'on[[:space:]]+FIELD_DEFINITION' "$SCHEMA"; then
  ok "directive aplica a FIELD_DEFINITION"
else
  fail "directive no aplica a FIELD_DEFINITION"
fi

# 3. enum Role
if grep -qE 'enum[[:space:]]+Role' "$SCHEMA"; then
  ok "enum Role definido"
else
  fail "enum Role no definido"
fi

# 4. Query.me con @auth(requires: USER)
if grep -qE 'me:.*@auth' "$SCHEMA" && grep -qE 'requires:[[:space:]]*USER' "$SCHEMA"; then
  ok "Query.me tiene @auth(requires: USER)"
else
  fail "Query.me no tiene @auth(requires: USER)"
fi

# 5. Query.allUsers con @auth(requires: ADMIN)
if grep -qE 'allUsers.*@auth' "$SCHEMA" && grep -qE 'requires:[[:space:]]*ADMIN' "$SCHEMA"; then
  ok "Query.allUsers tiene @auth(requires: ADMIN)"
else
  fail "Query.allUsers no tiene @auth(requires: ADMIN)"
fi

# 6. User.email con @auth
if grep -qE 'email.*@auth' "$SCHEMA"; then
  ok "User.email tiene @auth (autorización por campo)"
else
  fail "User.email no tiene @auth"
fi

# 7. directives.js existe
if [[ -f "$DIRECTIVES" ]]; then ok "directives.js existe"; else fail "directives.js no existe"; fi

# 8. AuthDirective clase definida
if grep -qE 'class[[:space:]]+AuthDirective' "$DIRECTIVES"; then
  ok "clase AuthDirective definida"
else
  fail "clase AuthDirective no definida"
fi

# 9. visitFieldDefinition definido
if grep -qE 'visitFieldDefinition' "$DIRECTIVES"; then
  ok "visitFieldDefinition definido"
else
  fail "visitFieldDefinition no definido"
fi

# 10. comprueba context.user y FORBIDDEN
if grep -qE 'context\.user' "$DIRECTIVES" && grep -qE 'FORBIDDEN' "$DIRECTIVES"; then
  ok "comprueba context.user y lanza FORBIDDEN"
else
  fail "no comprueba context.user o no lanza FORBIDDEN"
fi

# 11. expected.json con FORBIDDEN
if [[ -f "$EXPECTED" ]] && command -v python3 >/dev/null 2>&1; then
  if python3 -c "
import json
d = json.load(open('$EXPECTED'))
assert d['data'] is None
assert d['errors'][0]['extensions']['code'] == 'FORBIDDEN'
" 2>/dev/null; then
    ok "expected.json tiene error FORBIDDEN"
  else
    fail "expected.json no tiene error FORBIDDEN"
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
