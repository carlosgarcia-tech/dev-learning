# Ejercicio 03 — Generators y iterators

- **Nivel:** 3/5
- **Tema:** yield, generators, next, iter, Iterable
- **Tiempo estimado:** 25 min

## Enunciado

Completa `main.py` para que implemente:

1. El generator `contador_descendente(n)` que con `yield` produzca `n, n-1, ..., 0`.
2. El generator `fibonacci(limite)` que produzca los números de Fibonacci menores o iguales a `limite` (empieza por 0, 1).
3. El generator `pares_impares(n)` que intercale `("par", i)` para `i` par y `("impar", i)` para `i` impar desde `0` hasta `n`.

El bloque `if __name__ == "__main__":` puede servir de demo: recorre `contador_descendente(5)` con un `for` imprimiendo cada valor, usa `next()` sobre `fibonacci(50)` para imprimir los 3 primeros términos, recorre `pares_impares(5)` y convierte `contador_descendente(3)` a lista con `list(...)`.

Salida esperada:

```
Contador descendente: 5 4 3 2 1 0
Primeros Fibonacci: 0 1 1
Etiquetas hasta 5: ('par', 0) ('impar', 1) ('par', 2) ('impar', 3) ('par', 4) ('impar', 5)
Lista: [3, 2, 1, 0]
```

## Requisitos

- [ ] Definir los 3 generators con `yield`.
- [ ] Iterar `contador_descendente(5)` con `for`.
- [ ] Usar `next()` sobre un generator.
- [ ] Convertir un generator a lista con `list()`.
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

- Una función con `yield` devuelve un objeto generator.
- Los generators son "perezosos": producen un valor por iteración y recuerdan el estado.
- `next(gen)` obtiene el siguiente valor y lanza `StopIteration` al terminar.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````python
def contador_descendente(n):
    while n >= 0:
        yield n
        n -= 1


def fibonacci(limite):
    a, b = 0, 1
    while a <= limite:
        yield a
        a, b = b, a + b


def pares_impares(n):
    for i in range(n + 1):
        if i % 2 == 0:
            yield ("par", i)
        else:
            yield ("impar", i)


if __name__ == "__main__":
    print("Contador descendente:", *contador_descendente(5))

    fib = fibonacci(50)
    print("Primeros Fibonacci:", next(fib), next(fib), next(fib))

    print("Etiquetas hasta 5:", *pares_impares(5))

    print("Lista:", list(contador_descendente(3)))
````

</details>