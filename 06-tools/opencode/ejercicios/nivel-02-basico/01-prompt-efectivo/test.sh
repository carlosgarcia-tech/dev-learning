#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/prompt.txt" ] || { echo "Falta prompt.txt"; exit 1; }
grep -qi "users\|endpoint" "$DIR/prompt.txt" || { echo "Prompt incompleto"; exit 1; }
grep -qi "test" "$DIR/prompt.txt" || { echo "No menciona tests"; exit 1; }
echo "OK"
