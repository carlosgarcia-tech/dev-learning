const http = require("node:http");

const PUERTO = 3000;

const productos = [
  { nombre: "Laptop", precio: 800 },
  { nombre: "Mouse", precio: 20 },
];

function responder(res, codigo, tipo, cuerpo) {
  // TODO: envía headers (Content-Type y Content-Length) y el cuerpo.
  throw new Error("TODO: implementar responder(...)");
}

function crearServidor() {
  // TODO: devuelve un http.Server que responde por ruta:
  // "/" 200 texto; "/hora" 200 ISO; "/saludo?nombre=" 200; "/productos" 200 JSON; otra 404.
  throw new Error("TODO: implementar crearServidor()");
}

if (require.main === module) {
  crearServidor().listen(PUERTO, () => {
    console.log(`Servidor escuchando en http://localhost:${PUERTO}`);
  });
}

module.exports = { crearServidor, responder, PUERTO, productos };
