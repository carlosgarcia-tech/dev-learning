#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/respuesta.txt" ] || { echo "Falta respuesta.txt"; exit 1; }
grep -qi "Remote-SSH\|Remote - SSH" "$DIR/respuesta.txt" || { echo "No menciona la extensión"; exit 1; }
echo "OK"
