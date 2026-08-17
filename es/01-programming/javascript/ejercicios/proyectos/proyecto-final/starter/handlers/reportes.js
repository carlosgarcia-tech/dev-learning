function inventario(req, res, ctx) {
  // TODO: GET /api/reportes/inventario.
  // Devuelve 200 con:
  //   totalProductos, unidadesTotales, valorInventario (suma de precio*stock),
  //   productosSinStock, bajoStock (stock > 0 y <= 5).
  throw new Error("TODO: implementar inventario(req, res, ctx)");
}

function ventas(req, res, ctx) {
  // TODO: GET /api/reportes/ventas.
  // Devuelve 200 con: totalPedidos, ingresosTotales (suma de pedidos.total),
  // pedidosPorEstado (objeto contador por estado).
  throw new Error("TODO: implementar ventas(req, res, ctx)");
}

function manejar(req, res, ctx) {
  // TODO: despacha los reportes.
  // Solo GET con ctx.partes de 3 elementos. partes[2] === "inventario" o "ventas".
  // Resto -> 405 { error: "Método no permitido" } o 404 { error: "Reporte no encontrado" }.
  throw new Error("TODO: implementar manejar(req, res, ctx)");
}

module.exports = { manejar };
