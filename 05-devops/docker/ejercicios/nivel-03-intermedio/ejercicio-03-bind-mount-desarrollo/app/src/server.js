// src/server.js — app Node para desarrollo con --watch
const http = require("http");
const PORT = process.env.PORT || 3000;
const NODE_ENV = process.env.NODE_ENV || "development";
http.createServer((req, res) => {
  res.writeHead(200, { "Content-Type": "application/json" });
  res.end(JSON.stringify({ ok: true, env: NODE_ENV, ts: Date.now() }));
}).listen(PORT, "0.0.0.0", () => console.log(`[${NODE_ENV}] en :${PORT}`));
