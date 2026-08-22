#!/usr/bin/env bash
# Validación del ejercicio 01 - Session ID seguro.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

SESS_FILE="session.json"

if [[ ! -f "$SESS_FILE" ]]; then
  echo "FAIL: falta $SESS_FILE"
  fail
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "FAIL: se requiere python3"
  fail
fi

python3 - "$SESS_FILE" <<'PY'
import json, sys, re

with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)

errors = []

sid = data.get("session_id", "")

# Longitud mínima: 32 caracteres
if len(sid) < 32:
    errors.append(f"session_id debe tener mínimo 32 caracteres, tiene {len(sid)}")

# Solo caracteres URL-safe [A-Za-z0-9_-]
if not re.match(r'^[A-Za-z0-9_-]+$', sid):
    errors.append("session_id solo debe contener [A-Za-z0-9_-]")

# No espacios, +, /, =
for bad in [' ', '+', '/', '=']:
    if bad in sid:
        errors.append(f"session_id no debe contener '{bad}'")

# entropia_bits = 256
if data.get("entropia_bits") != 256:
    errors.append(f"entropia_bits debe ser 256, es {data.get('entropia_bits')}")

# algoritmo
alg = data.get("algoritmo", "")
if alg not in ("CSPRNG", "secrets.token_urlsafe"):
    errors.append(f"algoritmo debe ser 'CSPRNG' o 'secrets.token_urlsafe', es '{alg}'")

# prefijo
if data.get("prefijo") != "sess_":
    errors.append(f"prefijo debe ser 'sess_', es '{data.get('prefijo')}'")

# session_id debe empezar por el prefijo
if data.get("prefijo") and not sid.startswith(data["prefijo"]):
    errors.append("session_id debe empezar por el prefijo")

if errors:
    for e in errors:
        print(f"FAIL: {e}")
    sys.exit(1)

print("OK Tests pasaron")
PY
