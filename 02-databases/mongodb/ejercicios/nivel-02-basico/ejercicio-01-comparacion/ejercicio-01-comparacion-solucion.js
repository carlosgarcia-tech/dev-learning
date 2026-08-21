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
