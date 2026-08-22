// Servidor HTTP desde cero en Node.js — ESQUELETO
// Implementa los TODOs fase por fase. Consulta el README.md para el enunciado completo.
// Ejecuta: node server.js

const http = require("http");
const crypto = require("crypto");

const PORT = 3000;
const SECRET = "supersecreto";
const USERS = { admin: "1234" };
let tasks = [{ id: 1, titulo: "Aprender HTTP", hecho: false }];
let nextId = 2;
const rateLimit = {};

// ====== Utilidades JWT ======
function b64url(obj) {
  // TODO: codificar obj a base64url
  return Buffer.from(JSON.stringify(obj)).toString("base64url");
}

function sign(payload) {
  // TODO: firmar payload con HMAC-SHA256
  const header = b64url({ alg: "HS256", typ: "JWT" });
  const body = b64url(payload);
  const sig = crypto.createHmac("sha256", SECRET).update(`${header}.${body}`).digest("base64url");
  return `${header}.${body}.${sig}`;
}

function verify(token) {
  // TODO: verificar firma y expiración
  const [h, p, s] = token.split(".");
  if (!h || !p || !s) return null;
  const expected = crypto.createHmac("sha256", SECRET).update(`${h}.${p}`).digest("base64url");
  if (expected !== s) return null;
  try {
    const payload = JSON.parse(Buffer.from(p, "base64url").toString());
    if (payload.exp && Date.now() / 1000 > payload.exp) return null;
    return payload;
  } catch {
    return null;
  }
}

// ====== Utilidades HTTP ======
function send(res, status, body, headers = {}) {
  const json = body !== null ? JSON.stringify(body) : "";
  res.writeHead(status, {
    "Content-Type": "application/json; charset=utf-8",
    "Content-Length": Buffer.byteLength(json),
    ...headers,
  });
  if (json) res.write(json);
  res.end();
}

function readBody(req) {
  // TODO: leer y parsear el body JSON del request
  return new Promise((resolve) => {
    let data = "";
    req.on("data", (c) => (data += c));
    req.on("end", () => {
      try {
        resolve(data ? JSON.parse(data) : {});
      } catch {
        resolve(null);
      }
    });
  });
}

function etag(body) {
  return '"' + crypto.createHash("sha256").update(body).digest("hex").slice(0, 16) + '"';
}

function authenticate(req) {
  // TODO: extraer y verificar el Bearer token
  const auth = req.headers["authorization"] || "";
  if (!auth.startsWith("Bearer ")) return null;
  return verify(auth.slice(7));
}

function checkRate(ip) {
  // TODO: rate limiting por IP (10 peticiones/min)
  const now = Date.now();
  const windowMs = 60000;
  rateLimit[ip] = (rateLimit[ip] || []).filter((t) => now - t < windowMs);
  if (rateLimit[ip].length >= 10) {
    const retry = Math.ceil((windowMs - (now - rateLimit[ip][0])) / 1000);
    return { limited: true, retry };
  }
  rateLimit[ip].push(now);
  return { limited: false };
}

const CORS_HEADERS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "GET, POST, PATCH, DELETE, OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type, Authorization",
};

// ====== Router principal ======
const server = http.createServer(async (req, res) => {
  const url = new URL(req.url, `http://localhost:${PORT}`);
  const path = url.pathname;
  const method = req.method;
  const ip = req.socket.remoteAddress;

  // CORS preflight
  if (method === "OPTIONS") {
    res.writeHead(204, CORS_HEADERS);
    res.end();
    return;
  }

  // Rate limiting
  const rl = checkRate(ip);
  if (rl.limited) {
    return send(res, 429, { error: "Too Many Requests" }, { "Retry-After": rl.retry, ...CORS_HEADERS });
  }

  try {
    // GET /health
    if (path === "/health" && method === "GET") {
      return send(res, 200, { status: "ok" }, CORS_HEADERS);
    }

    // POST /auth/login
    if (path === "/auth/login" && method === "POST") {
      const body = await readBody(req);
      if (!body) return send(res, 400, { error: "JSON inválido" }, CORS_HEADERS);
      const { username, password } = body;
      if (USERS[username] !== password) {
        return send(res, 401, { error: "Credenciales inválidas" }, CORS_HEADERS);
      }
      const token = sign({ sub: username, role: "admin", exp: Math.floor(Date.now() / 1000) + 3600 });
      return send(res, 200, { token }, {
        "Set-Cookie": `token=${token}; HttpOnly; Secure; SameSite=Lax; Path=/; Max-Age=3600`,
        ...CORS_HEADERS,
      });
    }

    // Rutas /tasks (protegidas)
    if (path.startsWith("/tasks")) {
      const user = authenticate(req);
      if (!user) return send(res, 401, { error: "Unauthorized" }, CORS_HEADERS);

      if (path === "/tasks" && method === "GET") {
        const body = JSON.stringify(tasks);
        const tag = etag(body);
        const inm = req.headers["if-none-match"];
        if (inm === tag) return send(res, 304, null, { ETag: tag, ...CORS_HEADERS });
        return send(res, 200, tasks, { ETag: tag, ...CORS_HEADERS });
      }

      if (path === "/tasks" && method === "POST") {
        const body = await readBody(req);
        if (!body || !body.titulo) return send(res, 422, { error: "Falta titulo" }, CORS_HEADERS);
        const task = { id: nextId++, titulo: body.titulo, hecho: false };
        tasks.push(task);
        return send(res, 201, task, { Location: `/tasks/${task.id}`, ...CORS_HEADERS });
      }

      const m = path.match(/^\/tasks\/(\d+)$/);

      if (m && method === "GET") {
        const task = tasks.find((t) => t.id === Number(m[1]));
        if (!task) return send(res, 404, { error: "Not Found" }, CORS_HEADERS);
        return send(res, 200, task, CORS_HEADERS);
      }

      if (m && method === "PATCH") {
        const task = tasks.find((t) => t.id === Number(m[1]));
        if (!task) return send(res, 404, { error: "Not Found" }, CORS_HEADERS);
        const body = await readBody(req);
        if (!body) return send(res, 400, { error: "JSON inválido" }, CORS_HEADERS);
        if (body.titulo !== undefined) task.titulo = body.titulo;
        if (body.hecho !== undefined) task.hecho = body.hecho;
        return send(res, 200, task, CORS_HEADERS);
      }

      if (m && method === "DELETE") {
        const idx = tasks.findIndex((t) => t.id === Number(m[1]));
        if (idx === -1) return send(res, 404, { error: "Not Found" }, CORS_HEADERS);
        tasks.splice(idx, 1);
        return send(res, 204, null, CORS_HEADERS);
      }
    }

    send(res, 404, { error: "Not Found" }, CORS_HEADERS);
  } catch (err) {
    send(res, 500, { error: "Internal Server Error" }, CORS_HEADERS);
  }
});

server.listen(PORT, () => {
  console.log(`Servidor HTTP en http://localhost:${PORT}`);
});

module.exports = { server, sign, verify };
