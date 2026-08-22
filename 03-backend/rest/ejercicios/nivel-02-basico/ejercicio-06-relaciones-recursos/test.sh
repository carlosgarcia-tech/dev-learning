#!/usr/bin/env bash
# Validación del ejercicio 06 - Relaciones entre recursos (referencia vs embebido).
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

command -v python3 >/dev/null 2>&1 || { echo "FAIL: se requiere python3"; fail; }
for f in respuesta.json respuesta_expand.json; do
  [[ -f "$f" ]] || { echo "FAIL: falta $f"; fail; }
  python3 -m json.tool "$f" >/dev/null 2>&1 || { echo "FAIL: $f no es JSON válido"; python3 -m json.tool "$f" || true; fail; }
done

python3 - <<'PY'
import json, sys
errors = []
with open("respuesta.json", encoding="utf-8") as f:
    r = json.load(f)
if r.get("status") != 200: errors.append("respuesta.json status debe ser 200")
b = r.get("body", {})
if not isinstance(b.get("userId"), str): errors.append("respuesta.json body.userId debe ser string (referencia)")
if "user" in b and isinstance(b.get("user"), dict): errors.append("respuesta.json no debe incluir user embebido por defecto")
for k in ("id", "total", "status"):
    if k not in b: errors.append(f"respuesta.json body falta '{k}'")

with open("respuesta_expand.json", encoding="utf-8") as f:
    re_ = json.load(f)
if re_.get("status") != 200: errors.append("respuesta_expand.json status debe ser 200")
be = re_.get("body", {})
u = be.get("user")
if not isinstance(u, dict) or "id" not in u or "name" not in u:
    errors.append("respuesta_expand.json body.user debe ser objeto con id y name")
for k in ("id", "userId", "total", "status"):
    if k not in be: errors.append(f"respuesta_expand.json body falta '{k}'")

if errors:
    for e in errors: print("  -", e)
    sys.exit(1)
print("OK Tests pasaron")
PY
