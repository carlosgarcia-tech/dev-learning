// pagos/service.js - microservicio de pagos (reacciona a PedidoCreado)

const { bus, eventos } = require('../bus');
const { Logger } = require('../shared/logger');

class PagosService {
  constructor(falla = false) {
    this.db = new Map(); // BD propia
    this.logger = new Logger();
    this.falla = falla; // simula fallo de pago (para probar compensaciones)
  }
  // Reacciona a PedidoCreado: intenta cobrar
  onPedidoCreado(e) {
    this.logger.info('procesando pago', e.trace_id, { pedido_id: e.pedido_id });
    if (this.falla) {
      this.logger.error('pago fallido', e.trace_id, { pedido_id: e.pedido_id });
      bus.publish(new eventos.PagoFallido(e.pedido_id, e.cliente_id, e.trace_id));
    } else {
      const cobro = { pedido_id: e.pedido_id, estado: 'cobrado' };
      this.db.set(e.pedido_id, cobro);
      this.logger.info('pago confirmado', e.trace_id, { pedido_id: e.pedido_id });
      bus.publish(new eventos.PagoConfirmado(e.pedido_id, e.cliente_id, e.trace_id));
    }
  }
}

module.exports = { PagosService };
