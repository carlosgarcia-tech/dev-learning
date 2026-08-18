# 06 — Node.js y Express

## Objetivos

- [ ] Explicar qué es Node.js, el runtime V8 y el event loop.
- [ ] Distinguir módulos CommonJS (`require`/`module.exports`) de ESM (`import`/`export`).
- [ ] Crear y entender `package.json` (name, version, main, scripts) y los comandos de npm.
- [ ] Levantar un servidor HTTP mínimo con `node:http` y leer el body con `data`/`end`.
- [ ] Trabajar con cabeceras, códigos de estado y respuestas JSON.
- [ ] Instalar Express y crear rutas con `app.get`/`post`/`put`/`delete`.
- [ ] Usar `req.params`, `req.query` y `req.body` (con `express.json()`).
- [ ] Modularizar con `express.Router` y rutas paramétricas (`/usuarios/:id`).
- [ ] Entender los middlewares, su orden de ejecución y `next()`.
- [ ] Servir archivos estáticos con `express.static`.
- [ ] Diseñar una API REST (routes/, controllers/, data/), persistir en JSON con `node:fs/promises` y validar entrada.
- [ ] Implementar autenticación con tokens HMAC (`node:crypto`) y cabecera `Authorization: Bearer`.
- [ ] Testear una API con `node:test` y `fetch` sobre un puerto de test.
- [ ] Aplicar buenas prácticas: `process.env`, `dotenv`, errores centralizados, CORS, helmet y límites.
- [ ] Preparar el despliegue con `NODE_ENV` y PM2.

## Apuntes

### ¿Qué es Node.js?

Node.js es un **runtime de JavaScript** para el servidor: ejecuta JS fuera del navegador. Está construido sobre **V8**, el motor de Chrome que compila JS a binario, y sobre **libuv**, la biblioteca del event loop que gestiona la entrada/salida asíncrona (red, disco, timers). En Node no existe `document` ni `window`; hay módulos como `node:fs`, `node:http` y `node:crypto`. Puedes inspeccionar el runtime con `node -p "process.version"` (imprime la versión, p. ej. `v22.x.x`).

**Un solo hilo con event loop.** Node ejecuta tu código en un único hilo. Las operaciones lentas (leer un archivo, esperar una petición) se delegan a libuv y su resultado vuelve como evento; mientras tanto el hilo sigue atendiendo otras cosas. No bloquees el hilo con cálculos síncronos pesados dentro de un handler. **Node 18+** trae `fetch` global, `node:test`, `node --watch` y, en ESM, top-level `await`.

### Módulos CommonJS vs ESM

El sistema por defecto de Node es **CommonJS** (CJS): cada archivo es un módulo que exporta con `module.exports` e importa con `require()`. El moderno es **ESM**, que usa `export`/`import` y requiere extensión `.mjs` o `"type": "module"` en `package.json`.

```javascript
// sumador.js (CommonJS)
function sumar(a, b) { return a + b; }
module.exports = { sumar };
// main.js (CommonJS)
const { sumar } = require("./sumador");
console.log(sumar(2, 3)); // 5
```

```javascript
// sumador.mjs (ESM)
export function sumar(a, b) { return a + b; }
// main.mjs (ESM)
import { sumar } from "./sumador.mjs";
console.log(sumar(2, 3)); // 5
```

| Aspecto | CommonJS | ESM |
|---|---|---|
| Importar / exportar | `require` / `module.exports` | `import` / `export` |
| Carga | Síncrona | Asíncrona |
| Top-level await | No | Sí |
| Extensión | `.js` (por defecto) | `.mjs` o `"type": "module"` |

El proyecto final MiTienda usa **Node puro con CommonJS**; esta guía mezcla ambos para que domines los dos.

### package.json y npm

`package.json` es el manifiesto del proyecto: metadatos, scripts y dependencias. Se genera con `npm init` (`npm init -y` acepta valores por defecto).

```json
{
  "name": "mi-api",
  "version": "1.0.0",
  "main": "server.js",
  "scripts": {
    "start": "node server.js",
    "dev": "node --watch server.js",
    "test": "node --test"
  },
  "dependencies": { "express": "^4.19.0" }
}
```

- `name`/`version` identifican el paquete; `main` es el archivo de entrada; `scripts` son atajos (`npm start`, `npm run dev`).
- `dependencies` son paquetes de producción; `devDependencies`, solo de desarrollo.

```bash
npm init -y                    # crea package.json
npm install express            # instala y guarda en dependencies
npm ci                         # instala exactamente lo de package-lock.json
```

`npm install` crea **`node_modules/`** (el código de las dependencias; no se versiona en git) y **`package-lock.json`** (versiones exactas; sí se versiona para instalaciones reproducibles).

### El módulo http: un servidor mínimo

`http.createServer(callback)` recibe una función que corre en cada petición con `req` (request) y `res` (response); `server.listen(puerto, callback)` arranca el servidor (el puerto `0` elige uno libre, útil en tests). El servidor mínimo es: `createServer((req, res) => { res.writeHead(200, { "Content-Type": "text/plain; charset=utf-8" }); res.end("¡Hola desde Node!"); }).listen(3000)`.

**Rutas con `if`.** `req.method` es el verbo (`GET`, `POST`, ...) y `req.url` la ruta con la query string; sepárala con `req.url.split("?")[0]`. **Cabeceras y códigos de estado:** `res.writeHead(codigo, cabeceras)` fija ambos a la vez; `res.setHeader(...)` fija una; `res.statusCode = 404` solo el código. Códigos habituales: `200` OK, `201` Creado, `204` Sin contenido, `400` Inválida, `401` No autorizado, `404` No encontrado, `405` No permitido, `500` Error interno.

**Leer el body.** El cuerpo llega como *stream*: se acumula con el evento `data` y se procesa en `end` (solo ocurre cuando llegan todos los datos). Este patrón —leer, parsear, responder— es lo que Express automatiza con `express.json()`.

```javascript
const http = require("node:http");
const server = http.createServer((req, res) => {
  const ruta = req.url.split("?")[0];
  if (req.method === "GET" && ruta === "/") {
    res.writeHead(200, { "Content-Type": "text/plain; charset=utf-8" });
    res.end("Inicio");
    return;
  }
  if (req.method === "GET" && ruta === "/api/hora") {
    res.writeHead(200, { "Content-Type": "application/json" });
    res.end(JSON.stringify({ hora: new Date().toISOString() }));
    return;
  }
  if (req.method === "POST" && ruta === "/api/usuarios") {
    let cuerpo = "";
    req.on("data", (trozo) => { cuerpo += trozo; });
    req.on("end", () => {
      const datos = JSON.parse(cuerpo || "{}"); // envolver en try/catch
      res.writeHead(201, { "Content-Type": "application/json" });
      res.end(JSON.stringify({ id: 1, ...datos }));
    });
    return;
  }
  res.writeHead(404, { "Content-Type": "application/json" });
  res.end(JSON.stringify({ error: "Ruta no encontrada" }));
});

server.listen(3000, () => console.log("Servidor en http://localhost:3000"));
```

### Introducción a Express

Express es el framework web más usado de Node. Encapsula `node:http` y añade routing, middlewares y helpers. **No viene instalado**: hay que instalarlo en cada proyecto.

```bash
npm install express
```

```javascript
const express = require("express");
const app = express();
app.get("/", (req, res) => res.send("¡Hola desde Express!"));
app.get("/api/usuarios", (req, res) => {
  res.json([{ id: 1, nombre: "Ana" }, { id: 2, nombre: "Luis" }]);
});
app.listen(3000, () => console.log("Express en http://localhost:3000"));
```

Diferencias con `http` puro: `app.get("/ruta", handler)` registra un handler por **método y ruta**; `res.json(objeto)` serializa a JSON, fija `Content-Type: application/json` y termina; `res.send(texto)` envía texto; `res.status(codigo)` fija el estado y devuelve la misma `res`, así que encadenas `res.status(404).json({ error: "..." })`.

**Verbos.** `app.get(ruta, handler)`, `app.post`, `app.put`, `app.patch` y `app.delete` registran handlers por método y ruta: `GET` lee, `POST` crea, `PUT` reemplaza, `PATCH` actualiza parcialmente y `DELETE` elimina.

**`req.params`, `req.query` y `req.body`.**

- `req.params` — segmentos de la ruta marcados con `:`. En `/usuarios/42` con ruta `/usuarios/:id`, `req.params.id` vale `"42"` (siempre string).
- `req.query` — objeto de la query string. En `/productos?orden=desc&pagina=2` es `{ orden: "desc", pagina: "2" }`.
- `req.body` — el JSON del cuerpo, **solo si activaste `express.json()`** antes de las rutas; si no, es `undefined`.

```javascript
const app = express();
app.use(express.json());
app.get("/api/usuarios/:id", (req, res) => {
  res.json({ id: Number(req.params.id), limite: req.query.limite ?? 10 });
});
app.post("/api/usuarios", (req, res) => {
  res.status(201).json({ id: 99, ...req.body });
});
```

**Rutas paramétricas.** El `:nombre` captura un segmento (`/pedidos/:id/lineas/:lineaId`). Declara las rutas estáticas **antes** que las paramétricas, o `/usuarios/nuevo` quedaría capturado por `:id`.

### express.Router para modularizar

Un `express.Router()` es como un mini-app: registra rutas y luego se monta bajo un prefijo con `app.use`.

```javascript
// routes/usuarios.js
const express = require("express");
const router = express.Router();
router.get("/", (req, res) => res.json([{ id: 1, nombre: "Ana" }]));
router.get("/:id", (req, res) => res.json({ id: Number(req.params.id) }));
module.exports = router;
```

```javascript
// app.js
const express = require("express");
const app = express();
app.use(express.json());
app.use("/api/usuarios", require("./routes/usuarios")); // monta bajo el prefijo
app.listen(3000, () => console.log("API en http://localhost:3000"));
```

### Middleware

Un **middleware** es una función `(req, res, next)` que corre entre la petición y la respuesta: procesa algo, modifica `req`/`res` o responde, y al final llama **`next()`** para pasar el control. Si no llama `next()` ni responde, la petición se cuelga. **El orden importa:** corren en orden de registro — terceros (logging, parsing) → propios → rutas → 404 → errores.

```javascript
const app = express();
app.use((req, res, next) => {
  console.log(`${req.method} ${req.url} — ${new Date().toISOString()}`);
  next();
});
app.get("/", (req, res) => res.send("Hola"));
```

**Middleware de terceros.** `express.json()` parsea el body a `req.body` y `morgan` (`npm install morgan`) registra cada petición: `app.use(morgan("dev"))` y `app.use(express.json())`.

**Middleware de errores.** Tiene **cuatro parámetros** `(err, req, res, next)` (Express lo reconoce por la aridad) y se registra al final.

```javascript
app.use((req, res) => res.status(404).json({ error: "Ruta no encontrada" }));
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(err.status || 500).json({ error: err.status ? err.message : "Error interno del servidor" });
});
```

**Middleware propio de auth** (patrón de MiTienda): valida el token, guarda la sesión en `req` y llama `next()`; si es inválido responde `401` sin `next()`.

### Servir archivos estáticos

`express.static("carpeta")` sirve archivos (CSS, JS, imágenes) desde un directorio: `app.use(express.static("public"))` expone `public/index.html` en `GET /index.html` (y lo sirve como índice en `/`). Con prefijo: `app.use("/estaticos", express.static("public"))`.

### API REST con Express: estructura y persistencia

Una API REST expone **recursos** (productos, usuarios, pedidos) sobre **verbos HTTP** mapeados a CRUD: `GET` lee, `POST` crea, `PUT` reemplaza, `DELETE` elimina. Los códigos de estado comunican el resultado y las respuestas son JSON con contrato consistente.

**Estructura recomendada:**

```
mi-api/
├── app.js              # crea y exporta el app de Express
├── server.js           # arranca app.js (app.listen)
├── routes/             # rutas que delegan en controllers
│   └── productos.js
├── controllers/        # lógica de negocio (leer/escribir datos)
│   └── productos.js
├── data/               # persistencia en archivo
│   └── productos.json
└── package.json
```

Separar `app.js` (exportable y testable) de `server.js` (solo arranca) es clave. **Persistencia con `node:fs/promises`.** Sin base de datos, los datos viven en un archivo JSON: `fs.readFile` para leer, `fs.writeFile` en cada mutación. `JSON.stringify(datos, null, 2)` escribe JSON legible (lo exige MiTienda). Como todo es asíncrono, los handlers son `async` y delegan errores con `next(e)`.

```javascript
// controllers/productos.js
const fs = require("node:fs/promises");
const path = require("node:path");
const archivo = path.join(__dirname, "..", "data", "productos.json");
async function leer() {
  try {
    return JSON.parse(await fs.readFile(archivo, "utf8"));
  } catch {
    return []; // archivo vacío o inexistente -> lista vacía
  }
}
async function guardar(productos) {
  await fs.writeFile(archivo, JSON.stringify(productos, null, 2));
}
module.exports = { leer, guardar };
```

**Validación de entrada.** Comprueba tipos y rangos **antes** de guardar; si falla, responde `400` con mensaje claro en vez de dejar que un dato inválido truene con `500`.

```javascript
// routes/productos.js
const express = require("express");
const router = express.Router();
const { leer, guardar } = require("../controllers/productos");
const validar = (req) => {
  const { nombre, precio } = req.body || {};
  if (typeof nombre !== "string" || nombre.trim() === "") return "El nombre es obligatorio";
  if (typeof precio !== "number" || precio < 0) return "El precio debe ser un número ≥ 0";
  return null;
};
router.get("/", async (req, res, next) => {
  try { res.json(await leer()); } catch (e) { next(e); }
});
router.get("/:id", async (req, res, next) => {
  try {
    const lista = await leer();
    const producto = lista.find((p) => p.id === Number(req.params.id));
    if (!producto) return res.status(404).json({ error: "Producto no encontrado" });
    res.json(producto);
  } catch (e) { next(e); }
});
router.post("/", async (req, res, next) => {
  try {
    const error = validar(req);
    if (error) return res.status(400).json({ error });
    const lista = await leer();
    const producto = { id: lista.length + 1, nombre: req.body.nombre.trim(), precio: req.body.precio };
    lista.push(producto);
    await guardar(lista);
    res.status(201).json(producto);
  } catch (e) { next(e); }
});
// PUT y DELETE siguen el mismo patrón: buscar por id (404 si no existe),
// validar y reemplazar (PUT) o filtrar y guardar (DELETE -> 204).
module.exports = router;
```

```javascript
// app.js — exporta el app (rutas + 404 + errores); server.js solo lo arranca
const express = require("express");
const app = express();
app.use(express.json());
app.use("/api/productos", require("./routes/productos"));
app.use((req, res) => res.status(404).json({ error: "Ruta no encontrada" }));
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ error: "Error interno del servidor" });
});
module.exports = app;
// server.js
const app = require("./app");
app.listen(process.env.PORT || 3000, () => console.log("API en http://localhost:3000"));
```

Flujo de errores: lo inesperado va a `next(e)` y el middleware central responde `500`; los `400`/`404` de negocio se responden en cada ruta; el `404` de ruta es una respuesta normal al final del app.

### Autenticación básica: tokens HMAC

Patrón clásico: **login** → el servidor entrega un token → el cliente lo envía en cada petición con la cabecera `Authorization: Bearer <token>` → un middleware lo verifica. MiTienda usa tokens firmados con **HMAC-SHA256** de `node:crypto`, sin librerías externas, con formato `payload.firma`:

- `payload` = JSON `{ sub, usuario, exp }` en base64url.
- `firma` = `HMAC-SHA256(payload)` con un secreto solo del servidor.
- `exp` = expiración en ms (MiTienda usa 8 horas).

```javascript
// auth.js
const crypto = require("node:crypto");
const SECRETO = process.env.TOKEN_SECRETO || "secreto-de-desarrollo";
function generarToken(usuario) {
  const payload = Buffer.from(
    JSON.stringify({ sub: usuario.id, usuario: usuario.usuario, exp: Date.now() + 8 * 60 * 60 * 1000 })
  ).toString("base64url");
  const firma = crypto.createHmac("sha256", SECRETO).update(payload).digest("base64url");
  return `${payload}.${firma}`;
}
function verificarToken(token) {
  const [payload, firma] = String(token).split(".");
  if (!payload || !firma) return null;
  const esperada = crypto.createHmac("sha256", SECRETO).update(payload).digest("base64url");
  const a = Buffer.from(firma);
  const b = Buffer.from(esperada);
  if (a.length !== b.length || !crypto.timingSafeEqual(a, b)) return null;
  const datos = JSON.parse(Buffer.from(payload, "base64url").toString("utf8"));
  return datos.exp >= Date.now() ? datos : null;
}
module.exports = { generarToken, verificarToken };
```

**Por qué `timingSafeEqual`.** Comparar con `===` termina en la primera diferencia y el tiempo de respuesta delata cuánto coincidió. `timingSafeEqual` tarda lo mismo siempre; es resistente a *timing attacks* (exigido en MiTienda).

**Middleware que protege rutas:**

```javascript
// middleware/auth.js
const { verificarToken } = require("../auth");
function requiereToken(req, res, next) {
  const cabecera = req.headers.authorization || "";
  const token = cabecera.startsWith("Bearer ") ? cabecera.slice(7) : null;
  const sesion = token ? verificarToken(token) : null;
  if (!sesion) return res.status(401).json({ error: "No autorizado" });
  req.usuario = sesion;
  next();
}
module.exports = requiereToken;
```

**Login y rutas protegidas.** Todo lo que se monte **después** de `app.use(requiereToken)` queda protegido:

```javascript
app.post("/api/auth/login", (req, res) => {
  const { usuario, clave } = req.body || {};
  if (usuario === "admin" && clave === "admin123") {
    return res.json({ token: generarToken({ id: 1, usuario }) });
  }
  res.status(401).json({ error: "Credenciales inválidas" });
});
app.use("/api/productos", requiereToken);
app.use("/api/productos", productosRouter);
```

Error típico: responder sin `return` y seguir ejecutando, o llamar `next()` dos veces.

### Testing de una API Express con node:test

No está instalado `supertest` y MiTienda exige cero dependencias. Node ofrece `node:test` y `node:assert/strict`. Estrategia: `app.js` exporta el app sin arrancarlo; en el test se crea un servidor real con `http.createServer(app)` escuchando en el puerto **0** (efímero), se hace `fetch` a `http://127.0.0.1:<puerto>/...` y se cierra con `t.after`.

```javascript
// test/api.test.js
const { test } = require("node:test");
const assert = require("node:assert/strict");
const http = require("node:http");
const app = require("../app");
async function arrancar(t) {
  const servidor = http.createServer(app);
  await new Promise((resolve) => servidor.listen(0, resolve));
  t.after(() => servidor.close());
  return `http://127.0.0.1:${servidor.address().port}`;
}
test("GET /api/productos devuelve 200 con un array", async (t) => {
  const respuesta = await fetch(`${await arrancar(t)}/api/productos`);
  assert.equal(respuesta.status, 200);
  assert.ok(Array.isArray(await respuesta.json()));
});
test("POST con nombre vacío devuelve 400", async (t) => {
  const respuesta = await fetch(`${await arrancar(t)}/api/productos`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ nombre: "  ", precio: 10 }),
  });
  assert.equal(respuesta.status, 400);
  assert.equal((await respuesta.json()).error, "El nombre es obligatorio");
});
```

Ejecuta con `node --test`. Este es el enfoque de los `tests/` de MiTienda.

**Mocks.** Sustituye piezas lentas o externas y restáuralas con `t.after`: usa un `data/` temporal o una función falsa en vez del controller real; para probar expiración, genera un token con `exp` en el pasado; asigna `process.env.X = "..."` y restáuralo tras el test.

```javascript
test("token manipulado se rechaza", () => {
  const { generarToken, verificarToken } = require("../auth");
  const token = generarToken({ id: 1, usuario: "admin" });
  assert.equal(verificarToken(token + "x"), null);
});
```

### Buenas prácticas

**Variables de entorno con `process.env` y `dotenv`.** Configuración sensible o variable (puerto, secretos, URLs) no va hardcodeada. `dotenv` carga el archivo `.env` en desarrollo (`npm install dotenv`); `.env` no se versiona (añádelo a `.gitignore`); crea un `.env.example` como plantilla.

```javascript
require("dotenv").config(); // carga .env en desarrollo
const puerto = process.env.PORT || 3000;
const secreto = process.env.TOKEN_SECRETO;
```

**CORS y helmet.** En producción el frontend vive en otro origen: `cors` añade las cabeceras CORS; `helmet` fija cabeceras de seguridad. (`npm install cors helmet`)

```javascript
const cors = require("cors");
const helmet = require("helmet");
app.use(helmet());
app.use(cors());
```

**Límites de tamaño.** `express.json({ limit: "100kb" })` rechaza bodies mayores con `413`, protegiendo la memoria del servidor.

**Más buenas prácticas:** formato de error consistente (`{ error: "mensaje" }`); nombres en español y funciones pequeñas con una responsabilidad (lo exige MiTienda); `node --watch server.js` en desarrollo; scripts en `package.json`.

### Despliegue

**`NODE_ENV`.** En `production` Express reduce mensajes de desarrollo y cambia comportamientos: `NODE_ENV=production node server.js`. Léelo con `process.env.NODE_ENV` para ajustar tu código (ej. `if (process.env.NODE_ENV === "production") app.use(helmet());`).

**Servidores de producción.** Lo habitual es un **reverse proxy** (Nginx, Caddy) delante de Node: gestiona TLS/HTTPS, compresión y balanceo, y reenvía al puerto de la app.

**PM2 (opcional).** *Process manager* que reinicia la app si crashea y mantiene logs:

```bash
npm install -g pm2
pm2 start server.js --name mi-api
pm2 save
pm2 logs mi-api
```

**Checklist de despliegue:** `NODE_ENV=production`, secretos en `process.env`, puerto desde `process.env.PORT`, validación de entrada, errores centralizados, helmet + CORS + límites y la suite de tests pasando.

## Ejemplos de código

Ejemplo 1 — API REST Express completa en memoria. Requiere `npm install express` primero; copia a `api.js` y ejecuta `node api.js`.

```bash
curl http://localhost:3000/api/productos
curl -X POST http://localhost:3000/api/productos -H "Content-Type: application/json" -d '{"nombre":"Laptop","precio":999.99}'
```

```javascript
const express = require("express");
const app = express();
app.use(express.json());
let productos = [
  { id: 1, nombre: "Laptop", precio: 999.99 },
  { id: 2, nombre: "Mouse", precio: 25.5 },
];
app.get("/api/productos", (req, res) => res.json(productos));
app.get("/api/productos/:id", (req, res) => {
  const producto = productos.find((p) => p.id === Number(req.params.id));
  if (!producto) return res.status(404).json({ error: "No encontrado" });
  res.json(producto);
});
app.post("/api/productos", (req, res) => {
  const { nombre, precio } = req.body;
  if (!nombre || typeof precio !== "number") {
    return res.status(400).json({ error: "Datos inválidos" });
  }
  const nuevo = { id: productos.length + 1, nombre, precio };
  productos.push(nuevo);
  res.status(201).json(nuevo);
});
app.put("/api/productos/:id", (req, res) => {
  const i = productos.findIndex((p) => p.id === Number(req.params.id));
  if (i === -1) return res.status(404).json({ error: "No encontrado" });
  productos[i] = { id: Number(req.params.id), ...req.body };
  res.json(productos[i]);
});
app.delete("/api/productos/:id", (req, res) => {
  const restante = productos.filter((p) => p.id !== Number(req.params.id));
  if (restante.length === productos.length) return res.status(404).json({ error: "No encontrado" });
  productos = restante;
  res.status(204).end();
});
app.listen(3000, () => console.log("API en http://localhost:3000"));
```

El módulo `auth.js` de la sección de autenticación es ejecutable tal cual: añádele al final `console.log(generarToken({ id: 1, usuario: "admin" }))` para ver un token `payload.firma` en acción.

## Ejercicios relacionados

- [PROYECTO FINAL — API REST de MiTienda](../ejercicios/proyectos/proyecto-final/)
  - [README con la especificación completa](../ejercicios/proyectos/proyecto-final/README.md)
  - [Punto de partida (starter) con TODOs](../ejercicios/proyectos/proyecto-final/starter/)
  - [Suite de tests que debe pasar](../ejercicios/proyectos/proyecto-final/tests/)

## Errores comunes

- **Ejecutar código que usa Express sin instalarlo** → `Cannot find module 'express'`. Ejecuta `npm install express`.
- **Olvidar `express.json()` antes de las rutas** → `req.body` es `undefined` y acceder a `req.body.nombre` lanza `TypeError`.
- **Confundir `req.params` con `req.query`** → el `:id` de la ruta va en `params`; `?clave=valor` va en `query`. Además `req.params.id` es string.
- **Responder dos veces o no llamar `next()`** → la petición se cuelga o Express lanza `Cannot set headers after they are sent`. Responde con `return`.
- **Ruta paramétrica antes que estática** → `/usuarios/nuevo` queda capturado por `:id`. Ordena las estáticas primero.
- **`JSON.parse` sin try/catch en Node puro** → un body malformado rompe con `500`; responde `400`.
- **Validar después de guardar** → un dato inválido termina en disco; valida antes de persistir.
- **Hardcodear secretos o el puerto** → usa `process.env`; en producción un secreto en el código es una brecha.
- **Comparar firmas con `===`** → vulnerable a *timing attacks*; usa `crypto.timingSafeEqual` y comprueba longitudes.
- **`401` vs `403`** → `401` es "no autenticado" (sin token o token inválido); `403` es "autenticado sin permiso". MiTienda usa `401`.
- **Montar el middleware de auth demasiado tarde** → debe ir **antes** de las rutas protegidas.
- **No exportar el app** → no puedes testearlo; `app.js` exporta y `server.js` hace el `listen`.
- **Cuerpos gigantes** → un body enorme agota la memoria; usa `express.json({ limit: "100kb" })`.
- **Sin `t.after(() => servidor.close())` en tests** → el servidor queda escuchando y `node --test` no termina.

## Recursos

- [Node.js — Guía oficial](https://nodejs.org/en/learn)
- [Node.js — Módulo http](https://nodejs.org/api/http.html)
- [Node.js — node:fs/promises](https://nodejs.org/api/fs.html#promises-api)
- [Node.js — node:crypto (HMAC, timingSafeEqual)](https://nodejs.org/api/crypto.html)
- [Node.js — Test runner (node:test)](https://nodejs.org/api/test.html)
- [Express — Routing](https://expressjs.com/en/guide/routing.html)
- [Express — express.json](https://expressjs.com/en/api.html#express.json)
- [npm — package-lock.json](https://docs.npmjs.com/cli/v10/configuring-npm/package-lock-json)
- [Morgan — logger HTTP](https://github.com/expressjs/morgan)
- [Helmet — cabeceras de seguridad](https://helmetjs.github.io/)
- [CORS — middleware de Express](https://github.com/expressjs/cors)
- [dotenv — variables de entorno](https://github.com/motdotla/dotenv)
- [PM2 — Gestor de procesos](https://pm2.keymetrics.io/docs/usage/quick-start/)
- [MDN — Códigos de estado HTTP](https://developer.mozilla.org/es/docs/Web/HTTP/Status)
- [MDN — Cabecera Authorization](https://developer.mozilla.org/es/docs/Web/HTTP/Headers/Authorization)
- [MDN — fetch](https://developer.mozilla.org/es/docs/Web/API/Fetch_API)