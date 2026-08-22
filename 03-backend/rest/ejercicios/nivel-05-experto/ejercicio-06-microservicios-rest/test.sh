#!/usr/bin/env bash
# Validación del ejercicio 06 - Microservicios REST.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

RESP="respuesta.json"
[[ -f "$RESP" ]] || { echo "FAIL: falta $RESP"; fail; }
command -v python3 >/dev/null 2>&1 || { echo "FAIL: se requiere python3"; fail; }
python3 -m json.tool "$RESP" >/dev/null 2>&1 || { echo "FAIL: $RESP no es JSON válido"; python3 -m json.tool "$RESP" || true; fail; }

python3 - <<'PY'
import json, sys
with open("respuesta.json", encoding="utf-8") as f:
    r = json.load(f)
errors = []
flujo = r.get("flujo")
if not isinstance(flujo, list) or len(flujo) < 3:
    errors.append("flujo debe tener al menos 3 pasos")
else:
    for i, paso in enumerate(flujo):
        for k in ("actor", "accion", "endpoint"):
            if k not in paso: errors.append(f"flujo[{i}] falta '{k}'")

res = r.get("resiliencia")
if not isinstance(res, list): errors.append("resiliencia debe ser array")
else:
    for k in ("circuit-breaker", "timeout", "retry"):
        if k not in res: errors.append(f"resiliencia debe incluir '{k}'")

c = r.get("contrato", {})
for k in ("endpoint", "method", "response"):
    if k not in c: errors.append(f"contrato falta '{k}'")

if errors:
    for e in errors: print("  -", e)
    sys.exit(1)
print("OK Tests pasaron")
PY
