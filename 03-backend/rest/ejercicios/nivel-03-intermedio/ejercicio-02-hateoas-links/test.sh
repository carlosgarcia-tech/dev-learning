#!/usr/bin/env bash
# Validación del ejercicio 02 - HATEOAS links.
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
if r.get("status") != 200: errors.append("status debe ser 200")
links = r.get("body", {}).get("_links")
if not isinstance(links, dict): errors.append("body._links debe ser un objeto")
else:
    METHODS = {"GET","POST","PUT","PATCH","DELETE"}
    for name in ("self", "cancel", "pay"):
        lk = links.get(name)
        if not isinstance(lk, dict): errors.append(f"_links.{name} debe ser un objeto")
        else:
            if not isinstance(lk.get("href"), str): errors.append(f"_links.{name}.href debe ser string")
            if lk.get("method") not in METHODS: errors.append(f"_links.{name}.method debe ser HTTP válido")
    if links.get("self", {}).get("href") != "/orders/ord_456":
        errors.append("_links.self.href debe ser /orders/ord_456")
if errors:
    for e in errors: print("  -", e)
    sys.exit(1)
print("OK Tests pasaron")
PY
