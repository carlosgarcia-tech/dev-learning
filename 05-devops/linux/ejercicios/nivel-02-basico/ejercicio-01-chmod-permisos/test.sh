#!/usr/bin/env bash
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

bash "$HERE/setup.sh" "$TMP"
cd "$TMP"
bash "$HERE/solucion.sh"

fail=0
[ "$(stat -c %a proyecto/script.sh)" = "755" ] || { echo "FAIL: script.sh es $(stat -c %a proyecto/script.sh), esperado 755"; fail=1; }
[ "$(stat -c %a proyecto/secreto.key)" = "600" ] || { echo "FAIL: secreto.key es $(stat -c %a proyecto/secreto.key), esperado 600"; fail=1; }
[ "$(stat -c %a proyecto/publico.txt)" = "664" ] || { echo "FAIL: publico.txt es $(stat -c %a proyecto/publico.txt), esperado 664"; fail=1; }
[ "$(stat -c %a proyecto/carpeta)" = "770" ] || { echo "FAIL: carpeta es $(stat -c %a proyecto/carpeta), esperado 770"; fail=1; }

if [ "$fail" -eq 0 ]; then
  echo "OK Tests pasaron"; exit 0
else
  echo "FAIL Tests fallaron"; exit 1
fi
