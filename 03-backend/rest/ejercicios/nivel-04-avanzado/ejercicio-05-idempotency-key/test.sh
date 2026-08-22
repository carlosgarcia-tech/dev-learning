#!/usr/bin/env bash
# Validación del ejercicio 05 - Idempotency key.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

command -v python3 >/dev/null 2>&1 || { echo "FAIL: se requiere python3"; fail; }
for f in respuesta_primera.json respuesta_reintento.json respuesta_conflicto.json; do
  [[ -f "$f" ]] || { echo "FAIL: falta $f"; fail; }
  python3 -m json.tool "$f" >/dev/null 2>&1 || { echo "FAIL: $f no es JSON válido"; python3 -m json.tool "$f" || true; fail; }
done

python3 - <<'PY'
import json, sys
errors = []
with open("respuesta_primera.json", encoding="utf-8") as f:
    r1 = json.load(f)
if r1.get("status") != 201: errors.append("respuesta_primera.status debe ser 201")
b1 = r1.get("body", {})
if not b1.get("id"): errors.append("respuesta_primera.body.id debe existir")
if b1.get("status") != "completed": errors.append("respuesta_primera.body.status debe ser 'completed'")

with open("respuesta_reintento.json", encoding="utf-8") as f:
    r2 = json.load(f)
if r2.get("status") != 201: errors.append("respuesta_reintento.status debe ser 201 (resultado cacheado)")
if r2.get("body", {}).get("id") != b1.get("id"):
    errors.append("respuesta_reintento.body.id debe ser igual al de la primera petición")

with open("respuesta_conflicto.json", encoding="utf-8") as f:
    r3 = json.load(f)
if r3.get("status") != 409: errors.append("respuesta_conflicto.status debe ser 409")
if errors:
    for e in errors: print("  -", e)
    sys.exit(1)
print("OK Tests pasaron")
PY
