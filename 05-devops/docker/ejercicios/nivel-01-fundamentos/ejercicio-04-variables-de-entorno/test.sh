#!/usr/bin/env bash
# test.sh — valida el ejercicio 04: variables de entorno
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
    grep -qiE '^ENV[[:space:]]+PORT' "$DF" && ok "ENV PORT definido" || fail "Falta ENV PORT=3000"
    grep -qiE '^ENV[[:space:]].*NODE_ENV' "$DF" && ok "ENV NODE_ENV definido" || fail "Falta ENV NODE_ENV"
    grep -qiE '^RUN[[:space:]].*npm[[:space:]]+ci' "$DF" && ok "RUN npm ci" || fail "Falta RUN npm ci"
    grep -qiE '^EXPOSE[[:space:]]+3000' "$DF" && ok "EXPOSE 3000" || fail "Falta EXPOSE 3000"
    grep -qiE '^CMD[[:space:]]+\[' "$DF" && ok "CMD exec form" || fail "CMD en forma exec"
    grep -qiE 'node.*server\.js' "$DF" && ok "CMD ejecuta server.js" || fail "CMD debe ejecutar node server.js"
    grep -qiE 'FROM[[:space:]]+\S+:latest' "$DF" && fail "No use :latest" || ok "sin :latest"
  fi
fi

[[ -f .dockerignore ]] && ok "existe .dockerignore" || fail "falta .dockerignore"
[[ -f app/server.js ]] && ok "existe app/server.js" || fail "falta app/server.js"

if [[ -f "$DF" ]] && command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
  IMG="ej04-test:$$"
  if docker build -q -t "$IMG" . >/dev/null 2>&1; then
    ok "docker build OK"
    docker run -d --rm --name "ej04-$$" -e PORT=14004 -p 14004:14004 "$IMG" >/dev/null 2>&1 || true
    sleep 2
    if BODY="$(curl -sf http://localhost:14004/ 2>/dev/null || true)"; then
      [[ "$BODY" == *'"port":14004'* ]] && ok "app respeta PORT=14004 via -e" || fail "app no usa PORT del entorno"
    else fail "app no responde"; fi
    docker stop "ej04-$$" >/dev/null 2>&1 || true
    docker rmi "$IMG" >/dev/null 2>&1 || true
  else fail "docker build falló"; fi
else MSGS+=("INFO - docker no disponible, se omite build/run"); fi

printf '%s\n' "${MSGS[@]}"
if [[ "$FAIL" -eq 0 ]]; then echo "OK Tests pasaron ($PASS)"; exit 0
else echo "FAIL Tests fallaron ($FAIL)"; exit 1; fi
