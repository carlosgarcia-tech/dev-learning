#!/usr/bin/env bash
set -euo pipefail
DEST="${1:-$(pwd)}"
mkdir -p "$DEST/datos"
cd "$DEST/datos"
head -c 10240 /dev/zero | tr '\0' 'a' > grande.log
printf 'x' > chico.txt
printf 'cfg' > .oculto.cfg
printf 'hola\n' > nota1.txt
printf 'mundo\n' > nota2.txt
printf 'PNG' > imagen.png
