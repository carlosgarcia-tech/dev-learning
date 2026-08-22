#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/respuesta.txt" ] || { echo "Falta respuesta.txt"; exit 1; }
grep -qi "injection\|malicioso" "$DIR/respuesta.txt" || { echo "No explica injection"; exit 1; }
grep -qi "mitig\|no confiable\|revis" "$DIR/respuesta.txt" || { echo "No menciona mitigación"; exit 1; }
echo "OK"
