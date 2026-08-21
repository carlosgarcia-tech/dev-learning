#!/usr/bin/env bash
# test.sh — valida el ejercicio 03 nivel-02: volumen persistente
set -euo pipefail
cd "$(dirname "$0")"

DF="Dockerfile"
PASS=0; FAIL=0; MSGS=()
ok()   { PASS=$((PASS+1)); MSGS+=("OK - $1"); }
fail() { FAIL=$((FAIL+1)); MSGS+=("FAIL - $1"); }

[[ -f "$DF" ]] && ok "existe $DF" || fail "no existe $DF"

if [[ -f "$DF" ]]; then
  if command -v hadolint >/dev/null 2>&1; then
    if hadolint "$DF"; then ok "hadolint pasa"; else fail "hadolint reporta errores"; fi
  else
    grep -qiE '^FROM[[:space:]]+node:20-alpine' "$DF" && ok "FROM node:20-alpine" || fail "Falta FROM node:20-alpine"
    grep -qiE '^WORKDIR[[:space:]]+/app' "$DF" && ok "WORKDIR /app" || fail "Falta WORKDIR /app"
    grep -qiE '^VOLUME[[:space:]]+\[' "$DF" && ok "VOLUME exec form" || fail "Falta VOLUME en forma exec"
    grep -qiE '^VOLUME[[:space:]].*/app/data' "$DF" && ok "VOLUME /app/data" || fail "VOLUME debe declarar /app/data"
    grep -qiE '^CMD[[:space:]]+\[' "$DF" && ok "CMD exec form" || fail "CMD en forma exec"
    grep -qiE 'FROM[[:space:]]+\S+:latest' "$DF" && fail "No use :latest" || ok "sin :latest"
  fi
fi

[[ -f .dockerignore ]] && ok "existe .dockerignore" || fail "falta .dockerignore"
[[ -f app/server.js ]] && ok "existe app/server.js" || fail "falta app/server.js"
# La app debe escribir en /app/data
if grep -qiE '/app/data|DATA_DIR' app/server.js; then ok "app usa /app/data"; else fail "app debe escribir en /app/data"; fi

if [[ -f "$DF" ]] && command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
  IMG="ej02-03-test:$$"
  VOL="ej02-03-data-$$"
  if docker build -q -t "$IMG" . >/dev/null 2>&1; then
    ok "docker build OK"
    docker volume create "$VOL" >/dev/null 2>&1
    # Primera ejecución: contador llega a 2 (dos peticiones)
    docker run -d --rm --name "ej02-03-a-$$" -v "$VOL:/app/data" -p 13007:3000 "$IMG" >/dev/null 2>&1 || true
    sleep 2
    curl -sf http://localhost:13007/ >/dev/null 2>&1 || true
    curl -sf http://localhost:13007/ >/dev/null 2>&1 || true
    docker stop "ej02-03-a-$$" >/dev/null 2>&1 || true
    # Segunda ejecución con el MISMO volumen: contador debe seguir subiendo (persistencia)
    docker run -d --rm --name "ej02-03-b-$$" -v "$VOL:/app/data" -p 13008:3000 "$IMG" >/dev/null 2>&1 || true
    sleep 2
    OUT="$(curl -sf http://localhost:13008/ 2>/dev/null || true)"
    if echo "$OUT" | grep -qE '"count":3'; then ok "persistencia OK (contador=3 tras reinicio)"; else fail "persistencia falla (salida: $OUT)"; fi
    docker stop "ej02-03-b-$$" >/dev/null 2>&1 || true
    docker volume rm "$VOL" >/dev/null 2>&1 || true
    docker rmi "$IMG" >/dev/null 2>&1 || true
  else fail "docker build falló"; fi
else MSGS+=("INFO - docker no disponible, se omite build/run"); fi

printf '%s\n' "${MSGS[@]}"
if [[ "$FAIL" -eq 0 ]]; then echo "OK Tests pasaron ($PASS)"; exit 0
else echo "FAIL Tests fallaron ($FAIL)"; exit 1; fi
