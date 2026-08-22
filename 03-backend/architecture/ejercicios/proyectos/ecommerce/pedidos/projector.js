// pedidos/projector.js - sincroniza el read model desde los eventos del write model

class PedidosProjector {
  constructor(readModel) {
    this.readModel = readModel; // Map<cliente_id, [resumen]>
  }
  // Escucha PedidoCreado y proyecta a la vista denormalizada
  onPedidoCreado(e) {
    const total = (e.items || []).reduce((s, i) => s + i.precio * i.cantidad, 0);
    const resumen = { pedido_id: e.pedido_id, total, estado: 'confirmado' };
    const lista = this.readModel.get(e.cliente_id) || [];
    lista.push(resumen);
    this.readModel.set(e.cliente_id, lista);
  }
  // Actualiza el estado en la vista cuando se confirma el pago
  onPagoConfirmado(e) {
    const lista = this.readModel.get(e.cliente_id) || [];
    const r = lista.find(x => x.pedido_id === e.pedido_id);
    if (r) r.estado = 'pagado';
  }
  // Actualiza el estado en la vista cuando se cancela (pago fallido)
  onPagoFallido(e) {
    const lista = this.readModel.get(e.cliente_id) || [];
    const r = lista.find(x => x.pedido_id === e.pedido_id);
    if (r) r.estado = 'cancelado';
  }
}

module.exports = { PedidosProjector };
