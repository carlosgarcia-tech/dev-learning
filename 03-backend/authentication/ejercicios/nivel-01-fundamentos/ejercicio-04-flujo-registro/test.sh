#!/usr/bin/env bash
# Validación del ejercicio 04 - Flujo de registro.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

REG_FILE="registro.json"
INPUT_FILE="input.json"

for f in "$REG_FILE" "$INPUT_FILE"; do
  if [[ ! -f "$f" ]]; then
    echo "FAIL: falta $f"
    fail
  fi
done

if ! command -v python3 >/dev/null 2>&1; then
  echo "FAIL: se requiere python3"
  fail
fi

python3 - "$REG_FILE" "$INPUT_FILE" <<'PY'
import json, sys, re

with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)
with open(sys.argv[2], encoding="utf-8") as f:
    inp = json.load(f)

errors = []

# status
if data.get("status") != "success":
    errors.append(f"status debe ser 'success', es '{data.get('status')}'")

# email
if data.get("email") != inp.get("email"):
    errors.append(f"email debe ser '{inp.get('email')}', es '{data.get('email')}'")

# email_valido
if data.get("email_valido") is not True:
    errors.append("email_valido debe ser true")

# password_valida
if data.get("password_valida") is not True:
    errors.append("password_valida debe ser true")

# password_hash formato bcrypt
ph = data.get("password_hash", "")
if not re.match(r'^\$2[aby]\$\d{2}\$[A-Za-z0-9./]{53}$', ph):
    errors.append("password_hash no tiene formato bcrypt válido")

# password_hash NO contiene la password original
if inp.get("password", "") and inp["password"] in ph:
    errors.append("password_hash NO debe contener la password original")

# user_id no vacío
if not data.get("user_id"):
    errors.append("user_id no puede estar vacío")

# created_at ISO 8601
ca = data.get("created_at", "")
if not re.match(r'^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z$', ca):
    errors.append(f"created_at debe ser ISO 8601 (YYYY-MM-DDTHH:MM:SSZ), es '{ca}'")

if errors:
    for e in errors:
        print(f"FAIL: {e}")
    sys.exit(1)

print("OK Tests pasaron")
PY
