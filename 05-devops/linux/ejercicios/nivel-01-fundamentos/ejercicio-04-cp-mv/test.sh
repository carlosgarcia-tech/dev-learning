#!/usr/bin/env bash
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

bash "$HERE/setup.sh" "$TMP"
cd "$TMP"
bash "$HERE/solucion.sh"

fail=0
[ -f "destino/config.yml" ] || { echo "FAIL: falta destino/config.yml"; fail=1; }
[ -f "destino/notas/a.txt" ] || { echo "FAIL: falta destino/notas/a.txt"; fail=1; }
[ -f "destino/notas/b.txt" ] || { echo "FAIL: falta destino/notas/b.txt"; fail=1; }
[ -f "destino/index.html" ] || { echo "FAIL: falta destino/index.html"; fail=1; }
[ ! -f "origen/plantilla.html" ] || { echo "FAIL: origen/plantilla.html sigue existiendo"; fail=1; }
[ ! -f "origen/config.yml" ] || { echo "FAIL: origen/config.yml sigue existiendo"; fail=1; }

if [ "$fail" -eq 0 ]; then
  echo "OK Tests pasaron"; exit 0
else
  echo "FAIL Tests fallaron"; exit 1
fi
