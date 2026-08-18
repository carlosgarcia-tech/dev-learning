# Ejercicio 06 — Tuplas y sets

- **Nivel:** 2/5
- **Tema:** tuplas, desempaquetado, sets, operaciones de conjunto
- **Tiempo estimado:** 20 min

## Enunciado

Crea un archivo `tuplas_sets.py` que:

1. Defina la tupla `punto = (3, 5)` y la desempaquete en `x, y`; imprime `x` e `y`.
2. Intente asignar `punto[0] = 10` dentro de un `try/except` capturando `TypeError` e imprima `Las tuplas son inmutables`.
3. Defina `estudiantes_a = {"ana", "luis", "maria"}` y `estudiantes_b = {"luis", "carlos", "pablo"}`.
4. Imprima la unión, la intersección y la diferencia `estudiantes_a - estudiantes_b`.
5. Elimine los duplicados de la lista `[1, 2, 2, 3, 3, 3, 4]` usando `set()` e imprima el resultado ordenado.

Salida esperada:

```
x=3, y=5
Las tuplas son inmutables
Unión: {'ana', 'carlos', 'luis', 'maria', 'pablo'}
Intersección: {'luis'}
Diferencia: {'ana', 'maria'}
Sin duplicados: [1, 2, 3, 4]
```

## Requisitos

- [ ] Desempaquetar la tupla en `x, y`.
- [ ] Capturar `TypeError` al intentar modificar la tupla.
- [ ] Usar `|`, `&` y `-` con sets.
- [ ] Convertir una lista a set para deduplicar y ordenar con `sorted`.
- [ ] Ejecutarlo localmente con `python3 tuplas_sets.py` y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- La unión se hace con `a | b`, la intersección con `a & b` y la diferencia con `a - b`.
- `set(lista)` elimina duplicados; `sorted(set(...))` devuelve una lista ordenada.
- El orden de los sets no está garantizado, así que no te preocupes por el orden de los elementos de la unión en la salida.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````python
punto = (3, 5)
x, y = punto
print(f"x={x}, y={y}")

try:
    punto[0] = 10
except TypeError:
    print("Las tuplas son inmutables")

estudiantes_a = {"ana", "luis", "maria"}
estudiantes_b = {"luis", "carlos", "pablo"}

print(f"Unión: {estudiantes_a | estudiantes_b}")
print(f"Intersección: {estudiantes_a & estudiantes_b}")
print(f"Diferencia: {estudiantes_a - estudiantes_b}")

numeros = [1, 2, 2, 3, 3, 3, 4]
print(f"Sin duplicados: {sorted(set(numeros))}")
````

</details>