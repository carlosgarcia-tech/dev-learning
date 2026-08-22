#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/procesos.txt" ] || { echo "Falta procesos.txt"; exit 1; }
[ -f "$DIR/bash-procs.txt" ] || { echo "Falta bash-procs.txt"; exit 1; }
echo "OK"
