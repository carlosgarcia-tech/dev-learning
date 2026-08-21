#!/usr/bin/env bash
set -euo pipefail
DEST="${1:-$(pwd)}"
seq 1 100 > "$DEST/numeros.txt"
