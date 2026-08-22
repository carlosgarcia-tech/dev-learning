#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
LO=$(node -p "require('./$DIR/package.json').dependencies.lodash || ''")
CH=$(node -p "require('./$DIR/package.json').dependencies.chalk || ''")
AX=$(node -p "require('./$DIR/package.json').dependencies.axios || ''")
[[ "$LO" == ^* ]] || { echo "lodash debe empezar con ^"; exit 1; }
[[ "$CH" == ~* ]] || { echo "chalk debe empezar con ~"; exit 1; }
[[ "$AX" =~ ^[0-9] ]] || { echo "axios debe ser versión exacta"; exit 1; }
echo "OK"
