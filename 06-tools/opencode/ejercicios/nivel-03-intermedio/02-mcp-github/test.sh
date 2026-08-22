#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/opencode.json" ] || { echo "Falta opencode.json"; exit 1; }
node -p "JSON.stringify(require('./$DIR/opencode.json').mcp?.github || {})" | grep -q "github" || { echo "Falta MCP github"; exit 1; }
echo "OK"
