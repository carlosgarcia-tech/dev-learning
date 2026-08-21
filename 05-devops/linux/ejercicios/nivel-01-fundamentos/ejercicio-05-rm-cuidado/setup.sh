#!/usr/bin/env bash
set -euo pipefail
DEST="${1:-$(pwd)}"
mkdir -p "$DEST/tmp/basura"
printf 'debug\n' > "$DEST/tmp/debug.log"
printf 'error\n' > "$DEST/tmp/error.log"
printf 'info\n'   > "$DEST/tmp/info.log"
printf 'NO BORRAR\n' > "$DEST/tmp/importante.txt"
printf 'a\n' > "$DEST/tmp/basura/a.tmp"
printf 'b\n' > "$DEST/tmp/basura/b.tmp"
