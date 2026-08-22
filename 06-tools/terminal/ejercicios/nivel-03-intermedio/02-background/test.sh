#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/pid.txt" ] || { echo "Falta pid.txt"; exit 1; }
grep -qE "^[0-9]+" "$DIR/pid.txt" || { echo "pid.txt no tiene un PID"; exit 1; }
echo "OK"
