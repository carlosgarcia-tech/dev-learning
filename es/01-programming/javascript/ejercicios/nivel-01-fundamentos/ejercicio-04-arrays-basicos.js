function primerElemento(arr) {
  // TODO: devuelve arr[0].
  throw new Error("TODO: implementar primerElemento(arr)");
}

function ultimoElemento(arr) {
  // TODO: devuelve arr[arr.length - 1].
  throw new Error("TODO: implementar ultimoElemento(arr)");
}

function agregarAlFinal(arr, item) {
  // TODO: hace push y devuelve el array.
  throw new Error("TODO: implementar agregarAlFinal(arr, item)");
}

function quitarDelFinal(arr) {
  // TODO: hace pop y devuelve { quitado, array }.
  throw new Error("TODO: implementar quitarDelFinal(arr)");
}

function agregarAlInicio(arr, item) {
  // TODO: hace unshift y devuelve el array.
  throw new Error("TODO: implementar agregarAlInicio(arr, item)");
}

function quitarDelInicio(arr) {
  // TODO: hace shift y devuelve { quitado, array }.
  throw new Error("TODO: implementar quitarDelInicio(arr)");
}

if (require.main === module) {
  const tareas = ["estudiar", "cocinar", "dormir"];
  console.log(`Longitud: ${tareas.length}`);
  console.log(`Primero: ${primerElemento(tareas)}`);
  console.log(`Último: ${ultimoElemento(tareas)}`);
  console.log(`Después de push: ${agregarAlFinal(tareas, "leer")}`);
  const pop = quitarDelFinal(tareas);
  console.log(`pop() quita: ${pop.quitado} -> ${pop.array}`);
  console.log(`Después de unshift: ${agregarAlInicio(tareas, "correr")}`);
  const shift = quitarDelInicio(tareas);
  console.log(`shift() quita: ${shift.quitado} -> ${shift.array}`);
}

module.exports = {
  primerElemento,
  ultimoElemento,
  agregarAlFinal,
  quitarDelFinal,
  agregarAlInicio,
  quitarDelInicio,
};
