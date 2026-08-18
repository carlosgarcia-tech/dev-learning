# Ejercicio 03 — Context managers

- **Nivel:** 4/5
- **Tema:** with, __enter__, __exit__, contextlib.contextmanager
- **Tiempo estimado:** 30 min

## Enunciado

Completa `main.py` para que implemente:

1. La clase `Temporizador` con:
   - `__enter__` que registra el tiempo de inicio en `self.inicio` con `time.perf_counter()` y devuelve `self`.
   - `__exit__` que guarda el tiempo transcurrido en `self.transcurrido`, imprime `Transcurrido: X.XXXXs` y devuelve `False` (no suprime excepciones).
2. `sumar_uno_a_millon()` — devuelve `sum(range(1, 1_000_001))`.
3. El context manager `ignorar(Error)` usando `@contextlib.contextmanager` que capture la excepción indicada dentro del bloque `with`, imprima `Excepción ignorada: <tipo>` y no la propague.
4. `main()` — usa `with Temporizador():` para ejecutar `sumar_uno_a_millon()` y `with ignorar(ValueError):` para envolver `int("no es número")`.

Salida esperada (ejemplo):

```
Transcurrido: 0.0134s
Suma: 500000500000
Excepción ignorada: <class 'ValueError'>
Programa terminado
```

## Requisitos

- [ ] Implementar `__enter__` y `__exit__` en una clase.
- [ ] Usar `with` con la clase.
- [ ] Crear un context manager con `@contextlib.contextmanager` y `yield`.
- [ ] Comprobar que `__exit__` devuelve `False` para no ocultar errores.
- [ ] Los tests pasan: `python3 test_main.py`

> **Cómo ejecutar los tests**
>
> Desde la carpeta del ejercicio:
>
> ```bash
> python3 test_main.py
> ```
>
> El runner devuelve `0` si todos los tests pasan y `1` si falla alguno.

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
        self.transcurrido = time.perf_counter() - self.inicio
        print(f"Transcurrido: {self.transcurrido:.4f}s")
        return False


def sumar_uno_a_millon() -> int:
    return sum(range(1, 1_000_001))


@contextlib.contextmanager
def ignorar(Error):
    try:
        yield
    except Error as e:
        print(f"Excepción ignorada: {type(e)}")


def main() -> None:
    with Temporizador():
        total = sumar_uno_a_millon()
        print(f"Suma: {total}")

    with ignorar(ValueError):
        int("no es número")

    print("Programa terminado")


if __name__ == "__main__":
    main()
````

</details>