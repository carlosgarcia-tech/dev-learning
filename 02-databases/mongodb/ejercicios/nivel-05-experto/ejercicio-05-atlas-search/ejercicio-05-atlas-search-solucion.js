// 1. Índice simple sobre genero
print(db.libros.createIndex({ genero: 1 }));

// Índice de texto (necesario para $text) sobre titulo
print(db.libros.createIndex({ titulo: "text" }));

// 2. $text $search "aventura": score ($meta textScore), orden por score desc
db.libros.find(
  { $text: { $search: "aventura" } },
  { _id: 0, titulo: 1, score: { $meta: "textScore" } }
).sort({ score: { $meta: "textScore" }, titulo: 1 }).forEach(d => printjson(d));

// 3. Búsqueda $text con exclusión de palabra
db.libros.find(
  { $text: { $search: "aventura -espacio" } },
  { _id: 0, titulo: 1 }
).sort({ titulo: 1 }).forEach(d => printjson(d));

// 4. $text combinado con $match adicional (anio > 1950)
db.libros.find(
  { $text: { $search: "misterio" }, anio: { $gt: 1950 } },
  { _id: 0, titulo: 1, genero: 1, anio: 1 }
).sort({ titulo: 1 }).forEach(d => printjson(d));