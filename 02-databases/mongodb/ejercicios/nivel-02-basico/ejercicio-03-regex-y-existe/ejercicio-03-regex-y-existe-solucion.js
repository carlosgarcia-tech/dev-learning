// 1. Títulos que empiecen por "El " (expresión regular, insensible a mayúsculas)
db.articulos.find({ titulo: { $regex: "^El ", $options: "i" } }, { _id: 0 })
  .sort({ titulo: 1 }).forEach(d => printjson(d));

// 2. Autores que contengan "García" (operador $regex)
db.articulos.find({ autor: { $regex: "García" } }, { _id: 0 })
  .sort({ titulo: 1 }).forEach(d => printjson(d));

// 3. Documentos que tengan el campo "resumen" (operador $exists)
db.articulos.find({ resumen: { $exists: true } }, { _id: 0 })
  .sort({ titulo: 1 }).forEach(d => printjson(d));

// 4. Documentos cuyo campo "precio" sea de tipo double (operador $type)
db.articulos.find({ precio: { $type: "double" } }, { _id: 0 })
  .sort({ titulo: 1 }).forEach(d => printjson(d));
