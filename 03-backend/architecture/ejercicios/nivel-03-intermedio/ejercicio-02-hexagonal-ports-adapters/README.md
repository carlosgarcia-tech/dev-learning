# Ejercicio 02 — Arquitectura hexagonal (ports & adapters)

- **Nivel:** 3/5
- **Tema:** Puertos y adaptadores (hexagonal)
- **Tiempo estimado:** 40 min

## Enunciado

Implementa un núcleo hexagonal donde el **caso de uso** no conoce ni HTTP ni BD. Define puertos driving (de entrada) y driven (de salida), y adaptadores concretos.

El archivo `solucion.js` debe contener:

- Un **puerto driven** `UserRepositoryPort` (interfaz con `save`, `findByEmail`).
- Un **caso de uso** `CreateUserUseCase` que implementa el puerto driving y usa el driven.
- Un **adaptador driving** `HttpUserController` que traduce HTTP al use case.
- Un **adaptador driven** `InMemoryUserRepository` que implementa `UserRepositoryPort`.

Pasos:

1. Examina `estructura.json` y `diagrama.txt`.
2. Implementa `solucion.js`.
3. Ejecuta `bash test.sh`.

## Requisitos

- [ ] `solucion.js` define `UserRepositoryPort` con `save` y `findByEmail`
- [ ] `solucion.js` define `CreateUserUseCase` que recibe el repo por constructor
- [ ] `solucion.js` define `HttpUserController` (adaptador driving) con `post(body)`
- [ ] `solucion.js` define `InMemoryUserRepository` que implementa `UserRepositoryPort`
- [ ] El use case no importa nada de HTTP ni de la implementación concreta del repo
- [ ] `estructura.json` es JSON válido
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- En JS no hay interfaces formales; usa una clase base con métodos que lanzan error.
- `UserRepositoryPort`: `save(user)` y `findByEmail(email)` lanzan `new Error('no implementado')`.
- `InMemoryUserRepository extends UserRepositoryPort` con un Map.
- `CreateUserUseCase.execute(email)`: valida duplicado con `repo.findByEmail`, crea user, `repo.save`.
- `HttpUserController.post(body)` → `{status, body}`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`solucion.js`:

```javascript
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
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
