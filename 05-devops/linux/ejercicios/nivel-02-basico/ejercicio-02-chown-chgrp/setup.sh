#!/usr/bin/env bash
set -euo pipefail
DEST="${1:-$(pwd)}"
mkdir -p "$DEST/datos/carpeta"
printf 'compartido\n' > "$DEST/datos/compartido.txt"
printf 'local\n'     > "$DEST/datos/local.txt"
printf 'uno\n'       > "$DEST/datos/carpeta/a.txt"
printf 'dos\n'       > "$DEST/datos/carpeta/b.txt"
