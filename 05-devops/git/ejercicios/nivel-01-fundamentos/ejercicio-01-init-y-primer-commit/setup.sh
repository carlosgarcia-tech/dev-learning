#!/bin/bash
# Crea un directorio temporal con un README.md pero SIN inicializar git.
# El estudiante debe hacer git init él mismo.
set -euo pipefail

REPO_DIR=$(mktemp -d)
echo "# Mi proyecto" > "$REPO_DIR/README.md"

echo "$REPO_DIR"
