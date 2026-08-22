#!/usr/bin/env bash
# Validación del ejercicio 03 - Orden con sort=-price.
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
if r.get("status") != 200:
    errors.append(f"status debe ser 200, es {r.get('status')}")
data = r.get("body", {}).get("data")
if not isinstance(data, list) or len(data) < 3:
    errors.append("body.data debe tener al menos 3 elementos")
else:
    prices = [p.get("price") for p in data]
    for i in range(len(prices) - 1):
        if not isinstance(prices[i], (int, float)) or not isinstance(prices[i+1], (int, float)):
            errors.append(f"data[{i}].price debe ser numérico")
            break
        if prices[i] < prices[i+1]:
            errors.append(f"orden incorrecto: data[{i}].price={prices[i]} < data[{i+1}].price={prices[i+1]} (debe ser descendente)")
            break
if errors:
    for e in errors: print("  -", e)
    sys.exit(1)
print("OK Tests pasaron")
PY
