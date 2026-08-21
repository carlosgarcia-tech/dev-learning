// server.js — app de producción con /health y verificación de db+cache por TCP
const http = require("http");
const net = require("net");
const PORT = process.env.PORT || 3000;

function reachable(host, port) {
  return new Promise((resolve) => {
    const s = net.createConnection({ host, port, timeout: 1500 });
    s.on("connect", () => { s.end(); resolve(true); });
    s.on("error", () => resolve(false));
    s.on("timeout", () => { s.destroy(); resolve(false); });
  });
}

http.createServer(async (req, res) => {
  if (req.url === "/health") {
    const db = await reachable(process.env.DB_HOST || "db", 5432);
    const cache = await reachable("cache", 6379);
    res.writeHead(200, { "Content-Type": "application/json" });
    res.end(JSON.stringify({ ok: db && cache, db, cache }));
    return;
  }
  res.writeHead(200, { "Content-Type": "application/json" });
  res.end(JSON.stringify({ ok: true, service: "app" }));
}).listen(PORT, "0.0.0.0", () => console.log(`app en :${PORT}`));
