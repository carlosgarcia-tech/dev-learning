#!/usr/bin/env bash
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

bash "$HERE/setup.sh" "$TMP"
cd "$TMP"
bash "$HERE/solucion.sh"

fail=0
[ "$(tr -d ' \n' < totales.txt)" = "46" ] || { echo "FAIL: totales.txt=$(cat totales.txt), esperado 46"; fail=1; }
ing=$(tr -d ' \n' < ingresos.txt)
case "$ing" in
  33|33.6) : ;;
  *) echo "FAIL: ingresos.txt=$ing, esperado 33 o 33.6"; fail=1;;
esac
grep -qx "manzana" productos_unicos.txt || { echo "FAIL: falta manzana en productos_unicos.txt"; fail=1; }
grep -qx "pan"      productos_unicos.txt || { echo "FAIL: falta pan en productos_unicos.txt"; fail=1; }
grep -qx "leche"    productos_unicos.txt || { echo "FAIL: falta leche en productos_unicos.txt"; fail=1; }
[ "$(wc -l < productos_unicos.txt)" -eq 3 ] || { echo "FAIL: productos_unicos.txt debería tener 3 líneas, tiene $(wc -l < productos_unicos.txt)"; fail=1; }
head -n1 ventas_pan.txt | grep -q "producto" || { echo "FAIL: ventas_pan.txt no tiene cabecera"; fail=1; }
[ "$(grep -c "^pan," ventas_pan.txt)" -eq 2 ] || { echo "FAIL: ventas_pan.txt no tiene 2 filas de pan"; fail=1; }
[ "$(tr -d ' \n' < resumen.txt)" = "6" ] || { echo "FAIL: resumen.txt=$(cat resumen.txt), esperado 6"; fail=1; }

if [ "$fail" -eq 0 ]; then
  echo "OK Tests pasaron"; exit 0
else
  echo "FAIL Tests fallaron"; exit 1
fi
