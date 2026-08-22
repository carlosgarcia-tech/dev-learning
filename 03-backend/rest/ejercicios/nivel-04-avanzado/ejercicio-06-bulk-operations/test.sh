#!/usr/bin/env bash
# Validación del ejercicio 06 - Bulk operations.
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
if r.get("status") != 200: errors.append(f"status debe ser 200, es {r.get('status')}")
b = r.get("body", {})
results = b.get("results")
if not isinstance(results, list) or len(results) != 3:
    errors.append("body.results debe tener 3 elementos")
else:
    by_index = {x.get("index"): x for x in results}
    for i in (0, 1, 2):
        if i not in by_index: errors.append(f"falta resultado con index={i}")
    if by_index.get(0, {}).get("status") != "created": errors.append("results[0].status debe ser 'created'")
    if "id" not in by_index.get(0, {}): errors.append("results[0] debe tener id")
    if by_index.get(1, {}).get("status") != "error": errors.append("results[1].status debe ser 'error'")
    if "error" not in by_index.get(1, {}): errors.append("results[1] debe tener error")
    if by_index.get(2, {}).get("status") != "created": errors.append("results[2].status debe ser 'created'")
summary = b.get("summary", {})
if summary.get("created") != 2: errors.append("summary.created debe ser 2")
if summary.get("failed") != 1: errors.append("summary.failed debe ser 1")
if errors:
    for e in errors: print("  -", e)
    sys.exit(1)
print("OK Tests pasaron")
PY
