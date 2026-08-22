// pedidos/aggregate.js - Aggregate root Pedido (DDD) con invariantes

class Pedido {
  constructor(id, cliente_id) {
    this.id = id;
    this.cliente_id = cliente_id;
    this.items = [];
    this.estado = 'borrador';
  }
  // Invariante: no se puede modificar un pedido confirmado
  addItem(item) {
    if (this.estado === 'confirmado') {
      throw new Error('no se puede modificar un pedido confirmado');
    }
    if (!item || item.cantidad <= 0) throw new Error('item inválido');
    this.items.push(item);
  }
  total() {
    return this.items.reduce((s, i) => s + i.precio * i.cantidad, 0);
  }
  // Invariante: no confirmar un pedido vacío
  confirmar() {
    if (this.items.length === 0) throw new Error('no se puede confirmar un pedido vacío');
    this.estado = 'confirmado';
  }
  cancelar() {
    this.estado = 'cancelado';
  }
  marcarPagado() {
    this.estado = 'pagado';
  }
}

module.exports = { Pedido };
