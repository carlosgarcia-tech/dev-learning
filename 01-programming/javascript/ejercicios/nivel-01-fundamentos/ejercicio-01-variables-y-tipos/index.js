function crearDatos() {
  // TODO: devuelve un objeto con { nombre, ciudad, edad, programacion }.
  throw new Error("TODO: implementar crearDatos()");
}

function tiposDe(datos) {
  // TODO: devuelve un array con 4 líneas "X es de tipo <tipo>" usando typeof.
  throw new Error("TODO: implementar tiposDe(datos)");
}

function formatearDescripcion(datos) {
  // TODO: devuelve "Soy <nombre>, tengo <edad> años, nací en <ciudad> y es <programacion> que estudio programación." con template literals.
  throw new Error("TODO: implementar formatearDescripcion(datos)");
}

if (require.main === module) {
  const datos = crearDatos();
  for (const linea of tiposDe(datos)) console.log(linea);
  console.log(formatearDescripcion(datos));
}

module.exports = { crearDatos, tiposDe, formatearDescripcion };
