# Ejercicio 06 — Funciones avanzadas

- **Nivel:** 3/5
- **Tema:** *args, **kwargs, map, filter, sorted, lambdas, functools.reduce
- **Tiempo estimado:** 30 min

## Enunciado

Completa `main.py` para que implemente:

1. `sumar_todos(*args)` — devuelve la suma de todos los argumentos posicionales.
2. `imprimir_datos(**kwargs)` — devuelve un `str` con cada par `clave: valor` en una línea propia (formato `  clave=valor`).
3. `elevar_al_cuadrado(numeros)` — usa `map` con una lambda para elevar al cuadrado cada número y devuelve la lista resultante.
4. `filtrar_pares(numeros)` — usa `filter` con una lambda para quedarse con los pares y devuelve la lista resultante.
5. `ordenar_por_edad(personas)` — usa `sorted` con `key=lambda` para ordenar las tuplas `(nombre, edad)` por edad.
6. `multiplicar_todos(numeros)` — usa `functools.reduce` con una lambda para multiplicar todos los números.

El bloque `if __name__ == "__main__":` puede servir de demo con los valores de ejemplo:

```
Suma de 1..5: 15
datos:
  nombre=Ana
  edad=30
  ciudad=Lima
Cuadrados: [1, 4, 9, 16, 25]
Pares: [2, 4, 6]
Ordenados por edad: [('luis', 22), ('pedro', 28), ('ana', 30)]
Producto: 24
```

## Requisitos

- [ ] Usar `*args` y `**kwargs` en las funciones.
- [ ] Usar `map`, `filter`, `sorted` con `key` y `functools.reduce`.
- [ ] Escribir al menos 3 lambdas.
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

- `map(f, lista)` devuelve un iterador; conviértelo con `list()`.
- `sorted(lista, key=lambda t: t[1])` ordena por el segundo elemento de cada tupla.
- `reduce` está en `functools`; recibe la función, la lista y un valor inicial opcional.
- `**kwargs` es un diccionario; itera con `.items()`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````python
import functools


def sumar_todos(*args):
    return sum(args)


def imprimir_datos(**kwargs):
    return "\n".join(f"  {clave}={valor}" for clave, valor in kwargs.items())


def elevar_al_cuadrado(numeros):
    return list(map(lambda x: x ** 2, numeros))


def filtrar_pares(numeros):
    return list(filter(lambda x: x % 2 == 0, numeros))


def ordenar_por_edad(personas):
    return sorted(personas, key=lambda p: p[1])


def multiplicar_todos(numeros):
    return functools.reduce(lambda a, b: a * b, numeros)


if __name__ == "__main__":
    print(f"Suma de 1..5: {sumar_todos(1, 2, 3, 4, 5)}")
    print("datos:")
    print(imprimir_datos(nombre="Ana", edad=30, ciudad="Lima"))

    print(f"Cuadrados: {elevar_al_cuadrado([1, 2, 3, 4, 5])}")
    print(f"Pares: {filtrar_pares([1, 2, 3, 4, 5, 6])}")

    personas = [("ana", 30), ("luis", 22), ("pedro", 28)]
    print(f"Ordenados por edad: {ordenar_por_edad(personas)}")

    print(f"Producto: {multiplicar_todos([1, 2, 3, 4])}")
````

</details>