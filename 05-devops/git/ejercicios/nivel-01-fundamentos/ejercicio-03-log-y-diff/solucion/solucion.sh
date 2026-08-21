#!/bin/bash
# Solución: modificar README.md sin commitear.
set -euo pipefail
REPO_DIR="${1:-.}"
cd "$REPO_DIR"

echo "## Instalación" >> README.md
