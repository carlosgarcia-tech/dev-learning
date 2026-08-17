# Ejercicio 03 — Métodos de listas

- **Nivel:** 2/5
- **Tema:** append, insert, remove, pop, sort, index, count, extend
- **Tiempo estimado:** 20 min

## Enunciado

Crea un archivo `metodos_listas.py` que parta de `frutas = ["manzana", "pera", "uva"]` y aplique, en orden, cada operación imprimiendo el estado de la lista después de cada paso:

1. Añadir `"kiwi"` al final con `append`.
2. Insertar `"limón"` en la posición 0 con `insert(0, ...)`.
3. Añadir `["mango", "papaya"]` con `extend`.
4. Eliminar `"pera"` por valor con `remove`.
5. Eliminar y guardar el último elemento con `pop` e imprimir el elemento eliminado.
6. Ordenar alfabéticamente con `sort`.
7. Imprimir el índice de `"manzana"` con `index`.
8. Contar cuántas veces aparece `"uva"` con `count`.

Salida esperada:

```
['manzana', 'pera', 'uva', 'kiwi']
['limón', 'manzana', 'pera', 'uva', 'kiwi']
['limón', 'manzana', 'pera', 'uva', 'kiwi', 'mango', 'papaya']
['limón', 'manzana', 'uva', 'kiwi', 'mango', 'papaya']
Eliminado: papaya
['kiwi', 'limón', 'mango', 'manzana', 'uva']
Índice de manzana: 3
Veces uva: 1
```

## Requisitos

- [ ] Aplicar los 8 métodos en el orden indicado.
- [ ] Imprimir la lista después de cada mutación.
- [ ] Capturar el valor devuelto por `pop`.
- [ ] Ejecutarlo localmente con `python3 metodos_listas.py` y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `append` añade un solo elemento; `extend` añade varios de otra lista.
- `remove` elimina por valor; `pop()` elimina por índice (el último si va vacío) y devuelve el valor.
- `sort()` ordena la lista en el lugar; `index` devuelve la posición; `count` cuenta apariciones.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````python
frutas = ["manzana", "pera", "uva"]

frutas.append("kiwi")
print(frutas)

frutas.insert(0, "limón")
print(frutas)

frutas.extend(["mango", "papaya"])
print(frutas)

frutas.remove("pera")
print(frutas)

eliminado = frutas.pop()
print(frutas)
print(f"Eliminado: {eliminado}")

frutas.sort()
print(frutas)

print(f"Índice de manzana: {frutas.index('manzana')}")
print(f"Veces uva: {frutas.count('uva')}")
````

</details>