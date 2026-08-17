const http = require("node:http");
const { crearDb } = require("./db");
const { verificarToken } = require("./auth");
const authHandlers = require("./handlers/auth");
const productoHandlers = require("./handlers/productos");
const pedidoHandlers = require("./handlers/pedidos");
const reporteHandlers = require("./handlers/reportes");

const PUERTO = 3000;

function responder(res, codigo, dato) {
  // TODO: envía una respuesta JSON.
  // res.writeHead(codigo, { "Content-Type": "application/json; charset=utf-8", "Content-Length": Buffer.byteLength(cuerpo) })
  // res.end(cuerpo)
  throw new Error("TODO: implementar responder(res, codigo, dato)");
}

function leerBody(req) {
  // TODO: devuelve una promesa con el body JSON (o null si es inválido o está vacío).
  // let cuerpo = ""; req.on("data", ...); req.on("end", ...); intenta JSON.parse.
  throw new Error("TODO: implementar leerBody(req)");
}

function crearServidor(config) {
  // TODO: monta el servidor HTTP de la API.
  // 1. Crea la db: const db = crearDb(config.archivoDatos, config.datosIniciales).
  // 2. Lee secreto y expiracionTokenMs del config.
  // 3. En el handler de cada petición:
  //    - Divide url.pathname en partes (sin "/").
  //    - Si partes[0] !== "api" -> 404 { error: "Ruta no encontrada" }.
  //    - Si es POST /api/auth/login -> authHandlers.login.
  //    - Si no, lee el header "authorization" (Bearer <token>) y verifica el token; si no es válido -> 401 { error: "No autorizado" }.
  //    - Despacha a productoHandlers / pedidoHandlers / reporteHandlers según partes[1].
  //    - Si no coincide -> 404.
  throw new Error("TODO: implementar crearServidor(config)");
}

if (require.main === module) {
  const config = require("./config");
  crearServidor(config).listen(config.puerto, () => {
    console.log(
      `API de MiTienda escuchando en http://localhost:${config.puerto}`
    );
  });
}

module.exports = { crearServidor, responder, leerBody, PUERTO };
