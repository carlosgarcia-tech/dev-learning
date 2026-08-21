// 1. Total de ventas por estado ($group, $sum, $sort)
printjson(db.pedidos.aggregate([
  { $group: { _id: "$estado", total: { $sum: "$total" } } },
  { $project: { _id: 0, estado: "$_id", total: 1 } },
  { $sort: { estado: 1 } }
]).toArray());

// 2. Top 2 productos más vendidos ($unwind, $group, $sort, $limit)
printjson(db.pedidos.aggregate([
  { $unwind: "$items" },
  { $group: { _id: "$items.producto", cantidad: { $sum: "$items.cantidad" } } },
  { $project: { _id: 0, producto: "$_id", cantidad: 1 } },
  { $sort: { cantidad: -1, producto: 1 } },
  { $limit: 2 }
]).toArray());

// 3. Total por cliente ($group + $lookup para el nombre)
printjson(db.pedidos.aggregate([
  {
    $lookup: {
      from: "clientes",
      localField: "cliente",
      foreignField: "codigo",
      as: "info"
    }
  },
  { $unwind: "$info" },
  { $group: { _id: "$info.nombre", total: { $sum: "$total" } } },
  { $project: { _id: 0, cliente: "$_id", total: 1 } },
  { $sort: { cliente: 1 } }
]).toArray());

// 4. Pedidos por mes ($group con $substr sobre fecha "YYYY-MM-DD")
printjson(db.pedidos.aggregate([
  {
    $group: {
      _id: { $substr: ["$fecha", 0, 7] },
      pedidos: { $sum: 1 }
    }
  },
  { $project: { _id: 0, mes: "$_id", pedidos: 1 } },
  { $sort: { mes: 1 } }
]).toArray());