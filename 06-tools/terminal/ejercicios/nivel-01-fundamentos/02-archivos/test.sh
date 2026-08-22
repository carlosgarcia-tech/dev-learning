#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/notas.txt" ] || { echo "Falta notas.txt"; exit 1; }
[ -d "$DIR/backups" ] || { echo "Falta backups/"; exit 1; }
[ -d "$DIR/a/b/c" ] || { echo "Falta a/b/c/"; exit 1; }
echo "OK"
