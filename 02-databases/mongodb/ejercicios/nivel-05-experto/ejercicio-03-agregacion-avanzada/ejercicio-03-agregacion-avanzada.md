# Ejercicio 03 — Agregación Avanzada

- **Nivel:** 5/5
- **Tema:** $bucket, $facet, $group con $push, $sort y proyección
- **Tiempo estimado:** 25 min

## Enunciado

Dado el siguiente estado inicial (ya cargado por el setup en `setup.js`):

```js
db.ventas.insertMany([
  { fecha: "2024-01-05", vendedor: "Ana", importe: 150, categoria: "electronica" },
  { fecha: "2024-01-12", vendedor: "Luis", importe: 40, categoria: "ropa" },
  { fecha: "2024-02-03", vendedor: "Ana", importe: 300, categoria: "hogar" },
  { fecha: "2024-02-18", vendedor: "Sara", importe: 90, categoria: "ropa" },
  { fecha: "2024-03-01", vendedor: "Luis", importe: 250, categoria: "electronica" },
  { fecha: "2024-03-22", vendedor: "Sara", importe: 120, categoria: "hogar" },
  { fecha: "2024-04-09", vendedor: "Ana", importe: 60, categoria: "ropa" },
  { fecha: "2024-04-27", vendedor: "Luis", importe: 500, categoria: "electronica" },
  { fecha: "2024-05-14", vendedor: "Sara", importe: 80, categoria: "hogar" },
  { fecha: "2024-05-30", vendedor: "Ana", importe: 200, categoria: "electronica" }
]);
```

Responde las siguientes consultas con `mongosh` contra la base `ejercicios_db`:

1. Agrupa las ventas en rangos de importe con `$bucket` (límites `[0, 100, 200, 400, 1000]`) contando cuántas ventas caen en cada rango.
2. Con una sola agregación `$facet`, calcula a la vez: total de ventas por vendedor, nº de ventas por categoría y el total global.
3. Con `$group` y `$push`, agrupa los importes por categoría en un array.
4. Ordena todas las ventas por `importe` descendente y proyecta el resultado con `_id: 0`.

## Requisitos

- [ ] Cada consulta se ejecuta con `mongosh` sobre el estado del setup
- [ ] Las consultas devuelven el resultado esperado
- [ ] La salida usa proyección `_id: 0` y orden estable donde corresponda
- [ ] Los tests pasan: `bash ejercicio-03-agregacion-avanzada-test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `$bucket` usa `groupBy: "$importe"`, `boundaries: [0, 100, 200, 400, 1000]` y `output: { total: { $sum: 1 } }`.
- En `$facet` cada clave define su propia sub-pipeline; dentro de cada una aplica `$group`, `$project` con `_id: 0` y `$sort` para una salida estable.
- `$push` acumula los valores en orden de aparición; ordénalo después por la categoría.
- Recuerda terminar siempre con `_id: 0` y `.sort()` para que la salida sea determinista.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````js
// 1. $bucket por rangos de importe con contadores
printjson(db.ventas.aggregate([
  {
    $bucket: {
      groupBy: "$importe",
      boundaries: [0, 100, 200, 400, 1000],
      default: "otro",
      output: { total: { $sum: 1 } }
    }
  },
  { $sort: { _id: 1 } },
  { $project: { _id: 0, rango: "$_id", total: 1 } }
]).toArray());

// 2. $facet: por vendedor (sum), por categoria (count), total global
const facet = db.ventas.aggregate([
  {
    $facet: {
      porVendedor: [
        { $group: { _id: "$vendedor", total: { $sum: "$importe" } } },
        { $project: { _id: 0, vendedor: "$_id", total: 1 } },
        { $sort: { vendedor: 1 } }
      ],
      porCategoria: [
        { $group: { _id: "$categoria", total: { $sum: 1 } } },
        { $project: { _id: 0, categoria: "$_id", total: 1 } },
        { $sort: { categoria: 1 } }
      ],
      totalGlobal: [
        { $group: { _id: null, total: { $sum: "$importe" } } },
        { $project: { _id: 0, total: 1 } }
      ]
    }
  }
]).toArray()[0];
printjson(facet.porVendedor);
printjson(facet.porCategoria);
printjson(facet.totalGlobal);

// 3. $group con $push (importes por categoria)
printjson(db.ventas.aggregate([
  { $group: { _id: "$categoria", importes: { $push: "$importe" } } },
  { $project: { _id: 0, categoria: "$_id", importes: 1 } },
  { $sort: { categoria: 1 } }
]).toArray());

// 4. $sort por importe desc y proyección final {_id:0}
printjson(db.ventas.aggregate([
  { $sort: { importe: -1 } },
  { $project: { _id: 0, fecha: 1, vendedor: 1, importe: 1, categoria: 1 } }
]).toArray());
````

</details>

## Cómo ejecutar los tests

```bash
bash ejercicio-03-agregacion-avanzada-test.sh   # requiere podman (levanta mongo efímero)
```