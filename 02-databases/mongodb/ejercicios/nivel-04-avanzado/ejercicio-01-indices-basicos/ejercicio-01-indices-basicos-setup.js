db.productos.drop();
db.productos.insertMany([
  { nombre: "camisa", precio: 25, categoria: "ropa" },
  { nombre: "pantalon", precio: 40, categoria: "ropa" },
  { nombre: "zapatillas", precio: 80, categoria: "calzado" },
  { nombre: "gorra", precio: 15, categoria: "ropa" },
  { nombre: "reloj", precio: 120, categoria: "accesorios" },
  { nombre: "mochila", precio: 60, categoria: "accesorios" }
]);