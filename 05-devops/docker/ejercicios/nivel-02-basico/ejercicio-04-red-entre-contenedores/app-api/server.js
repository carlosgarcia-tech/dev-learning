// server.js — API que consulta al backend por DNS interno (nombre del servicio)
const http = require("http");
const PORT = process.env.PORT || 3000;

function proxy(cb) {
  const BACKEND_URL = process.env.BACKEND_URL || "http://backend:3000/health";
  http.get(BACKEND_URL, (res) => {
    let data = "";
    res.on("data", (c) => (data += c));
    res.on("end", () => cb(data));
  }).on("error", (err) => cb(JSON.stringify({ error: err.message })));
}

http.createServer((req, res) => {
  if (req.url === "/proxy") {
    proxy((body) => {
      res.writeHead(200, { "Content-Type": "application/json" });
      res.end(JSON.stringify({ from: "api", backend: body }));
    });
    return;
  }
  res.writeHead(200, { "Content-Type": "application/json" });
  res.end(JSON.stringify({ ok: true, from: "api" }));
}).listen(PORT, "0.0.0.0", () => console.log(`api en :${PORT}`));
