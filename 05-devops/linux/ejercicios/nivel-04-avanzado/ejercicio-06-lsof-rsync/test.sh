#!/usr/bin/env bash
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

bash "$HERE/setup.sh" "$TMP"
cd "$TMP"
bash "$HERE/solucion.sh"

fail=0
[ -s abiertos.txt ] || { echo "FAIL: abiertos.txt vacío o no existe"; fail=1; }
[ -s puertos.txt ] || { echo "FAIL: puertos.txt vacío o no existe"; fail=1; }
[ -s sync_log.txt ] || { echo "FAIL: sync_log.txt vacío o no existe"; fail=1; }
# destino debe contener los archivos de origen
[ -f destino/a.txt ] || { echo "FAIL: destino/a.txt no existe"; fail=1; }
[ -f destino/b.txt ] || { echo "FAIL: destino/b.txt no existe"; fail=1; }
[ -f destino/c.txt ] || { echo "FAIL: destino/c.txt no existe"; fail=1; }
[ -f destino/extra.txt ] || { echo "FAIL: destino/extra.txt no existe (segunda sincronización)"; fail=1; }
[ -f origen/extra.txt ] || { echo "FAIL: origen/extra.txt no existe"; fail=1; }

if [ "$fail" -eq 0 ]; then
  echo "OK Tests pasaron"; exit 0
else
  echo "FAIL Tests fallaron"; exit 1
fi
