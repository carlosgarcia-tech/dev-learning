# Ejercicio 05 — Recursión

- **Nivel:** 3/5
- **Tema:** recursión, caso base, factorial, Fibonacci, memoización
- **Tiempo estimado:** 25 min

## Enunciado

Crea un archivo `recursion.py` que:

1. Defina `factorial(n)` recursivo: `1` si `n <= 1`, si no `n * factorial(n - 1)`.
2. Defina `fibonacci(n)` recursivo: `n` si `n <= 1`, si no `fibonacci(n - 1) + fibonacci(n - 2)`.
3. Defina `suma_lista(lista)` recursivo que sume los elementos (caso base: lista vacía devuelve 0).
4. Imprima `factorial(5)`, `factorial(0)`, `fibonacci(10)` y `suma_lista([1, 2, 3, 4, 5])`.

Salida esperada:

```
factorial(5) = 120
factorial(0) = 1
fibonacci(10) = 55
suma_lista([1, 2, 3, 4, 5]) = 15
```

## Requisitos

- [ ] Definir las 3 funciones recursivas con su caso base.
- [ ] Llamar a cada función con los valores pedidos.
- [ ] No usar bucles dentro de las funciones recursivas.
- [ ] Ejecutarlo localmente con `python3 recursion.py` y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Toda recursión necesita un **caso base** que detenga las llamadas.
- `factorial(5)` es `5 * 4 * 3 * 2 * 1 = 120`.
- Para `fibonacci`, el caso base es `n <= 1` devolviendo `n`.
- Recuerda que la recursión sin caso base desborda la pila con `RecursionError`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````python
def factorial(n):
    if n <= 1:
        return 1
    return n * factorial(n - 1)


def fibonacci(n):
    if n <= 1:
        return n
    return fibonacci(n - 1) + fibonacci(n - 2)


def suma_lista(lista):
    if not lista:
        return 0
    return lista[0] + suma_lista(lista[1:])


print(f"factorial(5) = {factorial(5)}")
print(f"factorial(0) = {factorial(0)}")
print(f"fibonacci(10) = {fibonacci(10)}")
print(f"suma_lista([1, 2, 3, 4, 5]) = {suma_lista([1, 2, 3, 4, 5])}")
````

</details>