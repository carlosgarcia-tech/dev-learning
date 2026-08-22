#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/plantilla-prompt.md" ] || { echo "Falta plantilla-prompt.md"; exit 1; }
grep -qi "test\|ARCHIVO" "$DIR/plantilla-prompt.md" || { echo "Plantilla incompleta"; exit 1; }
echo "OK"
