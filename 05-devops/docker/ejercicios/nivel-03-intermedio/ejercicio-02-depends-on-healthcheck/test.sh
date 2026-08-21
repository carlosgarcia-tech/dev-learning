#!/usr/bin/env bash
# test.sh — valida el ejercicio 02 nivel-03: depends_on y healthcheck
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
  grep -qiE '^[[:space:]]*reporter:' "$CF" && ok "servicio 'reporter'" || fail "falta servicio 'reporter'"
  # healthcheck en app
  if grep -qiE 'healthcheck' "$CF" && grep -qiE 'wget.*health' "$CF"; then ok "app tiene healthcheck wget /health"; else fail "app debe tener healthcheck con wget a /health"; fi
  grep -qiE 'interval' "$CF" && grep -qiE 'timeout' "$CF" && grep -qiE 'retries' "$CF" && ok "healthcheck con interval/timeout/retries" || fail "healthcheck necesita interval, timeout y retries"
  # depends_on con service_healthy
  grep -qiE 'service_healthy' "$CF" && ok "reporter depende de app (service_healthy)" || fail "reporter debe usar depends_on con condition: service_healthy"
  # reporter usa wget hacia app
  grep -qiE 'wget.*http://app:3000' "$CF" && ok "reporter usa wget a http://app:3000" || fail "reporter debe hacer wget a http://app:3000/health"
  grep -qiE '8092:3000' "$CF" && ok "app publica 8092:3000" || fail "app debe publicar 8092:3000"
  grep -qiE 'appnet' "$CF" && ok "red appnet" || fail "falta red appnet"
fi

if [[ -f "$CF" ]] && command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
  if docker compose -f "$CF" up -d --build >/dev/null 2>&1; then
    ok "docker compose up OK"
    sleep 5
    if curl -sf http://localhost:8092/health >/dev/null 2>&1; then ok "app responde /health"; else fail "app no responde /health"; fi
    # reporter debería haber terminado con OK
    if docker compose -f "$CF" logs reporter 2>/dev/null | grep -qi 'OK'; then ok "reporter alcanzó a app"; else fail "reporter no alcanzó a app"; fi
    docker compose -f "$CF" down -v >/dev/null 2>&1 || true
  else fail "docker compose up falló"; fi
else MSGS+=("INFO - docker no disponible, se omite up/down"); fi

printf '%s\n' "${MSGS[@]}"
if [[ "$FAIL" -eq 0 ]]; then echo "OK Tests pasaron ($PASS)"; exit 0
else echo "FAIL Tests fallaron ($FAIL)"; exit 1; fi
