const http = require("node:http");

const PUERTO = 4000;

function responder(res, codigo, dato) {
  // TODO: envía el JSON con Content-Type y Content-Length.
  throw new Error("TODO: implementar responder(res, codigo, dato)");
}

function leerBody(req) {
  // TODO: devuelve una promesa con el JSON del body (o null si es inválido).
  throw new Error("TODO: implementar leerBody(req)");
}

function crearServidor() {
  // TODO: devuelve un http.Server con GET /productos, GET /productos/:id, POST /productos.
  throw new Error("TODO: implementar crearServidor()");
}

if (require.main === module) {
  crearServidor().listen(PUERTO, () => {
    console.log(`API escuchando en http://localhost:${PUERTO}`);
  });
}

module.exports = { crearServidor, responder, leerBody, PUERTO };
