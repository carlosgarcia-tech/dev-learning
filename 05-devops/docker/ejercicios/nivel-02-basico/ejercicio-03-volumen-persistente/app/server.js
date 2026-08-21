// server.js — incrementa un contador persistente en /app/data/counter.json
const http = require("http");
const fs = require("fs");
const path = require("path");

const PORT = process.env.PORT || 3000;
const DATA_DIR = process.env.DATA_DIR || "/app/data";
const DATA_FILE = path.join(DATA_DIR, "counter.json");

function readCounter() {
  try {
    return JSON.parse(fs.readFileSync(DATA_FILE, "utf8")).count;
  } catch {
    return 0;
  }
}

function writeCounter(n) {
  fs.mkdirSync(DATA_DIR, { recursive: true });
  fs.writeFileSync(DATA_FILE, JSON.stringify({ count: n }));
}

http.createServer((req, res) => {
  const next = readCounter() + 1;
  writeCounter(next);
  res.writeHead(200, { "Content-Type": "application/json" });
  res.end(JSON.stringify({ count: next }));
}).listen(PORT, "0.0.0.0", () => console.log(`escuchando en :${PORT}`));
