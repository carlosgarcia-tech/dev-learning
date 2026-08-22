#!/usr/bin/env bash
# test.sh — Ejercicio 05: Query complexity y depth limiting
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCHEMA="$DIR/schema.graphql"
SERVER="$DIR/server.js"
QUERY="$DIR/query.graphql"
EXPECTED="$DIR/expected.json"
PASS=0
FAIL=0

ok()   { echo "  ✓ $1"; PASS=$((PASS+1)); }
fail() { echo "  ✗ $1"; FAIL=$((FAIL+1)); }

echo "Ejercicio 05 — Query complexity y depth limiting"

# 1. directive @complexity declarada
if grep -qE 'directive[[:space:]]+@complexity' "$SCHEMA"; then
  ok "directive @complexity declarada"
else
  fail "directive @complexity no declarada"
fi

# 2. Query.users con @complexity
if grep -qE 'users.*@complexity' "$SCHEMA" || grep -B1 'users' "$SCHEMA" | grep -q 'complexity'; then
  ok "Query.users tiene @complexity"
else
  fail "Query.users no tiene @complexity"
fi

# 3. server.js existe
if [[ -f "$SERVER" ]]; then ok "server.js existe"; else fail "server.js no existe"; fi

# 4. depthLimit importado
if grep -qE 'depthLimit|graphql-depth-limit' "$SERVER"; then
  ok "depthLimit importado"
else
  fail "depthLimit no importado"
fi

# 5. depthLimit(7)
if grep -qE 'depthLimit[[:space:]]*\([[:space:]]*7' "$SERVER"; then
  ok "depthLimit(7) configurado"
else
  fail "depthLimit(7) no configurado"
fi

# 6. createComplexityRule importado
if grep -qE 'createComplexityRule' "$SERVER"; then
  ok "createComplexityRule importado"
else
  fail "createComplexityRule no importado"
fi

# 7. maximumComplexity: 1000
if grep -qE 'maximumComplexity[[:space:]]*:[[:space:]]*1000' "$SERVER"; then
  ok "maximumComplexity: 1000 configurado"
else
  fail "maximumComplexity no configurado a 1000"
fi

# 8. validationRules configurado
if grep -qE 'validationRules' "$SERVER"; then
  ok "validationRules configurado"
else
  fail "validationRules no configurado"
fi

# 9. query pide users con limit
if grep -qE 'users[[:space:]]*\([[:space:]]*limit' "$QUERY"; then
  ok "query pide users(limit: ...)"
else
  fail "query no pide users con limit"
fi

# 10. expected.json
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
