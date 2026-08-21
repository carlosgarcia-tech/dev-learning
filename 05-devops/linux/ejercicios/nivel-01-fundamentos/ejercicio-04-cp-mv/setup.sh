#!/usr/bin/env bash
set -euo pipefail
DEST="${1:-$(pwd)}"
mkdir -p "$DEST/origen/notas"
printf 'clave: valor\n' > "$DEST/origen/config.yml"
printf 'nota a\n' > "$DEST/origen/notas/a.txt"
printf 'nota b\n' > "$DEST/origen/notas/b.txt"
printf '<html></html>\n' > "$DEST/origen/plantilla.html"
