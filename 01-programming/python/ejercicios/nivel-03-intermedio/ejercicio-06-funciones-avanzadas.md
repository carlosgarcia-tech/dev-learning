# Ejercicio 06 — Funciones avanzadas

- **Nivel:** 3/5
- **Tema:** *args, **kwargs, map, filter, sorted, lambdas, functools.reduce
- **Tiempo estimado:** 30 min

## Enunciado

Crea un archivo `funciones_avanzadas.py` que:

1. Defina `sumar_todos(*args)` que devuelva la suma de todos los argumentos posicionales.
2. Defina `imprimir_datos(**kwargs)` que imprima cada par `clave: valor`.
3. Use `map` con una lambda para elevar al cuadrado la lista `[1, 2, 3, 4, 5]` e imprima la lista resultante.
4. Use `filter` con una lambda para quedarse con los pares de la lista e imprima el resultado.
5. Use `sorted` con `key=lambda` para ordenar la lista `[("ana", 30), ("luis", 22), ("pedro", 28)]` por edad e imprima la lista ordenada.
6. Use `functools.reduce` con una lambda para multiplicar todos los números de `[1, 2, 3, 4]` e imprima el resultado.

Salida esperada:

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
- [ ] Ejecutarlo localmente con `python3 funciones_avanzadas.py` y verificar la salida.

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
    for clave, valor in kwargs.items():
        print(f"  {clave}={valor}")


print(f"Suma de 1..5: {sumar_todos(1, 2, 3, 4, 5)}")
print("datos:")
imprimir_datos(nombre="Ana", edad=30, ciudad="Lima")

cuadrados = list(map(lambda x: x ** 2, [1, 2, 3, 4, 5]))
print(f"Cuadrados: {cuadrados}")

pares = list(filter(lambda x: x % 2 == 0, [1, 2, 3, 4, 5, 6]))
print(f"Pares: {pares}")

personas = [("ana", 30), ("luis", 22), ("pedro", 28)]
ordenadas = sorted(personas, key=lambda p: p[1])
print(f"Ordenados por edad: {ordenadas}")

producto = functools.reduce(lambda a, b: a * b, [1, 2, 3, 4])
print(f"Producto: {producto}")
````

</details>