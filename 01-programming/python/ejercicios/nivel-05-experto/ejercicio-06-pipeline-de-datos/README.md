# Ejercicio 06 — Pipeline de datos

- **Nivel:** 5/5
- **Tema:** pipeline, generators, comprehensions, análisis de datos, filtrado
- **Tiempo estimado:** 45 min

## Enunciado

Completa `main.py` para que procese una lista de diccionarios de ventas siguiendo un **pipeline de transformaciones**. Datos base:

```python
ventas = [
    {"producto": "manzana", "cantidad": 10, "precio": 1.5},
    {"producto": "pera", "cantidad": 5, "precio": 2.0},
    {"producto": "manzana", "cantidad": 20, "precio": 1.5},
    {"producto": "uva", "cantidad": 8, "precio": 3.0},
    {"producto": "pera", "cantidad": 3, "precio": 2.0},
]
```

Implementa las funciones:

1. `enriquecer(ventas)` — usa una comprehension para añadir `total = cantidad * precio` a cada venta (`[{**v, "total": ...} for v in ventas]`, sin mutar los originales).
2. `filtrar_ventas(enriquecidas)` — usa `filter` con una lambda para quedarte con ventas de `total >= 10`.
3. `agrupar_por_producto(filtradas)` — suma los totales por producto en un diccionario con `get(producto, 0)`.
4. `ordenar_por_total(por_producto)` — ordena los productos por total descendente (devuelve lista de tuplas `(producto, total)`).
5. `resumir(ventas)` — aplica el pipeline completo y devuelve la lista de líneas de salida: `Producto: <nombre> - Total: <X.XX>` por cada producto y `TOTAL: <suma global>` como última línea.

En `if __name__ == "__main__":`, imprime las líneas devueltas por `resumir(VENTAS)`.

Salida esperada:

```
Producto: manzana - Total: 45.00
Producto: uva - Total: 24.00
Producto: pera - Total: 10.00
TOTAL: 79.00
```

## Requisitos

- [ ] Usar una comprehension para enriquecer los datos.
- [ ] Usar `filter` con una lambda.
- [ ] Agrupar con un diccionario y `get`.
- [ ] Ordenar con `sorted` y `key=lambda` descendente.
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

- `[{**v, "total": v["cantidad"] * v["precio"]} for v in ventas]` enriquece copiando cada dict.
- Para agrupar: `por_producto[venta["producto"]] = por_producto.get(venta["producto"], 0) + venta["total"]`.
- Ordena con `sorted(items, key=lambda kv: kv[1], reverse=True)`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````python
VENTAS = [
    {"producto": "manzana", "cantidad": 10, "precio": 1.5},
    {"producto": "pera", "cantidad": 5, "precio": 2.0},
    {"producto": "manzana", "cantidad": 20, "precio": 1.5},
    {"producto": "uva", "cantidad": 8, "precio": 3.0},
    {"producto": "pera", "cantidad": 3, "precio": 2.0},
]


def enriquecer(ventas):
    return [{**v, "total": v["cantidad"] * v["precio"]} for v in ventas]


def filtrar_ventas(enriquecidas):
    return list(filter(lambda v: v["total"] >= 10, enriquecidas))


def agrupar_por_producto(filtradas):
    por_producto = {}
    for venta in filtradas:
        por_producto[venta["producto"]] = (
            por_producto.get(venta["producto"], 0) + venta["total"]
        )
    return por_producto


def ordenar_por_total(por_producto):
    return sorted(por_producto.items(), key=lambda kv: kv[1], reverse=True)


def resumir(ventas):
    enriquecidas = enriquecer(ventas)
    filtradas = filtrar_ventas(enriquecidas)
    por_producto = agrupar_por_producto(filtradas)
    ordenadas = ordenar_por_total(por_producto)

    lineas = [f"Producto: {p} - Total: {t:.2f}" for p, t in ordenadas]
    lineas.append(f"TOTAL: {sum(por_producto.values()):.2f}")
    return lineas


if __name__ == "__main__":
    for linea in resumir(VENTAS):
        print(linea)
````

</details>