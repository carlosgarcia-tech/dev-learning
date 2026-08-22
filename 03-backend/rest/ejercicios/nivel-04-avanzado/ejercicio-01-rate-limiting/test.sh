#!/usr/bin/env bash
# Validación del ejercicio 01 - Rate limiting (429).
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
if r.get("status") != 429: errors.append(f"status debe ser 429, es {r.get('status')}")
h = r.get("headers", {})
ra = h.get("Retry-After")
if not isinstance(ra, int) or ra <= 0: errors.append("Retry-After debe ser entero > 0")
if h.get("X-RateLimit-Limit") != 100: errors.append("X-RateLimit-Limit debe ser 100")
if h.get("X-RateLimit-Remaining") != 0: errors.append("X-RateLimit-Remaining debe ser 0")
rr = h.get("X-RateLimit-Reset")
if not isinstance(rr, int) or rr <= 0: errors.append("X-RateLimit-Reset debe ser epoch entero > 0")
if r.get("body", {}).get("code") != "rate_limit_exceeded":
    errors.append("body.code debe ser 'rate_limit_exceeded'")
if errors:
    for e in errors: print("  -", e)
    sys.exit(1)
print("OK Tests pasaron")
PY
