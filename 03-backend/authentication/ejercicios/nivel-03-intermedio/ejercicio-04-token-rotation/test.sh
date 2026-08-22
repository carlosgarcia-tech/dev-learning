#!/usr/bin/env bash
# Validación del ejercicio 04 - Token rotation.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

ROT_FILE="rotation.json"

if [[ ! -f "$ROT_FILE" ]]; then
  echo "FAIL: falta $ROT_FILE"
  fail
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "FAIL: se requiere python3"
  fail
fi

python3 - "$ROT_FILE" <<'PY'
import json, sys

with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)

errors = []

familia = data.get("familia_id", "")
if not familia:
    errors.append("familia_id no puede estar vacío")

pasos = data.get("pasos", [])
if len(pasos) != 4:
    errors.append(f"Debe haber 4 pasos, hay {len(pasos)}")
else:
    # Paso 1: login
    p1 = pasos[0]
    if "refresh_1" not in p1.get("emitidos", []):
        errors.append("Paso 1 (login): debe emitir refresh_1")
    if p1.get("familia_invalidada") is not False:
        errors.append("Paso 1: familia_invalidada debe ser false")
    
    # Paso 2: refresh_1
    p2 = pasos[1]
    if "refresh_1" not in p2.get("invalidados", []):
        errors.append("Paso 2 (refresh_1): refresh_1 debe estar invalidado")
    if "refresh_2" not in p2.get("emitidos", []):
        errors.append("Paso 2: debe emitir refresh_2")
    if p2.get("familia_invalidada") is not False:
        errors.append("Paso 2: familia_invalidada debe ser false")
    
    # Paso 3: refresh_2
    p3 = pasos[2]
    if "refresh_2" not in p3.get("invalidados", []):
        errors.append("Paso 3 (refresh_2): refresh_2 debe estar invalidado")
    if "refresh_3" not in p3.get("emitidos", []):
        errors.append("Paso 3: debe emitir refresh_3")
    if p3.get("familia_invalidada") is not False:
        errors.append("Paso 3: familia_invalidada debe ser false")
    
    # Paso 4: reuso detectado
    p4 = pasos[3]
    if p4.get("familia_invalidada") is not True:
        errors.append("Paso 4 (reuso): familia_invalidada debe ser true")
    invalidados_4 = p4.get("invalidados", [])
    for r in ["refresh_1", "refresh_2", "refresh_3"]:
        if r not in invalidados_4:
            errors.append(f"Paso 4: {r} debe estar en invalidados")
    if p4.get("activos", []) != []:
        errors.append("Paso 4: activos debe estar vacío (todos invalidados)")

if errors:
    for e in errors:
        print(f"FAIL: {e}")
    sys.exit(1)

print("OK Tests pasaron")
PY
