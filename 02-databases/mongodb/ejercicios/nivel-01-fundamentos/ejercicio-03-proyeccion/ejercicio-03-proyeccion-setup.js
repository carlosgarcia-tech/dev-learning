db.articulos.drop();
db.articulos.insertMany([
  { titulo: "Cien años de soledad", autor: "Gabriel García Márquez", anio: 1967, precio: 12 },
  { titulo: "1984", autor: "George Orwell", anio: 1949, precio: 10 },
  { titulo: "El nombre del viento", autor: "Patrick Rothfuss", anio: 2007, precio: 15 },
  { titulo: "Ready Player One", autor: "Ernest Cline", anio: 2011, precio: 18 },
  { titulo: "La sombra del viento", autor: "Carlos Ruiz Zafón", anio: 2001, precio: 14 }
]);