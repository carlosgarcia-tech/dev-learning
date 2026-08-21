#!/usr/bin/env bash
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

bash "$HERE/setup.sh" "$TMP"
cd "$TMP"
bash "$HERE/solucion.sh"

fail=0
# peticiones_por_ip.txt: 192.168.1.10 aparece 3 veces, 192.168.1.11 2 veces
grep -q "192.168.1.10" peticiones_por_ip.txt || { echo "FAIL: falta 192.168.1.10 en peticiones_por_ip.txt"; fail=1; }
grep -q "192.168.1.11" peticiones_por_ip.txt || { echo "FAIL: falta 192.168.1.11 en peticiones_por_ip.txt"; fail=1; }
grep -E "192.168.1.10.*3" peticiones_por_ip.txt >/dev/null || { echo "FAIL: 192.168.1.10 debería tener 3 peticiones"; fail=1; }

# codigos_estado.txt: 200 aparece 4 veces, 401 una vez, 404 una vez, 500 una vez
grep -q "200" codigos_estado.txt || { echo "FAIL: falta codigo 200 en codigos_estado.txt"; fail=1; }
grep -q "401" codigos_estado.txt || { echo "FAIL: falta codigo 401 en codigos_estado.txt"; fail=1; }
grep -E "200.*4" codigos_estado.txt >/dev/null || { echo "FAIL: codigo 200 debería tener 4"; fail=1; }

# peticiones_4xx_5xx.txt: solo líneas con códigos 4xx/5xx (401, 404, 500)
[ -s peticiones_4xx_5xx.txt ] || { echo "FAIL: peticiones_4xx_5xx.txt vacío"; fail=1; }
lineas_4xx=$(wc -l < peticiones_4xx_5xx.txt)
[ "$lineas_4xx" -eq 3 ] || { echo "FAIL: peticiones_4xx_5xx.txt tiene $lineas_4xx líneas, esperadas 3"; fail=1; }
if grep -E ' (200|301|302)$' peticiones_4xx_5xx.txt >/dev/null; then
  echo "FAIL: peticiones_4xx_5xx.txt contiene códigos no-4xx/5xx"; fail=1
fi

# ip_top.txt: la IP con más peticiones (192.168.1.10 con 3)
grep -q "IP_TOP" ip_top.txt || { echo "FAIL: ip_top.txt no tiene formato IP_TOP"; fail=1; }
grep -q "192.168.1.10" ip_top.txt || { echo "FAIL: la IP top debería ser 192.168.1.10"; fail=1; }

# resumen.txt
grep -q "Total de peticiones: 8" resumen.txt || { echo "FAIL: resumen.txt no muestra total 8"; fail=1; }
grep -q "IPs distintas: 4" resumen.txt || { echo "FAIL: resumen.txt no muestra 4 IPs distintas"; fail=1; }
grep -q "Errores (4xx/5xx): 3" resumen.txt || { echo "FAIL: resumen.txt no muestra 3 errores"; fail=1; }

if [ "$fail" -eq 0 ]; then
  echo "OK Tests pasaron"; exit 0
else
  echo "FAIL Tests fallaron"; exit 1
fi
