#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/.opencodeignore" ] || { echo "Falta .opencodeignore"; exit 1; }
grep -q ".env" "$DIR/.opencodeignore" || { echo "Falta .env"; exit 1; }
grep -q "\.key" "$DIR/.opencodeignore" || { echo "Falta *.key"; exit 1; }
echo "OK"
