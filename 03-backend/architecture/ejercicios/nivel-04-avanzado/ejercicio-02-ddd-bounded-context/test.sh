#!/usr/bin/env bash
# Validación del ejercicio 02 (nivel 04) - DDD bounded context.
# Comprueba value object inmutable, aggregate root e invariantes.
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

for cls in "Dinero" "PedidoCreado" "Item" "Pedido"; do
  grep -q "class $cls" "$SOL" || { echo "FAIL: $SOL debe definir $cls"; fail; }
done

# Dinero inmutable (frozen)
grep -qE "frozen=True" "$SOL" || { echo "FAIL: Dinero debe ser frozen (inmutable)"; fail; }

# Métodos del aggregate
for m in "def add_item" "def confirmar" "def total"; do
  grep -q "$m" "$SOL" || { echo "FAIL: Pedido debe tener $m"; fail; }
done

# Verificación funcional
python3 - "$SOL" <<'PY'
import importlib.util, sys
spec = importlib.util.spec_from_file_location("sol", sys.argv[1])
m = importlib.util.module_from_spec(spec); spec.loader.exec_module(m)

# Value object: inmutable y valida
d = m.Dinero(10, "EUR")
try:
    d.cantidad = 5  # frozen → debe fallar
    print("FAIL: Dinero debe ser inmutable"); sys.exit(1)
except Exception:
    pass
try:
    m.Dinero(-1)
    print("FAIL: Dinero(-1) debe lanzar ValueError"); sys.exit(1)
except ValueError:
    pass

# Aggregate
p = m.Pedido("p-1")
p.add_item(m.Item("Café", m.Dinero(2)))
p.add_item(m.Item("Libro", m.Dinero(10)))
total = p.total()
if total.cantidad != 12:
    print("FAIL: total debe ser 12, es", total.cantidad); sys.exit(1)

# Invariante: tras confirmar, no se puede añadir
p.confirmar()
if p.estado != "confirmado":
    print("FAIL: tras confirmar, estado debe ser 'confirmado'"); sys.exit(1)
try:
    p.add_item(m.Item("X", m.Dinero(1)))
    print("FAIL: no se puede añadir items a un pedido confirmado"); sys.exit(1)
except RuntimeError:
    pass

# Evento publicado
if len(p.eventos) != 1 or not isinstance(p.eventos[0], m.PedidoCreado):
    print("FAIL: confirmar debe publicar PedidoCreado"); sys.exit(1)
if p.eventos[0].pedido_id != "p-1":
    print("FAIL: el evento debe llevar el pedido_id"); sys.exit(1)
PY

echo "OK Tests pasaron"
