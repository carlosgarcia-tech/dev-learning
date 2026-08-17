# Ejercicio 02 — List comprehensions

- **Nivel:** 2/5
- **Tema:** list comprehensions, map, filter
- **Tiempo estimado:** 15 min

## Enunciado

Crea un archivo `comprehensions.py` con la lista base `numeros = list(range(1, 21))` y genera:

1. `cuadrados` — cada número elevado al cuadrado.
2. `pares` — solo los números pares.
3. `multiplos_de_3` — solo los múltiplos de 3.
4. `etiquetas` — strings `par` para pares e `impar` para impares.
5. `divididos` — cada número dividido entre 2 (como `float`).

Imprime cada lista resultante.

Salida esperada:

```
Cuadrados: [1, 4, 9, 16, 25, 36, 49, 64, 81, 100, 121, 144, 169, 196, 225, 256, 289, 324, 361, 400]
Pares: [2, 4, 6, 8, 10, 12, 14, 16, 18, 20]
Múltiplos de 3: [3, 6, 9, 12, 15, 18]
Etiquetas: ['impar', 'par', 'impar', ...]
Divididos: [0.5, 1.0, 1.5, ...]
```

## Requisitos

- [ ] Crear `numeros` con `list(range(1, 21))`.
- [ ] Escribir una comprehension por cada lista pedida.
- [ ] Usar condición `if` dentro de las comprehensions 2 y 3.
- [ ] Ejecutarlo localmente con `python3 comprehensions.py` y verificar la salida.

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
numeros = list(range(1, 21))

cuadrados = [n ** 2 for n in numeros]
pares = [n for n in numeros if n % 2 == 0]
multiplos_de_3 = [n for n in numeros if n % 3 == 0]
etiquetas = ["par" if n % 2 == 0 else "impar" for n in numeros]
divididos = [n / 2 for n in numeros]

print(f"Cuadrados: {cuadrados}")
print(f"Pares: {pares}")
print(f"Múltiplos de 3: {multiplos_de_3}")
print(f"Etiquetas: {etiquetas}")
print(f"Divididos: {divididos}")
````

</details>