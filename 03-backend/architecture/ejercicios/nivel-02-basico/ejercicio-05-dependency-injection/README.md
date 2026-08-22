# Ejercicio 05 — Dependency Injection

- **Nivel:** 2/5
- **Tema:** Contenedor DI básico (registro y resolución)
- **Tiempo estimado:** 35 min

## Enunciado

Implementa un **contenedor de Dependency Injection** mínimo que registre dependencias y las resuelva, inyectándolas automáticamente en los constructores.

El archivo `solucion.py` debe contener:

- Una clase `Container` con métodos `register(interfaz, implementacion)` y `resolve(interfaz)`.
- El `resolve` debe instanciar la implementación e inyectar sus dependencias (resolviéndolas recursivamente).
- Ejemplo: `UserService` depende de `UserRepository`; al resolver `UserService`, el container resuelve primero `UserRepository` y lo inyecta.

Pasos:

1. Examina `estructura.json` y `diagrama.txt`.
2. Implementa `solucion.py`.
3. Ejecuta `bash test.sh`.

## Requisitos

- [ ] `solucion.py` define `Container` con `register(interfaz, impl)` y `resolve(interfaz)`
- [ ] `resolve` instancia la implementación y le inyecta sus dependencias
- [ ] Al resolver `UserService`, el container resuelve `UserRepository` y lo pasa al constructor
- [ ] `UserService` recibe el repo por constructor
- [ ] `estructura.json` es JSON válido
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `register` guarda en un dict: `self._bindings[interfaz] = impl`.
- `resolve` necesita saber qué dependencias inyectar. Una forma sencilla: cada implementación expone una lista `deps = [UserRepository]` (clase de dependencia) y el container las resuelve recursivamente.
- En `resolve`: si la impl tiene `deps`, resuelve cada una y las pasa al constructor; si no, instancia sin args.
- Alternativa simple para este ejercicio: las dependencias se resuelven por **nombre de parámetro del constructor** usando `inspect`. Pero la versión con `deps` es más pedagógica.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

`solucion.py`:

```python
class Container:
    def __init__(self):
        self._bindings = {}
        self._singletons = {}

    def register(self, interfaz, impl):
        self._bindings[interfaz] = impl

    def resolve(self, interfaz):
        if interfaz not in self._bindings:
            raise KeyError(f"No hay implementación registrada para {interfaz}")
        impl = self._bindings[interfaz]
        # Dependencias declaradas en la clase
        deps = getattr(impl, "deps", [])
        instancias = [self.resolve(d) for d in deps]
        return impl(*instancias)


# Ejemplo de uso
class UserRepository:
    deps = []   # sin dependencias
    def find(self, id): return {"id": id, "name": "Ana"}

class UserService:
    deps = [UserRepository]   # depende de UserRepository
    def __init__(self, repo):
        self.repo = repo
    def get_user(self, id):
        return self.repo.find(id)
```

Uso:

```python
c = Container()
c.register(UserRepository, UserRepository)
c.register(UserService, UserService)
svc = c.resolve(UserService)
print(svc.get_user(1))  # {'id': 1, 'name': 'Ana'}
```

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
