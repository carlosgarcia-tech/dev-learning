# Ejercicio 01 — Identificar capas

- **Nivel:** 1/5
- **Tema:** Arquitectura en capas (presentación, negocio, datos)
- **Tiempo estimado:** 20 min

## Enunciado

Tienes un fragmento de código espagueti donde una sola función mezcla presentación, negocio y datos. Tu tarea es **identificar y separar** las tres capas: `Controller` (presentación), `Service` (negocio) y `Repository` (datos).

El archivo `solucion.js` debe contener una función `crearUsuarioHandler` que delegue correctamente en un `UserService` y este en un `UserRepository`, sin mezclar responsabilidades. La validación del email (regla de negocio) vive en el Service; el `INSERT` (dato) vive en el Repository; el formato HTTP vive en el Controller.

Pasos:

1. Examina `estructura.json` para ver la estructura esperada de las 3 capas.
2. Implementa `solucion.js` con las 3 clases desacopladas (constructor injection).
3. Ejecuta `bash test.sh`.

## Requisitos

- [ ] `solucion.js` define una clase `UserRepository` con método `save(user)`
- [ ] `solucion.js` define una clase `UserService` con método `createUser(name, email)`
- [ ] `solucion.js` define una clase `UserController` con método `postUser(body)`
- [ ] `UserService` valida que el email contenga `@` (regla de negocio)
- [ ] `UserService` recibe el repositorio por constructor (inyección)
- [ ] `UserController` no contiene SQL ni reglas de negocio, solo llama al service
- [ ] `estructura.json` es JSON válido y lista las 3 capas
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El controller recibe el service por constructor; el service recibe el repo por constructor.
- La validación `email.includes('@')` es regla de negocio → va en `UserService.createUser`.
- El `INSERT INTO users...` es acceso a datos → va en `UserRepository.save`.
- El controller devuelve un objeto `{status, body}`; no conoce SQL ni validaciones.
- `estructura.json` puede ser `{"capas": ["controller", "service", "repository"]}`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`solucion.js`:

```javascript
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

// Composición
const repo = new UserRepository();
const service = new UserService(repo);
const controller = new UserController(service);

// Exportar para tests
module.exports = { UserRepository, UserService, UserController };
```

`estructura.json`:

```json
{
  "capas": ["controller", "service", "repository"],
  "reglas": {
    "controller": "solo traduce HTTP, no tiene lógica ni SQL",
    "service": "valida reglas de negocio, no conoce HTTP ni SQL",
    "repository": "persiste datos, no conoce reglas de negocio"
  }
}
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
