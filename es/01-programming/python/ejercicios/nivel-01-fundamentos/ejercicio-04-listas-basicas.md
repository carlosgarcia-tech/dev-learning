# Ejercicio 04 — Listas básicas

- **Nivel:** 1/5
- **Tema:** listas, append, índices, slicing, métodos
- **Tiempo estimado:** 15 min

## Enunciado

Crea un archivo `listas.py` que trabaje con la lista `[5, 2, 9, 1, 7, 3]` y muestre:

1. La lista original.
2. El primer y el último elemento.
3. La lista ordenada con `sorted()`.
4. La lista invertida con `[::-1]`.
5. La suma total (`sum`), el mínimo (`min`) y el máximo (`max`).
6. Una lista nueva donde cada elemento se multiplique por 2 (usa un bucle `for` con `append`).

Salida esperada:

```
Original: [5, 2, 9, 1, 7, 3]
Primero: 5
Último: 3
Ordenada: [1, 2, 3, 5, 7, 9]
Invertida: [3, 7, 1, 9, 2, 5]
Suma: 27
Mínimo: 1
Máximo: 9
Dobles: [10, 4, 18, 2, 14, 6]
```

## Requisitos

- [ ] Crear la lista fija `[5, 2, 9, 1, 7, 3]`.
- [ ] Usar índices `[0]` y `[-1]`, `sorted()`, `[::-1]`, `sum()`, `min()`, `max()`.
- [ ] Construir la lista de dobles con un bucle `for` y `append()`.
- [ ] Ejecutarlo localmente con `python3 listas.py` y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `sorted(lista)` devuelve una copia ordenada sin modificar la original.
- `sum(lista)` suma todos los elementos numéricos.
- Para los dobles: `dobles = []` y luego `dobles.append(n * 2)` dentro del bucle.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````python
numeros = [5, 2, 9, 1, 7, 3]

print(f"Original: {numeros}")
print(f"Primero: {numeros[0]}")
print(f"Último: {numeros[-1]}")
print(f"Ordenada: {sorted(numeros)}")
print(f"Invertida: {numeros[::-1]}")
print(f"Suma: {sum(numeros)}")
print(f"Mínimo: {min(numeros)}")
print(f"Máximo: {max(numeros)}")

dobles = []
for n in numeros:
    dobles.append(n * 2)
print(f"Dobles: {dobles}")
````

</details>