// 1. $bucket por rangos de importe con contadores
printjson(db.ventas.aggregate([
  {
    $bucket: {
      groupBy: "$importe",
      boundaries: [0, 100, 200, 400, 1000],
      default: "otro",
      output: { total: { $sum: 1 } }
    }
  },
  { $sort: { _id: 1 } },
  { $project: { _id: 0, rango: "$_id", total: 1 } }
]).toArray());

// 2. $facet: por vendedor (sum), por categoria (count), total global
const facet = db.ventas.aggregate([
  {
    $facet: {
      porVendedor: [
        { $group: { _id: "$vendedor", total: { $sum: "$importe" } } },
        { $project: { _id: 0, vendedor: "$_id", total: 1 } },
        { $sort: { vendedor: 1 } }
      ],
      porCategoria: [
        { $group: { _id: "$categoria", total: { $sum: 1 } } },
        { $project: { _id: 0, categoria: "$_id", total: 1 } },
        { $sort: { categoria: 1 } }
      ],
      totalGlobal: [
        { $group: { _id: null, total: { $sum: "$importe" } } },
        { $project: { _id: 0, total: 1 } }
      ]
    }
  }
]).toArray()[0];
printjson(facet.porVendedor);
printjson(facet.porCategoria);
printjson(facet.totalGlobal);

// 3. $group con $push (importes por categoria)
printjson(db.ventas.aggregate([
  { $group: { _id: "$categoria", importes: { $push: "$importe" } } },
  { $project: { _id: 0, categoria: "$_id", importes: 1 } },
  { $sort: { categoria: 1 } }
]).toArray());

// 4. $sort por importe desc y proyección final {_id:0}
printjson(db.ventas.aggregate([
  { $sort: { importe: -1 } },
  { $project: { _id: 0, fecha: 1, vendedor: 1, importe: 1, categoria: 1 } }
]).toArray());
