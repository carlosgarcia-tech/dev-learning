#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/ci.yml" ] || { echo "Falta ci.yml"; exit 1; }
grep -q "pnpm/action-setup" "$DIR/ci.yml" || { echo "Falta pnpm/action-setup"; exit 1; }
grep -q "frozen-lockfile" "$DIR/ci.yml" || { echo "Falta frozen-lockfile"; exit 1; }
echo "OK"
