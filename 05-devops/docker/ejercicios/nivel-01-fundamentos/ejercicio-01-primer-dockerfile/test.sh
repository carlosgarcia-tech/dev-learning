#!/usr/bin/env bash
# test.sh — valida el ejercicio 01: primer Dockerfile
set -euo pipefail

cd "$(dirname "$0")"

DF="Dockerfile"
PASS=0
FAIL=0
MSGS=()

ok()   { PASS=$((PASS+1)); MSGS+=("OK - $1"); }
fail() { FAIL=$((FAIL+1)); MSGS+=("FAIL - $1"); }

# 1) Existencia del Dockerfile
if [[ -f "$DF" ]]; then ok "existe $DF"; else fail "no existe $DF"; fi

# 2) Validación con hadolint (si disponible) o con grep/awk
if [[ -f "$DF" ]]; then
  if command -v hadolint >/dev/null 2>&1; then
    if hadolint "$DF"; then ok "hadolint pasa"; else fail "hadolint reporta errores"; fi
  else
    # FROM alpine presente
    if grep -qiE '^FROM[[:space:]]+alpine:3\.20' "$DF"; then
      ok "FROM alpine:3.20 presente"
    else
      fail "Falta 'FROM alpine:3.20'"
    fi
    # RUN apk add curl
    if grep -qiE '^RUN[[:space:]].*apk[[:space:]]+add.*curl' "$DF"; then
      ok "RUN instala curl"
    else
      fail "Falta 'RUN apk add ... curl'"
    fi
    # CMD en forma exec
    if grep -qiE '^CMD[[:space:]]+\[' "$DF"; then
      ok "CMD en forma exec"
    else
      fail "CMD debe estar en forma exec (CMD [\"echo\", ...])"
    fi
    # El CMD contiene echo Hola Docker
    if grep -qiE 'echo.*Hola Docker' "$DF"; then
      ok "CMD imprime 'Hola Docker'"
    else
      fail "CMD no imprime 'Hola Docker'"
    fi
    # No usar :latest
    if grep -qiE 'FROM[[:space:]]+\S+:latest' "$DF"; then
      fail "No uses :latest, fija la versión"
    else
      ok "sin :latest"
    fi
  fi
fi

# 3) .dockerignore
if [[ -f .dockerignore ]]; then ok "existe .dockerignore"; else fail "falta .dockerignore"; fi

# 4) Si Docker está disponible, construir y ejecutar
if [[ -f "$DF" ]] && command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
  IMG="ej01-test:$$"
  if docker build -q -t "$IMG" . >/dev/null 2>&1; then
    ok "docker build OK"
    OUT="$(docker run --rm "$IMG" 2>/dev/null || true)"
    if [[ "$OUT" == *"Hola Docker"* ]]; then
      ok "docker run imprime 'Hola Docker'"
    else
      fail "docker run no imprime 'Hola Docker' (salida: $OUT)"
    fi
    docker rmi "$IMG" >/dev/null 2>&1 || true
  else
    fail "docker build falló"
  fi
else
  MSGS+=("INFO - docker no disponible, se omite build/run")
fi

# Resultado
printf '%s\n' "${MSGS[@]}"
if [[ "$FAIL" -eq 0 ]]; then
  echo "OK Tests pasaron ($PASS)"
  exit 0
else
  echo "FAIL Tests fallaron ($FAIL)"
  exit 1
fi
