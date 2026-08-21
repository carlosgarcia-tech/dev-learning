#!/usr/bin/env bash
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

cd "$TMP"
bash "$HERE/solucion.sh"

fail=0
[ -f reglas.sh ] || { echo "FAIL: no se creó reglas.sh"; fail=1; }
[ -x reglas.sh ] || { echo "FAIL: reglas.sh no es ejecutable"; fail=1; }
[ -s resumen.txt ] || { echo "FAIL: resumen.txt vacío"; fail=1; }

# Comprobar las 8 líneas en orden
grep -qx 'ufw default deny incoming' reglas.sh || { echo "FAIL: falta 'default deny incoming'"; fail=1; }
grep -qx 'ufw default allow outgoing' reglas.sh || { echo "FAIL: falta 'default allow outgoing'"; fail=1; }
grep -qx 'ufw allow 22/tcp' reglas.sh || { echo "FAIL: falta 'allow 22/tcp'"; fail=1; }
grep -qx 'ufw allow 80/tcp' reglas.sh || { echo "FAIL: falta 'allow 80/tcp'"; fail=1; }
grep -qx 'ufw allow 443/tcp' reglas.sh || { echo "FAIL: falta 'allow 443/tcp'"; fail=1; }
grep -qx 'ufw allow from 192.168.1.0/24 to any port 5432' reglas.sh || { echo "FAIL: falta regla 5432 LAN"; fail=1; }
grep -qx 'ufw deny 3306' reglas.sh || { echo "FAIL: falta 'deny 3306'"; fail=1; }
grep -qx 'ufw enable' reglas.sh || { echo "FAIL: falta 'ufw enable'"; fail=1; }

# Orden: deny incoming antes que allow 22
line_deny=$(grep -nx 'ufw default deny incoming' reglas.sh | cut -d: -f1)
line_ssh=$(grep -nx 'ufw allow 22/tcp' reglas.sh | cut -d: -f1)
[ "$line_deny" -lt "$line_ssh" ] || { echo "FAIL: el orden es incorrecto (deny debe ir antes que allow 22)"; fail=1; }

if [ "$fail" -eq 0 ]; then
  echo "OK Tests pasaron"; exit 0
else
  echo "FAIL Tests fallaron"; exit 1
fi
