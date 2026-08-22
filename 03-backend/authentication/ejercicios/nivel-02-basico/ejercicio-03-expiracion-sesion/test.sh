#!/usr/bin/env bash
# Validación del ejercicio 03 - Expiración de sesión (absolute y sliding).
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

EXP_FILE="expiracion.json"

if [[ ! -f "$EXP_FILE" ]]; then
  echo "FAIL: falta $EXP_FILE"
  fail
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "FAIL: se requiere python3"
  fail
fi

python3 - "$EXP_FILE" <<'PY'
import json, sys

with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)

errors = []

created = data.get("created_at")
ttl = data.get("ttl_segundos")
ultima = data.get("ultima_actividad")
ahora = data.get("ahora")

# absolute_expires_at = created_at + ttl
expected_abs = created + ttl
if data.get("absolute_expires_at") != expected_abs:
    errors.append(f"absolute_expires_at debe ser {expected_abs}, es {data.get('absolute_expires_at')}")

# absolute_valida: ahora < absolute_expires_at
expected_abs_valida = ahora < expected_abs
if data.get("absolute_valida") is not expected_abs_valida:
    errors.append(f"absolute_valida debe ser {expected_abs_valida}, es {data.get('absolute_valida')}")

# sliding_expires_at = ultima_actividad + ttl
expected_sli = ultima + ttl
if data.get("sliding_expires_at") != expected_sli:
    errors.append(f"sliding_expires_at debe ser {expected_sli}, es {data.get('sliding_expires_at')}")

# sliding_valida: ahora < sliding_expires_at
expected_sli_valida = ahora < expected_sli
if data.get("sliding_valida") is not expected_sli_valida:
    errors.append(f"sliding_valida debe ser {expected_sli_valida}, es {data.get('sliding_valida')}")

# diferencia_segundos = sliding_expires_at - absolute_expires_at
expected_diff = expected_sli - expected_abs
if data.get("diferencia_segundos") != expected_diff:
    errors.append(f"diferencia_segundos debe ser {expected_diff}, es {data.get('diferencia_segundos')}")

if errors:
    for e in errors:
        print(f"FAIL: {e}")
    sys.exit(1)

print("OK Tests pasaron")
PY
