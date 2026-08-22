class Manejador {
  constructor() { this.next = null; }
  setNext(h) { this.next = h; return h; }
  manejar(req) {
    if (this.next) return this.next.manejar(req);
    return null;
  }
}

class AuthHandler extends Manejador {
  manejar(req) {
    if (!req.token) return { status: 401, body: 'no autorizado' };
    return super.manejar(req);  // pasa al siguiente
  }
}

class LogHandler extends Manejador {
  manejar(req) {
    console.log(`[log] ${req.path}`);
    return super.manejar(req);  // pasa al siguiente
  }
}

class NegocioHandler extends Manejador {
  manejar(req) {
    return { status: 200, body: 'OK' };
  }
}

module.exports = { Manejador, AuthHandler, LogHandler, NegocioHandler };
