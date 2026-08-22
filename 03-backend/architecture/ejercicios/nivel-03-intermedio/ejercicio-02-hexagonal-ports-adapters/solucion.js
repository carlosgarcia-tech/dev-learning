// ===== PUERTO DRIVEN (lo que la app necesita del exterior) =====
class UserRepositoryPort {
  save(user) { throw new Error('no implementado'); }
  findByEmail(email) { throw new Error('no implementado'); }
}

// ===== NÚCLEO (caso de uso) — no conoce HTTP ni la BD concreta =====
class CreateUserUseCase {
  constructor(repo) { this.repo = repo; }   // depende del PUERTO, no de la impl
  execute(email) {
    if (this.repo.findByEmail(email)) throw new Error('ya existe');
    const user = { id: 'u-' + email, email };
    this.repo.save(user);
    return user;
  }
}

// ===== ADAPTADOR DRIVING (HTTP → use case) =====
class HttpUserController {
  constructor(useCase) { this.uc = useCase; }
  post(body) {
    try {
      const user = this.uc.execute(body.email);
      return { status: 201, body: user };
    } catch (e) {
      return { status: 400, body: { error: e.message } };
    }
  }
}

// ===== ADAPTADOR DRIVEN (implementa el puerto) =====
class InMemoryUserRepository extends UserRepositoryPort {
  constructor() { super(); this._byEmail = new Map(); }
  save(user) { this._byEmail.set(user.email, user); return user; }
  findByEmail(email) { return this._byEmail.get(email); }
}

module.exports = {
  UserRepositoryPort, CreateUserUseCase, HttpUserController, InMemoryUserRepository,
};
