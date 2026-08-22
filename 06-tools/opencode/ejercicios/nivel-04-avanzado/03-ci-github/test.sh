#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/ci.yml" ] || { echo "Falta ci.yml"; exit 1; }
grep -q "opencode" "$DIR/ci.yml" || { echo "No menciona opencode"; exit 1; }
grep -q "OPENCODE_API_KEY" "$DIR/ci.yml" || { echo "Falta API key"; exit 1; }
echo "OK"
