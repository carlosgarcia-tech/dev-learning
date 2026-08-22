#!/usr/bin/env bash
# test.sh — Ejercicio 06: Fragmentos avanzados
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCHEMA="$DIR/schema.graphql"
QUERY="$DIR/query.graphql"
VARS="$DIR/variables.json"
EXPECTED="$DIR/expected.json"
PASS=0
FAIL=0

ok()   { echo "  ✓ $1"; PASS=$((PASS+1)); }
fail() { echo "  ✗ $1"; FAIL=$((FAIL+1)); }

echo "Ejercicio 06 — Fragmentos avanzados"

# 1. interface Entity definida
if grep -qE 'interface[[:space:]]+Entity[[:space:]]*\{' "$SCHEMA"; then
  ok "interface Entity definida"
else
  fail "interface Entity no definida"
fi

# 2. User y Post implementan Entity
if grep -qE 'type[[:space:]]+User[[:space:]]+implements[[:space:]]+Entity' "$SCHEMA"; then
  ok "User implements Entity"
else
  fail "User no implements Entity"
fi

# 3. Variables declaradas
if grep -qE '\$withEmail:[[:space:]]*Boolean!' "$QUERY"; then
  ok "variable \$withEmail declarada"
else
  fail "variable \$withEmail no declarada"
fi

if grep -qE '\$skipPosts:[[:space:]]*Boolean!' "$QUERY"; then
  ok "variable \$skipPosts declarada"
else
  fail "variable \$skipPosts no declarada"
fi

# 4. @include(if: $withEmail)
if grep -qE '@include[[:space:]]*\([[:space:]]*if:[[:space:]]*\$withEmail' "$QUERY"; then
  ok "@include(if: \$withEmail) presente"
else
  fail "@include(if: \$withEmail) no encontrado"
fi

# 5. @skip(if: $skipPosts)
if grep -qE '@skip[[:space:]]*\([[:space:]]*if:[[:space:]]*\$skipPosts' "$QUERY"; then
  ok "@skip(if: \$skipPosts) presente"
else
  fail "@skip(if: \$skipPosts) no encontrado"
fi

# 6. Fragment EntityFields on Entity
if grep -qE 'fragment[[:space:]]+EntityFields[[:space:]]+on[[:space:]]+Entity' "$QUERY"; then
  ok "fragment EntityFields on Entity definido"
else
  fail "fragment EntityFields no definido"
fi

# 7. Inline fragments
if grep -qE '\.\.\.[[:space:]]*on[[:space:]]+User' "$QUERY" && grep -qE '\.\.\.[[:space:]]*on[[:space:]]+Post' "$QUERY"; then
  ok "inline fragments on User y Post presentes"
else
  fail "inline fragments no encontrados"
fi

# 8. variables.json válido
if [[ -f "$VARS" ]] && command -v python3 >/dev/null 2>&1; then
  if python3 -c "
import json
v = json.load(open('$VARS'))
assert 'withEmail' in v and 'skipPosts' in v and 'id' in v
" 2>/dev/null; then
    ok "variables.json tiene id, withEmail, skipPosts"
  else
    fail "variables.json no tiene las variables esperadas"
  fi
else
  ok "variables.json existe (o python3 no disponible)"
fi

# 9. expected.json
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
