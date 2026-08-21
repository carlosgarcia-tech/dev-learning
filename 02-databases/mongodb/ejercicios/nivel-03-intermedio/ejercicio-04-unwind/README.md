# Ejercicio 04 — Unwind

- **Nivel:** 3/5
- **Tema:** `$unwind`, `$group`, `$sum`, `$multiply`, `$project`
- **Tiempo estimado:** 15 min

## Enunciado

Dado el siguiente estado inicial (ya cargado por el setup en `setup.js`):

```js
db.pedidos.insertMany([
  { codigo: 1, cliente: "ana", items: [
      { producto: "portatil", cantidad: 1, precio: 900 },
      { producto: "raton", cantidad: 2, precio: 25 }
  ] },
  { codigo: 2, cliente: "luis", items: [
      { producto: "portatil", cantidad: 1, precio: 900 },
      { producto: "teclado", cantidad: 1, precio: 45 }
  ] },
  { codigo: 3, cliente: "carla", items: [
      { producto: "monitor", cantidad: 2, precio: 200 },
      { producto: "teclado", cantidad: 1, precio: 45 },
      { producto: "raton", cantidad: 1, precio: 25 }
  ] },
  { codigo: 4, cliente: "marta", items: [
      { producto: "monitor", cantidad: 1, precio: 200 },
      { producto: "portatil", cantidad: 1, precio: 900 }
  ] }
]);
```

Responde las siguientes consultas con `mongosh` contra la base `ejercicios_db`:

1. Aplana `items` con `$unwind` y agrupa por `producto` sumando las cantidades vendidas.
2. Aplana `items` y agrupa por `codigo` calculando el `total` como suma de `cantidad * precio` por pedido.
3. Aplana `items` y proyecta cada item con su `subtotal` (`cantidad * precio`), manteniendo `codigo`, `cliente` y `producto`, con `_id: 0`.

## Requisitos

- [ ] Cada consulta se ejecuta con `mongosh` sobre el estado del setup
- [ ] Las consultas devuelven el resultado esperado
- [ ] La salida usa proyección `_id: 0` y orden estable donde corresponda
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `$unwind: "$items"` duplica el pedido por cada elemento del array.
- En el `$group`, `_id` es la clave; las cantidades se suman con `$sum: "$items.cantidad"`.
- El subtotal de cada item se calcula con `$multiply: ["$items.cantidad", "$items.precio"]`.
- Usa un `$sort` final con orden estable (p. ej. `{ codigo: 1, producto: 1 }`).

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````js
// 1. $unwind items + $group por producto sumando cantidades
db.pedidos.aggregate([
  { $unwind: "$items" },
  { $group: { _id: "$items.producto", totalCantidad: { $sum: "$items.cantidad" } } },
  { $sort: { totalCantidad: -1, _id: 1 } },
  { $project: { _id: 0, producto: "$_id", totalCantidad: 1 } }
]).forEach(d => printjson(d));

// 2. $unwind + $group por pedido con total = suma(cantidad * precio)
db.pedidos.aggregate([
  { $unwind: "$items" },
  { $group: {
      _id: "$codigo",
      total: { $sum: { $multiply: ["$items.cantidad", "$items.precio"] } }
  } },
  { $sort: { _id: 1 } },
  { $project: { _id: 0, codigo: "$_id", total: 1 } }
]).forEach(d => printjson(d));

// 3. $unwind + $project de cada item con subtotal, _id: 0
db.pedidos.aggregate([
  { $unwind: "$items" },
  { $project: {
      _id: 0,
      codigo: 1,
      cliente: 1,
      producto: "$items.producto",
      cantidad: "$items.cantidad",
      subtotal: { $multiply: ["$items.cantidad", "$items.precio"] }
  } },
  { $sort: { codigo: 1, producto: 1 } }
]).forEach(d => printjson(d));
````

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
