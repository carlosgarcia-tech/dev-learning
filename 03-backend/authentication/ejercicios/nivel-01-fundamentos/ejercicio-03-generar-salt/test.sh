#!/usr/bin/env bash
# Validación del ejercicio 03 - Generar salt para bcrypt.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

SALT_FILE="salt.json"

if [[ ! -f "$SALT_FILE" ]]; then
  echo "FAIL: falta $SALT_FILE"
  fail
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "FAIL: se requiere python3"
  fail
fi

python3 - "$SALT_FILE" <<'PY'
import json, sys, re

with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)

errors = []

salt = data.get("salt", "")
salt_ref = data.get("salt_referencia", "")

# salt: 22 chars del alfabeto base64
if len(salt) != 22:
    errors.append(f"salt debe tener 22 caracteres, tiene {len(salt)}")
else:
    if not re.match(r'^[A-Za-z0-9./]{22}$', salt):
        errors.append("salt solo debe contener [A-Za-z0-9./]")

# salt debe ser distinto de referencia
if salt == salt_ref:
    errors.append("salt debe ser distinto de salt_referencia")

# longitud
if data.get("longitud") != 22:
    errors.append(f"longitud debe ser 22, es {data.get('longitud')}")

# alfabeto
if data.get("alfabeto") != "[A-Za-z0-9./]":
    errors.append(f"alfabeto debe ser '[A-Za-z0-9./]', es '{data.get('alfabeto')}'")

# entropia_bits
if data.get("entropia_bits") != 132:
    errors.append(f"entropia_bits debe ser 132, es {data.get('entropia_bits')}")

if errors:
    for e in errors:
        print(f"FAIL: {e}")
    sys.exit(1)

print("OK Tests pasaron")
PY
