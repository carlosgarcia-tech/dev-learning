#!/usr/bin/env bash
set -euo pipefail
DEST="${1:-$(pwd)}"
mkdir -p "$DEST/proyecto/carpeta"
printf '#!/bin/bash\necho hola\n' > "$DEST/proyecto/script.sh"
printf 'SECRET=12345\n' > "$DEST/proyecto/secreto.key"
printf 'contenido publico\n' > "$DEST/proyecto/publico.txt"
printf 'dentro\n' > "$DEST/proyecto/carpeta/dentro.txt"
chmod 644 "$DEST/proyecto/script.sh" "$DEST/proyecto/secreto.key" "$DEST/proyecto/publico.txt" "$DEST/proyecto/carpeta/dentro.txt"
chmod 755 "$DEST/proyecto/carpeta"
