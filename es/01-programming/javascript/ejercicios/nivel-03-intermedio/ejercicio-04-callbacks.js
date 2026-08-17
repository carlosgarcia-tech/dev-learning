function operacion(a, b, callback) {
  // TODO: devuelve callback(a, b).
  throw new Error("TODO: implementar operacion(a, b, callback)");
}

function suma(a, b) {
  // TODO: devuelve a + b.
  throw new Error("TODO: implementar suma(a, b)");
}

function resta(a, b) {
  // TODO: devuelve a - b.
  throw new Error("TODO: implementar resta(a, b)");
}

function multiplica(a, b) {
  // TODO: devuelve a * b.
  throw new Error("TODO: implementar multiplica(a, b)");
}

function procesarLista(lista, transformacion) {
  // TODO: devuelve lista.map(transformacion).
  throw new Error("TODO: implementar procesarLista(lista, transformacion)");
}

function leerDato(callback) {
  // TODO: setTimeout de 500 ms y llama callback("dato leído").
  throw new Error("TODO: implementar leerDato(callback)");
}

if (require.main === module) {
  console.log(`operacion suma: ${operacion(5, 3, suma)}`);
  console.log(`operacion resta: ${operacion(5, 3, resta)}`);
  console.log(`operacion multiplica: ${operacion(5, 3, multiplica)}`);
  console.log(`Lista transformada: ${procesarLista([1, 2, 3, 4, 5], (n) => n * 2)}`);
  console.log("(esperando 500 ms...)");
  leerDato((dato) => console.log(`Callback async: ${dato}`));
}

module.exports = { operacion, suma, resta, multiplica, procesarLista, leerDato };
