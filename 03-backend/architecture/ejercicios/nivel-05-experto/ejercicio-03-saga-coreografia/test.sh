#!/usr/bin/env bash
# Validación del ejercicio 03 (nivel 05) - Saga coreografía.
# Comprueba el flujo de éxito y de fallo con compensaciones automáticas.
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

for cls in "EventBus" "PedidoCreado" "InventarioReservado" "PagoConfirmado" "PagoFallido" "PedidosService" "InventarioService" "PagosService"; do
  grep -q "class $cls" "$SOL" || { echo "FAIL: $SOL debe definir $cls"; fail; }
done

# Desacoplamiento: ningún servicio referencia a otro servicio concreto
python3 - "$SOL" <<'PY'
import re, sys
with open(sys.argv[1], encoding="utf-8") as f:
    src = f.read()
for svc in ("PedidosService", "InventarioService", "PagosService"):
    m = re.search(rf"class {svc}.*?\n}}", src, re.S)
    if not m: continue
    bloque = m.group(0)
    for otro in ("PedidosService", "InventarioService", "PagosService"):
        if otro != svc and otro in bloque:
            print(f"FAIL: {svc} no debe referenciar a {otro} (coreografía)"); sys.exit(1)
PY

# Verificación funcional: éxito y fallo
python3 - "$SOL" <<'PY'
import importlib.util, sys
spec = importlib.util.spec_from_file_location("sol", sys.argv[1])
m = importlib.util.module_from_spec(spec); spec.loader.exec_module(m)

def setup(falla_pago):
    bus = m.EventBus()
    pedidos = m.PedidosService(bus)
    inv = m.InventarioService(bus)
    pagos = m.PagosService(bus, falla=falla_pago)
    bus.subscribe(m.PedidoCreado, inv.on_pedido_creado)
    bus.subscribe(m.InventarioReservado, pagos.on_inventario_reservado)
    bus.subscribe(m.PagoConfirmado, pedidos.on_pago_confirmado)
    bus.subscribe(m.PagoFallido, pedidos.on_pago_fallido)
    bus.subscribe(m.PagoFallido, inv.on_pago_fallido)
    return pedidos, inv, pagos

# === ÉXITO ===
pedidos, inv, pagos = setup(falla_pago=False)
pedidos.crear("p1")
if pedidos.pedidos.get("p1") != "pagado":
    print("FAIL: en éxito, pedido debe quedar 'pagado', es", pedidos.pedidos.get("p1")); sys.exit(1)
if "p1" not in inv.reservados:
    print("FAIL: en éxito, inventario debe reservar p1"); sys.exit(1)
if "p1" not in pagos.cobros:
    print("FAIL: en éxito, pagos debe cobrar p1"); sys.exit(1)

# === FALLO (pago falla) → compensaciones ===
pedidos2, inv2, pagos2 = setup(falla_pago=True)
pedidos2.crear("p2")
if pedidos2.pedidos.get("p2") != "cancelado":
    print("FAIL: en fallo, pedido debe quedar 'cancelado', es", pedidos2.pedidos.get("p2")); sys.exit(1)
if "p2" not in pedidos2.cancelados:
    print("FAIL: en fallo, pedidos debe registrar cancelación"); sys.exit(1)
if "p2" not in inv2.liberados:
    print("FAIL: en fallo, inventario debe liberar el stock (compensación)"); sys.exit(1)
if "p2" not in inv2.reservados:
    print("FAIL: en fallo, inventario igualmente reservó antes de liberar"); sys.exit(1)
PY

echo "OK Tests pasaron"
