// 1. Insertar un producto nuevo con insertOne y comprobar el recuento
db.productos.insertOne({ nombre: "Teclado Mecánico", precio: 45, stock: 5, categoria: "Periféricos" });
print("Documentos tras insertOne: " + db.productos.countDocuments());

// 2. Insertar 3 productos más con insertMany
db.productos.insertMany([
  { nombre: "Auriculares", precio: 30, stock: 12, categoria: "Periféricos" },
  { nombre: "Webcam", precio: 60, stock: 4, categoria: "Periféricos" },
  { nombre: "Alfombrilla", precio: 8, stock: 60, categoria: "Accesorios" }
]);

// 3. Consultar todos los productos ordenados por nombre
db.productos.find({}, { _id: 0 }).sort({ nombre: 1 }).forEach(d => printjson(d));

// 4. Recuento total de productos
print("Total de productos: " + db.productos.countDocuments());