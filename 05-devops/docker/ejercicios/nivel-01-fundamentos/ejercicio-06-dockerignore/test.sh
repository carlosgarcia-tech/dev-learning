#!/usr/bin/env bash
# test.sh — valida el ejercicio 06: .dockerignore
set -euo pipefail
cd "$(dirname "$0")"

DI=".dockerignore"
DF="Dockerfile"
PASS=0; FAIL=0; MSGS=()
ok()   { PASS=$((PASS+1)); MSGS+=("OK - $1"); }
fail() { FAIL=$((FAIL+1)); MSGS+=("FAIL - $1"); }

# 1) .dockerignore existe y tiene las exclusiones clave
if [[ -f "$DI" ]]; then
  ok "existe .dockerignore"
  for PAT in node_modules '.git' '\*\.log' secrets\.env '\.env' Dockerfile\*; do
    if grep -qiE "^$PAT" "$DI"; then ok "excluye $PAT"; else fail ".dockerignore no excluye $PAT"; fi
  done
else
  fail "no existe .dockerignore"
fi

# 2) Dockerfile existe y es válido
if [[ -f "$DF" ]]; then
  ok "existe Dockerfile"
  if command -v hadolint >/dev/null 2>&1; then
    if hadolint "$DF"; then ok "hadolint pasa"; else fail "hadolint reporta errores"; fi
  else
    grep -qiE '^FROM[[:space:]]+node:20-alpine' "$DF" && ok "FROM node:20-alpine" || fail "Falta FROM node:20-alpine"
    grep -qiE '^CMD[[:space:]]+\[' "$DF" && ok "CMD exec form" || fail "CMD en forma exec"
    grep -qiE 'node.*server\.js' "$DF" && ok "CMD ejecuta server.js" || fail "CMD debe ejecutar node server.js"
    grep -qiE 'FROM[[:space:]]+\S+:latest' "$DF" && fail "No use :latest" || ok "sin :latest"
  fi
else
  fail "no existe Dockerfile"
fi

[[ -f secrets.env ]] && ok "existe secrets.env (fixture)" || fail "falta secrets.env (fixture)"

# 3) Si Docker disponible, verifica que secrets.env NO entra en la imagen
if [[ -f "$DF" ]] && command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
  IMG="ej06-test:$$"
  if docker build -q -t "$IMG" . >/dev/null 2>&1; then
    ok "docker build OK"
    # Comprobar que secrets.env no está en el contexto/imagen
    if docker run --rm "$IMG" ls /app/secrets.env 2>/dev/null; then
      fail "secrets.env entró en la imagen (.dockerignore no funciona)"
    else
      ok "secrets.env no entra en la imagen"
    fi
    docker rmi "$IMG" >/dev/null 2>&1 || true
  else fail "docker build falló"; fi
else MSGS+=("INFO - docker no disponible, se omite build/run"); fi

printf '%s\n' "${MSGS[@]}"
if [[ "$FAIL" -eq 0 ]]; then echo "OK Tests pasaron ($PASS)"; exit 0
else echo "FAIL Tests fallaron ($FAIL)"; exit 1; fi
