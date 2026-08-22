#!/usr/bin/env bash
# Validación del ejercicio 05 (nivel 04) - API Gateway.
# Comprueba auth, routing y 404.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

SOL="solucion.js"
STRUCT="estructura.json"
DIAG="diagrama.txt"

for f in "$SOL" "$STRUCT" "$DIAG"; do
  [[ -f "$f" ]] || { echo "FAIL: falta $f"; fail; }
done
command -v python3 >/dev/null 2>&1 || { echo "FAIL: se requiere python3"; fail; }
command -v node >/dev/null 2>&1 || { echo "FAIL: se requiere node"; fail; }

python3 -m json.tool "$STRUCT" >/dev/null 2>&1 || { echo "FAIL: $STRUCT no es JSON válido"; fail; }
node --check "$SOL" 2>/dev/null || { echo "FAIL: $SOL no compila"; fail; }

grep -q "class ApiGateway" "$SOL" || { echo "FAIL: debe definir ApiGateway"; fail; }
grep -qE "register\s*\(" "$SOL" || { echo "FAIL: debe tener register"; fail; }
grep -qE "request\s*\(" "$SOL" || { echo "FAIL: debe tener request"; fail; }

# Verificación funcional
node -e '
const { ApiGateway, userService, productService } = require("./'"$SOL"'");
const gw = new ApiGateway();
gw.register("/users", userService).register("/products", productService);

// Sin token → 401
const r1 = gw.request("/users/1", null);
if (r1.status !== 401) { console.error("FAIL: sin token → 401, es", r1.status); process.exit(1); }

// Path no registrado → 404
const r2 = gw.request("/unknown/1", "tok");
if (r2.status !== 404) { console.error("FAIL: path no registrado → 404, es", r2.status); process.exit(1); }

// Path registrado + token → 200
const r3 = gw.request("/users/1", "tok");
if (r3.status !== 200) { console.error("FAIL: users + token → 200, es", r3.status); process.exit(1); }
if (r3.body.servicio !== "users") { console.error("FAIL: debe enrutar a users"); process.exit(1); }

const r4 = gw.request("/products/42", "tok");
if (r4.status !== 200 || r4.body.servicio !== "products") { console.error("FAIL: products"); process.exit(1); }
' || fail

echo "OK Tests pasaron"
