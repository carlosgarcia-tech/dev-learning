#!/usr/bin/env bash
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

bash "$HERE/setup.sh" "$TMP"
cd "$TMP"
bash "$HERE/solucion.sh" >/dev/null 2>&1 || true

fail=0
[ -s "datos/listado_largo.txt" ] || { echo "FAIL: listado_largo.txt vacío o no existe"; fail=1; }
[ -s "datos/listado_txt.txt" ] || { echo "FAIL: listado_txt.txt vacío o no existe"; fail=1; }
grep -q "\.oculto.cfg" "datos/listado_largo.txt" || { echo "FAIL: listado_largo no incluye el oculto"; fail=1; }

if [ "$fail" -eq 0 ]; then
  echo "OK Tests pasaron"; exit 0
else
  echo "FAIL Tests fallaron"; exit 1
fi
