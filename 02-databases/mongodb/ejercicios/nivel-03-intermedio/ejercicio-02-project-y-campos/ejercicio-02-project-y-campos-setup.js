db.productos.drop();
db.productos.insertMany([
  { nombre: "Teclado", precio: 45, iva: 0.21 },
  { nombre: "Ratón", precio: 25, iva: 0.1 },
  { nombre: "Monitor", precio: 200, iva: 0.21 },
  { nombre: "Webcam", precio: 60, iva: 0.1 },
  { nombre: "Auriculares", precio: 80, iva: 0.21 },
  { nombre: "Soporte", precio: 30, iva: 0.1 }
]);
