#!/usr/bin/env bash
set -euo pipefail
DEST="${1:-$(pwd)}"
mkdir -p "$DEST/src/config"
printf 'datos originales\n' > "$DEST/src/original.txt"
printf 'port=8080\n' > "$DEST/src/config/app.conf"
