# Proyecto Final — Servidor HTTP desde cero en Node.js

> Proyecto integrador: construir un servidor HTTP completo **sin frameworks** que maneje rutas, métodos, JSON, cookies, CORS, caché con ETag, autenticación con JWT, rate limiting y manejo de errores.

- **Nivel:** 5/5
- **Tiempo estimado:** 6–10 h

## Contexto

Has estudiado HTTP a fondo: peticiones, respuestas, métodos, códigos, headers, cookies, CORS, caché, autenticación y seguridad. Ahora vas a construir un servidor HTTP desde cero usando **solo el módulo `http` de Node.js** (sin Express, sin Fastify, sin Koa). El objetivo es entender cómo funciona un servidor HTTP por dentro: parsear la petición, enrutar, leer el body, devolver respuestas correctas.

El servidor gestiona una API de **tareas** (todo list) con:

- CRUD completo de tareas.
- Autenticación con JWT.
- Cookies de sesión.
- CORS configurable.
- Caché con ETag.
- Rate limiting por IP.
- Manejo de errores estructurado.

## Requisitos

### Funcionales

- [ ] `GET /health` → 200 con `{"status":"ok"}`.
- [ ] `POST /auth/login` con `{"username":"admin","password":"1234"}` → 200 con `{"token":"<jwt>"}` y `Set-Cookie`.
- [ ] `GET /tasks` (con Bearer válido) → 200 con lista de tareas + `ETag`.
- [ ] `GET /tasks/:id` (con Bearer válido) → 200 con una tarea o 404.
- [ ] `POST /tasks` (con Bearer válido) → 201 con la tarea creada y `Location`.
- [ ] `PATCH /tasks/:id` (con Bearer válido) → 200 con la tarea actualizada.
- [ ] `DELETE /tasks/:id` (con Bearer válido) → 204.
- [ ] `GET /tasks` con `If-None-Match` coincidente → 304.
- [ ] Sin token → 401; con token inválido → 401.
- [ ] Rate limiting: más de 10 peticiones/min → 429 con `Retry-After`.
- [ ] CORS: preflight `OPTIONS` responde con headers CORS.
- [ ] Errores no capturados → 500 con `{"error":"..."}`.

### Técnicos

- [ ] Usa solo `http`, `crypto`, `url` de Node.js (sin npm).
- [ ] Parsea el path, query string y body JSON manualmente.
- [ ] Implementa el router manual (sin librerías).
- [ ] JWT firmado con HMAC-SHA256 (sin librerías externas).
- [ ] Rate limiting en memoria (por IP).
- [ ] Manejo de errores con try/catch y respuestas JSON estructuradas.

## Fases

### Fase 1 — Servidor mínimo y router

- Arrancar `http.createServer` en el puerto 3000.
- Parsear `req.method`, `req.url` (path + query).
- Implementar un router simple: un mapa de rutas `{"GET /health": handler}`.
- Responder 404 para rutas no encontradas.

### Fase 2 — Body JSON y CRUD de tareas

- Leer el body del request (eventos `data`/`end`), parsear JSON.
- Implementar CRUD en memoria (array de tareas).
- `POST /tasks` → 201 + `Location`.
- `PATCH /tasks/:id` → 200.
- `DELETE /tasks/:id` → 204.
- Validar entradas → 400/422.

### Fase 3 — Autenticación JWT

- `POST /auth/login` verifica credenciales y emite un JWT (HMAC-SHA256 con `crypto`).
- Middleware que verifica el `Authorization: Bearer` en rutas `/tasks`.
- Sin token → 401; token inválido → 401.
- `Set-Cookie: token=<jwt>; HttpOnly; Secure; SameSite=Lax`.

### Fase 4 — Caché con ETag

- `GET /tasks` calcula un ETag (hash del body).
- Si el cliente envía `If-None-Match` coincidente → 304.
- Si no → 200 + `ETag`.

### Fase 5 — CORS y rate limiting

- Responder a `OPTIONS` con headers CORS (`Access-Control-Allow-*`).
- Rate limiting por IP: contador en memoria, 10 peticiones/min → 429 + `Retry-After`.

### Fase 6 — Manejo de errores

- Envolver handlers en try/catch.
- Errores no controlados → 500 con `{"error":"Internal Server Error"}`.
- Errores de validación → 400/422 con `{"error":"..."}`.
- No filtrar stack traces en producción.

## Criterios de aceptación

1. `node server.js` arranca sin errores en el puerto 3000.
2. `curl http://localhost:3000/health` → `{"status":"ok"}` con 200.
3. Login devuelve un JWT válido.
4. CRUD de tareas funciona con el JWT.
5. ETag + 304 funciona en `GET /tasks`.
6. Rate limiting responde 429 tras 10 peticiones.
7. CORS responde al preflight OPTIONS.
8. Errores devuelven JSON estructurado con el código correcto.
9. `bash test.sh` pasa (valida los puntos anteriores con curl).

## Estructura

```
proyectos/servidor-http-node/
├── README.md          (este archivo)
├── server.js          (tu implementación - starter)
├── test.sh            (tests de integración con curl)
└── peticiones.http    (ejemplos de peticiones)
```

## Cómo empezar

1. Lee `server.js` (tiene el esqueleto con TODOs).
2. Implementa fase por fase.
3. Ejecuta `bash test.sh` para validar.

```bash
# Terminal 1: arrancar el servidor
node server.js

# Terminal 2: probar
curl http://localhost:3000/health
```

## Pistas

<details>
<summary>Mostrar pistas generales</summary>

- Usa `http.createServer((req, res) => { ... })` y `req.method`, `req.url`.
- Parsea la URL con `new URL(req.url, 'http://localhost')`.
- Lee el body acumulando chunks: `req.on('data', chunk => body += chunk)` y `req.on('end', ...)`.
- Para JWT: `crypto.createHmac('sha256', secret).update(input).digest('base64url')`.
- Para ETag: `crypto.createHash('sha256').update(body).digest('hex')`.
- Rate limiting: un objeto `{ ip: [timestamps] }` filtrado por ventana.
- CORS: comprueba `req.headers.origin` y responde headers en `OPTIONS` y en todas las respuestas.

</details>

## Solución de referencia

<details>
<summary>Mostrar la solución completa de server.js</summary>

```js
const http = require("http");
const crypto = require("crypto");

const PORT = 3000;
const SECRET = "supersecreto";
const USERS = { admin: "1234" };
let tasks = [{ id: 1, titulo: "Aprender HTTP", hecho: false }];
let nextId = 2;
const rateLimit = {}; // { ip: [timestamps] }

// --- Utilidades JWT ---
function b64url(obj) {
  return Buffer.from(JSON.stringify(obj)).toString("base64url");
}
function sign(payload) {
  const header = b64url({ alg: "HS256", typ: "JWT" });
  const body = b64url(payload);
  const sig = crypto
    .createHmac("sha256", SECRET)
    .update(`${header}.${body}`)
    .digest("base64url");
  return `${header}.${body}.${sig}`;
}
function verify(token) {
  const [h, p, s] = token.split(".");
  if (!h || !p || !s) return null;
  const expected = crypto
    .createHmac("sha256", SECRET)
    .update(`${h}.${p}`)
    .digest("base64url");
  if (expected !== s) return null;
  try {
    const payload = JSON.parse(Buffer.from(p, "base64url").toString());
    if (payload.exp && Date.now() / 1000 > payload.exp) return null;
    return payload;
  } catch {
    return null;
  }
}

// --- Utilidades HTTP ---
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

// --- Middleware de auth ---
function authenticate(req) {
  const auth = req.headers["authorization"] || "";
  if (!auth.startsWith("Bearer ")) return null;
  return verify(auth.slice(7));
}

// --- Rate limiting ---
function checkRate(ip) {
  const now = Date.now();
  const window = 60000;
  rateLimit[ip] = (rateLimit[ip] || []).filter((t) => now - t < window);
  if (rateLimit[ip].length >= 10) {
    const retry = Math.ceil((window - (now - rateLimit[ip][0])) / 1000);
    return { limited: true, retry };
  }
  rateLimit[ip].push(now);
  return { limited: false };
}

// --- CORS ---
const CORS_HEADERS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "GET, POST, PATCH, DELETE, OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type, Authorization",
};

// --- Router ---
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
    send(res, 429, { error: "Too Many Requests" }, { "Retry-After": rl.retry, ...CORS_HEADERS });
    return;
  }

  try {
    // Health
    if (path === "/health" && method === "GET") {
      return send(res, 200, { status: "ok" }, CORS_HEADERS);
    }

    // Login
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

    // Rutas protegidas (/tasks)
    if (path.startsWith("/tasks")) {
      const user = authenticate(req);
      if (!user) return send(res, 401, { error: "Unauthorized" }, CORS_HEADERS);

      // GET /tasks (lista con ETag)
      if (path === "/tasks" && method === "GET") {
        const body = JSON.stringify(tasks);
        const tag = etag(body);
        const inm = req.headers["if-none-match"];
        if (inm === tag) {
          return send(res, 304, null, { ETag: tag, ...CORS_HEADERS });
        }
        return send(res, 200, tasks, { ETag: tag, ...CORS_HEADERS });
      }

      // POST /tasks
      if (path === "/tasks" && method === "POST") {
        const body = await readBody(req);
        if (!body || !body.titulo) return send(res, 422, { error: "Falta titulo" }, CORS_HEADERS);
        const task = { id: nextId++, titulo: body.titulo, hecho: false };
        tasks.push(task);
        return send(res, 201, task, { Location: `/tasks/${task.id}`, ...CORS_HEADERS });
      }

      // GET /tasks/:id
      const m = path.match(/^\/tasks\/(\d+)$/);
      if (m && method === "GET") {
        const task = tasks.find((t) => t.id === Number(m[1]));
        if (!task) return send(res, 404, { error: "Not Found" }, CORS_HEADERS);
        return send(res, 200, task, CORS_HEADERS);
      }

      // PATCH /tasks/:id
      if (m && method === "PATCH") {
        const task = tasks.find((t) => t.id === Number(m[1]));
        if (!task) return send(res, 404, { error: "Not Found" }, CORS_HEADERS);
        const body = await readBody(req);
        if (!body) return send(res, 400, { error: "JSON inválido" }, CORS_HEADERS);
        if (body.titulo !== undefined) task.titulo = body.titulo;
        if (body.hecho !== undefined) task.hecho = body.hecho;
        return send(res, 200, task, CORS_HEADERS);
      }

      // DELETE /tasks/:id
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
```

</details>
