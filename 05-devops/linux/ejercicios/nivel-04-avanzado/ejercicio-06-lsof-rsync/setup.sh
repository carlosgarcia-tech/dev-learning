#!/usr/bin/env bash
set -euo pipefail
DEST="${1:-$(pwd)}"
mkdir -p "$DEST/origen" "$DEST/destino"
printf 'uno\n' > "$DEST/origen/a.txt"
printf 'dos\n' > "$DEST/origen/b.txt"
printf 'tres\n' > "$DEST/origen/c.txt"
