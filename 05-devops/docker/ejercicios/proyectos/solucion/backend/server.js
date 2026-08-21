// server.js — API REST de tareas (solución del proyecto final)
const http = require("http");
const PORT = process.env.PORT || 3000;

let tasks = [];
let nextId = 1;

function parseBody(req, cb) {
  let body = "";
  req.on("data", (c) => (body += c));
  req.on("end", () => {
    try { cb(JSON.parse(body || "{}")); } catch { cb({}); }
  });
}

function json(res, code, data) {
  res.writeHead(code, { "Content-Type": "application/json" });
  res.end(JSON.stringify(data));
}

const server = http.createServer((req, res) => {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader("Access-Control-Allow-Methods", "GET,POST,OPTIONS");
  res.setHeader("Access-Control-Allow-Headers", "Content-Type");
  if (req.method === "OPTIONS") return json(res, 204, {});

  if (req.url === "/health") return json(res, 200, { ok: true });
  if (req.url === "/api/health") return json(res, 200, { ok: true, db: process.env.DB_HOST || "db" });
  if (req.url === "/api/tasks" && req.method === "GET") return json(res, 200, tasks);
  if (req.url === "/api/tasks" && req.method === "POST") {
    return parseBody(req, (body) => {
      if (!body.title) return json(res, 400, { error: "title es obligatorio" });
      const task = { id: nextId++, title: body.title };
      tasks.push(task);
      return json(res, 201, task);
    });
  }
  json(res, 404, { error: "Not found" });
});

server.listen(PORT, "0.0.0.0", () => console.log(`backend API en :${PORT}`));
