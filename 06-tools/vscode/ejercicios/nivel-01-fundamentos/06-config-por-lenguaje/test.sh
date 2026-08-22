#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/settings.json" ] || { echo "Falta settings.json"; exit 1; }
node -p "require('./$DIR/settings.json')['[python]']['editor.tabSize']" | grep -q 4 || { echo "Python tabSize debe ser 4"; exit 1; }
node -p "require('./$DIR/settings.json')['[javascript]']['editor.tabSize']" | grep -q 2 || { echo "JS tabSize debe ser 2"; exit 1; }
echo "OK"
