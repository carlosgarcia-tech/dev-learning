// pedidos/queries.js - CQRS read model: query handler (vista denormalizada)

class PedidosQueryHandler {
  constructor(readModel) {
    this.readModel = readModel; // Map<cliente_id, [resumen]> denormalizado
  }
  handle(query) {
    // Devuelve los pedidos de un cliente (vista denormalizada, rápida)
    return this.readModel.get(query.cliente_id) || [];
  }
}

module.exports = { PedidosQueryHandler };
