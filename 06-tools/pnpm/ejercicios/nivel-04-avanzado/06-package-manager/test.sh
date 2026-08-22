#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
PM=$(node -p "require('./$DIR/package.json').packageManager || ''")
echo "$PM" | grep -q "pnpm@" || { echo "packageManager incorrecto: $PM"; exit 1; }
echo "OK"
