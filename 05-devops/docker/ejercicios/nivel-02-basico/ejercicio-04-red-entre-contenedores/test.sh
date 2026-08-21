#!/usr/bin/env bash
# test.sh — valida el ejercicio 04 nivel-02: red entre dos contenedores
set -euo pipefail
cd "$(dirname "$0")"

CF="docker-compose.yml"
PASS=0; FAIL=0; MSGS=()
ok()   { PASS=$((PASS+1)); MSGS+=("OK - $1"); }
fail() { FAIL=$((FAIL+1)); MSGS+=("FAIL - $1"); }

[[ -f "$CF" ]] && ok "existe $CF" || fail "no existe $CF"

if [[ -f "$CF" ]]; then
  # Validar estructura YAML con docker compose config si está disponible
  if command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
    if docker compose -f "$CF" config >/dev/null 2>&1; then ok "docker compose config válido"; else fail "docker compose config inválido"; fi
  fi
  # Servicios api y backend
  if grep -qiE '^[[:space:]]*api:' "$CF"; then ok "servicio 'api' definido"; else fail "falta servicio 'api'"; fi
  if grep -qiE '^[[:space:]]*backend:' "$CF"; then ok "servicio 'backend' definido"; else fail "falta servicio 'backend'"; fi
  # Red appnet
  if grep -qiE 'appnet' "$CF"; then ok "red appnet referenciada"; else fail "falta red 'appnet'"; fi
  if grep -qiE '^networks:' "$CF" && grep -qiE '^[[:space:]]*appnet:' "$CF"; then ok "red appnet definida en top-level"; else fail "define la red 'appnet' en la sección networks: top-level"; fi
  # api publica 8090
  if grep -qiE '8090:3000' "$CF"; then ok "api publica 8090:3000"; else fail "api debe publicar 8090:3000"; fi
  # backend NO debe exponer puertos al host
  # (extrae bloque backend y comprueba que no tiene 'ports:')
  if awk '/^[[:space:]]*backend:/{f=1} f&&/^[[:space:]]+[a-z]/&&!/backend:/{if($1=="ports:")exit 1} /^networks:/{exit}' "$CF"; then
    ok "backend no publica puertos al host"
  else
    fail "backend no debe tener 'ports:' (solo accesible dentro de la red)"
  fi
  # api depende de backend
  grep -qiE 'depends_on' "$CF" && grep -qiE 'backend' "$CF" && ok "api depende de backend" || fail "api debe tener depends_on: [backend]"
fi

[[ -f app-api/server.js ]] && ok "existe app-api/server.js" || fail "falta app-api/server.js"
[[ -f app-backend/server.js ]] && ok "existe app-backend/server.js" || fail "falta app-backend/server.js"
# api debe consultar a http://backend
if grep -qiE 'http://backend' app-api/server.js; then ok "api usa DNS interno 'http://backend'"; else fail "api debe consultar a http://backend:3000 (DNS interno)"; fi

if [[ -f "$CF" ]] && command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
  if docker compose -f "$CF" up -d --build >/dev/null 2>&1; then
    ok "docker compose up OK"
    sleep 4
    if curl -sf http://localhost:8090/ >/dev/null 2>&1; then ok "api responde /"; else fail "api no responde en 8090"; fi
    if curl -sf http://localhost:8090/proxy 2>/dev/null | grep -qi 'backend'; then ok "api consulta al backend por DNS"; else fail "api no logra consultar al backend"; fi
    docker compose -f "$CF" down -v >/dev/null 2>&1 || true
  else fail "docker compose up falló"; fi
else MSGS+=("INFO - docker no disponible, se omite up/down"); fi

printf '%s\n' "${MSGS[@]}"
if [[ "$FAIL" -eq 0 ]]; then echo "OK Tests pasaron ($PASS)"; exit 0
else echo "FAIL Tests fallaron ($FAIL)"; exit 1; fi
