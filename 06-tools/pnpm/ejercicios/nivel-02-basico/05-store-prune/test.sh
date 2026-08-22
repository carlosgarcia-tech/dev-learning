#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/prune.txt" ] || { echo "Falta prune.txt"; exit 1; }
[ -f "$DIR/respuesta.txt" ] || { echo "Falta respuesta.txt"; exit 1; }
grep -qi "prune\|eliminar\|liberar" "$DIR/respuesta.txt" || { echo "Respuesta incompleta"; exit 1; }
echo "OK"
