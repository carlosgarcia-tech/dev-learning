// 1. $group por vendedor: total ($sum), nº de pedidos ($count) y promedio ($avg)
db.ventas.aggregate([
  { $group: {
      _id: "$vendedor",
      totalImporte: { $sum: "$importe" },
      pedidos: { $count: {} },
      promedio: { $avg: "$importe" }
  } },
  { $sort: { _id: 1 } },
  { $project: { _id: 0, vendedor: "$_id", total: "$totalImporte", pedidos: 1, promedio: 1 } }
]).forEach(d => printjson(d));

// 2. $sort por total desc (grupo por vendedor con $sum)
db.ventas.aggregate([
  { $group: { _id: "$vendedor", total: { $sum: "$importe" } } },
  { $sort: { total: -1 } },
  { $project: { _id: 0, vendedor: "$_id", total: 1 } }
]).forEach(d => printjson(d));

// 3. $group por ciudad con $sum y $sort alfabético
db.ventas.aggregate([
  { $group: { _id: "$ciudad", total: { $sum: "$importe" } } },
  { $sort: { _id: 1 } },
  { $project: { _id: 0, ciudad: "$_id", total: 1 } }
]).forEach(d => printjson(d));

// 4. $match antes de $group (solo importe > 100) + $group por vendedor
db.ventas.aggregate([
  { $match: { importe: { $gt: 100 } } },
  { $group: { _id: "$vendedor", total: { $sum: "$importe" } } },
  { $sort: { _id: 1 } },
  { $project: { _id: 0, vendedor: "$_id", total: 1 } }
]).forEach(d => printjson(d));
