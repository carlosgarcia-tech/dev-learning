#!/usr/bin/env bash
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

cd "$TMP"
bash "$HERE/solucion.sh"

fail=0
[ -s informe.txt ] || { echo "FAIL: informe.txt vacío o no existe"; fail=1; }
grep -q "=== Informe del sistema" informe.txt || { echo "FAIL: falta la cabecera del informe"; fail=1; }
for sec in "## CPU" "## Memoria" "## Disco" "## Top 5 CPU" "## Top 5 Memoria" "## Resumen"; do
  grep -qF "$sec" informe.txt || { echo "FAIL: falta la sección '$sec'"; fail=1; }
done
grep -q "Load average:" informe.txt || { echo "FAIL: falta 'Load average:' en Resumen"; fail=1; }
grep -q "Memoria disponible:" informe.txt || { echo "FAIL: falta 'Memoria disponible:' en Resumen"; fail=1; }

if [ "$fail" -eq 0 ]; then
  echo "OK Tests pasaron"; exit 0
else
  echo "FAIL Tests fallaron"; exit 1
fi
