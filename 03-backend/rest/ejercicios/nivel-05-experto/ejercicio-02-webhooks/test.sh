#!/usr/bin/env bash
# Validación del ejercicio 02 - Webhooks.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

command -v python3 >/dev/null 2>&1 || { echo "FAIL: se requiere python3"; fail; }
for f in respuesta_registro.json peticion_evento.json respuesta_evento.json; do
  [[ -f "$f" ]] || { echo "FAIL: falta $f"; fail; }
  python3 -m json.tool "$f" >/dev/null 2>&1 || { echo "FAIL: $f no es JSON válido"; python3 -m json.tool "$f" || true; fail; }
done

python3 - <<'PY'
import json, sys
errors = []
with open("respuesta_registro.json", encoding="utf-8") as f:
    r = json.load(f)
if r.get("status") != 201: errors.append("respuesta_registro.status debe ser 201")
b = r.get("body", {})
for k in ("id", "url", "events", "secret"):
    if k not in b: errors.append(f"respuesta_registro.body falta '{k}'")
if not isinstance(b.get("events"), list): errors.append("respuesta_registro.body.events debe ser array")

with open("peticion_evento.json", encoding="utf-8") as f:
    p = json.load(f)
if p.get("method") != "POST": errors.append("peticion_evento.method debe ser POST")
h = p.get("headers", {})
if h.get("X-Webhook-Event") != "order.paid": errors.append("X-Webhook-Event debe ser 'order.paid'")
sig = h.get("X-Webhook-Signature", "")
if not sig.startswith("sha256="): errors.append("X-Webhook-Signature debe empezar por 'sha256='")
body = p.get("body", {})
if body.get("type") != "order.paid": errors.append("body.type debe ser 'order.paid'")
if "id" not in body: errors.append("body.id (eventId) debe existir para idempotencia")
if "data" not in body: errors.append("body.data debe existir")

with open("respuesta_evento.json", encoding="utf-8") as f:
    re_ = json.load(f)
if re_.get("status") != 200: errors.append("respuesta_evento.status debe ser 200")
if errors:
    for e in errors: print("  -", e)
    sys.exit(1)
print("OK Tests pasaron")
PY
