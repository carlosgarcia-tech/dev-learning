// 1. Top 3: $sort puntos desc + $limit 3
db.participantes.aggregate([
  { $sort: { puntos: -1 } },
  { $limit: 3 },
  { $project: { _id: 0, nombre: 1, puntos: 1 } }
]).forEach(d => printjson(d));

// 2. Posiciones 4-5: $sort desc + $skip 3 + $limit 2
db.participantes.aggregate([
  { $sort: { puntos: -1 } },
  { $skip: 3 },
  { $limit: 2 },
  { $project: { _id: 0, nombre: 1, puntos: 1 } }
]).forEach(d => printjson(d));

// 3. $sort alfabético + $limit 3 con proyección {_id: 0}
db.participantes.aggregate([
  { $sort: { nombre: 1 } },
  { $limit: 3 },
  { $project: { _id: 0, nombre: 1, puntos: 1 } }
]).forEach(d => printjson(d));