// usuarios/service.js - microservicio de usuarios (BD propia)

const { bus, eventos } = require('../bus');
const { Logger } = require('../shared/logger');

class UsuariosService {
  constructor() {
    this.db = new Map(); // BD propia (no compartida)
    this.logger = new Logger();
  }
  handle({ path, body, trace_id }) {
    if (path.startsWith('/usuarios') && path.includes('/register')) {
      return this.register(body, trace_id);
    }
    if (path.startsWith('/usuarios')) {
      return this.list(trace_id);
    }
    throw new Error('ruta no soportada');
  }
  register(body, trace_id) {
    const id = 'u-' + Math.random().toString(36).slice(2);
    const user = { id, email: body.email };
    this.db.set(id, user);
    this.logger.info('usuario creado', trace_id, { usuario_id: id });
    bus.publish(new eventos.UsuarioCreado(id, body.email));
    return user;
  }
  list(trace_id) {
    return [...this.db.values()];
  }
}

module.exports = { UsuariosService };
