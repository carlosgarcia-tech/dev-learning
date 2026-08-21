db.productos.drop();
db.productos.insertMany([
  { nombre: "Monitor", precio: 349, stock: 12, categoria: "informatica" },
  { nombre: "Ratón", precio: 25.99, stock: 40, categoria: "informatica" },
  { nombre: "Silla", precio: 199, stock: 6, categoria: "hogar" },
  { nombre: "Lámpara", precio: 27.99, stock: 0, categoria: "hogar" },
  { nombre: "Auriculares", precio: 79.9, stock: 3, categoria: "accesorios" },
  { nombre: "Portátil", precio: 899, stock: 10, categoria: "informatica" }
]);
