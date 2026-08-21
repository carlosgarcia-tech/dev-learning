// 1. Pedidos cuyo cliente vive en "Madrid" (dot notation sobre cliente.ciudad)
db.pedidos.find({ "cliente.ciudad": "Madrid" }, { _id: 0 })
  .sort({ codigo: 1 }).forEach(d => printjson(d));

// 2. Pedidos cuyo cliente se llama "Ana" (dot notation sobre cliente.nombre)
db.pedidos.find({ "cliente.nombre": "Ana" }, { _id: 0 })
  .sort({ codigo: 1 }).forEach(d => printjson(d));

// 3. Pedidos con algún item "laptop" (filtro sobre array de objetos embebidos)
db.pedidos.find({ "items.producto": "laptop" }, { _id: 0 })
  .sort({ codigo: 1 }).forEach(d => printjson(d));

// 4. Proyección de subcampo embebido: solo cliente.nombre (_id: 0)
db.pedidos.find({}, { _id: 0, "cliente.nombre": 1 })
  .sort({ codigo: 1 }).forEach(d => printjson(d));
