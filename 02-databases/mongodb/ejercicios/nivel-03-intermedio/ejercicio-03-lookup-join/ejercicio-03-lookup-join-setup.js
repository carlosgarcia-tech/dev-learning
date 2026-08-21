db.autores.drop();
db.libros.drop();
db.autores.insertMany([
  { _id: "a1", nombre: "Gabriel García Márquez", nacionalidad: "colombiana" },
  { _id: "a2", nombre: "Isabel Allende", nacionalidad: "chilena" },
  { _id: "a3", nombre: "Jorge Luis Borges", nacionalidad: "argentina" },
  { _id: "a4", nombre: "Julio Cortázar", nacionalidad: "argentina" }
]);
db.libros.insertMany([
  { _id: "l1", titulo: "Cien años de soledad", autor_id: "a1", anio: 1967 },
  { _id: "l2", titulo: "El amor en los tiempos del cólera", autor_id: "a1", anio: 1985 },
  { _id: "l3", titulo: "La casa de los espíritus", autor_id: "a2", anio: 1982 },
  { _id: "l4", titulo: "Inés del alma mía", autor_id: "a2", anio: 2006 },
  { _id: "l5", titulo: "Ficciones", autor_id: "a3", anio: 1944 },
  { _id: "l6", titulo: "Rayuela", autor_id: "a4", anio: 1963 }
]);
