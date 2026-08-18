# Ejercicio 05 — Bucles

- **Nivel:** 1/5
- **Tema:** for, while, range, break, continue
- **Tiempo estimado:** 20 min

## Enunciado

Completa `main.py` para que implemente funciones que usen distintos tipos de bucles:

1. `numeros_1_al_10()` — con un `for` + `range`, devuelve el string `"1, 2, 3, 4, 5, 6, 7, 8, 9, 10"`.
2. `tabla_multiplicar(base, limite)` — devuelve una **lista de strings** con la tabla de multiplicar de `base` del 1 al `limite` (formato `"7 x 1 = 7"`).
3. `suma_hasta(n)` — con un `while`, devuelve la suma de los números del 1 al `n`.
4. `numeros_pares(lista)` — recorre la lista y, usando `continue`, devuelve una lista con solo los pares.
5. `primer_multiplo_de(n)` — usando `break`, devuelve el primer número >= 1 divisible entre `n`.

Salida esperada (con `n = 100`, lista `[3, 7, 12, 5, 8, 15]`, `n = 21`):

```
numeros_1_al_10() == "1, 2, 3, 4, 5, 6, 7, 8, 9, 10"
tabla_multiplicar(7, 10)[0] == "7 x 1 = 7"
tabla_multiplicar(7, 10)[-1] == "7 x 10 = 70"
suma_hasta(100) == 5050
numeros_pares([3, 7, 12, 5, 8, 15]) == [12, 8]
primer_multiplo_de(21) == 21
```

## Requisitos

- [ ] Usar `for` con `range` para los puntos 1 y 2.
- [ ] Usar `while` para sumar del 1 al 100.
- [ ] Usar `continue` para saltar los impares.
- [ ] Usar `break` al encontrar el primer múltiplo de 21.
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

- `range(1, 11)` genera 1..10 (el 11 no se incluye).
- Un número es múltiplo de `n` si `numero % n == 0`.
- Para los pares: `if numero % 2 != 0: continue`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````python
def numeros_1_al_10() -> str:
    return ", ".join(str(i) for i in range(1, 11))


def tabla_multiplicar(base: int, limite: int) -> list:
    filas = []
    for i in range(1, limite + 1):
        filas.append(f"{base} x {i} = {base * i}")
    return filas


def suma_hasta(n: int) -> int:
    total = 0
    i = 1
    while i <= n:
        total += i
        i += 1
    return total


def numeros_pares(lista: list) -> list:
    pares = []
    for numero in lista:
        if numero % 2 != 0:
            continue
        pares.append(numero)
    return pares


def primer_multiplo_de(n: int) -> int:
    for i in range(1, n * 10 + 1):
        if i % n == 0:
            return i


if __name__ == "__main__":
    print(numeros_1_al_10())
    for fila in tabla_multiplicar(7, 10):
        print(fila)
    print(f"Suma 1..100: {suma_hasta(100)}")
    print(f"Pares: {numeros_pares([3, 7, 12, 5, 8, 15])}")
    print(f"Primer múltiplo de 21: {primer_multiplo_de(21)}")
````

</details>