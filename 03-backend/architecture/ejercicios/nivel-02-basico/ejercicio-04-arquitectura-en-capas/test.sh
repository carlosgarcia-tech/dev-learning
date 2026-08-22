#!/usr/bin/env bash
# Validación del ejercicio 04 (nivel 02) - Arquitectura en capas.
# Comprueba 3 capas separadas, inyección y reglas de negocio en el sitio correcto.
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

for cls in "ProductRepository" "ProductService" "ProductController"; do
  grep -q "class $cls" "$SOL" || { echo "FAIL: $SOL debe definir $cls"; fail; }
done

# Métodos por capa
grep -qE "createProduct\s*\(" "$SOL" || { echo "FAIL: ProductService debe tener createProduct"; fail; }
grep -qE "postProduct\s*\(" "$SOL" || { echo "FAIL: ProductController debe tener postProduct"; fail; }
grep -qE "findAll\s*\(" "$SOL" || { echo "FAIL: ProductRepository debe tener findAll"; fail; }

# Controller NO debe contener SQL ni validar precio
python3 - "$SOL" <<'PY'
import re, sys
with open(sys.argv[1], encoding="utf-8") as f:
    src = f.read()
m = re.search(r"class ProductController.*?\n}(?:\s*\n)", src, re.S)
if not m:
    print("FAIL: no se pudo aislar ProductController"); sys.exit(1)
bloque = m.group(0)
if re.search(r"INSERT|SELECT|UPDATE\s+\w|DELETE\s+FROM", bloque, re.I):
    print("FAIL: ProductController no debe contener SQL"); sys.exit(1)
if re.search(r"precio\s*[<>]=?\s*0|precio\s*<=\s*0", bloque):
    print("FAIL: ProductController no debe validar precio (es regla del service)"); sys.exit(1)
PY

# Verificación funcional
node -e '
const { createApp } = require("./'"$SOL"'");
const { controller } = createApp();
const ok = controller.postProduct({ name: "Camiseta", precio: 20 });
if (ok.status !== 201) { console.error("FAIL: crear válido → 201"); process.exit(1); }
if (!ok.body.id) { console.error("FAIL: body debe tener id"); process.exit(1); }
const bad = controller.postProduct({ name: "X", precio: 0 });
if (bad.status !== 400) { console.error("FAIL: precio 0 → 400"); process.exit(1); }
const list = controller.getProducts();
if (list.status !== 200 || list.body.length !== 1) { console.error("FAIL: getProducts → 200 con 1"); process.exit(1); }
' || fail

echo "OK Tests pasaron"
