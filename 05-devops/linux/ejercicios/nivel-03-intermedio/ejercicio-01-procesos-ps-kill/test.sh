#!/usr/bin/env bash
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

cd "$TMP"
bash "$HERE/solucion.sh"

fail=0
[ -s proceso.txt ] || { echo "FAIL: proceso.txt vacío"; fail=1; }
[ "$(cat estado.txt)" = "vivo" ] || { echo "FAIL: estado.txt = $(cat estado.txt), esperado vivo"; fail=1; }
[ "$(cat estado_final.txt)" = "muerto" ] || { echo "FAIL: estado_final.txt = $(cat estado_final.txt), esperado muerto"; fail=1; }
[ -f todos_sleep.txt ] || { echo "FAIL: todos_sleep.txt no existe"; fail=1; }

if [ "$fail" -eq 0 ]; then
  echo "OK Tests pasaron"; exit 0
else
  echo "FAIL Tests fallaron"; exit 1
fi
