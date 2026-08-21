# Ejercicio 01 — Comparación

- **Nivel:** 2/5
- **Tema:** Operadores de comparación `$gt`, `$gte`, `$lte`, `$in`, `$nin`
- **Tiempo estimado:** 10 min

## Enunciado

Dado el siguiente estado inicial (ya cargado por el setup en `setup.js`):

```js
db.productos.insertMany([
  { nombre: "Monitor", precio: 349, stock: 12, categoria: "informatica" },
  { nombre: "Ratón", precio: 25.99, stock: 40, categoria: "informatica" },
  { nombre: "Silla", precio: 199, stock: 6, categoria: "hogar" },
  { nombre: "Lámpara", precio: 27.99, stock: 0, categoria: "hogar" },
  { nombre: "Auriculares", precio: 79.9, stock: 3, categoria: "accesorios" },
  { nombre: "Portátil", precio: 899, stock: 10, categoria: "informatica" }
]);
```

Responde las siguientes consultas con `mongosh` contra la base `ejercicios_db`:

1. Productos con `precio > 100` (usa `$gt`). Proyecta `_id: 0` y ordena por `precio` ascendente.
2. Productos con `precio` entre 50 y 200, ambos inclusivos (usa `$gte` y `$lte`). Ordena por `precio` ascendente.
3. Productos de las categorías `"hogar"` o `"accesorios"` (usa `$in`). Ordena por `nombre` ascendente.
4. Productos cuyo `stock` NO esté en `[0, 10]` (usa `$nin`). Ordena por `stock` ascendente.

## Requisitos

- [ ] Cada consulta se ejecuta con `mongosh` sobre el estado del setup
- [ ] Las consultas devuelven el resultado esperado
- [ ] La salida usa proyección `_id: 0` y orden estable donde corresponda
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- La sintaxis de los operadores es `{ campo: { $gt: valor } }` dentro del filtro del `find`.
- `$gte` y `$lte` pueden combinarse en un mismo objeto: `{ $gte: 50, $lte: 200 }`.
- `$in` recibe un array de valores posibles y `$nin` excluye los del array.
- Imprime con `.forEach(d => printjson(d))` para una salida legible.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````js
// 1. Productos con precio > 100 (operador $gt)
db.productos.find({ precio: { $gt: 100 } }, { _id: 0 })
  .sort({ precio: 1 }).forEach(d => printjson(d));

// 2. Productos con precio entre 50 y 200, ambos inclusivos ($gte y $lte)
db.productos.find({ precio: { $gte: 50, $lte: 200 } }, { _id: 0 })
  .sort({ precio: 1 }).forEach(d => printjson(d));

// 3. Productos de las categorías "hogar" o "accesorios" (operador $in)
db.productos.find({ categoria: { $in: ["hogar", "accesorios"] } }, { _id: 0 })
  .sort({ nombre: 1 }).forEach(d => printjson(d));

// 4. Productos cuyo stock NO esté en [0, 10] (operador $nin)
db.productos.find({ stock: { $nin: [0, 10] } }, { _id: 0 })
  .sort({ stock: 1 }).forEach(d => printjson(d));
````

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
