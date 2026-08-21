#!/usr/bin/env bash
set -euo pipefail
DEST="${1:-$(pwd)}"
mkdir -p "$DEST/img"
for i in $(seq -w 1 12); do
  head -c 2048 /dev/zero | tr '\0' 'x' > "$DEST/img/foto-${i}.txt"
done
