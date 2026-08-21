db.peliculas.drop();
db.peliculas.insertMany([
  { titulo: "La vida es bella", anio: 1997, generos: [{ nombre: "comedia", popular: true }, { nombre: "drama", popular: false }] },
  { titulo: "El laberinto del fauno", anio: 2006, generos: [{ nombre: "fantasia", popular: true }, { nombre: "drama", popular: false }] },
  { titulo: "Piratas del Caribe", anio: 2003, generos: [{ nombre: "aventura", popular: true }, { nombre: "accion", popular: false }, { nombre: "comedia", popular: true }] },
  { titulo: "Regreso al futuro", anio: 1985, generos: [{ nombre: "aventura", popular: false }, { nombre: "comedia", popular: true }, { nombre: "ciencia ficcion", popular: false }] },
  { titulo: "Amelie", anio: 2001, generos: [{ nombre: "comedia", popular: true }, { nombre: "romance", popular: false }] },
  { titulo: "El llanero solitario", anio: 2013, generos: [{ nombre: "aventura", popular: true }, { nombre: "comedia", popular: false }] }
]);
