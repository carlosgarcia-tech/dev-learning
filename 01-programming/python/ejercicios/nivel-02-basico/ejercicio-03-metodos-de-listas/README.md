# Ejercicio 03 — Métodos de listas

- **Nivel:** 2/5
- **Tema:** append, insert, remove, pop, sort, index, count, extend
- **Tiempo estimado:** 20 min

## Enunciado

Completa `main.py` para que implemente las funciones que aplican, en orden, cada operación sobre una lista de frutas que parte de `["manzana", "pera", "uva"]`:

1. `frutas_iniciales()` — devuelve `["manzana", "pera", "uva"]`.
2. `agregar_kiwi(frutas)` — añade `"kiwi"` al final con `append` y devuelve la lista.
3. `insertar_limon(frutas)` — inserta `"limón"` en la posición 0 con `insert(0, ...)` y devuelve la lista.
4. `extender_mango_papaya(frutas)` — añade `["mango", "papaya"]` con `extend` y devuelve la lista.
5. `quitar_pera(frutas)` — elimina `"pera"` por valor con `remove` y devuelve la lista.
6. `quitar_ultimo(frutas)` — elimina el último elemento con `pop` y devuelve la tupla `(elemento_eliminado, frutas)`.
7. `ordenar_frutas(frutas)` — ordena alfabéticamente con `sort` y devuelve la lista.
8. `indice_de(frutas, elemento)` — devuelve el índice de `elemento` con `index`.
9. `contar(frutas, elemento)` — devuelve cuántas veces aparece `elemento` con `count`.

Salida esperada (ejemplo de checks):

```
frutas_iniciales() devuelve ['manzana', 'pera', 'uva']
agregar_kiwi(...) devuelve ['manzana', 'pera', 'uva', 'kiwi']
insertar_limon(...) devuelve ['limón', 'manzana', 'pera', 'uva', 'kiwi']
extender_mango_papaya(...) devuelve ['limón', 'manzana', 'pera', 'uva', 'kiwi', 'mango', 'papaya']
quitar_pera(...) devuelve ['limón', 'manzana', 'uva', 'kiwi', 'mango', 'papaya']
quitar_ultimo(...) devuelve ('papaya', ['limón', 'manzana', 'uva', 'kiwi', 'mango'])
ordenar_frutas(...) devuelve ['kiwi', 'limón', 'mango', 'manzana', 'uva']
indice_de(frutas, "manzana") devuelve 3
contar(frutas, "uva") devuelve 1
```

## Requisitos

- [ ] Aplicar los 8 métodos en el orden indicado.
- [ ] `quitar_ultimo` captura el valor devuelto por `pop`.
- [ ] Cada función devuelve el resultado (no imprime).
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

- `append` añade un solo elemento; `extend` añade varios de otra lista.
- `remove` elimina por valor; `pop()` elimina por índice (el último si va vacío) y devuelve el valor.
- `sort()` ordena la lista en el lugar; `index` devuelve la posición; `count` cuenta apariciones.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````python
def frutas_iniciales():
    return ["manzana", "pera", "uva"]


def agregar_kiwi(frutas):
    frutas.append("kiwi")
    return frutas


def insertar_limon(frutas):
    frutas.insert(0, "limón")
    return frutas


def extender_mango_papaya(frutas):
    frutas.extend(["mango", "papaya"])
    return frutas


def quitar_pera(frutas):
    frutas.remove("pera")
    return frutas


def quitar_ultimo(frutas):
    eliminado = frutas.pop()
    return eliminado, frutas


def ordenar_frutas(frutas):
    frutas.sort()
    return frutas


def indice_de(frutas, elemento):
    return frutas.index(elemento)


def contar(frutas, elemento):
    return frutas.count(elemento)


if __name__ == "__main__":
    frutas = frutas_iniciales()
    print(agregar_kiwi(frutas))
    print(insertar_limon(frutas))
    print(extender_mango_papaya(frutas))
    print(quitar_pera(frutas))
    eliminado, frutas = quitar_ultimo(frutas)
    print(f"Eliminado: {eliminado}")
    print(ordenar_frutas(frutas))
    print(f"Índice de manzana: {indice_de(frutas, 'manzana')}")
    print(f"Veces uva: {contar(frutas, 'uva')}")
````

</details>