# Ejercicio 01 — Implementar Repository pattern

- **Nivel:** 2/5
- **Tema:** Patrón Repository con abstracción de persistencia
- **Tiempo estimado:** 30 min

## Enunciado

Implementa el patrón **Repository** para que el dominio no conozca la BD. Define una interfaz `UserRepository` (puerto) con `save`, `findById`, `findByEmail` y dos implementaciones: `MySQLUserRepository` (simulada) y `InMemoryUserRepository` (real, para tests).

El `UserService` (dominio) debe depender de la **interfaz**, no de una implementación concreta. En tests se inyecta `InMemoryUserRepository`.

El archivo `solucion.py` debe contener:

- Una clase abstracta `UserRepository` (puerto).
- `InMemoryUserRepository` (implementación real, usa un dict).
- `MySQLUserRepository` (simulada, imprime lo que haría).
- `UserService` que recibe el repositorio por constructor y solo usa la interfaz.

Pasos:

1. Examina `estructura.json`.
2. Implementa `solucion.py`.
3. Ejecuta `bash test.sh`.

## Requisitos

- [ ] `solucion.py` define la interfaz abstracta `UserRepository` con `save`, `findById`, `findByEmail`
- [ ] `solucion.py` define `InMemoryUserRepository` (implementa con un dict real)
- [ ] `solucion.py` define `MySQLUserRepository` (simulada con prints)
- [ ] `solucion.py` define `UserService` que recibe el repo por constructor
- [ ] `UserService` solo usa métodos de la interfaz (no SQL directo)
- [ ] `estructura.json` es JSON válido
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Usa `abc.ABC` para la interfaz `UserRepository`.
- `InMemoryUserRepository` guarda en un dict indexado por id; mantiene también índice por email.
- `UserService.register(email)` comprueba duplicados con `repo.findByEmail` antes de guardar.
- La inyección: `UserService(InMemoryUserRepository())` en tests, `UserService(MySQLUserRepository())` en prod.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`solucion.py`:

```python
from abc import ABC, abstractmethod

# Interfaz (puerto driven)
class UserRepository(ABC):
    @abstractmethod
    def save(self, user): ...
    @abstractmethod
    def find_by_id(self, id): ...
    @abstractmethod
    def find_by_email(self, email): ...

# Implementación para tests (real, en memoria)
class InMemoryUserRepository(UserRepository):
    def __init__(self):
        self._by_id = {}
        self._by_email = {}
    def save(self, user):
        self._by_id[user["id"]] = user
        self._by_email[user["email"]] = user
        return user
    def find_by_id(self, id):
        return self._by_id.get(id)
    def find_by_email(self, email):
        return self._by_email.get(email)

# Implementación "de producción" (simulada)
class MySQLUserRepository(UserRepository):
    def save(self, user):
        print(f"[MySQL] INSERT INTO users ... {user}")
        return user
    def find_by_id(self, id):
        print(f"[MySQL] SELECT * FROM users WHERE id={id}")
        return None
    def find_by_email(self, email):
        print(f"[MySQL] SELECT * FROM users WHERE email={email}")
        return None

# Dominio: depende de la INTERFAZ, no de MySQL
class UserService:
    def __init__(self, repo: UserRepository):
        self.repo = repo
    def register(self, email):
        if self.repo.find_by_email(email):
            raise ValueError("ya existe")
        user = {"id": f"u-{email}", "email": email}
        self.repo.save(user)
        return user
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
