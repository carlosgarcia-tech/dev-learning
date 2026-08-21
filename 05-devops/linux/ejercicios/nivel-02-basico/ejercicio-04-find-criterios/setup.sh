#!/usr/bin/env bash
set -euo pipefail
DEST="${1:-$(pwd)}"
mkdir -p "$DEST/archivos/subdir"
cd "$DEST/archivos"
head -c 12000 /dev/zero | tr '\0' 'a' > grande.log      # >10 KB
printf '' > vacio.txt                                    # vacío
printf 'app log\n' > app.log
printf 'nota\n' > nota.txt
printf 'copia vieja\n' > config.bak
printf 'otra copia\n' > datos.bak
printf 'sub\n' > subdir/dentro.txt
