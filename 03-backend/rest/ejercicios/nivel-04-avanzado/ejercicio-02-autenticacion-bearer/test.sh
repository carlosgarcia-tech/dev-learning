#!/usr/bin/env bash
# Validación del ejercicio 02 - Autenticación Bearer (401/403).
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

command -v python3 >/dev/null 2>&1 || { echo "FAIL: se requiere python3"; fail; }
for f in respuesta_401.json respuesta_403.json; do
  [[ -f "$f" ]] || { echo "FAIL: falta $f"; fail; }
  python3 -m json.tool "$f" >/dev/null 2>&1 || { echo "FAIL: $f no es JSON válido"; python3 -m json.tool "$f" || true; fail; }
done

python3 - <<'PY'
import json, sys
errors = []
with open("respuesta_401.json", encoding="utf-8") as f:
    r = json.load(f)
if r.get("status") != 401: errors.append("respuesta_401.status debe ser 401")
if r.get("headers", {}).get("WWW-Authenticate") != "Bearer":
    errors.append("respuesta_401 debe incluir WWW-Authenticate: Bearer")
d1 = str(r.get("body", {}).get("detail", "")).lower()
if "token" not in d1 and "auth" not in d1:
    errors.append("respuesta_401.detail debe mencionar auth/token")

with open("respuesta_403.json", encoding="utf-8") as f:
    r = json.load(f)
if r.get("status") != 403: errors.append("respuesta_403.status debe ser 403")
d3 = str(r.get("body", {}).get("detail", "")).lower()
if "perm" not in d3 and "forbid" not in d3 and "prohib" not in d3:
    errors.append("respuesta_403.detail debe mencionar permiso/forbidden")
if "WWW-Authenticate" in r.get("headers", {}):
    errors.append("respuesta_403 no debe incluir WWW-Authenticate (ya autenticado)")
if errors:
    for e in errors: print("  -", e)
    sys.exit(1)
print("OK Tests pasaron")
PY
