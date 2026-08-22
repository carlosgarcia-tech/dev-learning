#!/usr/bin/env bash
# Validación del ejercicio 06 (nivel 04) - Saga (orquestación).
# Comprueba ejecución normal y compensaciones en orden inverso.
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

for cls in "PedidosService" "InventarioService" "PagosService" "CrearPedidoSaga"; do
  grep -q "class $cls" "$SOL" || { echo "FAIL: $SOL debe definir $cls"; fail; }
done
for m in "def execute" "def compensate"; do
  grep -q "$m" "$SOL" || { echo "FAIL: debe haber $m"; fail; }
done

# Verificación funcional
python3 - "$SOL" <<'PY'
import importlib.util, sys
spec = importlib.util.spec_from_file_location("sol", sys.argv[1])
m = importlib.util.module_from_spec(spec); spec.loader.exec_module(m)

# Caso éxito
saga_ok = m.CrearPedidoSaga(m.PedidosService(), m.InventarioService(), m.PagosService(falla=False))
res = saga_ok.execute()
if res != ["pedido_creado", "stock_reservado", "pago_cobrado"]:
    print("FAIL: caso éxito debe devolver los 3 resultados, fue:", res); sys.exit(1)

# Caso fallo en Pagos → debe lanzar y compensar los 2 anteriores
# Usamos servicios que registran las compensaciones
class SpyPedidos(m.PedidosService):
    def __init__(self): self.compensado = False
    def compensate(self): self.compensado = True
class SpyInv(m.InventarioService):
    def __init__(self): self.compensado = False
    def compensate(self): self.compensado = True

p = SpyPedidos(); i = SpyInv()
saga_fail = m.CrearPedidoSaga(p, i, m.PagosService(falla=True))
try:
    saga_fail.execute()
    print("FAIL: la saga con pago fallido debe lanzar"); sys.exit(1)
except RuntimeError:
    pass

# Ambos anteriores deben haberse compensado
if not p.compensado or not i.compensado:
    print("FAIL: Pedidos e Inventario deben estar compensados tras fallo"); sys.exit(1)

# El orden inverso: Inventario se compensa antes que Pedidos (comprobamos con contador global)
orden = []
class OrdenPedidos(m.PedidosService):
    def compensate(self): orden.append("pedidos")
class OrdenInv(m.InventarioService):
    def compensate(self): orden.append("inventario")
saga_orden = m.CrearPedidoSaga(OrdenPedidos(), OrdenInv(), m.PagosService(falla=True))
try:
    saga_orden.execute()
except RuntimeError:
    pass
if orden != ["inventario", "pedidos"]:
    print("FAIL: compensación debe ser en orden inverso [inventario, pedidos], fue:", orden); sys.exit(1)
PY

echo "OK Tests pasaron"
