// 1. $unwind items + $group por producto sumando cantidades
db.pedidos.aggregate([
  { $unwind: "$items" },
  { $group: { _id: "$items.producto", totalCantidad: { $sum: "$items.cantidad" } } },
  { $sort: { totalCantidad: -1, _id: 1 } },
  { $project: { _id: 0, producto: "$_id", totalCantidad: 1 } }
]).forEach(d => printjson(d));

// 2. $unwind + $group por pedido con total = suma(cantidad * precio)
db.pedidos.aggregate([
  { $unwind: "$items" },
  { $group: {
      _id: "$codigo",
      total: { $sum: { $multiply: ["$items.cantidad", "$items.precio"] } }
  } },
  { $sort: { _id: 1 } },
  { $project: { _id: 0, codigo: "$_id", total: 1 } }
]).forEach(d => printjson(d));

// 3. $unwind + $project de cada item con subtotal, _id: 0
db.pedidos.aggregate([
  { $unwind: "$items" },
  { $project: {
      _id: 0,
      codigo: 1,
      cliente: 1,
      producto: "$items.producto",
      cantidad: "$items.cantidad",
      subtotal: { $multiply: ["$items.cantidad", "$items.precio"] }
  } },
  { $sort: { codigo: 1, producto: 1 } }
]).forEach(d => printjson(d));