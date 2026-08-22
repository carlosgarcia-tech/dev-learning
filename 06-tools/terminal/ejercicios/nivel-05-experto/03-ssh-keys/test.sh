#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/respuesta.txt" ] || { echo "Falta respuesta.txt"; exit 1; }
grep -qi "ssh-keygen" "$DIR/respuesta.txt" || { echo "No menciona ssh-keygen"; exit 1; }
grep -qi "ssh-copy-id" "$DIR/respuesta.txt" || { echo "No menciona ssh-copy-id"; exit 1; }
echo "OK"
