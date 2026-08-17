# Ejercicio 02 — Servidor HTTP

- **Nivel:** 5/5
- **Tema:** Servidor con node:http
- **Tiempo estimado:** 35 min

## Enunciado

Crea un archivo `servidor.js` que levante un servidor HTTP con el módulo `node:http` en el puerto `3000` que responda según la URL:

- `GET /` → texto `"Bienvenido al servidor de Node.js"`.
- `GET /hora` → la fecha/hora actual en formato ISO (usa `new Date().toISOString()`).
- `GET /saludo?nombre=Ana` → `"Hola, Ana!"` (lee el query string con `URL`).
- `GET /productos` → un JSON con un array de productos.
- cualquier otra ruta → código `404` con texto `"No encontrado"`.

El servidor debe:
- Configurar el `Content-Type` adecuado (`text/plain; charset=utf-8` para texto y `application/json; charset=utf-8` para JSON).
- Escribir el `Content-Length` con `Buffer.byteLength`.
- Establecer el código de estado correcto (200 o 404).
- Imprimir `"Servidor escuchando en http://localhost:3000"` al arrancar.

Pruebas con curl:

```
$ curl http://localhost:3000/
Bienvenido al servidor de Node.js
$ curl http://localhost:3000/saludo?nombre=Ana
Hola, Ana!
$ curl http://localhost:3000/productos
[{"nombre":"Laptop","precio":800},{"nombre":"Mouse","precio":20}]
$ curl http://localhost:3000/otra
No encontrado
```

## Requisitos

- [ ] Usar `http.createServer` y `server.listen(3000)`.
- [ ] Responder según la ruta con `req.url`.
- [ ] Leer el query string con la clase global `URL`.
- [ ] Enviar `Content-Type`, `Content-Length` y códigos 200/404 correctos.
- [ ] Ejecutarlo localmente con `node servidor.js` y probarlo con curl.
- [ ] Los tests pasan: `node --test ejercicio-02-servidor-http.test.js`.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `const url = new URL(req.url, "http://localhost");` te da `url.pathname` y `url.searchParams.get("nombre")`.
- `res.writeHead(200, { "Content-Type": "text/plain; charset=utf-8" })`.
- `res.end(Buffer.from(texto))` o usa `Content-Length` con `Buffer.byteLength(texto)`.
- Para finalizar el servidor en pruebas: `Ctrl+C`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````javascript
const http = require("node:http");

const PUERTO = 3000;
const productos = [
  { nombre: "Laptop", precio: 800 },
  { nombre: "Mouse", precio: 20 },
];

function responder(res, codigo, tipo, cuerpo) {
  res.writeHead(codigo, {
    "Content-Type": `${tipo}; charset=utf-8`,
    "Content-Length": Buffer.byteLength(cuerpo),
  });
  res.end(cuerpo);
}

function crearServidor() {
  return http.createServer((req, res) => {
    const url = new URL(req.url, `http://localhost:${PUERTO}`);
    const ruta = url.pathname;

    if (ruta === "/") {
      responder(res, 200, "text/plain", "Bienvenido al servidor de Node.js");
    } else if (ruta === "/hora") {
      responder(res, 200, "text/plain", new Date().toISOString());
    } else if (ruta === "/saludo") {
      const nombre = url.searchParams.get("nombre") || "mundo";
      responder(res, 200, "text/plain", `Hola, ${nombre}!`);
    } else if (ruta === "/productos") {
      responder(res, 200, "application/json", JSON.stringify(productos));
    } else {
      responder(res, 404, "text/plain", "No encontrado");
    }
  });
}

if (require.main === module) {
  crearServidor().listen(PUERTO, () => {
    console.log(`Servidor escuchando en http://localhost:${PUERTO}`);
  });
}

module.exports = { crearServidor, responder, PUERTO, productos };
````

</details>