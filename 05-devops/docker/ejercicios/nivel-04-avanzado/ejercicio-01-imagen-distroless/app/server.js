// server.js — app Node para imagen distroless
const http = require("http");
const PORT = process.env.PORT || 3000;
http.createServer((req, res) => {
  res.writeHead(200, { "Content-Type": "application/json" });
  res.end(JSON.stringify({ ok: true, runtime: "distroless" }));
}).listen(PORT, "0.0.0.0", () => console.log(`distroless app en :${PORT}`));
