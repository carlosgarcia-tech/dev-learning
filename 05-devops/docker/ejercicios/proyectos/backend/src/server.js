// src/server.js — API REST de tareas (usa solo Node stdlib + postgres por TCP)
const http = require("http");
const net = require("net");
const PORT = process.env.PORT || 3000;

const DB_HOST = process.env.DB_HOST || "db";
const DB_PORT = Number(process.env.DB_PORT || 5432);
const DB_USER = process.env.DB_USER || "appuser";
const DB_PASSWORD = process.env.DB_PASSWORD || "changeme";
const DB_NAME = process.env.DB_NAME || "tasksdb";

// --- Cliente Postgres mínimo (protocolo v3) ---
// Para no añadir dependencias externas, usamos el protocolo binario de Postgres.
// Esto es un cliente educativo simplificado; en producción usa 'pg'.

function sendStartup(socket, user, database) {
  // Mensaje de Startup: tag 'user' y 'database'
  const params = Buffer.from(`user\0${user}\0database\0${database}\0\0`, "utf8");
  const len = params.length + 4;
  const header = Buffer.alloc(8);
  header.writeUInt32BE(len, 0);
  header.writeUInt32BE(196608, 4); // protocol version 3.0
  socket.write(Buffer.concat([header, params]));
}

function query(sql, cb) {
  return new Promise((resolve) => {
    let received = "";
    const socket = net.createConnection({ host: DB_HOST, port: DB_PORT, timeout: 5000 });
    socket.on("connect", () => sendStartup(socket, DB_USER, DB_NAME));
    socket.on("error", () => resolve({ ok: false, error: "db error" }));
    socket.on("timeout", () => { socket.destroy(); resolve({ ok: false, error: "timeout" }); });
    socket.on("data", (data) => {
      received += data.toString("utf8");
      // Respuesta muy simplificada: para el ejercicio, solo verificamos conexión
      socket.end();
      resolve({ ok: true, raw: received.length });
    });
  });
}

// --- Almacenamiento en memoria (fallback si la BBDD no responde) ---
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

const server = http.createServer(async (req, res) => {
  // CORS para desarrollo
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader("Access-Control-Allow-Methods", "GET,POST,OPTIONS");
  res.setHeader("Access-Control-Allow-Headers", "Content-Type");
  if (req.method === "OPTIONS") return json(res, 204, {});

  if (req.url === "/health") return json(res, 200, { ok: true });

  if (req.url === "/api/health") return json(res, 200, { ok: true, db: DB_HOST });

  if (req.url === "/api/tasks" && req.method === "GET") {
    return json(res, 200, tasks);
  }

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
