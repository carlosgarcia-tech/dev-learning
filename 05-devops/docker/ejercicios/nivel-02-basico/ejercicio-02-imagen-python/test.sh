#!/usr/bin/env bash
# test.sh — valida el ejercicio 02 nivel-02: imagen para app Python
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
    grep -qiE '^FROM[[:space:]]+python:3\.12-slim' "$DF" && ok "FROM python:3.12-slim" || fail "Falta FROM python:3.12-slim"
    grep -qiE '^WORKDIR[[:space:]]+/app' "$DF" && ok "WORKDIR /app" || fail "Falta WORKDIR /app"
    # requirements.txt copiado antes que el resto
    REQ_LINE=$(grep -nE 'requirements\.txt' "$DF" | head -1 | cut -d: -f1)
    APP_LINE=$(grep -nE '^COPY[[:space:]].*app' "$DF" | head -1 | cut -d: -f1)
    if [[ -n "$REQ_LINE" && -n "$APP_LINE" && "$REQ_LINE" -lt "$APP_LINE" ]]; then
      ok "requirements.txt copiado antes que el código (cache)"
    else
      fail "Copia requirements.txt antes que el resto del código"
    fi
    grep -qiE '^RUN[[:space:]].*pip[[:space:]]+install' "$DF" && ok "RUN pip install" || fail "Falta RUN pip install"
    grep -qiE 'no-cache-dir' "$DF" && ok "pip --no-cache-dir" || fail "Usa --no-cache-dir en pip install"
    grep -qiE '^EXPOSE[[:space:]]+5000' "$DF" && ok "EXPOSE 5000" || fail "Falta EXPOSE 5000"
    grep -qiE '^CMD[[:space:]]+\[' "$DF" && ok "CMD exec form" || fail "CMD en forma exec"
    grep -qiE 'python.*app\.py' "$DF" && ok "CMD ejecuta app.py" || fail "CMD debe ejecutar python app.py"
    grep -qiE 'FROM[[:space:]]+\S+:latest' "$DF" && fail "No use :latest" || ok "sin :latest"
  fi
fi

[[ -f .dockerignore ]] && ok "existe .dockerignore" || fail "falta .dockerignore"
[[ -f app/app.py ]] && ok "existe app/app.py" || fail "falta app/app.py"
[[ -f app/requirements.txt ]] && ok "existe app/requirements.txt" || fail "falta app/requirements.txt"

if [[ -f "$DF" ]] && command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
  IMG="ej02-02-test:$$"
  if docker build -q -t "$IMG" . >/dev/null 2>&1; then
    ok "docker build OK"
    docker run -d --rm --name "ej02-02-$$" -p 13006:5000 "$IMG" >/dev/null 2>&1 || true
    sleep 3
    if curl -sf http://localhost:13006/health >/dev/null 2>&1; then ok "app responde /health"; else fail "app no responde en /health"; fi
    docker stop "ej02-02-$$" >/dev/null 2>&1 || true
    docker rmi "$IMG" >/dev/null 2>&1 || true
  else fail "docker build falló"; fi
else MSGS+=("INFO - docker no disponible, se omite build/run"); fi

printf '%s\n' "${MSGS[@]}"
if [[ "$FAIL" -eq 0 ]]; then echo "OK Tests pasaron ($PASS)"; exit 0
else echo "FAIL Tests fallaron ($FAIL)"; exit 1; fi
