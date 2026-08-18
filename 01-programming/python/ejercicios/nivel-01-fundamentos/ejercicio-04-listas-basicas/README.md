# Ejercicio 04 — Listas básicas

- **Nivel:** 1/5
- **Tema:** listas, append, índices, slicing, métodos
- **Tiempo estimado:** 15 min

## Enunciado

Completa `main.py` para que implemente funciones que trabajen con una lista de números:

1. `primero(lista)` — devuelve `lista[0]`.
2. `ultimo(lista)` — devuelve `lista[-1]`.
3. `ordenada(lista)` — devuelve una copia ordenada con `sorted()` (sin modificar la original).
4. `invertida(lista)` — devuelve la lista invertida con `[::-1]`.
5. `suma(lista)` — devuelve `sum(lista)`.
6. `minimo(lista)` — devuelve `min(lista)`.
7. `maximo(lista)` — devuelve `max(lista)`.
8. `dobles(lista)` — devuelve una lista nueva donde cada elemento se multiplique por 2 (usa un bucle `for` con `append`).

Salida esperada (con `[5, 2, 9, 1, 7, 3]`):

```
primero == 5
ultimo == 3
ordenada == [1, 2, 3, 5, 7, 9]
invertida == [3, 7, 1, 9, 2, 5]
suma == 27
minimo == 1
maximo == 9
dobles == [10, 4, 18, 2, 14, 6]
```

## Requisitos

- [ ] Usar índices `[0]` y `[-1]`, `sorted()`, `[::-1]`, `sum()`, `min()`, `max()`.
- [ ] `dobles` usa un bucle `for` y `append()` (no list comprehension).
- [ ] `ordenada` no modifica la lista original.
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

- `sorted(lista)` devuelve una copia ordenada sin modificar la original.
- `sum(lista)` suma todos los elementos numéricos.
- Para los dobles: `dobles = []` y luego `dobles.append(n * 2)` dentro del bucle.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````python
def primero(lista):
    return lista[0]


def ultimo(lista):
    return lista[-1]


def ordenada(lista):
    return sorted(lista)


def invertida(lista):
    return lista[::-1]


def suma(lista):
    return sum(lista)


def minimo(lista):
    return min(lista)


def maximo(lista):
    return max(lista)


def dobles(lista):
    resultado = []
    for n in lista:
        resultado.append(n * 2)
    return resultado


if __name__ == "__main__":
    numeros = [5, 2, 9, 1, 7, 3]
    print(f"Primero: {primero(numeros)}")
    print(f"Último: {ultimo(numeros)}")
    print(f"Ordenada: {ordenada(numeros)}")
    print(f"Invertida: {invertida(numeros)}")
    print(f"Suma: {suma(numeros)}")
    print(f"Mínimo: {minimo(numeros)}")
    print(f"Máximo: {maximo(numeros)}")
    print(f"Dobles: {dobles(numeros)}")
````

</details>