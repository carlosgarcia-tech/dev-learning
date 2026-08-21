#!/usr/bin/env bash
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

bash "$HERE/setup.sh" "$TMP"
cp "$HERE/solucion.sh" "$TMP/solucion.sh"
cd "$TMP"
bash ./solucion.sh

fail=0
[ -x procesar.sh ] || { echo "FAIL: procesar.sh no existe o no es ejecutable"; fail=1; }
out_count=$(find procesados -name "*.out" 2>/dev/null | wc -l)
[ "$out_count" -eq 12 ] || { echo "FAIL: se esperaban 12 .out, hay $out_count"; fail=1; }
[ -s tiempo_secuencial.txt ] || { echo "FAIL: tiempo_secuencial.txt vacío"; fail=1; }
[ -s tiempo_paralelo.txt ] || { echo "FAIL: tiempo_paralelo.txt vacío"; fail=1; }
grep -q "Secuencial:" comparacion.txt || { echo "FAIL: comparacion.txt sin 'Secuencial:'"; fail=1; }
grep -q "Paralelo:" comparacion.txt || { echo "FAIL: comparacion.txt sin 'Paralelo:'"; fail=1; }
grep -q "Aceleracion:" comparacion.txt || { echo "FAIL: comparacion.txt sin 'Aceleracion:'"; fail=1; }

# Verificar que el paralelo fue más rápido (o igual, por tolerancia del sistema)
sec=$(grep -o '[0-9]*' tiempo_secuencial.txt | head -1)
par=$(grep -o '[0-9]*' tiempo_paralelo.txt | head -1)
if [ -n "$sec" ] && [ -n "$par" ] && [ "$sec" -gt 0 ]; then
  [ "$par" -le "$sec" ] || { echo "FAIL: paralelo ($par) fue más lento que secuencial ($sec)"; fail=1; }
fi

if [ "$fail" -eq 0 ]; then
  echo "OK Tests pasaron"; exit 0
else
  echo "FAIL Tests fallaron"; exit 1
fi
