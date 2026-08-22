// gateway/gateway.js - API Gateway: auth + routing + trace_id

const { CircuitBreaker } = require('../shared/circuit-breaker');

class ApiGateway {
  constructor() {
    this.routes = new Map(); // prefijo -> servicio
    this.tokens = new Set(['valid-token']); // tokens válidos (simulado)
  }
  register(prefix, service) {
    this.routes.set(prefix, service);
    return this;
  }
  // request: { path, token, body }
  request({ path, token, body }) {
    // Auth: sin token válido → 401
    if (!token || !this.tokens.has(token)) {
      return { status: 401, body: { error: 'no autorizado' } };
    }
    // Genera trace_id y lo propaga
    const trace_id = Math.random().toString(36).slice(2, 10);
    // Routing
    for (const [prefix, service] of this.routes) {
      if (path.startsWith(prefix)) {
        // Envuelve la llamada al servicio con Circuit Breaker
        const cb = service._cb || new CircuitBreaker();
        service._cb = cb;
        try {
          const result = cb.call(() => service.handle({ path, body, trace_id }));
          return { status: 200, body: result, trace_id };
        } catch (e) {
          return { status: 503, body: { error: e.message }, trace_id };
        }
      }
    }
    return { status: 404, body: { error: 'ruta no encontrada' }, trace_id };
  }
}

module.exports = { ApiGateway };
