# Ejercicio 05 — API REST mínima

- **Nivel:** 5/5
- **Tema:** API con GET/POST en Node puro
- **Tiempo estimado:** 40 min

## Enunciado

Crea un archivo `api.js` que implemente una API REST mínima con `node:http` (sin librerías) que gestione una lista de productos **en memoria**:

- `GET /productos` → `200` con JSON del array de productos.
- `GET /productos/:id` → `200` con el producto o `404` con `{ error: "No encontrado" }`.
- `POST /productos` → lee el body JSON `{ "nombre": "Tablet", "precio": 300 }`, crea el producto con `id` autoincremental, devuelve `201` con el objeto creado.
- Cualquier otra ruta o método → `404` o `405`.

Características:
- El body se lee acumulando `req.on("data", ...)` y `req.on("end", ...)`.
- Valida que el POST tenga `nombre` y `precio`; si falta, responde `400` con `{ error: "Datos inválidos" }`.
- Envía siempre `Content-Type: application/json`.
- Escucha en el puerto `4000`.

Pruebas con curl:

```
$ curl http://localhost:4000/productos
[]
$ curl -X POST http://localhost:4000/productos -H "Content-Type: application/json" -d '{"nombre":"Tablet","precio":300}'
{"id":1,"nombre":"Tablet","precio":300}
$ curl http://localhost:4000/productos
[{"id":1,"nombre":"Tablet","precio":300}]
$ curl http://localhost:4000/productos/1
{"id":1,"nombre":"Tablet","precio":300}
$ curl http://localhost:4000/productos/99
{"error":"No encontrado"}
$ curl -X POST http://localhost:4000/productos -H "Content-Type: application/json" -d '{"nombre":"Solo nombre"}'
{"error":"Datos inválidos"}
```

## Requisitos

- [ ] Manejar `GET` (lista y por id) y `POST` (crear).
- [ ] Leer el body de forma asíncrona con `req.on("data")` / `req.on("end")`.
- [ ] Devolver códigos de estado correctos: 200, 201, 400, 404.
- [ ] Validar los datos del POST.
- [ ] Ejecutarlo localmente con `node api.js` y probarlo con curl.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Extrae el id con `url.pathname.split("/")[2]`.
- Lee el body: `let cuerpo = ""; req.on("data", (chunk) => (cuerpo += chunk)); req.on("end", () => {...})`.
- Convierte con `JSON.parse` dentro de try/catch (un JSON inválido lanzará error).
- Envía JSON con `res.writeHead(codigo, { "Content-Type": "application/json" }); res.end(JSON.stringify(dato))`.
- Al recibir el id, `Number(...)` y compara con `producto.id`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````javascript
const http = require("node:http");

const PUERTO = 4000;
let productos = [];
let siguienteId = 1;

function responder(res, codigo, dato) {
  const cuerpo = JSON.stringify(dato);
  res.writeHead(codigo, {
    "Content-Type": "application/json; charset=utf-8",
    "Content-Length": Buffer.byteLength(cuerpo),
  });
  res.end(cuerpo);
}

function leerBody(req) {
  return new Promise((resolve) => {
    let cuerpo = "";
    req.on("data", (chunk) => (cuerpo += chunk));
    req.on("end", () => {
      try {
        resolve(JSON.parse(cuerpo));
      } catch {
        resolve(null);
      }
    });
  });
}

const servidor = http.createServer(async (req, res) => {
  const url = new URL(req.url, `http://localhost:${PUERTO}`);
  const partes = url.pathname.split("/").filter(Boolean);

  if (partes[0] !== "productos") {
    return responder(res, 404, { error: "No encontrado" });
  }

  if (req.method === "GET" && partes.length === 1) {
    return responder(res, 200, productos);
  }

  if (req.method === "GET" && partes.length === 2) {
    const id = Number(partes[1]);
    const producto = productos.find((p) => p.id === id);
    if (!producto) return responder(res, 404, { error: "No encontrado" });
    return responder(res, 200, producto);
  }

  if (req.method === "POST" && partes.length === 1) {
    const datos = await leerBody(req);
    if (!datos || typeof datos.nombre !== "string" || typeof datos.precio !== "number") {
      return responder(res, 400, { error: "Datos inválidos" });
    }
    const nuevo = { id: siguienteId++, nombre: datos.nombre, precio: datos.precio };
    productos.push(nuevo);
    return responder(res, 201, nuevo);
  }

  responder(res, 405, { error: "Método no permitido" });
});

servidor.listen(PUERTO, () => {
  console.log(`API escuchando en http://localhost:${PUERTO}`);
});
````

</details>