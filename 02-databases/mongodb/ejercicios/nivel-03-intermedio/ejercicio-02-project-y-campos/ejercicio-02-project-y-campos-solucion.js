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
