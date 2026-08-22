#!/usr/bin/env bash
# Validación del ejercicio 03 - Async operations con 202.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

command -v python3 >/dev/null 2>&1 || { echo "FAIL: se requiere python3"; fail; }
for f in respuesta_202.json respuesta_running.json respuesta_completed.json; do
  [[ -f "$f" ]] || { echo "FAIL: falta $f"; fail; }
  python3 -m json.tool "$f" >/dev/null 2>&1 || { echo "FAIL: $f no es JSON válido"; python3 -m json.tool "$f" || true; fail; }
done

python3 - <<'PY'
import json, sys
errors = []
with open("respuesta_202.json", encoding="utf-8") as f:
    r = json.load(f)
if r.get("status") != 202: errors.append("respuesta_202.status debe ser 202")
if not str(r.get("headers", {}).get("Location", "")).startswith("/jobs/"):
    errors.append("respuesta_202.headers.Location debe apuntar a /jobs/{id}")
b = r.get("body", {})
if b.get("status") != "pending": errors.append("respuesta_202.body.status debe ser 'pending'")
if not b.get("jobId"): errors.append("respuesta_202.body.jobId debe existir")
if not b.get("statusUrl"): errors.append("respuesta_202.body.statusUrl debe existir")

with open("respuesta_running.json", encoding="utf-8") as f:
    rr = json.load(f)
if rr.get("status") != 200: errors.append("respuesta_running.status debe ser 200")
br = rr.get("body", {})
if br.get("status") != "running": errors.append("respuesta_running.body.status debe ser 'running'")
if not isinstance(br.get("progress"), int) or not (0 <= br.get("progress") <= 100):
    errors.append("respuesta_running.body.progress debe ser entero 0-100")

with open("respuesta_completed.json", encoding="utf-8") as f:
    rc = json.load(f)
if rc.get("status") != 200: errors.append("respuesta_completed.status debe ser 200")
bc = rc.get("body", {})
if bc.get("status") != "completed": errors.append("respuesta_completed.body.status debe ser 'completed'")
if not bc.get("result", {}).get("reportUrl"):
    errors.append("respuesta_completed.body.result.reportUrl debe existir")
if errors:
    for e in errors: print("  -", e)
    sys.exit(1)
print("OK Tests pasaron")
PY
