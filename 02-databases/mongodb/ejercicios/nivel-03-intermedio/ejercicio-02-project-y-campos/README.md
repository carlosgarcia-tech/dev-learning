# Ejercicio 02 — Project y Campos

- **Nivel:** 3/5
- **Tema:** `$project`, `$addFields`, `$multiply`, `$add`, `$round`, `$sort`, `$limit`
- **Tiempo estimado:** 15 min

## Enunciado

Dado el siguiente estado inicial (ya cargado por el setup en `setup.js`):

```js
db.productos.insertMany([
  { nombre: "Teclado", precio: 45, iva: 0.21 },
  { nombre: "Ratón", precio: 25, iva: 0.1 },
  { nombre: "Monitor", precio: 200, iva: 0.21 },
  { nombre: "Webcam", precio: 60, iva: 0.1 },
  { nombre: "Auriculares", precio: 80, iva: 0.21 },
  { nombre: "Soporte", precio: 30, iva: 0.1 }
]);
```

Responde las siguientes consultas con `mongosh` contra la base `ejercicios_db`:

1. Con `$project` calcula `precio_total = precio * (1 + iva)` y proyecta `_id: 0`.
2. Con `$project` redondea `precio_total` a 2 decimales usando `$round`.
3. Con `$addFields` añade el campo `margen = precio * 0.2` y proyecta solo `nombre`, `precio` y `margen` (`_id: 0`).
4. Ordena por `precio_total` desc con `$sort` y limita a 2 resultados con `$limit`.

## Requisitos

- [ ] Cada consulta se ejecuta con `mongosh` sobre el estado del setup
- [ ] Las consultas devuelven el resultado esperado
- [ ] La salida usa proyección `_id: 0` y orden estable donde corresponda
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `precio * (1 + iva)` se escribe `{ $multiply: ["$precio", { $add: [1, "$iva"] }] }`.
- `$round` recibe el valor y el número de decimales: `{ $round: [expresion, 2] }`.
- `$addFields` añade campos manteniendo los originales; luego puedes proyectar solo los que quieras.
- Para el punto 4, encadena `$sort` antes de `$limit` en el mismo pipeline.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````js
// 1. $project precio_total = precio * (1 + iva), _id: 0
db.productos.aggregate([
  { $project: {
      _id: 0,
      nombre: 1,
      precio: 1,
      precio_total: { $multiply: ["$precio", { $add: [1, "$iva"] }] }
  } },
  { $sort: { nombre: 1 } }
]).forEach(d => printjson(d));

// 2. $project con $round (precio_total redondeado a 2 decimales)
db.productos.aggregate([
  { $project: {
      _id: 0,
      nombre: 1,
      precio_final: {
        $round: [{ $multiply: ["$precio", { $add: [1, "$iva"] }] }, 2]
      }
  } },
  { $sort: { nombre: 1 } }
]).forEach(d => printjson(d));

// 3. $project solo nombre y precio con $addFields de margen (precio * 0.2)
db.productos.aggregate([
  { $addFields: { margen: { $multiply: ["$precio", 0.2] } } },
  { $sort: { nombre: 1 } },
  { $project: { _id: 0, nombre: 1, precio: 1, margen: 1 } }
]).forEach(d => printjson(d));

// 4. $sort por precio_total desc + $limit 2
db.productos.aggregate([
  { $project: {
      _id: 0,
      nombre: 1,
      precio_total: { $multiply: ["$precio", { $add: [1, "$iva"] }] }
  } },
  { $sort: { precio_total: -1 } },
  { $limit: 2 }
]).forEach(d => printjson(d));
````

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
