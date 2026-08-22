#!/usr/bin/env bash
# Validación del ejercicio 04 - Field selection (?fields=).
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
b = r.get("body", {})
for k in ("id", "name", "price"):
    if k not in b: errors.append(f"body debe incluir '{k}'")
# No debe incluir campos no pedidos
for k in ("stock", "category", "createdAt"):
    if k in b: errors.append(f"body NO debe incluir '{k}' (no estaba en fields)")
if errors:
    for e in errors: print("  -", e)
    sys.exit(1)
print("OK Tests pasaron")
PY
