#!/usr/bin/env bash
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

cd "$TMP"
bash "$HERE/solucion.sh"

fail=0
for f in log_arranque.txt log_errores.txt log_kernel.txt resumen_prioridades.txt; do
  [ -f "$f" ] || { echo "FAIL: falta $f"; fail=1; }
done
# resumen_prioridades.txt debe contener un número
grep -Eq '^[[:space:]]*[0-9]+[[:space:]]*$' resumen_prioridades.txt || { echo "FAIL: resumen_prioridades.txt no es un número"; fail=1; }

# Si el journal está disponible, log_arranque no debería estar vacío
if journalctl -b --no-pager >/dev/null 2>&1; then
  [ -s log_arranque.txt ] || { echo "FAIL: journal disponible pero log_arranque.txt vacío"; fail=1; }
fi

if [ "$fail" -eq 0 ]; then
  echo "OK Tests pasaron"; exit 0
else
  echo "FAIL Tests fallaron"; exit 1
fi
