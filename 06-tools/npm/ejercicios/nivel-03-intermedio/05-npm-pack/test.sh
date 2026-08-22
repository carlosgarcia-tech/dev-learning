#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/dryrun.txt" ] || { echo "Falta dryrun.txt"; exit 1; }
grep -qi "package.json" "$DIR/dryrun.txt" || { echo "No se menciona package.json"; exit 1; }
echo "OK"
