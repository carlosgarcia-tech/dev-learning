db.pedidos.drop();
db.pedidos.insertMany([
  {
    codigo: "P001", cliente: "C001", fecha: "2024-01-15", estado: "entregado", total: 150,
    items: [
      { producto: "teclado", cantidad: 2 },
      { producto: "raton", cantidad: 1 }
    ]
  },
  {
    codigo: "P002", cliente: "C002", fecha: "2024-01-28", estado: "entregado", total: 90,
    items: [
      { producto: "libro", cantidad: 3 }
    ]
  },
  {
    codigo: "P003", cliente: "C001", fecha: "2024-02-05", estado: "pendiente", total: 300,
    items: [
      { producto: "monitor", cantidad: 1 },
      { producto: "teclado", cantidad: 1 }
    ]
  },
  {
    codigo: "P004", cliente: "C003", fecha: "2024-02-19", estado: "entregado", total: 45,
    items: [
      { producto: "libro", cantidad: 1 }
    ]
  },
  {
    codigo: "P005", cliente: "C002", fecha: "2024-03-02", estado: "cancelado", total: 200,
    items: [
      { producto: "monitor", cantidad: 2 }
    ]
  },
  {
    codigo: "P006", cliente: "C001", fecha: "2024-03-25", estado: "entregado", total: 60,
    items: [
      { producto: "raton", cantidad: 3 }
    ]
  }
]);

db.clientes.drop();
db.clientes.insertMany([
  { codigo: "C001", nombre: "Ana", ciudad: "Madrid" },
  { codigo: "C002", nombre: "Luis", ciudad: "Barcelona" },
  { codigo: "C003", nombre: "Sara", ciudad: "Valencia" }
]);