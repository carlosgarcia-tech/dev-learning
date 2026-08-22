#!/usr/bin/env bash
# Validación del ejercicio 06 - Renovación de sesión.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

REN_FILE="renovacion.json"

if [[ ! -f "$REN_FILE" ]]; then
  echo "FAIL: falta $REN_FILE"
  fail
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "FAIL: se requiere python3"
  fail
fi

python3 - "$REN_FILE" <<'PY'
import json, sys, re

with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)

errors = []

# sesion_antigua
sa = data.get("sesion_antigua", {})
if sa.get("id") != "sess_a8b9c0d1e2f3":
    errors.append(f"sesion_antigua.id debe ser 'sess_a8b9c0d1e2f3', es '{sa.get('id')}'")
if sa.get("invalidada") is not True:
    errors.append("sesion_antigua.invalidada debe ser true")

# sesion_nueva
sn = data.get("sesion_nueva", {})
new_id = sn.get("id", "")
if new_id == "sess_a8b9c0d1e2f3":
    errors.append("sesion_nueva.id debe ser distinto del anterior")
if not new_id.startswith("sess_"):
    errors.append("sesion_nueva.id debe empezar por 'sess_'")
if len(new_id) < 32:
    errors.append(f"sesion_nueva.id debe tener mínimo 32 caracteres, tiene {len(new_id)}")

# created_at y expires_at
if sn.get("created_at") != 1700001800:
    errors.append(f"sesion_nueva.created_at debe ser 1700001800, es {sn.get('created_at')}")
if sn.get("expires_at") != 1700005400:
    errors.append(f"sesion_nueva.expires_at debe ser 1700005400, es {sn.get('expires_at')}")

# ttl_renovado
if data.get("ttl_renovado") is not True:
    errors.append("ttl_renovado debe ser true")

if errors:
    for e in errors:
        print(f"FAIL: {e}")
    sys.exit(1)

print("OK Tests pasaron")
PY
