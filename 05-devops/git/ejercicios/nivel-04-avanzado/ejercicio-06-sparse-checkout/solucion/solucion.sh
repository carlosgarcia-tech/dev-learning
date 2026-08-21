#!/bin/bash
# Solución: clonar sin checkout, activar sparse-checkout no-cone para un archivo concreto, checkout.
set -euo pipefail
ORIGIN="${1:-.}"
cd "$(dirname "$ORIGIN")"

git clone -q --no-checkout "$ORIGIN" clon
cd clon
# En modo no-cone se admiten patrones de archivos concretos (no solo directorios)
git sparse-checkout set --no-cone "apps/web.txt"
git checkout main
