# Ejercicio 04 — Lambdas, map y filter

- **Nivel:** 4/5
- **Tema:** lambda, map, filter, sorted con key, functools.reduce
- **Tiempo estimado:** 20 min

## Enunciado

Crea un archivo `lambdas_map_filter.py` que trabaje con `numeros = [5, 12, 7, 18, 3, 21, 9]` y `palabras = ["python", "es", "genial", "para", "datos"]`:

1. Con `map` + lambda, convierta cada número a su valor absoluto negativo (`-n`) e imprima la lista.
2. Con `filter` + lambda, quédese con los números mayores que 10 e imprima la lista.
3. Con `map` + lambda, devuelva la longitud de cada palabra (`len`) e imprima la lista.
4. Con `sorted` + `key=lambda`, ordene las palabras por su longitud (de menor a mayor) e imprima la lista.
5. Con `functools.reduce` + lambda, calcule el mayor de los números e imprima el resultado.

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
- [ ] Ejecutarlo localmente con `python3 lambdas_map_filter.py` y verificar la salida.

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

negativos = list(map(lambda n: -n, numeros))
print(f"Negativos: {negativos}")

mayores = list(filter(lambda n: n > 10, numeros))
print(f"Mayores que 10: {mayores}")

largos = list(map(lambda p: len(p), palabras))
print(f"Largos: {largos}")

ordenadas = sorted(palabras, key=lambda p: len(p))
print(f"Palabras por longitud: {ordenadas}")

maximo = functools.reduce(lambda a, b: a if a > b else b, numeros)
print(f"Máximo: {maximo}")
````

</details>