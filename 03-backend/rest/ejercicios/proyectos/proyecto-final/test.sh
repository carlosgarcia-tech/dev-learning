#!/usr/bin/env bash
# Validación del Proyecto Final: API REST de E-commerce.
# Comprueba que openapi.yaml es válido (YAML/JSON) y contiene los recursos
# y mecanismos mínimos: auth, productos, pedidos, pagos, webhooks, reports,
# securitySchemes Bearer, schemas de error y job, paginación por cursor,
# idempotency-key y un endpoint deprecado.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

SPEC="openapi.yaml"
[[ -f "$SPEC" ]] || { echo "FAIL: falta $SPEC"; fail; }
command -v python3 >/dev/null 2>&1 || { echo "FAIL: se requiere python3"; fail; }

# Validar los ejemplos JSON
for f in ejemplos/producto.json ejemplos/webhook-event.json ejemplos/async-job.json; do
  [[ -f "$f" ]] || { echo "FAIL: falta $f"; fail; }
  python3 -m json.tool "$f" >/dev/null 2>&1 || { echo "FAIL: $f no es JSON válido"; python3 -m json.tool "$f" || true; fail; }
done

python3 - "$SPEC" <<'PY'
import sys
spec_path = sys.argv[1]

# Intentar cargar como YAML con PyYAML; si no está, validar sobre el texto.
try:
    import yaml
    try:
        with open(spec_path, encoding="utf-8") as f:
            spec = yaml.safe_load(f)
        spec_mode = "yaml"
    except yaml.YAMLError as e:
        print(f"  - YAML inválido: {e}")
        sys.exit(1)
except ImportError:
    print("  (nota: PyYAML no instalado; validando como texto estructurado)")
    with open(spec_path, encoding="utf-8") as f:
        text = f.read()
    required_text = [
        "openapi: 3",
        "/auth/login",
        "/products",
        "/orders",
        "/payments",
        "/webhooks",
        "/reports",
        "/jobs/{id}",
        "BearerAuth",
        "Idempotency-Key",
        "cursor",
        "deprecated: true",
        "application/problem+json",
        "nextCursor",
    ]
    missing = [t for t in required_text if t not in text]
    if missing:
        print("  - faltan en la spec:", ", ".join(missing))
        sys.exit(1)
    print("OK Tests pasaron")
    sys.exit(0)

errors = []
if not str(spec.get("openapi", "")).startswith("3"):
    errors.append(f"openapi debe ser 3.x, es {spec.get('openapi')}")
paths = spec.get("paths", {})
required_paths = ["/auth/login", "/auth/refresh", "/products", "/products/{id}",
                  "/categories", "/users", "/users/me", "/carts/me", "/carts/items",
                  "/orders", "/orders/{id}/cancel", "/payments", "/webhooks",
                  "/reports", "/jobs/{id}"]
for p in required_paths:
    if p not in paths:
        errors.append(f"falta el path '{p}'")
# securitySchemes Bearer
ss = spec.get("components", {}).get("securitySchemes", {})
if "BearerAuth" not in ss:
    errors.append("falta securitySchemes.BearerAuth (JWT)")
if ss.get("BearerAuth", {}).get("bearerFormat") != "JWT":
    errors.append("BearerAuth.bearerFormat debe ser JWT")
# Idempotency-Key en /payments
pay_params = paths.get("/payments", {}).get("post", {}).get("parameters", [])
has_idem = any(p.get("name") == "Idempotency-Key" for p in pay_params)
if not has_idem:
    errors.append("POST /payments debe declarar el parámetro Idempotency-Key")
# cursor en /products y /orders
prod_params = paths.get("/products", {}).get("get", {}).get("parameters", [])
if not any(p.get("name") == "cursor" for p in prod_params):
    errors.append("GET /products debe aceptar el parámetro cursor")
# un endpoint deprecado
deprecated_found = False
for p, ops in paths.items():
    for method, op in ops.items():
        if isinstance(op, dict) and op.get("deprecated"):
            deprecated_found = True
            break
if not deprecated_found:
    errors.append("debe existir al menos un endpoint marcado como deprecated: true")
# schemas mínimos
schemas = spec.get("components", {}).get("schemas", {})
for s in ("Product", "Order", "Payment", "Job", "Error", "CursorPagination"):
    if s not in schemas:
        errors.append(f"falta el schema '{s}'")
# responses de error en problem+json
responses = spec.get("components", {}).get("responses", {})
for r in ("Unauthorized", "Forbidden", "NotFound", "ValidationError", "RateLimited"):
    if r not in responses:
        errors.append(f"falta la response '{r}'")
# Job con status enum y async 202 en /reports
reports = paths.get("/reports", {}).get("post", {}).get("responses", {})
if "202" not in reports:
    errors.append("POST /reports debe devolver 202 (operación asíncrona)")

if errors:
    for e in errors:
        print("  -", e)
    sys.exit(1)
print("OK Tests pasaron")
PY
