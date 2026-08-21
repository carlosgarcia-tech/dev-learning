// server.js — app para probar alias DNS en la red personalizada
const http = require("http");
const PORT = process.env.PORT || 3000;
http.createServer((req, res) => {
  res.writeHead(200, { "Content-Type": "application/json" });
  res.end(JSON.stringify({ ok: true, service: "api", alias: "backend" }));
}).listen(PORT, "0.0.0.0", () => console.log(`api en :${PORT}`));
