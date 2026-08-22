#!/usr/bin/env bash
set -euo pipefail
DIR="solucion"
[ -f "$DIR/ssh-config" ] || { echo "Falta ssh-config"; exit 1; }
grep -q "Host mi-servidor" "$DIR/ssh-config" || { echo "Falta Host"; exit 1; }
grep -q "HostName" "$DIR/ssh-config" || { echo "Falta HostName"; exit 1; }
grep -q "User" "$DIR/ssh-config" || { echo "Falta User"; exit 1; }
echo "OK"
