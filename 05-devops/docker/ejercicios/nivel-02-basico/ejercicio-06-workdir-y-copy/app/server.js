// server.js — app que imprime el usuario y el directorio (para verificar WORKDIR/USER)
const http = require("http");
const os = require("os");
const PORT = process.env.PORT || 3000;
http.createServer((req, res) => {
  res.writeHead(200, { "Content-Type": "application/json" });
  res.end(JSON.stringify({ ok: true, user: os.userInfo().username, cwd: process.cwd() }));
}).listen(PORT, "0.0.0.0", () => console.log(`[${os.userInfo().username}] en :${PORT}`));
