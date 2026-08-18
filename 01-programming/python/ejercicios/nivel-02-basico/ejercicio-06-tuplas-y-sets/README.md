# Ejercicio 06 — Tuplas y sets

- **Nivel:** 2/5
- **Tema:** tuplas, desempaquetado, sets, operaciones de conjunto
- **Tiempo estimado:** 20 min

## Enunciado

Completa `main.py` para que implemente:

1. `desempaquetar(punto)` — desempaqueta la tupla `punto` en `x, y` y devuelve la tupla `(x, y)`.
2. `es_inmutable(punto)` — intenta asignar `punto[0] = 10` dentro de un `try/except` capturando `TypeError`; devuelve `True` si la tupla es inmutable y `False` en caso contrario.
3. `union(a, b)` — devuelve la unión de dos sets (`a | b`).
4. `interseccion(a, b)` — devuelve la intersección de dos sets (`a & b`).
5. `diferencia(a, b)` — devuelve la diferencia `a - b`.
6. `sin_duplicados(lista)` — elimina los duplicados de la lista con `set()` y devuelve el resultado ordenado con `sorted`.

Salida esperada (ejemplo de checks):

```
desempaquetar((3, 5)) devuelve (3, 5)
es_inmutable((3, 5)) devuelve True
union({"ana", "luis", "maria"}, {"luis", "carlos", "pablo"}) devuelve {'ana', 'carlos', 'luis', 'maria', 'pablo'}
interseccion(a, b) devuelve {'luis'}
diferencia(a, b) devuelve {'ana', 'maria'}
sin_duplicados([1, 2, 2, 3, 3, 3, 4]) devuelve [1, 2, 3, 4]
```

## Requisitos

- [ ] Desempaquetar la tupla en `x, y`.
- [ ] Capturar `TypeError` al intentar modificar la tupla.
- [ ] Usar `|`, `&` y `-` con sets.
- [ ] Convertir una lista a set para deduplicar y ordenar con `sorted`.
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

- La unión se hace con `a | b`, la intersección con `a & b` y la diferencia con `a - b`.
- `set(lista)` elimina duplicados; `sorted(set(...))` devuelve una lista ordenada.
- El orden de los sets no está garantizado, así que no te preocupes por el orden de los elementos de la unión en la salida.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````python
def desempaquetar(punto):
    x, y = punto
    return x, y


def es_inmutable(punto):
    try:
        punto[0] = 10
    except TypeError:
        return True
    return False


def union(a, b):
    return a | b


def interseccion(a, b):
    return a & b


def diferencia(a, b):
    return a - b


def sin_duplicados(lista):
    return sorted(set(lista))


if __name__ == "__main__":
    punto = (3, 5)
    x, y = desempaquetar(punto)
    print(f"x={x}, y={y}")
    print("Las tuplas son inmutables" if es_inmutable(punto) else "Mutable")

    estudiantes_a = {"ana", "luis", "maria"}
    estudiantes_b = {"luis", "carlos", "pablo"}
    print(f"Unión: {union(estudiantes_a, estudiantes_b)}")
    print(f"Intersección: {interseccion(estudiantes_a, estudiantes_b)}")
    print(f"Diferencia: {diferencia(estudiantes_a, estudiantes_b)}")

    numeros = [1, 2, 2, 3, 3, 3, 4]
    print(f"Sin duplicados: {sin_duplicados(numeros)}")
````

</details>