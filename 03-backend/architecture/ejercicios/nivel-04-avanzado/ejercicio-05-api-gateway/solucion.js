class ApiGateway {
  constructor() {
    this.routes = new Map();
  }
  register(prefix, service) {
    this.routes.set(prefix, service);
    return this;
  }
  request(path, token) {
    // Auth: sin token → 401
    if (!token) return { status: 401, body: { error: 'no autorizado' } };
    // Routing: busca el servicio cuyo prefijo coincide
    for (const [prefix, service] of this.routes) {
      if (path.startsWith(prefix)) {
        return { status: 200, body: service.handle(path) };
      }
    }
    // No match → 404
    return { status: 404, body: { error: 'ruta no encontrada' } };
  }
}

// Servicios simulados (microservicios detrás del gateway)
const userService = { handle: (path) => ({ servicio: 'users', path }) };
const productService = { handle: (path) => ({ servicio: 'products', path }) };

module.exports = { ApiGateway, userService, productService };
