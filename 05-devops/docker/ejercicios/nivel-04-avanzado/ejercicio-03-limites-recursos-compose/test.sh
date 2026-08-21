#!/usr/bin/env bash
# test.sh — valida el ejercicio 03 nivel-04: límites de recursos en Compose
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
  grep -qiE 'build:[[:space:]]+\./app' "$CF" && ok "build ./app" || fail "app debe usar 'build: ./app'"
  grep -qiE 'mem_limit:[[:space:]]*256m' "$CF" && ok "mem_limit 256m" || fail "falta 'mem_limit: 256m'"
  grep -qiE 'mem_reservation:[[:space:]]*128m' "$CF" && ok "mem_reservation 128m" || fail "falta 'mem_reservation: 128m'"
  grep -qiE 'cpus:[[:space:]]*"0\.5"|cpus:[[:space:]]+0\.5' "$CF" && ok "cpus 0.5" || fail "falta 'cpus: \"0.5\"'"
  grep -qiE 'pids_limit:[[:space:]]*100' "$CF" && ok "pids_limit 100" || fail "falta 'pids_limit: 100'"
  grep -qiE 'on-failure' "$CF" && ok "restart on-failure" || fail "falta 'restart: \"on-failure:3\"'"
  grep -qiE '8097:3000' "$CF" && ok "puerto 8097:3000" || fail "app debe publicar 8097:3000"
fi

if [[ -f "$CF" ]] && command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
  if docker compose -f "$CF" up -d --build >/dev/null 2>&1; then
    ok "docker compose up OK"
    sleep 3
    if curl -sf http://localhost:8097/ >/dev/null 2>&1; then ok "app responde"; else fail "app no responde"; fi
    # Verificar límite de memoria aplicado
    MEM=$(docker inspect "$(docker compose -f "$CF" ps -q app)" --format '{{.HostConfig.Memory}}' 2>/dev/null || echo 0)
    if [[ "$MEM" -gt 0 ]]; then ok "límite de memoria aplicado ($MEM bytes)"; else fail "no se aplicó límite de memoria"; fi
    docker compose -f "$CF" down -v >/dev/null 2>&1 || true
  else fail "docker compose up falló"; fi
else MSGS+=("INFO - docker no disponible, se omite up/down"); fi

printf '%s\n' "${MSGS[@]}"
if [[ "$FAIL" -eq 0 ]]; then echo "OK Tests pasaron ($PASS)"; exit 0
else echo "FAIL Tests fallaron ($FAIL)"; exit 1; fi
