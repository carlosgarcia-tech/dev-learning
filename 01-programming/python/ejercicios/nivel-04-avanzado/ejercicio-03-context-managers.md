# Ejercicio 03 — Context managers

- **Nivel:** 4/5
- **Tema:** with, __enter__, __exit__, contextlib.contextmanager
- **Tiempo estimado:** 30 min

## Enunciado

Crea un archivo `context_managers.py` que:

1. Defina la clase `Temporizador` con `__enter__` que registra el tiempo de inicio con `time.perf_counter()` y `__exit__` que imprime `Transcurrido: X.XXXXs` y devuelve `False` (no suprime excepciones).
2. Use la clase con `with Temporizador():` para ejecutar un bucle que sume del 1 al 1_000_000.
3. Defina el generator `ignorar(Error)` usando `@contextlib.contextmanager` que capture la excepción indicada dentro del bloque `with` e imprima `Excepción ignorada: <tipo>`.
4. Use `with ignorar(ValueError):` para envolver `int("no es número")`.

Salida esperada (ejemplo):

```
Transcurrido: 0.0134s
Excepción ignorada: <class 'ValueError'>
```

## Requisitos

- [ ] Implementar `__enter__` y `__exit__` en una clase.
- [ ] Usar `with` con la clase.
- [ ] Crear un context manager con `@contextlib.contextmanager` y `yield`.
- [ ] Comprobar que `__exit__` devuelve `False` para no ocultar errores.
- [ ] Ejecutarlo localmente con `python3 context_managers.py` y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `__exit__(self, exc_type, exc_val, exc_tb)` recibe la excepción; devolver `True` la suprime.
- Con `@contextlib.contextmanager`, el código antes de `yield` es la entrada y el de después, la salida.
- Envuelve el `yield` en `try/except` dentro del generator si quieres capturar errores.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````python
import contextlib
import time


class Temporizador:
    def __enter__(self):
        self.inicio = time.perf_counter()
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        print(f"Transcurrido: {time.perf_counter() - self.inicio:.4f}s")
        return False


with Temporizador():
    total = sum(range(1, 1_000_001))
    print(f"Suma: {total}")


@contextlib.contextmanager
def ignorar(Error):
    try:
        yield
    except Error as e:
        print(f"Excepción ignorada: {type(e)}")


with ignorar(ValueError):
    int("no es número")

print("Programa terminado")
````

</details>