function simularPeticion(ms, fallar = false) {
  // TODO: promesa que resuelve "Respuesta lista" tras ms, o rechaza con Error("Error de red").
  throw new Error("TODO: implementar simularPeticion(ms, fallar)");
}

async function obtenerDatos(fallar) {
  // TODO: await simularPeticion(200, fallar); devuelve el resultado.
  throw new Error("TODO: implementar obtenerDatos(fallar)");
}

async function obtenerTodo() {
  // TODO: Promise.all de tres peticiones de 100/200/300 ms; devuelve el array.
  throw new Error("TODO: implementar obtenerTodo()");
}

if (require.main === module) {
  console.log("Inicio");
  obtenerDatos(false).then((r) => console.log(r));
  obtenerDatos(true).catch((error) => console.log(`Error: ${error.message}`));
  obtenerTodo().then((todas) => console.log(`Todas: ${todas}`));
  console.log("Fin");
}

module.exports = { simularPeticion, obtenerDatos, obtenerTodo };
