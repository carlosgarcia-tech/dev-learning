// server.js — lee configuración de variables de entorno
const http = require("http");

const PORT = process.env.PORT || 3000;
const NODE_ENV = process.env.NODE_ENV || "development";

const server = http.createServer((req, res) => {
  res.writeHead(200, { "Content-Type": "application/json" });
  res.end(JSON.stringify({ ok: true, env: NODE_ENV, port: Number(PORT) }));
});

server.listen(Number(PORT), "0.0.0.0", () => {
  console.log(`[${NODE_ENV}] Servidor escuchando en http://0.0.0.0:${PORT}`);
});
