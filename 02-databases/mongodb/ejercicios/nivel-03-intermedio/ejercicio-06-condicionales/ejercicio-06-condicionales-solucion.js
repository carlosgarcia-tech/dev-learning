// 1. $project con $cond anidado: categoría Alto / Medio / Bajo según salario
db.empleados.aggregate([
  { $project: {
      _id: 0,
      nombre: 1,
      salario: 1,
      categoria: {
        $cond: [
          { $gt: ["$salario", 5000] }, "Alto",
          { $cond: [{ $gt: ["$salario", 3000] }, "Medio", "Bajo"] }
        ]
      }
  } },
  { $sort: { nombre: 1 } }
]).forEach(d => printjson(d));

// 2. $project con $ifNull (bono por defecto 0) y total = salario + bono
db.empleados.aggregate([
  { $project: {
      _id: 0,
      nombre: 1,
      salario: 1,
      bono: { $ifNull: ["$bono", 0] },
      total: { $add: ["$salario", { $ifNull: ["$bono", 0] }] }
  } },
  { $sort: { nombre: 1 } }
]).forEach(d => printjson(d));

// 3. $sort por total desc + proyección {_id: 0}
db.empleados.aggregate([
  { $project: {
      _id: 0,
      nombre: 1,
      salario: 1,
      bono: { $ifNull: ["$bono", 0] },
      total: { $add: ["$salario", { $ifNull: ["$bono", 0] }] }
  } },
  { $sort: { total: -1 } }
]).forEach(d => printjson(d));