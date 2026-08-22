#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
F="$DIR/.gitignore"
[ -f "$F" ] || { echo "Falta .gitignore"; exit 1; }
grep -q "node_modules" "$F" || { echo "Falta node_modules"; exit 1; }
grep -q ".env" "$F" || { echo "Falta .env"; exit 1; }
! grep -qx "package.json" "$F" || { echo "package.json no debe ignorarse"; exit 1; }
! grep -qx "package-lock.json" "$F" || { echo "package-lock.json no debe ignorarse"; exit 1; }
echo "OK"
