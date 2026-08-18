function crearPelicula() {
  // TODO: devuelve { titulo, anio, director, duracionMin }.
  throw new Error("TODO: implementar crearPelicula()");
}

function enriquecer(pelicula) {
  // TODO: cambia duracionMin a 195 y añade genero y premios. Devuelve el objeto.
  throw new Error("TODO: implementar enriquecer(pelicula)");
}

if (require.main === module) {
  const pelicula = crearPelicula();
  console.log(`Título: ${pelicula.titulo}`);
  console.log(`Año: ${pelicula["anio"]}`);
  enriquecer(pelicula);
  console.log(`Nueva duración: ${pelicula.duracionMin}`);
  console.log(pelicula);
  console.log(`Premios ganados: ${pelicula.premios.length}`);
}

module.exports = { crearPelicula, enriquecer };
