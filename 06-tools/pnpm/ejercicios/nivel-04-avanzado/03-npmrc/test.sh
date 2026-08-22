#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
F="$DIR/.npmrc"
[ -f "$F" ] || { echo "Falta .npmrc"; exit 1; }
grep -q "auto-install-peers" "$F" || { echo "Falta auto-install-peers"; exit 1; }
echo "OK"
