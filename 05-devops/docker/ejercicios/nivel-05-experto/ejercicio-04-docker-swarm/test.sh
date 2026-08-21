#!/usr/bin/env bash
# test.sh — valida el ejercicio 04 nivel-05: Docker Swarm service
set -euo pipefail
cd "$(dirname "$0")"

CF="docker-compose.yml"
DS="deploy.sh"
PASS=0; FAIL=0; MSGS=()
ok()   { PASS=$((PASS+1)); MSGS+=("OK - $1"); }
fail() { FAIL=$((FAIL+1)); MSGS+=("FAIL - $1"); }

[[ -f "$CF" ]] && ok "existe $CF" || fail "no existe $CF"
[[ -f "$DS" ]] && ok "existe deploy.sh" || fail "no existe deploy.sh"

if [[ -f "$CF" ]]; then
  if command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
    if docker compose -f "$CF" config >/dev/null 2>&1; then ok "compose config válido"; else fail "compose config inválido"; fi
  fi
  grep -qiE '^[[:space:]]*web:' "$CF" && ok "servicio 'web'" || fail "falta servicio 'web'"
  grep -qiE 'image:[[:space:]]+\S+' "$CF" && ok "web usa image:" || fail "Swarm necesita 'image:' (build: se ignora en stack deploy)"
  grep -qiE 'deploy:' "$CF" && ok "sección deploy:" || fail "falta sección 'deploy:'"
  grep -qiE 'replicas:[[:space:]]*3' "$CF" && ok "replicas 3" || fail "falta 'deploy.replicas: 3'"
  grep -qiE 'update_config' "$CF" && ok "update_config" || fail "falta 'deploy.update_config'"
  grep -qiE 'parallelism:[[:space:]]*1' "$CF" && ok "parallelism 1" || fail "falta 'parallelism: 1'"
  grep -qiE 'delay:[[:space:]]*10s' "$CF" && ok "delay 10s" || fail "falta 'delay: 10s'"
  grep -qiE 'restart_policy' "$CF" && grep -qiE 'on-failure' "$CF" && ok "restart_policy on-failure" || fail "falta 'restart_policy: condition: on-failure'"
  grep -qiE 'resources' "$CF" && grep -qiE 'limits' "$CF" && ok "resources.limits" || fail "falta 'deploy.resources.limits'"
  grep -qiE 'memory:[[:space:]]*256M' "$CF" && ok "memory 256M" || fail "falta 'memory: 256M'"
  grep -qiE 'cpus:[[:space:]]*"0\.5"|cpus:[[:space:]]+0\.5' "$CF" && ok "cpus 0.5" || fail "falta 'cpus: \"0.5\"'"
  grep -qiE '8102:3000' "$CF" && ok "puerto 8102:3000" || fail "web debe publicar 8102:3000"
fi

if [[ -f "$DS" ]]; then
  grep -qiE 'docker[[:space:]]+build' "$DS" && ok "deploy.sh construye imagen" || fail "deploy.sh debe construir la imagen (docker build)"
  grep -qiE 'docker[[:space:]]+stack[[:space:]]+deploy' "$DS" && ok "deploy.sh usa stack deploy" || fail "deploy.sh debe usar 'docker stack deploy'"
  grep -qiE 'docker-compose\.yml' "$DS" && ok "deploy.sh referencia compose" || fail "deploy.sh debe usar '-c docker-compose.yml'"
  if bash -n "$DS"; then ok "deploy.sh sintaxis válida"; else fail "deploy.sh tiene errores de sintaxis"; fi
fi

if [[ -f "$DS" ]] && command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1 && docker info 2>/dev/null | grep -qi 'Swarm: active'; then
  if bash "$DS" >/dev/null 2>&1; then
    ok "docker stack deploy OK"
    sleep 5
    if docker service ls 2>/dev/null | grep -qi miapp; then ok "servicio miapp desplegado"; else fail "servicio miapp no encontrado"; fi
    docker stack rm miapp >/dev/null 2>&1 || true
  else fail "docker stack deploy falló"; fi
else MSGS+=("INFO - Swarm no disponible, se omite el deploy real"); fi

printf '%s\n' "${MSGS[@]}"
if [[ "$FAIL" -eq 0 ]]; then echo "OK Tests pasaron ($PASS)"; exit 0
else echo "FAIL Tests fallaron ($FAIL)"; exit 1; fi
