// bus.js - EventBus en memoria compartido (simula RabbitMQ/Kafka)
// En producción: reemplazar por conexión real a un broker.

class EventBus {
  constructor() {
    this._subs = new Map(); // tipoEvento -> Set(handler)
  }
  subscribe(eventType, handler) {
    if (!this._subs.has(eventType)) this._subs.set(eventType, new Set());
    this._subs.get(eventType).add(handler);
    return () => this._subs.get(eventType)?.delete(handler); // unsubscribe
  }
  publish(event) {
    const tipo = event.constructor.name;
    const handlers = this._subs.get(tipo);
    if (handlers) for (const h of handlers) h(event);
  }
}

// Instancia singleton compartida por todos los servicios (en un proceso)
const bus = new EventBus();
module.exports = { bus, EventBus };

// === Eventos del dominio (contrato compartido) ===
class UsuarioCreado {
  constructor(usuario_id, email) {
    this.usuario_id = usuario_id; this.email = email;
  }
}
class PedidoCreado {
  constructor(pedido_id, cliente_id, items, trace_id) {
    this.pedido_id = pedido_id; this.cliente_id = cliente_id;
    this.items = items; this.trace_id = trace_id;
  }
}
class PagoConfirmado {
  constructor(pedido_id, cliente_id, trace_id) {
    this.pedido_id = pedido_id; this.cliente_id = cliente_id; this.trace_id = trace_id;
  }
}
class PagoFallido {
  constructor(pedido_id, cliente_id, trace_id) {
    this.pedido_id = pedido_id; this.cliente_id = cliente_id; this.trace_id = trace_id;
  }
}
class ProductoActualizado {
  constructor(producto_id, trace_id) { this.producto_id = producto_id; this.trace_id = trace_id; }
}

module.exports.eventos = {
  UsuarioCreado, PedidoCreado, PagoConfirmado, PagoFallido, ProductoActualizado,
};
module.exports.bus = bus;
module.exports.EventBus = EventBus;
