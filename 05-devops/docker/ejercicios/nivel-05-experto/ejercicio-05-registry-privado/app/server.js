// server.js — app para subir al registry privado
const http = require("http");
const PORT = process.env.PORT || 3000;
http.createServer((req, res) => {
  res.writeHead(200, { "Content-Type": "application/json" });
  res.end(JSON.stringify({ ok: true, from: "registry-app" }));
}).listen(PORT, "0.0.0.0", () => console.log(`app en :${PORT}`));
