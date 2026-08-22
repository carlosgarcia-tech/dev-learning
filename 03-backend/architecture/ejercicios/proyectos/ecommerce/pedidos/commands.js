// pedidos/commands.js - CQRS write model: command handler

const { Pedido } = require('./aggregate');
const { bus, eventos } = require('../bus');
const { Logger } = require('../shared/logger');

class CrearPedidoHandler {
  constructor(writeModel) {
    this.writeModel = writeModel; // lista de pedidos (normalizado)
    this.logger = new Logger();
  }
  handle(command, trace_id) {
    const pedido = new Pedido('ped-' + Math.random().toString(36).slice(2), command.cliente_id);
    for (const item of command.items) pedido.addItem(item);
    pedido.confirmar(); // aplica invariante: lanzaría si vacío
    this.writeModel.push(pedido);
    this.logger.info('pedido creado', trace_id, { pedido_id: pedido.id });
    // Publica evento (dispara la saga coreografiada)
    bus.publish(new eventos.PedidoCreado(pedido.id, pedido.cliente_id, pedido.items, trace_id));
    return pedido.id;
  }
}

// Reacciones de pedidos a eventos de la saga
class PedidosReactions {
  constructor(writeModel, logger) {
    this.writeModel = writeModel;
    this.logger = logger;
  }
  onPagoConfirmado(e) {
    const pedido = this.writeModel.find(p => p.id === e.pedido_id);
    if (pedido) {
      pedido.marcarPagado();
      this.logger.info('pedido marcado como pagado', e.trace_id, { pedido_id: e.pedido_id });
    }
  }
  onPagoFallido(e) {
    const pedido = this.writeModel.find(p => p.id === e.pedido_id);
    if (pedido) {
      pedido.cancelar();
      this.logger.info('pedido cancelado por pago fallido', e.trace_id, { pedido_id: e.pedido_id });
    }
  }
}

module.exports = { CrearPedidoHandler, PedidosReactions };
