#!/usr/bin/env bash
# test.sh — valida el ejercicio 03: exponer puerto con app Node
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
    # Cache: package.json copiado ANTES que el resto del código
    if grep -nE '^COPY' "$DF" | awk -F: '{print $2": "$3}' | head -1 | grep -qiE 'package'; then
      ok "package.json copiado primero (cache)"
    else
      fail "Copia package.json antes que el resto del código (optimización de cache)"
    fi
    grep -qiE '^RUN[[:space:]].*npm[[:space:]]+ci' "$DF" && ok "RUN npm ci" || fail "Falta RUN npm ci"
    grep -qiE 'omit=dev|--omit=dev|--production' "$DF" && ok "npm ci omite dev deps" || fail "Usa --omit=dev o --production en npm ci"
    grep -qiE '^EXPOSE[[:space:]]+3000' "$DF" && ok "EXPOSE 3000" || fail "Falta EXPOSE 3000"
    grep -qiE '^CMD[[:space:]]+\[' "$DF" && ok "CMD exec form" || fail "CMD en forma exec"
    grep -qiE 'node.*server\.js' "$DF" && ok "CMD ejecuta node server.js" || fail "CMD debe ejecutar node server.js"
    grep -qiE 'FROM[[:space:]]+\S+:latest' "$DF" && fail "No use :latest" || ok "sin :latest"
  fi
fi

[[ -f .dockerignore ]] && ok "existe .dockerignore" || fail "falta .dockerignore"
[[ -f .dockerignore ]] && grep -qiE 'node_modules' .dockerignore && ok ".dockerignore excluye node_modules" || fail ".dockerignore debe excluir node_modules"
[[ -f app/server.js ]] && ok "existe app/server.js" || fail "falta app/server.js"

if [[ -f "$DF" ]] && command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
  IMG="ej03-test:$$"
  if docker build -q -t "$IMG" . >/dev/null 2>&1; then
    ok "docker build OK"
    docker run -d --rm --name "ej03-$$" -p 13003:3000 "$IMG" >/dev/null 2>&1 || true
    sleep 2
    if curl -sf http://localhost:13003/health >/dev/null 2>&1; then ok "app responde /health"; else fail "app no responde en /health"; fi
    docker stop "ej03-$$" >/dev/null 2>&1 || true
    docker rmi "$IMG" >/dev/null 2>&1 || true
  else fail "docker build falló"; fi
else MSGS+=("INFO - docker no disponible, se omite build/run"); fi

printf '%s\n' "${MSGS[@]}"
if [[ "$FAIL" -eq 0 ]]; then echo "OK Tests pasaron ($PASS)"; exit 0
else echo "FAIL Tests fallaron ($FAIL)"; exit 1; fi
