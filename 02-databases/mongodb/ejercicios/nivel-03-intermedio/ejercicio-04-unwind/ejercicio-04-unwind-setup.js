db.pedidos.drop();
db.pedidos.insertMany([
  { codigo: 1, cliente: "ana", items: [
      { producto: "portatil", cantidad: 1, precio: 900 },
      { producto: "raton", cantidad: 2, precio: 25 }
  ] },
  { codigo: 2, cliente: "luis", items: [
      { producto: "portatil", cantidad: 1, precio: 900 },
      { producto: "teclado", cantidad: 1, precio: 45 }
  ] },
  { codigo: 3, cliente: "carla", items: [
      { producto: "monitor", cantidad: 2, precio: 200 },
      { producto: "teclado", cantidad: 1, precio: 45 },
      { producto: "raton", cantidad: 1, precio: 25 }
  ] },
  { codigo: 4, cliente: "marta", items: [
      { producto: "monitor", cantidad: 1, precio: 200 },
      { producto: "portatil", cantidad: 1, precio: 900 }
  ] }
]);