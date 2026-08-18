const fs = require("node:fs");
const path = require("node:path");

function crearDb(archivo, datosIniciales) {
  // TODO: implementa la persistencia de la base de datos en un JSON.
  // 1. Crea el directorio (path.dirname) con fs.mkdirSync(..., { recursive: true }).
  // 2. Si el archivo no existe, créalo con JSON.stringify(datosIniciales, null, 2).
  // 3. Carga el JSON en una variable interna `datos` con fs.readFileSync + JSON.parse.
  // 4. Expone un objeto con:
  //    - productos()  -> array de productos
  //    - pedidos()    -> array de pedidos
  //    - usuarios()   -> array de usuarios
  //    - guardar()    -> escribe `datos` en el archivo
  //    - siguienteId(lista) -> Math.max(0, ...ids) + 1
  throw new Error("TODO: implementar crearDb(archivo, datosIniciales)");
}

module.exports = { crearDb };
