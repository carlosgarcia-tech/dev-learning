# Ejercicio 06 — Pipeline de datos

- **Nivel:** 5/5
- **Tema:** pipeline, generators, comprehensions, análisis de datos, filtrado
- **Tiempo estimado:** 45 min

## Enunciado

Crea un archivo `pipeline.py` que procese una lista de diccionarios de ventas siguiendo un **pipeline de transformaciones**. Datos base:

```python
ventas = [
    {"producto": "manzana", "cantidad": 10, "precio": 1.5},
    {"producto": "pera", "cantidad": 5, "precio": 2.0},
    {"producto": "manzana", "cantidad": 20, "precio": 1.5},
    {"producto": "uva", "cantidad": 8, "precio": 3.0},
    {"producto": "pera", "cantidad": 3, "precio": 2.0},
]
```

1. **Enriquecer:** usa una comprehension para añadir `total = cantidad * precio` a cada venta.
2. **Filtrar:** usa `filter` para quedarte con ventas de `total >= 10`.
3. **Agrupar:** suma los totales por producto en un diccionario con `get(producto, 0)`.
4. **Ordenar:** ordena los productos por total descendente.
5. **Resumir:** imprime `Producto: <nombre> - Total: <X.XX>` por cada producto y el `TOTAL: <suma global>`.

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
- [ ] Ejecutarlo localmente con `python3 pipeline.py` y verificar la salida.

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
ventas = [
    {"producto": "manzana", "cantidad": 10, "precio": 1.5},
    {"producto": "pera", "cantidad": 5, "precio": 2.0},
    {"producto": "manzana", "cantidad": 20, "precio": 1.5},
    {"producto": "uva", "cantidad": 8, "precio": 3.0},
    {"producto": "pera", "cantidad": 3, "precio": 2.0},
]

enriquecidas = [
    {**v, "total": v["cantidad"] * v["precio"]} for v in ventas
]

filtradas = list(filter(lambda v: v["total"] >= 10, enriquecidas))

por_producto = {}
for venta in filtradas:
    por_producto[venta["producto"]] = (
        por_producto.get(venta["producto"], 0) + venta["total"]
    )

ordenadas = sorted(por_producto.items(), key=lambda kv: kv[1], reverse=True)

for producto, total in ordenadas:
    print(f"Producto: {producto} - Total: {total:.2f}")

total_global = sum(por_producto.values())
print(f"TOTAL: {total_global:.2f}")
````

</details>