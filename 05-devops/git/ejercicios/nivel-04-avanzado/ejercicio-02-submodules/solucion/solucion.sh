#!/bin/bash
# Solución: añadir lib-repo como submodule en vendor/lib y commitear.
set -euo pipefail
MAIN="$1"
LIB="$2"
cd "$MAIN"

git submodule add -q "$LIB" vendor/lib
git commit -q -m "chore: añade lib como submodule"
