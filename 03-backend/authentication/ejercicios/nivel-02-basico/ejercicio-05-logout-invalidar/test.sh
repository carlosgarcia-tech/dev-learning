#!/usr/bin/env bash
# Validación del ejercicio 05 - Logout invalidar.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

LOGOUT_FILE="logout.json"

if [[ ! -f "$LOGOUT_FILE" ]]; then
  echo "FAIL: falta $LOGOUT_FILE"
  fail
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "FAIL: se requiere python3"
  fail
fi

python3 - "$LOGOUT_FILE" <<'PY'
import json, sys

with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)

errors = []

# logout_correcto
lc = data.get("logout_correcto", {})
if lc.get("sesion_invalidada") is not True:
    errors.append("logout_correcto.sesion_invalidada debe ser true")
if lc.get("cookie_borrada") is not True:
    errors.append("logout_correcto.cookie_borrada debe ser true")
if lc.get("token_reutilizable") is not False:
    errors.append("logout_correcto.token_reutilizable debe ser false")

# logout_incorrecto
li = data.get("logout_incorrecto", {})
if li.get("sesion_invalidada") is not False:
    errors.append("logout_incorrecto.sesion_invalidada debe ser false")
if li.get("cookie_borrada") is not True:
    errors.append("logout_incorrecto.cookie_borrada debe ser true")
if li.get("token_reutilizable") is not True:
    errors.append("logout_incorrecto.token_reutilizable debe ser true")

# pasos: mínimo 3
pasos = data.get("pasos", [])
if len(pasos) < 3:
    errors.append(f"pasos debe tener mínimo 3 elementos, tiene {len(pasos)}")

if errors:
    for e in errors:
        print(f"FAIL: {e}")
    sys.exit(1)

print("OK Tests pasaron")
PY
