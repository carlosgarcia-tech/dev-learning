function validarProducto(datos) {
  // TODO: valida un producto y devuelve null si es correcto, o un mensaje de error.
  // - datos debe ser un objeto.
  // - nombre: string no vacío (trim).
  // - precio: number >= 0.
  // - stock: number entero >= 0.
  // Mensajes sugeridos:
  //   "Datos inválidos", "El nombre es obligatorio",
  //   "El precio debe ser un número mayor o igual a 0",
  //   "El stock debe ser un entero mayor o igual a 0".
  throw new Error("TODO: implementar validarProducto(datos)");
}

function listar(req, res, ctx) {
  // TODO: GET /api/productos con búsqueda, filtros, orden y paginación.
  // Parámetros de query: buscar, minPrecio, maxPrecio, orden (asc|desc), pagina, limite.
  // Devuelve 200 { total, pagina, limite, productos }.
  throw new Error("TODO: implementar listar(req, res, ctx)");
}

function obtenerUno(req, res, ctx) {
  // TODO: GET /api/productos/:id -> 200 producto o 404 { error: "Producto no encontrado" }.
  throw new Error("TODO: implementar obtenerUno(req, res, ctx)");
}

async function crear(req, res, ctx) {
  // TODO: POST /api/productos.
  // 1. Lee el body y valida con validarProducto; si hay error -> 400 { error }.
  // 2. Asigna id = ctx.db.siguienteId(ctx.db.productos()).
  // 3. Añade, llama a ctx.db.guardar() y responde 201 con el producto.
  throw new Error("TODO: implementar crear(req, res, ctx)");
}

async function actualizar(req, res, ctx) {
  // TODO: PUT /api/productos/:id.
  // - 404 si no existe; 400 si la validación falla; 200 con el producto actualizado.
  throw new Error("TODO: implementar actualizar(req, res, ctx)");
}

function eliminar(req, res, ctx) {
  // TODO: DELETE /api/productos/:id.
  // - 404 si no existe; si no, elimina, guarda y responde 204 (sin body).
  throw new Error("TODO: implementar eliminar(req, res, ctx)");
}

async function manejar(req, res, ctx) {
  // TODO: despacha según método y profundidad de ctx.partes.
  // GET + 2 partes -> listar; GET + 3 partes -> obtenerUno; POST + 2 -> crear;
  // PUT + 3 -> actualizar; DELETE + 3 -> eliminar; resto -> 405 { error: "Método no permitido" }.
  throw new Error("TODO: implementar manejar(req, res, ctx)");
}

module.exports = { manejar, validarProducto };
