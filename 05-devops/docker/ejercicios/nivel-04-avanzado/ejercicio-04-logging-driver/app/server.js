// server.js — app que loguea en stdout (capturado por el logging driver de Docker)
const http = require("http");
const PORT = process.env.PORT || 3000;
http.createServer((req, res) => {
  console.log(JSON.stringify({ method: req.method, url: req.url, ts: Date.now() }));
  res.writeHead(200, { "Content-Type": "application/json" });
  res.end(JSON.stringify({ ok: true }));
}).listen(PORT, "0.0.0.0", () => console.log(`app en :${PORT}`));
