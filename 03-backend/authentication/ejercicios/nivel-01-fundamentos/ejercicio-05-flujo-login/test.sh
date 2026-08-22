#!/usr/bin/env bash
# Validación del ejercicio 05 - Flujo de login.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

LOGIN_FILE="login.json"

if [[ ! -f "$LOGIN_FILE" ]]; then
  echo "FAIL: falta $LOGIN_FILE"
  fail
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "FAIL: se requiere python3"
  fail
fi

python3 - "$LOGIN_FILE" <<'PY'
import json, sys

with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)

errors = []

intentos = data.get("intentos", [])
if len(intentos) != 2:
    errors.append(f"Debe haber 2 intentos, hay {len(intentos)}")
    print_errors = True
else:
    # Intento 1: correcto
    i1 = intentos[0]
    if i1.get("status") != "success":
        errors.append(f"Intento 1: status debe ser 'success', es '{i1.get('status')}'")
    if i1.get("authenticated") is not True:
        errors.append("Intento 1: authenticated debe ser true")
    if not i1.get("user_id"):
        errors.append("Intento 1: user_id no puede estar vacío")
    
    # Intento 2: incorrecto
    i2 = intentos[1]
    if i2.get("status") != "error":
        errors.append(f"Intento 2: status debe ser 'error', es '{i2.get('status')}'")
    if i2.get("authenticated") is not False:
        errors.append("Intento 2: authenticated debe ser false")
    if i2.get("user_id") is not None:
        errors.append("Intento 2: user_id debe ser null")
    
    # Mensaje genérico (no revela qué falló)
    msg = i2.get("message", "").lower()
    if "contraseña" in msg or "password" in msg or "email" in msg or "usuario" in msg:
        errors.append("Intento 2: el mensaje revela qué credencial falló")
    if "credencial" not in msg and "inválid" not in msg:
        errors.append("Intento 2: el mensaje debe contener 'credenciales' o 'inválid'")

if errors:
    for e in errors:
        print(f"FAIL: {e}")
    sys.exit(1)

print("OK Tests pasaron")
PY
