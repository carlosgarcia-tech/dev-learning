// server.js — app para verificar que corre como UID 10001 y FS read-only
const http = require("http");
const os = require("os");
const PORT = process.env.PORT || 3000;
http.createServer((req, res) => {
  res.writeHead(200, { "Content-Type": "application/json" });
  res.end(JSON.stringify({ ok: true, uid: os.userInfo().uid, username: os.userInfo().username }));
}).listen(PORT, "0.0.0.0", () => console.log(`[uid=${os.userInfo().uid}] en :${PORT}`));
