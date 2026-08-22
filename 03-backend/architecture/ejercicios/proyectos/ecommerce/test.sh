#!/usr/bin/env bash
# Validación end-to-end del proyecto integrador de microservicios.
# Comprueba: gateway+auth, servicios con BD propia, CQRS, saga con compensación,
# circuit breaker, caché y observabilidad (trace_id propagado).
set -euo pipefail
cd "$(dirname "$0")" || exit 1

fail() { echo "FAIL Tests fallaron"; exit 1; }

command -v python3 >/dev/null 2>&1 || { echo "FAIL: se requiere python3"; fail; }
command -v node >/dev/null 2>&1 || { echo "FAIL: se requiere node"; fail; }

# Validar JSON de estructura
python3 -m json.tool estructura.json >/dev/null 2>&1 || { echo "FAIL: estructura.json no es JSON válido"; fail; }

# Validar que todos los archivos existan
for f in bus.js gateway/gateway.js usuarios/service.js productos/service.js \
         pedidos/aggregate.js pedidos/commands.js pedidos/queries.js pedidos/projector.js \
         pagos/service.js shared/circuit-breaker.js shared/logger.js shared/metrics.js; do
  [[ -f "$f" ]] || { echo "FAIL: falta $f"; fail; }
done

# Validar sintaxis de todos los JS
for f in bus.js gateway/gateway.js usuarios/service.js productos/service.js \
         pedidos/aggregate.js pedidos/commands.js pedidos/queries.js pedidos/projector.js \
         pagos/service.js shared/circuit-breaker.js shared/logger.js shared/metrics.js; do
  node --check "$f" 2>/dev/null || { echo "FAIL: $f no compila"; fail; }
done

# Flujo 1 (éxito): saga completa con pago OK, en un proceso node aislado.
node -e '
const { ApiGateway } = require("./gateway/gateway");
const { UsuariosService } = require("./usuarios/service");
const { ProductosService } = require("./productos/service");
const { CrearPedidoHandler, PedidosReactions } = require("./pedidos/commands");
const { PedidosQueryHandler } = require("./pedidos/queries");
const { PedidosProjector } = require("./pedidos/projector");
const { PagosService } = require("./pagos/service");
const { bus } = require("./bus");
const { Logger } = require("./shared/logger");
const { CircuitBreaker } = require("./shared/circuit-breaker");

const usuarios = new UsuariosService();
const productos = new ProductosService();
const writeModel = [];
const readModel = new Map();
const cmdHandler = new CrearPedidoHandler(writeModel);
const projector = new PedidosProjector(readModel);
const queryHandler = new PedidosQueryHandler(readModel);
const pedidosReactions = new PedidosReactions(writeModel, new Logger());

const gw = new ApiGateway();
gw.register("/usuarios", usuarios);
gw.register("/productos", productos);

// Suscripciones (saga coreografiada + CQRS projection)
bus.subscribe("PedidoCreado", (e) => productos.onPedidoCreado(e));
bus.subscribe("PedidoCreado", (e) => projector.onPedidoCreado(e));
const pagos = new PagosService(false);
bus.subscribe("PedidoCreado", (e) => pagos.onPedidoCreado(e));
bus.subscribe("PagoConfirmado", (e) => projector.onPagoConfirmado(e));
bus.subscribe("PagoConfirmado", (e) => pedidosReactions.onPagoConfirmado(e));
bus.subscribe("PagoFallido", (e) => productos.onPagoFallido(e));
bus.subscribe("PagoFallido", (e) => projector.onPagoFallido(e));
bus.subscribe("PagoFallido", (e) => pedidosReactions.onPagoFallido(e));

// 1. Auth: sin token → 401
const r0 = gw.request({ path: "/productos", token: null, body: {} });
if (r0.status !== 401) { console.error("FAIL: sin token → 401"); process.exit(1); }

// 2. Crear producto (gateway routing)
const r1 = gw.request({ path: "/productos/create", token: "valid-token", body: { nombre: "Café", precio: 10, stock: 100 } });
if (r1.status !== 200 || !r1.body.id) { console.error("FAIL: crear producto"); process.exit(1); }

// 3. Caché: primer list = miss, segundo = hit
productos.list("t1");
productos.list("t2");
const hits = productos.logger.logs.filter(l => l.msg === "cache hit").length;
const misses = productos.logger.logs.filter(l => l.msg === "cache miss").length;
if (misses < 1 || hits < 1) { console.error("FAIL: caché debe tener miss y hit"); process.exit(1); }

// 4. Crear pedido (CQRS + saga exitosa)
const pedido_id = cmdHandler.handle({ cliente_id: "cli-1", items: [{ precio: 10, cantidad: 2 }] }, "trace-xyz");
if (writeModel.length !== 1) { console.error("FAIL: write model debe tener 1 pedido"); process.exit(1); }
const pedido = writeModel[0];
if (pedido.estado !== "pagado") { console.error("FAIL: tras saga exitosa, pedido debe estar pagado, es", pedido.estado); process.exit(1); }

// Read model (CQRS) actualizado a pagado por el projector
const vista = queryHandler.handle({ cliente_id: "cli-1" });
if (vista.length !== 1 || vista[0].estado !== "pagado") {
  console.error("FAIL: read model debe tener 1 pedido pagado, tiene", JSON.stringify(vista)); process.exit(1);
}

// Invariante DDD: no añadir items a un pedido confirmado
try {
  pedido.addItem({ precio: 5, cantidad: 1 });
  console.error("FAIL: no se puede modificar un pedido confirmado"); process.exit(1);
} catch (e) { /* ok */ }

// 5. Circuit Breaker
const cb = new CircuitBreaker(2, 0.1);
for (let i = 0; i < 2; i++) {
  try { cb.call(() => { throw new Error("fallo"); }); } catch (e) {}
}
if (cb.estado !== "open") { console.error("FAIL: CB debe estar open tras 2 fallos"); process.exit(1); }
try {
  cb.call(() => "ok");
  console.error("FAIL: CB abierto debe lanzar"); process.exit(1);
} catch (e) { /* ok */ }

// 6. Observabilidad: trace_id en logs
const logConTrace = usuarios.logger.logs.find(l => l.trace_id);
if (!logConTrace) { console.error("FAIL: los logs deben llevar trace_id"); process.exit(1); }
' || { echo "FAIL en flujo de éxito"; fail; }

# Flujo 2 (fallo de pago): saga con compensaciones, en proceso node aparte (bus limpio).
node -e '
const { CrearPedidoHandler, PedidosReactions } = require("./pedidos/commands");
const { PedidosQueryHandler } = require("./pedidos/queries");
const { PedidosProjector } = require("./pedidos/projector");
const { ProductosService } = require("./productos/service");
const { PagosService } = require("./pagos/service");
const { bus } = require("./bus");
const { Logger } = require("./shared/logger");

const productos = new ProductosService();
const writeModel = [];
const readModel = new Map();
const cmdHandler = new CrearPedidoHandler(writeModel);
const projector = new PedidosProjector(readModel);
const queryHandler = new PedidosQueryHandler(readModel);
const pedidosReactions = new PedidosReactions(writeModel, new Logger());

bus.subscribe("PedidoCreado", (e) => productos.onPedidoCreado(e));
bus.subscribe("PedidoCreado", (e) => projector.onPedidoCreado(e));
const pagosFail = new PagosService(true);   // pago falla
bus.subscribe("PedidoCreado", (e) => pagosFail.onPedidoCreado(e));
bus.subscribe("PagoFallido", (e) => productos.onPagoFallido(e));
bus.subscribe("PagoFallido", (e) => projector.onPagoFallido(e));
bus.subscribe("PagoFallido", (e) => pedidosReactions.onPagoFallido(e));

const pid2 = cmdHandler.handle({ cliente_id: "cli-2", items: [{ precio: 5, cantidad: 1 }] }, "trace2");
const pedido2 = writeModel.find(p => p.id === pid2);
if (pedido2.estado !== "cancelado") { console.error("FAIL: tras pago fallido, pedido debe estar cancelado, es", pedido2.estado); process.exit(1); }
// Compensación: stock liberado (reserva eliminada)
if (productos.reservas.has(pid2)) { console.error("FAIL: el stock debe liberarse tras compensación"); process.exit(1); }
// Read model actualizado a cancelado
const vista2 = queryHandler.handle({ cliente_id: "cli-2" });
if (vista2.length !== 1 || vista2[0].estado !== "cancelado") {
  console.error("FAIL: read model debe tener 1 pedido cancelado, tiene", JSON.stringify(vista2)); process.exit(1);
}
' || { echo "FAIL en flujo de fallo/compensación"; fail; }

echo "OK Tests pasaron"
