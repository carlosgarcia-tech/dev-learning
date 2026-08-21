// server.js — app que muestra APP_VERSION desde ENV (pasa por ARG -> ENV)
const http = require("http");
const PORT = process.env.PORT || 3000;
const APP_VERSION = process.env.APP_VERSION || "0.0.0";
http.createServer((req, res) => {
  res.writeHead(200, { "Content-Type": "application/json" });
  res.end(JSON.stringify({ ok: true, version: APP_VERSION }));
}).listen(PORT, "0.0.0.0", () => console.log(`app v${APP_VERSION} en :${PORT}`));
