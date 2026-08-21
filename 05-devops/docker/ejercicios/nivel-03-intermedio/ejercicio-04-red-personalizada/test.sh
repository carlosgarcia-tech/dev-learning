#!/usr/bin/env bash
# test.sh — valida el ejercicio 04 nivel-03: red personalizada
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
  grep -qiE '^[[:space:]]*web:' "$CF" && ok "servicio 'web'" || fail "falta servicio 'web'"
  grep -qiE '^[[:space:]]*api:' "$CF" && ok "servicio 'api'" || fail "falta servicio 'api'"
  grep -qiE 'nginx:1\.27-alpine' "$CF" && ok "web usa nginx:1.27-alpine" || fail "web debe usar nginx:1.27-alpine"
  # Red appnet con subnet
  grep -qiE 'appnet' "$CF" && ok "red appnet definida" || fail "falta red appnet"
  grep -qiE '172\.28\.0\.0/16' "$CF" && ok "subnet 172.28.0.0/16" || fail "appnet debe definir subnet 172.28.0.0/16"
  grep -qiE 'driver:[[:space:]]*bridge' "$CF" && ok "driver bridge" || fail "appnet debe usar driver: bridge"
  # Red dbnet internal
  grep -qiE 'dbnet' "$CF" && ok "red dbnet definida" || fail "falta red dbnet"
  grep -qiE 'internal:[[:space:]]*true' "$CF" && ok "dbnet es internal" || fail "dbnet debe ser internal: true"
  # Alias
  grep -qiE 'aliases' "$CF" && ok "hay aliases definidos" || fail "define aliases DNS para los servicios"
  grep -qiE 'frontend' "$CF" && ok "alias frontend" || fail "web debe tener alias 'frontend'"
  grep -qiE 'backend' "$CF" && ok "alias backend" || fail "api debe tener alias 'backend'"
  grep -qiE '8094:80' "$CF" && ok "web publica 8094:80" || fail "web debe publicar 8094:80"
  grep -qiE '8095:3000' "$CF" && ok "api publica 8095:3000" || fail "api debe publicar 8095:3000"
fi

if [[ -f "$CF" ]] && command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
  if docker compose -f "$CF" up -d --build >/dev/null 2>&1; then
    ok "docker compose up OK"
    sleep 4
    if curl -sf http://localhost:8094/ >/dev/null 2>&1; then ok "web (nginx) responde"; else fail "web no responde"; fi
    if curl -sf http://localhost:8095/ >/dev/null 2>&1; then ok "api responde"; else fail "api no responde"; fi
    # Resolver alias 'frontend' desde dentro de api
    if docker compose -f "$CF" exec -T api wget -qO- http://frontend/ >/dev/null 2>&1; then ok "alias 'frontend' resuelve desde api"; else fail "alias 'frontend' no resuelve"; fi
    docker compose -f "$CF" down -v >/dev/null 2>&1 || true
  else fail "docker compose up falló"; fi
else MSGS+=("INFO - docker no disponible, se omite up/down"); fi

printf '%s\n' "${MSGS[@]}"
if [[ "$FAIL" -eq 0 ]]; then echo "OK Tests pasaron ($PASS)"; exit 0
else echo "FAIL Tests fallaron ($FAIL)"; exit 1; fi
