// productos/service.js - microservicio de productos (BD propia + cache)

const { bus, eventos } = require('../bus');
const { Logger } = require('../shared/logger');

class ProductosService {
  constructor() {
    this.db = new Map();    // BD propia
    this.cache = new Map(); // simula Redis
    this.logger = new Logger();
    this.reservas = new Map(); // producto_id -> cantidad reservada
  }
  handle({ path, body, trace_id }) {
    if (path.includes('/productos') && path.includes('/create')) return this.create(body, trace_id);
    if (path.includes('/productos')) return this.list(trace_id);
    throw new Error('ruta no soportada');
  }
  create(body, trace_id) {
    const id = 'p-' + Math.random().toString(36).slice(2);
    const prod = { id, nombre: body.nombre, precio: body.precio, stock: body.stock };
    this.db.set(id, prod);
    this.cache.delete('all'); // invalida cache (write-through)
    this.logger.info('producto creado', trace_id, { producto_id: id });
    bus.publish(new eventos.ProductoActualizado(id, trace_id));
    return prod;
  }
  // Cache-aside: lee cache; si miss, lee BD y llena cache
  list(trace_id) {
    if (this.cache.has('all')) {
      this.logger.info('cache hit', trace_id);
      return this.cache.get('all');
    }
    this.logger.info('cache miss', trace_id);
    const all = [...this.db.values()];
    this.cache.set('all', all); // TTL implícito
    return all;
  }
  // Saga: reservar stock al crear pedido
  onPedidoCreado(e) {
    const total = (e.items || []).reduce((s, i) => s + (i.cantidad || 0), 0);
    this.reservas.set(e.pedido_id, total);
    this.logger.info('stock reservado', e.trace_id, { pedido_id: e.pedido_id, total });
  }
  // Compensación: liberar stock si el pago falla
  onPagoFallido(e) {
    this.reservas.delete(e.pedido_id);
    this.logger.info('stock liberado (compensación)', e.trace_id, { pedido_id: e.pedido_id });
  }
}

module.exports = { ProductosService };
