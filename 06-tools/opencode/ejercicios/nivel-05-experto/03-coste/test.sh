#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/respuesta.txt" ] || { echo "Falta respuesta.txt"; exit 1; }
grep -qi "smallModel\|modelo pequeño" "$DIR/respuesta.txt" || { echo "No menciona smallModel"; exit 1; }
grep -qi "sesion\|contexto" "$DIR/respuesta.txt" || { echo "No menciona sesiones/contexto"; exit 1; }
echo "OK"
