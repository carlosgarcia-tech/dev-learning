// Capa de datos (Repository)
class UserRepository {
  constructor() { this.db = new Map(); }
  save(user) {
    this.db.set(user.id, user);
    return user; // simula INSERT
  }
  findById(id) { return this.db.get(id); }
}

// Capa de negocio (Service) — valida reglas, no conoce HTTP ni SQL
class UserService {
  constructor(repo) { this.repo = repo; }   // inyección
  createUser(name, email) {
    if (!email || !email.includes('@')) throw new Error('email inválido');
    const user = { id: 'u-' + Math.random().toString(36).slice(2), name, email };
    return this.repo.save(user);
  }
}

// Capa de presentación (Controller) — traduce HTTP, sin lógica ni SQL
class UserController {
  constructor(service) { this.service = service; }  // inyección
  postUser(body) {
    try {
      const user = this.service.createUser(body.name, body.email);
      return { status: 201, body: user };
    } catch (e) {
      return { status: 400, body: { error: e.message } };
    }
  }
}

module.exports = { UserRepository, UserService, UserController };
