// 1. Películas cuyo array generos coincida exactamente (mismo contenido y orden)
db.peliculas.find(
  { generos: [{ nombre: "comedia", popular: true }, { nombre: "drama", popular: false }] },
  { _id: 0 }
).sort({ titulo: 1 }).forEach(d => printjson(d));

// 2. Películas que contengan al menos un elemento "comedia" Y uno "aventura" ($all)
db.peliculas.find(
  { generos: { $all: [{ nombre: "comedia" }, { nombre: "aventura" }] } },
  { _id: 0 }
).sort({ titulo: 1 }).forEach(d => printjson(d));

// 3. Películas con exactamente 2 elementos en generos (operador $size)
db.peliculas.find({ generos: { $size: 2 } }, { _id: 0 })
  .sort({ titulo: 1 }).forEach(d => printjson(d));

// 4. Películas con un elemento del array que cumpla DOS condiciones a la vez:
//    nombre "aventura" Y popular false (operador $elemMatch)
db.peliculas.find(
  { generos: { $elemMatch: { nombre: "aventura", popular: false } } },
  { _id: 0 }
).sort({ titulo: 1 }).forEach(d => printjson(d));
