#!/bin/bash
# Solución: hacer pull en clon-b para integrar el commit del remoto.
set -euo pipefail
CLON_B="${1:-.}"
cd "$CLON_B"

git pull -q origin main
