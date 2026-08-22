#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/respuesta.txt" ] || { echo "Falta respuesta.txt"; exit 1; }
grep -qi "ssh-agent" "$DIR/respuesta.txt" || { echo "No menciona ssh-agent"; exit 1; }
grep -qi "ssh-add" "$DIR/respuesta.txt" || { echo "No menciona ssh-add"; exit 1; }
grep -qi "ForwardAgent" "$DIR/respuesta.txt" || { echo "No menciona ForwardAgent"; exit 1; }
echo "OK"
