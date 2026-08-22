#!/usr/bin/env bash
# Validación del ejercicio 01 - Hashing con bcrypt.
# Comprueba que hash.json tiene el formato bcrypt correcto.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

HASH_FILE="hash.json"

# 1. Archivo existe
if [[ ! -f "$HASH_FILE" ]]; then
  echo "FAIL: falta $HASH_FILE"
  fail
fi

# 2. python3 disponible
if ! command -v python3 >/dev/null 2>&1; then
  echo "FAIL: se requiere python3"
  fail
fi

# 3. Validar JSON y campos con python3
python3 - "$HASH_FILE" <<'PY'
import json, sys, re

with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)

errors = []

# algorithm
if data.get("algorithm") != "bcrypt":
    errors.append(f"algorithm debe ser 'bcrypt', no '{data.get('algorithm')}'")

# version
if data.get("version") not in ("2a", "2b", "2y"):
    errors.append(f"version debe ser 2a/2b/2y, no '{data.get('version')}'")

# cost_factor
cf = data.get("cost_factor")
if not isinstance(cf, int) or cf < 4 or cf > 31:
    errors.append(f"cost_factor debe ser un entero 4-31, es {cf}")

# salt: 22 chars
salt = data.get("salt", "")
if len(salt) != 22:
    errors.append(f"salt debe tener 22 caracteres, tiene {len(salt)}")

# password_hash: formato bcrypt completo
ph = data.get("password_hash", "")
pattern = r'^\$2[aby]\$\d{2}\$[A-Za-z0-9./]{53}$'
if not re.match(pattern, ph):
    errors.append("password_hash no tiene formato bcrypt válido")

# El salt debe estar contenido en el password_hash
if salt and salt not in ph:
    errors.append("salt no aparece dentro de password_hash")

if errors:
    for e in errors:
        print(f"FAIL: {e}")
    sys.exit(1)

print("OK Tests pasaron")
PY
