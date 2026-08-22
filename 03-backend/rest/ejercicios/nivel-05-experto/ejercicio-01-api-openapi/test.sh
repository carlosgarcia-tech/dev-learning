#!/usr/bin/env bash
# Validación del ejercicio 01 - Diseño de API con OpenAPI.
# Comprueba que openapi.yaml es YAML válido y contiene los endpoints y schemas requeridos.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

SPEC="openapi.yaml"
[[ -f "$SPEC" ]] || { echo "FAIL: falta $SPEC"; fail; }
command -v python3 >/dev/null 2>&1 || { echo "FAIL: se requiere python3"; fail; }

# Intentar cargar YAML con PyYAML; si no está, fallback a validar como JSON estructurado
# con un parser manual ligero basado en indentación.
python3 - "$SPEC" <<'PY'
import sys

spec_path = sys.argv[1]
try:
    import yaml
    with open(spec_path, encoding="utf-8") as f:
        spec = yaml.safe_load(f)
except ImportError:
    print("  (nota: PyYAML no instalado; validando como texto estructurado)")
    with open(spec_path, encoding="utf-8") as f:
        text = f.read()
    spec = None
    # Checks mínimos de presencia sobre el texto crudo
    required_text = [
        "openapi: 3",
        "/products",
        "Product",
        "ProductCreate",
        "responses:",
        "application/json",
        "404",
        "201",
        "422",
        "components:",
    ]
    missing = [t for t in required_text if t not in text]
    if missing:
        print("  - faltan en el texto:", ", ".join(missing))
        sys.exit(1)
    print("OK Tests pasaron")
    sys.exit(0)
except yaml.YAMLError as e:
    print(f"  - YAML inválido: {e}")
    sys.exit(1)

errors = []
if not str(spec.get("openapi", "")).startswith("3"):
    errors.append(f"openapi debe ser 3.x, es {spec.get('openapi')}")
paths = spec.get("paths", {})
if "/products" not in paths: errors.append("falta path /products")
else:
    if "get" not in paths["products"]: errors.append("falta GET /products")
    if "post" not in paths["products"]: errors.append("falta POST /products")
pid = paths.get("/products/{id}", {})
if not pid: errors.append("falta path /products/{id}")
else:
    if "get" not in pid: errors.append("falta GET /products/{id}")
    if "delete" not in pid: errors.append("falta DELETE /products/{id}")
# responses esperadas
post_responses = paths.get("/products", {}).get("post", {}).get("responses", {})
if "201" not in post_responses: errors.append("POST /products debe declarar 201")
if "422" not in post_responses: errors.append("POST /products debe declarar 422")
get_id_responses = pid.get("get", {}).get("responses", {})
if "200" not in get_id_responses: errors.append("GET /products/{id} debe declarar 200")
if "404" not in get_id_responses: errors.append("GET /products/{id} debe declarar 404")
schemas = spec.get("components", {}).get("schemas", {})
for s in ("Product", "ProductCreate", "Error"):
    if s not in schemas: errors.append(f"falta el schema '{s}' en components")
if errors:
    for e in errors: print("  -", e)
    sys.exit(1)
print("OK Tests pasaron")
PY
