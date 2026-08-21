// server.js — app que comprueba que la BBDD (host db, puerto 5432) acepta conexiones TCP
const http = require("http");
const net = require("net");
const PORT = process.env.PORT || 3000;
const DB_HOST = process.env.DB_HOST || "db";
const DB_PORT = Number(process.env.DB_PORT || 5432);

function dbReachable() {
  return new Promise((resolve) => {
    const s = net.createConnection({ host: DB_HOST, port: DB_PORT, timeout: 2000 });
    s.on("connect", () => { s.end(); resolve(true); });
    s.on("error", () => resolve(false));
    s.on("timeout", () => { s.destroy(); resolve(false); });
  });
}

http.createServer(async (req, res) => {
  const ok = await dbReachable();
  res.writeHead(200, { "Content-Type": "application/json" });
  res.end(JSON.stringify({ ok: true, db: { host: DB_HOST, port: DB_PORT, reachable: ok } }));
}).listen(PORT, "0.0.0.0", () => console.log(`app en :${PORT}`));
