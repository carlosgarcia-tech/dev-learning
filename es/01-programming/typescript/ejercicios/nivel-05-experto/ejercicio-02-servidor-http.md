# Ejercicio 02 — Servidor HTTP

- **Nivel:** 5/5
- **Tema:** `node:http`, `IncomingMessage`/`ServerResponse`, rutas tipadas
- **Tiempo estimado:** 45 min

## Enunciado

Crea un archivo `servidor-http.ts` que implemente un servidor HTTP mínimo con Node tipado:

1. Importe `createServer` e `IncomingMessage`/`ServerResponse` desde `node:http`.
2. Defina `interface Respuesta { ruta: string; metodo: string }` y un mapa `Record<string, (req, res) => void>` de manejadores tipados por ruta.
3. Implemente manejadores para:
   - `GET /` → responde `"Bienvenido al servidor TS"` (200).
   - `GET /saludar?nombre=Ana` → responde `"Hola, Ana"` (usa `new URL(req.url, base)` y `searchParams`).
   - Cualquier otra ruta → 404 con `{ error: "No encontrado" }`.
4. El servidor escuche en el puerto `3000` y responda con `Content-Type: application/json` o `text/plain` según corresponda.
5. Imprima en consola la ruta y el método de cada petición.

Salida esperada (ejemplo):

```
Servidor escuchando en http://localhost:3000
Peticion GET /
Peticion GET /saludar?nombre=Ana
```

## Requisitos

- [ ] Importar tipos de `node:http` (`IncomingMessage`, `ServerResponse`).
- [ ] Tipar `req` y `res` en los manejadores.
- [ ] Usar `URL` y `searchParams` para leer el query string.
- [ ] Responder 404 para rutas no manejadas.
- [ ] Ejecutarlo localmente con `npx tsc --strict --module NodeNext --moduleResolution NodeNext --outDir dist servidor-http.ts`, luego `node dist/servidor-http.js` y probar con `curl http://localhost:3000/`.
- [ ] Nota: requiere `@types/node` instalado.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `createServer((req: IncomingMessage, res: ServerResponse) => void)`.
- `new URL(req.url ?? "/", "http://localhost")` da acceso a `.pathname` y `.searchParams`.
- Responde con `res.writeHead(200, { "Content-Type": "text/plain" }); res.end("...");`.
- El 404: `res.writeHead(404, { "Content-Type": "application/json" }); res.end(JSON.stringify({ error: "No encontrado" }));`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````typescript
// ejecutar con: npx tsc --strict --module NodeNext --moduleResolution NodeNext --outDir dist servidor-http.ts
import { createServer } from "node:http";
import type { IncomingMessage, ServerResponse } from "node:http";

type Manejador = (req: IncomingMessage, res: ServerResponse) => void;

function responderTexto(res: ServerResponse, status: number, texto: string): void {
  res.writeHead(status, { "Content-Type": "text/plain" });
  res.end(texto);
}

function responderJson(res: ServerResponse, status: number, datos: unknown): void {
  res.writeHead(status, { "Content-Type": "application/json" });
  res.end(JSON.stringify(datos));
}

const manejadores: Record<string, Manejador> = {
  "/": (_req, res) => responderTexto(res, 200, "Bienvenido al servidor TS"),
  "/saludar": (req, res) => {
    const url = new URL(req.url ?? "/", "http://localhost");
    const nombre = url.searchParams.get("nombre") ?? "mundo";
    responderTexto(res, 200, `Hola, ${nombre}`);
  },
};

const servidor = createServer((req: IncomingMessage, res: ServerResponse): void => {
  const url = new URL(req.url ?? "/", "http://localhost");
  const ruta = url.pathname;
  const metodo = req.method ?? "GET";
  console.log(`Peticion ${metodo} ${ruta}`);

  const manejador = manejadores[ruta];
  if (manejador) {
    manejador(req, res);
  } else {
    responderJson(res, 404, { error: "No encontrado" });
  }
});

servidor.listen(3000, () => {
  console.log("Servidor escuchando en http://localhost:3000");
});
````

</details>