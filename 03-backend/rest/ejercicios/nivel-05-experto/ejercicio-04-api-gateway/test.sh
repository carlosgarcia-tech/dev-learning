#!/usr/bin/env bash
# Validación del ejercicio 04 - API gateway.
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
routes = r.get("routes")
if not isinstance(routes, list) or len(routes) < 2:
    errors.append("routes debe tener al menos 2 entradas")
else:
    services = set()
    for rt in routes:
        for k in ("path", "service", "methods"):
            if k not in rt: errors.append(f"cada ruta debe tener '{k}': {rt}")
        if not isinstance(rt.get("methods"), list): errors.append("route.methods debe ser array")
        services.add(rt.get("service"))
    if "products-service" not in services: errors.append("falta ruta a products-service")
    if "orders-service" not in services: errors.append("falta ruta a orders-service")

cc = r.get("crossCutting")
if not isinstance(cc, list): errors.append("crossCutting debe ser array")
else:
    for k in ("auth", "rateLimiting", "cors", "logging"):
        if k not in cc: errors.append(f"crossCutting debe incluir '{k}'")

d = r.get("defaults", {})
if not isinstance(d.get("rateLimitPerMinute"), int): errors.append("defaults.rateLimitPerMinute debe ser entero")
if not isinstance(d.get("timeoutSeconds"), int): errors.append("defaults.timeoutSeconds debe ser entero")

if errors:
    for e in errors: print("  -", e)
    sys.exit(1)
print("OK Tests pasaron")
PY
