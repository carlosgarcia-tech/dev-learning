// server.js — app que muestra la arquitectura en la que corre (multi-arch)
const http = require("http");
const os = require("os");
const PORT = process.env.PORT || 3000;
http.createServer((req, res) => {
  res.writeHead(200, { "Content-Type": "application/json" });
  res.end(JSON.stringify({ ok: true, arch: process.arch, platform: process.platform }));
}).listen(PORT, "0.0.0.0", () => console.log(`app (${process.arch}) en :${PORT}`));
