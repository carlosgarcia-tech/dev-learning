#!/usr/bin/env bash
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

cd "$TMP"
bash "$HERE/solucion.sh"

fail=0
[ -s hardening.txt ] || { echo "FAIL: hardening.txt vacío o no existe"; fail=1; }
for sec in "## SSH" "## Servicios inseguros" "## Permisos sensibles" "## Actualizaciones" "## Firewall"; do
  grep -qF "$sec" hardening.txt || { echo "FAIL: falta la sección '$sec' en hardening.txt"; fail=1; }
done
[ -f aplicar.sh ] || { echo "FAIL: aplicar.sh no existe"; fail=1; }
[ -x aplicar.sh ] || { echo "FAIL: aplicar.sh no es ejecutable"; fail=1; }
grep -q "PermitRootLogin no" aplicar.sh || { echo "FAIL: aplicar.sh no contiene 'PermitRootLogin no'"; fail=1; }
grep -q "ufw enable" aplicar.sh || { echo "FAIL: aplicar.sh no contiene 'ufw enable'"; fail=1; }

if [ "$fail" -eq 0 ]; then
  echo "OK Tests pasaron"; exit 0
else
  echo "FAIL Tests fallaron"; exit 1
fi
