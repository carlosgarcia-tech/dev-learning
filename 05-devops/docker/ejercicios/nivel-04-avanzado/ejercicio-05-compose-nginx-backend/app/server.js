// server.js — backend detrás del proxy nginx
const http = require("http");
const PORT = process.env.PORT || 3000;
http.createServer((req, res) => {
  res.writeHead(200, { "Content-Type": "application/json" });
  res.end(JSON.stringify({ ok: true, from: "backend", path: req.url }));
}).listen(PORT, "0.0.0.0", () => console.log(`backend en :${PORT}`));
