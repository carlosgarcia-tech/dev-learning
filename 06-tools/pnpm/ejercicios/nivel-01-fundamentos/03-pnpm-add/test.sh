#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
node -p "require('./$DIR/package.json').dependencies.express" | grep -q . || { echo "express falta"; exit 1; }
node -p "require('./$DIR/package.json').devDependencies.jest" | grep -q . || { echo "jest falta"; exit 1; }
echo "OK"
