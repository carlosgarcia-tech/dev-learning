#!/usr/bin/env bash
# test.sh — valida el ejercicio 06 nivel-03: build args y multi-arch
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
    # ARG NODE_VERSION antes del FROM
    FIRST_FROM_LINE=$(grep -nE '^FROM' "$DF" | head -1 | cut -d: -f1)
    NODE_ARG_LINE=$(grep -nE '^ARG[[:space:]]+NODE_VERSION' "$DF" | head -1 | cut -d: -f1)
    if [[ -n "$NODE_ARG_LINE" && -n "$FIRST_FROM_LINE" && "$NODE_ARG_LINE" -lt "$FIRST_FROM_LINE" ]]; then
      ok "ARG NODE_VERSION antes de FROM"
    else
      fail "Define 'ARG NODE_VERSION=20' antes del FROM"
    fi
    grep -qiE '^FROM[[:space:]]+node:\$\{NODE_VERSION\}-alpine' "$DF" && ok "FROM usa \${NODE_VERSION}" || fail "FROM debe usar node:\${NODE_VERSION}-alpine"
    grep -qiE '^ARG[[:space:]]+APP_VERSION' "$DF" && ok "ARG APP_VERSION definido" || fail "Falta 'ARG APP_VERSION'"
    grep -qiE '^ENV[[:space:]]+APP_VERSION' "$DF" && ok "ENV APP_VERSION" || fail "Falta 'ENV APP_VERSION=\$APP_VERSION'"
    grep -qiE 'org\.opencontainers\.image\.version' "$DF" && ok "LABEL oci version" || fail "Falta LABEL org.opencontainers.image.version"
    grep -qiE '^CMD[[:space:]]+\[' "$DF" && ok "CMD exec form" || fail "CMD en forma exec"
    grep -qiE 'node.*server\.js' "$DF" && ok "CMD ejecuta server.js" || fail "CMD debe ejecutar node server.js"
    grep -qiE 'FROM[[:space:]]+\S+:latest' "$DF" && fail "No use :latest" || ok "sin :latest"
  fi
fi

[[ -f .dockerignore ]] && ok "existe .dockerignore" || fail "falta .dockerignore"

if [[ -f "$DF" ]] && command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
  IMG="ej03-06-test:$$"
  # Build con --build-arg APP_VERSION=2.1.0
  if docker build --build-arg APP_VERSION=2.1.0 -q -t "$IMG" . >/dev/null 2>&1; then
    ok "docker build con --build-arg OK"
    docker run -d --rm --name "ej03-06-$$" -p 13021:3000 "$IMG" >/dev/null 2>&1 || true
    sleep 2
    if BODY="$(curl -sf http://localhost:13021/ 2>/dev/null || true)"; then
      echo "$BODY" | grep -qi '"version":"2.1.0"' && ok "APP_VERSION propagada (2.1.0)" || fail "APP_VERSION no se propagó (body: $BODY)"
    else fail "app no responde"; fi
    docker stop "ej03-06-$$" >/dev/null 2>&1 || true
    docker rmi "$IMG" >/dev/null 2>&1 || true
  else fail "docker build falló"; fi
else MSGS+=("INFO - docker no disponible, se omite build/run"); fi

printf '%s\n' "${MSGS[@]}"
if [[ "$FAIL" -eq 0 ]]; then echo "OK Tests pasaron ($PASS)"; exit 0
else echo "FAIL Tests fallaron ($FAIL)"; exit 1; fi
