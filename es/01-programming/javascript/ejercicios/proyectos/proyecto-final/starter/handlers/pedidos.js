async function crear(req, res, ctx) {
  // TODO: POST /api/pedidos.
  // 1. Lee el body. Valida:
  //    - cliente: string no vacío -> 400 { error: "El cliente es obligatorio" }.
  //    - productos: array no vacío -> 400 { error: "El pedido debe incluir al menos un producto" }.
  //    - cada línea { id: number, cantidad: entero > 0 } -> 400.
  // 2. Para cada línea: busca el producto; 400 si no existe; 400 "Stock insuficiente de <nombre>" si falta stock.
  // 3. Descuenta el stock, calcula subtotales y el total.
  // 4. Crea el pedido { id, cliente, fecha ISO, estado: "recibido", lineas, total }.
  // 5. Añádelo, guarda y responde 201 con el pedido.
  throw new Error("TODO: implementar crear(req, res, ctx)");
}

function listar(req, res, ctx) {
  // TODO: GET /api/pedidos con filtro ?estado= y paginación ?pagina=&limite=.
  // Devuelve 200 { total, pagina, limite, pedidos }.
  throw new Error("TODO: implementar listar(req, res, ctx)");
}

function obtenerUno(req, res, ctx) {
  // TODO: GET /api/pedidos/:id -> 200 pedido o 404 { error: "Pedido no encontrado" }.
  throw new Error("TODO: implementar obtenerUno(req, res, ctx)");
}

async function manejar(req, res, ctx) {
  // TODO: despacha según método y profundidad de ctx.partes.
  // GET + 2 partes -> listar; GET + 3 partes -> obtenerUno; POST + 2 -> crear; resto -> 405.
  throw new Error("TODO: implementar manejar(req, res, ctx)");
}

module.exports = { manejar };
