db.articulos.drop();
db.articulos.insertMany([
  { titulo: "El Quijote", autor: "Miguel de Cervantes", publicado: true, precio: 12.5, resumen: "Aventuras de un hidalgo." },
  { titulo: "el principito", autor: "Antoine de Saint-Exupéry", publicado: true, precio: 9.9 },
  { titulo: "Cien años de soledad", autor: "Gabriel García Márquez", publicado: true, precio: 15.0, resumen: "Historia de los Buendía." },
  { titulo: "La casa de los espíritus", autor: "Isabel Allende", publicado: false, precio: 14.5, resumen: "Saga familiar chilena." },
  { titulo: "El Hobbit", autor: "J. R. R. Tolkien", publicado: true, precio: NumberInt(18) },
  { titulo: "Crónica de una muerte anunciada", autor: "García Márquez", publicado: true, resumen: "Crónica de un crimen." }
]);
