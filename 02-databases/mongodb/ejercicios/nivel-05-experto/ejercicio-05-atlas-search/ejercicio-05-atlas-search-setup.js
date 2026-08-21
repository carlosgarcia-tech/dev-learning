db.libros.drop();
db.libros.insertMany([
  { titulo: "Aventuras en la isla del tesoro", autor: "R. L. Stevenson", genero: "aventura", anio: 1883 },
  { titulo: "Las aventuras de Huckleberry Finn", autor: "Mark Twain", genero: "aventura", anio: 1884 },
  { titulo: "Aventura en el espacio profundo", autor: "Carlos Mendez", genero: "ciencia ficcion", anio: 1998 },
  { titulo: "Misterio en la mansion", autor: "Sara Lopez", genero: "misterio", anio: 1975 },
  { titulo: "El misterio del faro", autor: "Sara Lopez", genero: "misterio", anio: 2005 },
  { titulo: "El tesoro perdido", autor: "Julio Verne", genero: "aventura", anio: 1869 }
]);