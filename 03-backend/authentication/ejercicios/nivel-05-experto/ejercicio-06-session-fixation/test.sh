#!/usr/bin/env bash
# Validación del ejercicio 06 - Session fixation.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

SF_FILE="session_fixation.json"

if [[ ! -f "$SF_FILE" ]]; then
  echo "FAIL: falta $SF_FILE"
  fail
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "FAIL: se requiere python3"
  fail
fi

python3 - "$SF_FILE" <<'PY'
import json, sys

with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)

errors = []

# Ataque
ataque = data.get("ataque", {})
if ataque.get("session_id_fijado") != "sess_ATTACKER_KNOWN_ID":
    errors.append(f"ataque.session_id_fijado debe ser 'sess_ATTACKER_KNOWN_ID', es '{ataque.get('session_id_fijado')}'")

sin_rot = ataque.get("sin_rotacion", {})
if sin_rot.get("vulnerable") is not True:
    errors.append("ataque.sin_rotacion.vulnerable debe ser true")
if sin_rot.get("atacante_accede") is not True:
    errors.append("ataque.sin_rotacion.atacante_accede debe ser true")
if not sin_rot.get("descripcion"):
    errors.append("ataque.sin_rotacion.descripcion no puede estar vacía")

# Defensa
defensa = data.get("defensa", {})
con_rot = defensa.get("con_rotacion", {})
if con_rot.get("vulnerable") is not False:
    errors.append("defensa.con_rotacion.vulnerable debe ser false")
if con_rot.get("session_id_rotado") is not True:
    errors.append("defensa.con_rotacion.session_id_rotado debe ser true")
if con_rot.get("atacante_accede") is not False:
    errors.append("defensa.con_rotacion.atacante_accede debe ser false")
if not con_rot.get("descripcion"):
    errors.append("defensa.con_rotacion.descripcion no puede estar vacía")

if errors:
    for e in errors:
        print(f"FAIL: {e}")
    sys.exit(1)

print("OK Tests pasaron")
PY
