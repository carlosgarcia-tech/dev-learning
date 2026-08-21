// server.js — app para Swarm (devuelve hostname para distinguir réplicas)
const http = require("http");
const os = require("os");
const PORT = process.env.PORT || 3000;
http.createServer((req, res) => {
  res.writeHead(200, { "Content-Type": "application/json" });
  res.end(JSON.stringify({ ok: true, hostname: os.hostname() }));
}).listen(PORT, "0.0.0.0", () => console.log(`app [${os.hostname()}] en :${PORT}`));
