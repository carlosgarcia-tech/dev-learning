#!/usr/bin/env bash
# Validación del ejercicio 04 - Rate limiting brute force.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

RL_FILE="rate_limit.json"

if [[ ! -f "$RL_FILE" ]]; then
  echo "FAIL: falta $RL_FILE"
  fail
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "FAIL: se requiere python3"
  fail
fi

python3 - "$RL_FILE" <<'PY'
import json, sys

with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)

errors = []

# max_intentos_ip y ventana
if data.get("max_intentos_ip") != 5:
    errors.append(f"max_intentos_ip debe ser 5, es {data.get('max_intentos_ip')}")
if data.get("ventana_segundos") != 900:
    errors.append(f"ventana_segundos debe ser 900, es {data.get('ventana_segundos')}")

intentos = data.get("intentos", [])
if len(intentos) != 8:
    errors.append(f"intentos debe tener 8 elementos, tiene {len(intentos)}")
else:
    expected = [
        (True, 0), (True, 0), (True, 0), (True, 0), (True, 0),
        (False, 2), (False, 4), (False, 8)
    ]
    for i, (exp_perm, exp_back) in enumerate(expected):
        a = intentos[i]
        if a.get("permitido") is not exp_perm:
            errors.append(f"Intento {i+1}: permitido debe ser {exp_perm}, es {a.get('permitido')}")
        if a.get("backoff_segundos") != exp_back:
            errors.append(f"Intento {i+1}: backoff_segundos debe ser {exp_back}, es {a.get('backoff_segundos')}")

if errors:
    for e in errors:
        print(f"FAIL: {e}")
    sys.exit(1)

print("OK Tests pasaron")
PY
