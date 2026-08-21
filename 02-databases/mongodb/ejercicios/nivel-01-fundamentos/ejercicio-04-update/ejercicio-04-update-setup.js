db.inventario.drop();
db.inventario.insertMany([
  { nombre: "Manzana", cantidad: 12, categoria: "Frutas" },
  { nombre: "Leche", cantidad: 5, categoria: "Lácteos" },
  { nombre: "Pan", cantidad: 0, categoria: "Panadería" },
  { nombre: "Queso", cantidad: 8, categoria: "Lácteos" },
  { nombre: "Tomate", cantidad: 3, categoria: "Verduras" }
]);