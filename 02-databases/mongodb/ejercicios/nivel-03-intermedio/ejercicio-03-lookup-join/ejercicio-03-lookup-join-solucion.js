// 1. $lookup libros -> autores por autor_id, $unwind y proyección {_id:0}
db.libros.aggregate([
  { $lookup: {
      from: "autores",
      localField: "autor_id",
      foreignField: "_id",
      as: "autor"
  } },
  { $unwind: "$autor" },
  { $project: { _id: 0, titulo: 1, anio: 1, autor: "$autor.nombre", nacionalidad: "$autor.nacionalidad" } },
  { $sort: { titulo: 1 } }
]).forEach(d => printjson(d));

// 2. $lookup sin $unwind: contar libros por autor con $size
db.autores.aggregate([
  { $lookup: {
      from: "libros",
      localField: "_id",
      foreignField: "autor_id",
      as: "libros"
  } },
  { $project: { _id: 0, autor: "$nombre", nacionalidad: 1, num_libros: { $size: "$libros" } } },
  { $sort: { autor: 1 } }
]).forEach(d => printjson(d));

// 3. $match anio > 2000 + $lookup + proyección {_id:0}
db.libros.aggregate([
  { $match: { anio: { $gt: 2000 } } },
  { $lookup: {
      from: "autores",
      localField: "autor_id",
      foreignField: "_id",
      as: "autor"
  } },
  { $unwind: "$autor" },
  { $project: { _id: 0, titulo: 1, anio: 1, autor: "$autor.nombre" } },
  { $sort: { titulo: 1 } }
]).forEach(d => printjson(d));
