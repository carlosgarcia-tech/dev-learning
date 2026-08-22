#!/usr/bin/env bash
# Validación del ejercicio 05 - Migración de versión de API.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

command -v python3 >/dev/null 2>&1 || { echo "FAIL: se requiere python3"; fail; }
for f in respuesta_v1_deprecada.json respuesta_v2.json; do
  [[ -f "$f" ]] || { echo "FAIL: falta $f"; fail; }
  python3 -m json.tool "$f" >/dev/null 2>&1 || { echo "FAIL: $f no es JSON válido"; python3 -m json.tool "$f" || true; fail; }
done

python3 - <<'PY'
import json, sys
errors = []
with open("respuesta_v1_deprecada.json", encoding="utf-8") as f:
    r1 = json.load(f)
if r1.get("status") != 200: errors.append("respuesta_v1_deprecada.status debe ser 200")
h = r1.get("headers", {})
if "Deprecation" not in h: errors.append("falta cabecera Deprecation")
if "Sunset" not in h: errors.append("falta cabecera Sunset")
link = h.get("Link", "")
if "successor-version" not in link or "v2" not in link:
    errors.append("Link debe incluir rel=\"successor-version\" y apuntar a v2")
b1 = r1.get("body", {})
if "price" not in b1: errors.append("v1.body debe usar price")
if "unitPrice" in b1: errors.append("v1.body no debe usar unitPrice (es de v2)")

with open("respuesta_v2.json", encoding="utf-8") as f:
    r2 = json.load(f)
if r2.get("status") != 200: errors.append("respuesta_v2.status debe ser 200")
b2 = r2.get("body", {})
if "unitPrice" not in b2: errors.append("v2.body debe tener unitPrice")
if "currency" not in b2: errors.append("v2.body debe tener currency")
if "price" in b2: errors.append("v2.body no debe tener price (renombrado)")
if errors:
    for e in errors: print("  -", e)
    sys.exit(1)
print("OK Tests pasaron")
PY
