#!/usr/bin/env bash
# test.sh — valida el ejercicio 03 nivel-05: escaneo con Trivy
set -euo pipefail
cd "$(dirname "$0")"

DF="Dockerfile"
SC="scan.sh"
PASS=0; FAIL=0; MSGS=()
ok()   { PASS=$((PASS+1)); MSGS+=("OK - $1"); }
fail() { FAIL=$((FAIL+1)); MSGS+=("FAIL - $1"); }

[[ -f "$DF" ]] && ok "existe Dockerfile" || fail "no existe Dockerfile"
[[ -f "$SC" ]] && ok "existe scan.sh" || fail "no existe scan.sh"

if [[ -f "$DF" ]]; then
  if command -v hadolint >/dev/null 2>&1; then
    if hadolint "$DF"; then ok "hadolint pasa"; else fail "hadolint reporta errores"; fi
  else
    grep -qiE '^FROM[[:space:]]+node:20-alpine' "$DF" && ok "FROM node:20-alpine" || fail "Falta FROM node:20-alpine"
    grep -qiE '^CMD[[:space:]]+\[' "$DF" && ok "CMD exec form" || fail "CMD en forma exec"
    grep -qiE 'FROM[[:space:]]+\S+:latest' "$DF" && fail "No use :latest" || ok "sin :latest"
  fi
fi

if [[ -f "$SC" ]]; then
  grep -qiE 'trivy' "$SC" && ok "scan.sh usa trivy" || fail "scan.sh debe usar 'trivy image'"
  grep -qiE 'image' "$SC" && ok "scan.sh escanea imagen" || fail "scan.sh debe ejecutar 'trivy image'"
  grep -qiE 'severity' "$SC" && ok "scan.sh define severity" || fail "scan.sh debe usar --severity HIGH,CRITICAL"
  grep -qiE 'HIGH,CRITICAL' "$SC" && ok "severity HIGH,CRITICAL" || fail "scan.sh debe filtrar HIGH,CRITICAL"
  grep -qiE 'exit-code[[:space:]]+1' "$SC" && ok "exit-code 1" || fail "scan.sh debe usar --exit-code 1"
  grep -qiE 'docker[[:space:]]+build' "$SC" && ok "scan.sh construye imagen" || fail "scan.sh debe construir la imagen antes de escanear"
  if bash -n "$SC"; then ok "scan.sh sintaxis válida"; else fail "scan.sh tiene errores de sintaxis"; fi
fi

# Si trivy y docker están disponibles, ejecutar el escaneo real
if [[ -f "$SC" ]] && command -v trivy >/dev/null 2>&1 && command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
  if bash "$SC" >/dev/null 2>&1; then
    ok "trivy: sin vulnerabilidades HIGH/CRITICAL"
  else
    fail "trivy: encontró vulnerabilidades HIGH/CRITICAL (o el build falló)"
  fi
  docker rmi ejercicio-trivy:latest >/dev/null 2>&1 || true
else
  MSGS+=("INFO - trivy/docker no disponibles, se omite el escaneo real")
fi

printf '%s\n' "${MSGS[@]}"
if [[ "$FAIL" -eq 0 ]]; then echo "OK Tests pasaron ($PASS)"; exit 0
else echo "FAIL Tests fallaron ($FAIL)"; exit 1; fi
