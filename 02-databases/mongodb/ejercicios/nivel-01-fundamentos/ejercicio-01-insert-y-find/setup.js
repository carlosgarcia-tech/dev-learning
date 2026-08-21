db.productos.drop();
db.productos.insertMany([
  { nombre: "Ratón", precio: 12, stock: 40, categoria: "Periféricos" },
  { nombre: "Teclado", precio: 25, stock: 15, categoria: "Periféricos" },
  { nombre: "Monitor", precio: 150, stock: 10, categoria: "Pantallas" }
]);