// src/server.js — servidor con /health para el healthcheck de Docker
const http = require("http");
const PORT = process.env.PORT || 3000;
http.createServer((req, res) => {
  const body = req.url === "/health" ? { ok: true } : { ok: true, path: req.url };
  res.writeHead(200, { "Content-Type": "application/json" });
  res.end(JSON.stringify(body));
}).listen(PORT, "0.0.0.0", () => console.log(`app en :${PORT}`));
