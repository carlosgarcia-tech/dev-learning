# Ejercicio 02 — List comprehensions

- **Nivel:** 2/5
- **Tema:** list comprehensions, map, filter
- **Tiempo estimado:** 15 min

## Enunciado

Completa `main.py` para que implemente:

1. `numeros()` — devuelve la lista base `list(range(1, 21))`.
2. `cuadrados(numeros)` — devuelve una lista con cada número de `numeros` elevado al cuadrado.
3. `pares(numeros)` — devuelve una lista con solo los números pares.
4. `multiplos_de_3(numeros)` — devuelve una lista con solo los múltiplos de 3.
5. `etiquetas(numeros)` — devuelve una lista de strings `par` para pares e `impar` para impares.
6. `divididos(numeros)` — devuelve una lista con cada número dividido entre 2 (como `float`).

Salida esperada (ejemplo de checks):

```
cuadrados(numeros())[0] devuelve 1
cuadrados(numeros())[-1] devuelve 400
pares(numeros()) devuelve [2, 4, 6, ..., 20]
multiplos_de_3(numeros()) devuelve [3, 6, 9, 12, 15, 18]
etiquetas(numeros())[0] devuelve "impar"
etiquetas(numeros())[1] devuelve "par"
divididos([1, 2, 3]) devuelve [0.5, 1.0, 1.5]
```

## Requisitos

- [ ] `numeros()` usa `list(range(1, 21))`.
- [ ] Escribir una comprehension por cada lista pedida.
- [ ] Usar condición `if` dentro de las comprehensions 2 y 3.
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

- Sintaxis: `[expresion for elemento in iterable if condicion]`.
- Par: `n % 2 == 0`; múltiplo de 3: `n % 3 == 0`.
- Para `divididos` no olvides que la división real devuelve `float`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````python
def numeros():
    return list(range(1, 21))


def cuadrados(numeros):
    return [n ** 2 for n in numeros]


def pares(numeros):
    return [n for n in numeros if n % 2 == 0]


def multiplos_de_3(numeros):
    return [n for n in numeros if n % 3 == 0]


def etiquetas(numeros):
    return ["par" if n % 2 == 0 else "impar" for n in numeros]


def divididos(numeros):
    return [n / 2 for n in numeros]


if __name__ == "__main__":
    nums = numeros()
    print(f"Cuadrados: {cuadrados(nums)}")
    print(f"Pares: {pares(nums)}")
    print(f"Múltiplos de 3: {multiplos_de_3(nums)}")
    print(f"Etiquetas: {etiquetas(nums)}")
    print(f"Divididos: {divididos(nums)}")
````

</details>