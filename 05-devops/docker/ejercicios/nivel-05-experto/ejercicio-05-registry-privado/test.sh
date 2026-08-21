#!/usr/bin/env bash
# test.sh — valida el ejercicio 05 nivel-05: registry privado
set -euo pipefail
cd "$(dirname "$0")"

CF="docker-compose.yml"
PS="push.sh"
PASS=0; FAIL=0; MSGS=()
ok()   { PASS=$((PASS+1)); MSGS+=("OK - $1"); }
fail() { FAIL=$((FAIL+1)); MSGS+=("FAIL - $1"); }

[[ -f "$CF" ]] && ok "existe $CF" || fail "no existe $CF"
[[ -f "$PS" ]] && ok "existe push.sh" || fail "no existe push.sh"

if [[ -f "$CF" ]]; then
  if command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
    if docker compose -f "$CF" config >/dev/null 2>&1; then ok "compose config válido"; else fail "compose config inválido"; fi
  fi
  grep -qiE '^[[:space:]]*registry:' "$CF" && ok "servicio 'registry'" || fail "falta servicio 'registry'"
  grep -qiE 'registry:2' "$CF" && ok "usa registry:2" || fail "registry debe usar 'registry:2'"
  grep -qiE '5000:5000' "$CF" && ok "puerto 5000:5000" || fail "registry debe publicar 5000:5000"
  grep -qiE 'registry_data:/var/lib/registry' "$CF" && ok "volumen registry_data" || fail "registry debe montar registry_data en /var/lib/registry"
  grep -qiE '^volumes:' "$CF" && grep -qiE '^[[:space:]]*registry_data:' "$CF" && ok "volumen registry_data top-level" || fail "define volumen registry_data en top-level"
fi

if [[ -f "$PS" ]]; then
  grep -qiE 'docker[[:space:]]+build' "$PS" && ok "push.sh construye imagen" || fail "push.sh debe construir la imagen"
  grep -qiE 'localhost:5000/miapp:1\.0' "$PS" && ok "push.sh etiqueta localhost:5000" || fail "push.sh debe etiquetar como localhost:5000/miapp:1.0"
  grep -qiE 'docker[[:space:]]+push' "$PS" && ok "push.sh hace docker push" || fail "push.sh debe hacer 'docker push localhost:5000/miapp:1.0'"
  if bash -n "$PS"; then ok "push.sh sintaxis válida"; else fail "push.sh tiene errores de sintaxis"; fi
fi

if [[ -f "$CF" ]] && command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
  if docker compose -f "$CF" up -d >/dev/null 2>&1; then
    ok "registry arrancado"
    sleep 3
    # Verificar que el registry responde
    if curl -sf http://localhost:5000/v2/ >/dev/null 2>&1; then ok "registry API responde"; else fail "registry API no responde en /v2/"; fi
    # Probar push si el script funciona
    if bash "$PS" >/dev/null 2>&1; then
      ok "push a registry privado OK"
      # Verificar que la imagen está en el registry
      if curl -sf http://localhost:5000/v2/miapp/tags/list 2>/dev/null | grep -qi '1.0'; then
        ok "imagen visible en el registry"
      else
        fail "imagen no encontrada en el registry"
      fi
    else
      fail "push.sh falló"
    fi
    docker compose -f "$CF" down -v >/dev/null 2>&1 || true
  else fail "registry no arrancó"; fi
else MSGS+=("INFO - docker no disponible, se omite up/push"); fi

printf '%s\n' "${MSGS[@]}"
if [[ "$FAIL" -eq 0 ]]; then echo "OK Tests pasaron ($PASS)"; exit 0
else echo "FAIL Tests fallaron ($FAIL)"; exit 1; fi
