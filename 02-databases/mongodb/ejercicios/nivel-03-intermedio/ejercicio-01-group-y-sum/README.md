# Ejercicio 01 — Group y Sum

- **Nivel:** 3/5
- **Tema:** `$group`, `$sum`, `$count`, `$avg`, `$match`, `$sort`
- **Tiempo estimado:** 15 min

## Enunciado

Dado el siguiente estado inicial (ya cargado por el setup en `setup.js`):

```js
db.ventas.insertMany([
  { vendedor: "ana", importe: 120, ciudad: "madrid" },
  { vendedor: "ana", importe: 80, ciudad: "barcelona" },
  { vendedor: "luis", importe: 250, ciudad: "madrid" },
  { vendedor: "carla", importe: 300, ciudad: "valencia" },
  { vendedor: "luis", importe: 150, ciudad: "barcelona" },
  { vendedor: "ana", importe: 200, ciudad: "valencia" },
  { vendedor: "carla", importe: 90, ciudad: "madrid" },
  { vendedor: "luis", importe: 175, ciudad: "valencia" },
  { vendedor: "marta", importe: 110, ciudad: "barcelona" },
  { vendedor: "marta", importe: 65, ciudad: "madrid" }
]);
```

Responde las siguientes consultas con `mongosh` contra la base `ejercicios_db`:

1. Agrupa por `vendedor` con `$group` calculando `total` (suma de `importe` con `$sum`), `pedidos` (número de ventas con `$count`) y `promedio` (media con `$avg`); proyecta `_id: 0`.
2. Obtén el `total` de ventas por `vendedor` y ordénalo por `total` de mayor a menor con `$sort`.
3. Agrupa por `ciudad` con `$sum` y ordena el resultado alfabéticamente por ciudad.
4. Filtra antes de agrupar con `$match` (solo ventas con `importe > 100`) y agrupa por `vendedor`.

## Requisitos

- [ ] Cada consulta se ejecuta con `mongosh` sobre el estado del setup
- [ ] Las consultas devuelven el resultado esperado
- [ ] La salida usa proyección `_id: 0` y orden estable donde corresponda
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- En `$group`, `_id` es la clave de agrupación; renombra con `{ _id: 0, vendedor: "$_id", total: 1 }`.
- `$count` se usa como acumulador dentro de `$group` (ej. `pedidos: { $count: {} }`).
- `$match` se coloca antes de `$group` para filtrar la entrada.
- Termina siempre con `$sort` y proyección `_id: 0` para una salida estable.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````js
// 1. $group por vendedor: total ($sum), nº de pedidos ($count) y promedio ($avg)
db.ventas.aggregate([
  { $group: {
      _id: "$vendedor",
      totalImporte: { $sum: "$importe" },
      pedidos: { $count: {} },
      promedio: { $avg: "$importe" }
  } },
  { $sort: { _id: 1 } },
  { $project: { _id: 0, vendedor: "$_id", total: "$totalImporte", pedidos: 1, promedio: 1 } }
]).forEach(d => printjson(d));

// 2. $sort por total desc (grupo por vendedor con $sum)
db.ventas.aggregate([
  { $group: { _id: "$vendedor", total: { $sum: "$importe" } } },
  { $sort: { total: -1 } },
  { $project: { _id: 0, vendedor: "$_id", total: 1 } }
]).forEach(d => printjson(d));

// 3. $group por ciudad con $sum y $sort alfabético
db.ventas.aggregate([
  { $group: { _id: "$ciudad", total: { $sum: "$importe" } } },
  { $sort: { _id: 1 } },
  { $project: { _id: 0, ciudad: "$_id", total: 1 } }
]).forEach(d => printjson(d));

// 4. $match antes de $group (solo importe > 100) + $group por vendedor
db.ventas.aggregate([
  { $match: { importe: { $gt: 100 } } },
  { $group: { _id: "$vendedor", total: { $sum: "$importe" } } },
  { $sort: { _id: 1 } },
  { $project: { _id: 0, vendedor: "$_id", total: 1 } }
]).forEach(d => printjson(d));
````

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
