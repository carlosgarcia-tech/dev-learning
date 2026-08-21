#!/usr/bin/env bash
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

bash "$HERE/setup.sh" "$TMP"
cd "$TMP"
bash "$HERE/solucion.sh"

fail=0
[ -s "logs/errores.txt" ] || { echo "FAIL: errores.txt vacío"; fail=1; }
grep -q "ERROR" logs/errores.txt || { echo "FAIL: errores.txt no contiene ERROR"; fail=1; }
[ -s "logs/sin_debug.txt" ] || { echo "FAIL: sin_debug.txt vacío"; fail=1; }
if grep -qi "debug" logs/sin_debug.txt; then echo "FAIL: sin_debug.txt contiene debug"; fail=1; fi
[ -s "logs/cuenta_warning.txt" ] || { echo "FAIL: cuenta_warning.txt vacío"; fail=1; }
[ -s "logs/errores_o_info.txt" ] || { echo "FAIL: errores_o_info.txt vacío"; fail=1; }
[ -f "logs/backup.tar.gz" ] || { echo "FAIL: backup.tar.gz no existe"; fail=1; }
tar tzf logs/backup.tar.gz | grep -q "app.log" || { echo "FAIL: app.log no está en el tar"; fail=1; }
tar tzf logs/backup.tar.gz | grep -q "server.log" || { echo "FAIL: server.log no está en el tar"; fail=1; }
[ -s "logs/contenido_tar.txt" ] || { echo "FAIL: contenido_tar.txt vacío"; fail=1; }

if [ "$fail" -eq 0 ]; then
  echo "OK Tests pasaron"; exit 0
else
  echo "FAIL Tests fallaron"; exit 1
fi
