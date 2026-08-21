db.pedidos.drop();
db.pedidos.insertMany([
  { codigo: 1, cliente: { nombre: "Ana", ciudad: "Madrid" }, items: [{ producto: "Portátil", cantidad: 1 }, { producto: "Ratón", cantidad: 2 }] },
  { codigo: 2, cliente: { nombre: "Luis", ciudad: "Madrid" }, items: [{ producto: "Monitor", cantidad: 1 }] },
  { codigo: 3, cliente: { nombre: "Ana", ciudad: "Barcelona" }, items: [{ producto: "Teclado", cantidad: 3 }, { producto: "Lámpara", cantidad: 2 }] },
  { codigo: 4, cliente: { nombre: "Marta", ciudad: "Madrid" }, items: [{ producto: "laptop", cantidad: 5 }, { producto: "Auriculares", cantidad: 1 }] },
  { codigo: 5, cliente: { nombre: "Pablo", ciudad: "Sevilla" }, items: [{ producto: "laptop", cantidad: 10 }] }
]);
