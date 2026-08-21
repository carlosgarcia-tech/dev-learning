#!/usr/bin/env bash
set -euo pipefail
DEST="${1:-$(pwd)}"
mkdir -p "$DEST/repo/src" "$DEST/repo/docs"
printf '# Repo\n' > "$DEST/repo/README.md"
: > "$DEST/repo/servidor.log"
for i in $(seq -w 1 20); do printf 'Linea %s\n' "$i" >> "$DEST/repo/servidor.log"; done
printf 'def main():\n    # TODO: refactorizar\n    return 0\n' > "$DEST/repo/src/main.py"
printf 'def util():\n    return 1\n' > "$DEST/repo/src/utils.py"
printf '# API docs\n' > "$DEST/repo/docs/api.md"
