// 1. Índice de texto compuesto sobre titulo y contenido
print(db.articulos.createIndex({ titulo: "text", contenido: "text" }));

// 2. $text $search "mongo": score ($meta textScore), orden por score desc
db.articulos.find(
  { $text: { $search: "mongo" } },
  { _id: 0, titulo: 1, score: { $meta: "textScore" } }
).sort({ score: { $meta: "textScore" }, titulo: 1 }).forEach(d => printjson(d));

// 3. Búsqueda de frase exacta entre comillas
db.articulos.find(
  { $text: { $search: "\"base de datos\"" } },
  { _id: 0, titulo: 1 }
).sort({ titulo: 1 }).forEach(d => printjson(d));

// 4. Búsqueda con exclusión (palabra con "-")
db.articulos.find(
  { $text: { $search: "mongo -shell" } },
  { _id: 0, titulo: 1 }
).sort({ titulo: 1 }).forEach(d => printjson(d));