#!/usr/bin/env bash
# test.sh — valida el ejercicio 04 nivel-04: logging driver
set -euo pipefail
cd "$(dirname "$0")"

CF="docker-compose.yml"
PASS=0; FAIL=0; MSGS=()
ok()   { PASS=$((PASS+1)); MSGS+=("OK - $1"); }
fail() { FAIL=$((FAIL+1)); MSGS+=("FAIL - $1"); }

[[ -f "$CF" ]] && ok "existe $CF" || fail "no existe $CF"

if [[ -f "$CF" ]]; then
  if command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
    if docker compose -f "$CF" config >/dev/null 2>&1; then ok "compose config válido"; else fail "compose config inválido"; fi
  fi
  grep -qiE '^[[:space:]]*app:' "$CF" && ok "servicio 'app'" || fail "falta servicio 'app'"
  grep -qiE 'logging' "$CF" && ok "sección logging" || fail "falta sección 'logging'"
  grep -qiE 'driver:[[:space:]]*json-file' "$CF" && ok "driver json-file" || fail "falta 'driver: json-file'"
  grep -qiE 'max-size:[[:space:]]*"10m"' "$CF" && ok "max-size 10m" || fail "falta 'max-size: \"10m\"'"
  grep -qiE 'max-file:[[:space:]]*"3"' "$CF" && ok "max-file 3" || fail "falta 'max-file: \"3\"'"
  grep -qiE '8098:3000' "$CF" && ok "puerto 8098:3000" || fail "app debe publicar 8098:3000"
fi

if [[ -f "$CF" ]] && command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
  if docker compose -f "$CF" up -d --build >/dev/null 2>&1; then
    ok "docker compose up OK"
    sleep 3
    curl -sf http://localhost:8098/ >/dev/null 2>&1 && ok "app responde" || fail "app no responde"
    # Verificar que el logging driver está aplicado
    DRIVER=$(docker inspect "$(docker compose -f "$CF" ps -q app)" --format '{{.HostConfig.LogConfig.Type}}' 2>/dev/null || echo "")
    if [[ "$DRIVER" == "json-file" ]]; then ok "logging driver aplicado"; else fail "logging driver no aplicado ($DRIVER)"; fi
    docker compose -f "$CF" down -v >/dev/null 2>&1 || true
  else fail "docker compose up falló"; fi
else MSGS+=("INFO - docker no disponible, se omite up/down"); fi

printf '%s\n' "${MSGS[@]}"
if [[ "$FAIL" -eq 0 ]]; then echo "OK Tests pasaron ($PASS)"; exit 0
else echo "FAIL Tests fallaron ($FAIL)"; exit 1; fi
