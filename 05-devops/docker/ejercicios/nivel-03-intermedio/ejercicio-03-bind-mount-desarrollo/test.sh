#!/usr/bin/env bash
# test.sh — valida el ejercicio 03 nivel-03: bind mount para desarrollo
set -euo pipefail
cd "$(dirname "$0")"

CF="docker-compose.yml"
PASS=0; FAIL=0; MSGS=()
ok()   { PASS=$((PASS+1)); MSGS+=("OK - $1"); }
fail() { FAIL=$((FAIL+1)); MSGS+=("FAIL - $1"); }

[[ -f "$CF" ]] && ok "existe $CF" || fail "no existe $CF"

if [[ -f "$CF" ]]; then
  if command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
    if docker compose -f "$CF" config >/dev/null 2>&1; then ok "docker compose config válido"; else fail "docker compose config inválido"; fi
  fi
  grep -qiE '^[[:space:]]*app:' "$CF" && ok "servicio 'app'" || fail "falta servicio 'app'"
  grep -qiE '8093:3000' "$CF" && ok "app publica 8093:3000" || fail "app debe publicar 8093:3000"
  # bind mount del código
  if grep -qiE '\./app/src:/app/src' "$CF" || grep -qiE '\./app/src:./src' "$CF"; then ok "bind mount ./app/src:/app/src"; else fail "falta bind mount ./app/src:/app/src"; fi
  # node_modules separado
  if grep -qiE '/app/node_modules' "$CF"; then ok "node_modules separado (volumen anónimo)"; else fail "monta /app/node_modules por separado"; fi
  # command con --watch
  if grep -qiE 'command' "$CF" && grep -qiE '\-\-watch' "$CF"; then ok "command con --watch"; else fail "sobrescribe command con node --watch"; fi
  # NODE_ENV=development
  grep -qiE 'NODE_ENV' "$CF" && grep -qiE 'development' "$CF" && ok "NODE_ENV=development" || fail "falta environment NODE_ENV=development"
fi

if [[ -f "$CF" ]] && command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
  if docker compose -f "$CF" up -d --build >/dev/null 2>&1; then
    ok "docker compose up OK"
    sleep 3
    if BODY="$(curl -sf http://localhost:8093/ 2>/dev/null || true)"; then
      echo "$BODY" | grep -qi '"env":"development"' && ok "app corre en modo development" || fail "app no está en development (body: $BODY)"
    else fail "app no responde"; fi
    docker compose -f "$CF" down -v >/dev/null 2>&1 || true
  else fail "docker compose up falló"; fi
else MSGS+=("INFO - docker no disponible, se omite up/down"); fi

printf '%s\n' "${MSGS[@]}"
if [[ "$FAIL" -eq 0 ]]; then echo "OK Tests pasaron ($PASS)"; exit 0
else echo "FAIL Tests fallaron ($FAIL)"; exit 1; fi
