# Ejercicio 06 — Mini Proyecto

- **Nivel:** 5/5
- **Tema:** mini proyecto integrador (`$group`, `$unwind`, `$lookup`, `$sort`, `$substr`)
- **Tiempo estimado:** 30 min

## Enunciado

Dado el siguiente estado inicial (ya cargado por el setup en `setup.js`):

```js
db.pedidos.insertMany([
  {
    codigo: "P001", cliente: "C001", fecha: "2024-01-15", estado: "entregado", total: 150,
    items: [
      { producto: "teclado", cantidad: 2 },
      { producto: "raton", cantidad: 1 }
    ]
  },
  {
    codigo: "P002", cliente: "C002", fecha: "2024-01-28", estado: "entregado", total: 90,
    items: [
      { producto: "libro", cantidad: 3 }
    ]
  },
  {
    codigo: "P003", cliente: "C001", fecha: "2024-02-05", estado: "pendiente", total: 300,
    items: [
      { producto: "monitor", cantidad: 1 },
      { producto: "teclado", cantidad: 1 }
    ]
  },
  {
    codigo: "P004", cliente: "C003", fecha: "2024-02-19", estado: "entregado", total: 45,
    items: [
      { producto: "libro", cantidad: 1 }
    ]
  },
  {
    codigo: "P005", cliente: "C002", fecha: "2024-03-02", estado: "cancelado", total: 200,
    items: [
      { producto: "monitor", cantidad: 2 }
    ]
  },
  {
    codigo: "P006", cliente: "C001", fecha: "2024-03-25", estado: "entregado", total: 60,
    items: [
      { producto: "raton", cantidad: 3 }
    ]
  }
]);

db.clientes.insertMany([
  { codigo: "C001", nombre: "Ana", ciudad: "Madrid" },
  { codigo: "C002", nombre: "Luis", ciudad: "Barcelona" },
  { codigo: "C003", nombre: "Sara", ciudad: "Valencia" }
]);
```

Responde las siguientes consultas con `mongosh` contra la base `ejercicios_db`:

1. Total de ventas por `estado` (con `$group` + `$sum`, ordenado por estado).
2. Top 2 productos más vendidos (deshaz el array con `$unwind`, agrupa por producto sumando cantidades, ordena y limita a 2).
3. Total de ventas por cliente, mostrando el nombre del cliente (usa `$lookup` contra `clientes`).
4. Número de pedidos por mes (agrupa por los 7 primeros caracteres de `fecha` con `$substr`).

## Requisitos

- [ ] Cada consulta se ejecuta con `mongosh` sobre el estado del setup
- [ ] Las consultas devuelven el resultado esperado
- [ ] La salida usa proyección `_id: 0` y orden estable donde corresponda
- [ ] Los tests pasan: `bash test.sh`

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `$unwind` transforma cada elemento de `items` en un documento independiente para poder agrupar por producto.
- `$lookup` une `pedidos.cliente` con `clientes.codigo`; luego `$unwind` sobre el campo `info` para acceder al nombre.
- Como `fecha` es un string `"YYYY-MM-DD"`, `$substr: ["$fecha", 0, 7]` te da el mes `"YYYY-MM"` de forma determinista.
- Usa `$sort` después de cada `$group` para que el orden de salida sea estable.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````js
// 1. Total de ventas por estado ($group, $sum, $sort)
printjson(db.pedidos.aggregate([
  { $group: { _id: "$estado", total: { $sum: "$total" } } },
  { $project: { _id: 0, estado: "$_id", total: 1 } },
  { $sort: { estado: 1 } }
]).toArray());

// 2. Top 2 productos más vendidos ($unwind, $group, $sort, $limit)
printjson(db.pedidos.aggregate([
  { $unwind: "$items" },
  { $group: { _id: "$items.producto", cantidad: { $sum: "$items.cantidad" } } },
  { $project: { _id: 0, producto: "$_id", cantidad: 1 } },
  { $sort: { cantidad: -1, producto: 1 } },
  { $limit: 2 }
]).toArray());

// 3. Total por cliente ($group + $lookup para el nombre)
printjson(db.pedidos.aggregate([
  {
    $lookup: {
      from: "clientes",
      localField: "cliente",
      foreignField: "codigo",
      as: "info"
    }
  },
  { $unwind: "$info" },
  { $group: { _id: "$info.nombre", total: { $sum: "$total" } } },
  { $project: { _id: 0, cliente: "$_id", total: 1 } },
  { $sort: { cliente: 1 } }
]).toArray());

// 4. Pedidos por mes ($group con $substr sobre fecha "YYYY-MM-DD")
printjson(db.pedidos.aggregate([
  {
    $group: {
      _id: { $substr: ["$fecha", 0, 7] },
      pedidos: { $sum: 1 }
    }
  },
  { $project: { _id: 0, mes: "$_id", pedidos: 1 } },
  { $sort: { mes: 1 } }
]).toArray());
````

</details>

## Cómo ejecutar los tests

```bash
bash test.sh
```
