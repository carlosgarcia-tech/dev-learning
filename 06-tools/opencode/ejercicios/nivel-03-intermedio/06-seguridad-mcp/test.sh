#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/respuesta.txt" ] || { echo "Falta respuesta.txt"; exit 1; }
grep -qi "riesgo\|sensibl" "$DIR/respuesta.txt" || { echo "No menciona riesgos"; exit 1; }
grep -qi "mitig\|variable\|limit" "$DIR/respuesta.txt" || { echo "No menciona mitigación"; exit 1; }
echo "OK"
