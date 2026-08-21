// 1. Proyección inclusiva: solo titulo y precio
db.articulos.find({}, { _id: 0, titulo: 1, precio: 1 }).sort({ titulo: 1 }).forEach(d => printjson(d));

// 2. Proyección exclusiva: excluir el campo autor
db.articulos.find({}, { _id: 0, autor: 0 }).sort({ titulo: 1 }).forEach(d => printjson(d));

// 3. Nivel 1: proyección con find (sin $project)

// 4. Proyección + filtro: solo titulo de los artículos posteriores al año 2000
db.articulos.find({ anio: { $gt: 2000 } }, { _id: 0, titulo: 1 }).sort({ titulo: 1 }).forEach(d => printjson(d));