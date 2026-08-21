// server.js — app con endpoint /health para el healthcheck de Docker
const http = require("http");
const PORT = process.env.PORT || 3000;
http.createServer((req, res) => {
  if (req.url === "/health") {
    res.writeHead(200, { "Content-Type": "application/json" });
    res.end(JSON.stringify({ ok: true }));
    return;
  }
  res.writeHead(200, { "Content-Type": "application/json" });
  res.end(JSON.stringify({ ok: true, path: req.url }));
}).listen(PORT, "0.0.0.0", () => console.log(`app en :${PORT}`));
