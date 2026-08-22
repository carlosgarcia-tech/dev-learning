#!/usr/bin/env bash
# Validación del ejercicio 03 (nivel 03) - Builder.
# Comprueba API fluida y construcción correcta de SQL.
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

SOL="solucion.py"
STRUCT="estructura.json"
DIAG="diagrama.txt"

for f in "$SOL" "$STRUCT" "$DIAG"; do
  [[ -f "$f" ]] || { echo "FAIL: falta $f"; fail; }
done
command -v python3 >/dev/null 2>&1 || { echo "FAIL: se requiere python3"; fail; }

python3 -m json.tool "$STRUCT" >/dev/null 2>&1 || { echo "FAIL: $STRUCT no es JSON válido"; fail; }
python3 -c "import py_compile; py_compile.compile('$SOL', doraise=True)" 2>/dev/null || { echo "FAIL: $SOL no compila"; fail; }

grep -q "class QueryBuilder" "$SOL" || { echo "FAIL: debe definir QueryBuilder"; fail; }
for m in "def select" "def from_" "def where" "def order_by" "def limit" "def build"; do
  grep -q "$m" "$SOL" || { echo "FAIL: QueryBuilder debe tener $m"; fail; }
done

# Verificación funcional
python3 - "$SOL" <<'PY'
import importlib.util, sys
spec = importlib.util.spec_from_file_location("sol", sys.argv[1])
m = importlib.util.module_from_spec(spec); spec.loader.exec_module(m)

qb = m.QueryBuilder()
# method chaining: cada método devuelve self
r = qb.select("id, name")
if r is not qb:
    print("FAIL: select debe devolver self para encadenar"); sys.exit(1)

sql = (m.QueryBuilder()
        .select("id, name")
        .from_("users")
        .where("age > 18")
        .where("active = 1")
        .limit(10)
        .build())
expected = "SELECT id, name FROM users WHERE age > 18 AND active = 1 LIMIT 10"
if sql != expected:
    print("FAIL: SQL incorrecto"); print("  fue:", sql); print("  esp:", expected); sys.exit(1)

# Con order_by
sql2 = (m.QueryBuilder()
         .from_("t")
         .order_by("x")
         .build())
if "ORDER BY x" not in sql2:
    print("FAIL: debe incluir ORDER BY x, fue:", sql2); sys.exit(1)

# Sin where ni limit
sql3 = m.QueryBuilder().from_("t").build()
if sql3 != "SELECT * FROM t":
    print("FAIL: sin where/limit debe ser 'SELECT * FROM t', fue:", sql3); sys.exit(1)
PY

echo "OK Tests pasaron"
