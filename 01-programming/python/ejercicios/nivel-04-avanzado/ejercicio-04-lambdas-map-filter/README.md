# Ejercicio 04 — Lambdas, map y filter

- **Nivel:** 4/5
- **Tema:** lambda, map, filter, sorted con key, functools.reduce
- **Tiempo estimado:** 20 min

## Enunciado

Completa `main.py` que trabaje con `numeros = [5, 12, 7, 18, 3, 21, 9]` y `palabras = ["python", "es", "genial", "para", "datos"]`:

1. `negativos(lista)` — con `map` + lambda, devuelve el valor absoluto negativo de cada número (`-n`).
2. `mayores_que(lista, limite=10)` — con `filter` + lambda, devuelve los números mayores que `limite`.
3. `longitudes(lista)` — con `map` + lambda, devuelve la longitud de cada palabra (`len`).
4. `ordenar_por_longitud(lista)` — con `sorted` + `key=lambda`, devuelve las palabras ordenadas por su longitud (de menor a mayor).
5. `maximo(lista)` — con `functools.reduce` + lambda, devuelve el mayor de los números.
6. `main()` — imprime la salida esperada usando las listas globales `numeros` y `palabras`.

Salida esperada:

```
Negativos: [-5, -12, -7, -18, -3, -21, -9]
Mayores que 10: [12, 18, 21]
Largos: [6, 2, 6, 4, 5]
Palabras por longitud: ['es', 'para', 'datos', 'python', 'genial']
Máximo: 21
```

## Requisitos

- [ ] Usar `map`, `filter` y `sorted` con lambdas.
- [ ] Usar `functools.reduce` para el máximo.
- [ ] Convertir los resultados de `map`/`filter` a lista.
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

- `map` y `filter` devuelven iteradores; envuélvelos con `list()`.
- `sorted(palabras, key=lambda p: len(p))` ordena por longitud.
- `reduce(funcion, lista)` acumula de izquierda a derecha; para el máximo usa `lambda a, b: a if a > b else b`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````python
import functools

numeros = [5, 12, 7, 18, 3, 21, 9]
palabras = ["python", "es", "genial", "para", "datos"]


def negativos(lista):
    return list(map(lambda n: -n, lista))


def mayores_que(lista, limite=10):
    return list(filter(lambda n: n > limite, lista))


def longitudes(lista):
    return list(map(lambda p: len(p), lista))


def ordenar_por_longitud(lista):
    return sorted(lista, key=lambda p: len(p))


def maximo(lista):
    return functools.reduce(lambda a, b: a if a > b else b, lista)


def main() -> None:
    print(f"Negativos: {negativos(numeros)}")
    print(f"Mayores que 10: {mayores_que(numeros)}")
    print(f"Largos: {longitudes(palabras)}")
    print(f"Palabras por longitud: {ordenar_por_longitud(palabras)}")
    print(f"Máximo: {maximo(numeros)}")


if __name__ == "__main__":
    main()
````

</details>