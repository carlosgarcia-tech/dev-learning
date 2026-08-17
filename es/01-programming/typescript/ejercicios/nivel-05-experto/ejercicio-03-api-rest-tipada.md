# Ejercicio 03 — API REST tipada

- **Nivel:** 5/5
- **Tema:** `node:http`, CRUD tipado, parsing de JSON, rutas con parámetros
- **Tiempo estimado:** 60 min

## Enunciado

Crea un archivo `api-rest.ts` que implemente una API REST de usuarios con Node tipado:

1. Defina `interface Usuario { id: number; nombre: string; email: string }` y un `type UsuarioNuevo = Omit<Usuario, "id">`.
2. Implemente `GET /usuarios` → lista completa; `GET /usuarios/:id` → uno (404 si no existe); `POST /usuarios` → crea validando `nombre` y `email` (400 si falta); `DELETE /usuarios/:id` → elimina (404 si no existe).
3. Implemente un helper `leerCuerpo(req): Promise<unknown>` que acumule los chunks y resuelva el JSON parseado.
4. Use un `Record<number, Usuario>` en memoria con un contador de ids.
5. Responda siempre con `application/json`; el 404 usa `{ error: "..." }` y el 400 `{ error: "..." }` con el motivo.

Salida esperada (ejemplo):

```
GET /usuarios -> 200 [ { id: 1, nombre: Ana, email: ana@correo.com } ]
POST /usuarios -> 201 { id: 2, nombre: Luis, email: luis@correo.com }
GET /usuarios/2 -> 200 { id: 2, nombre: Luis }
GET /usuarios/99 -> 404 { error: Usuario no encontrado }
POST /usuarios sin nombre -> 400 { error: nombre es requerido }
```

## Requisitos

- [ ] Implementar los 4 verbos con `switch` sobre `req.method`.
- [ ] Tipar `leerCuerpo` con `Promise<unknown>` y validar con una guard.
- [ ] Parsear el id de la ruta (`/usuarios/:id`) con `match` sobre el pathname.
- [ ] Devolver códigos 200/201/400/404 coherentes.
- [ ] Ejecutarlo localmente con `npx tsc --strict --module NodeNext --moduleResolution NodeNext --outDir dist api-rest.ts`, luego `node dist/api-rest.js` y probar con `curl`.
- [ ] Nota: requiere `@types/node` instalado.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- El cuerpo llega en chunks: `req.on("data", (c: Buffer) => ...)` y `req.on("end", ...)`.
- Guard para validar: `function esNuevo(v: unknown): v is UsuarioNuevo`.
- La ruta con parámetro: `const m = pathname.match(/^\/usuarios\/(\d+)$/);` y `const id = m ? Number(m[1]) : null;`.
- `res.writeHead(201, { "Content-Type": "application/json" }); res.end(JSON.stringify(usuario));`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````typescript
// ejecutar con: npx tsc --strict --module NodeNext --moduleResolution NodeNext --outDir dist api-rest.ts
import { createServer } from "node:http";
import type { IncomingMessage, ServerResponse } from "node:http";

interface Usuario {
  id: number;
  nombre: string;
  email: string;
}

type UsuarioNuevo = Omit<Usuario, "id">;

function responderJson(res: ServerResponse, status: number, datos: unknown): void {
  res.writeHead(status, { "Content-Type": "application/json" });
  res.end(JSON.stringify(datos));
}

function leerCuerpo(req: IncomingMessage): Promise<unknown> {
  return new Promise((resolve, reject) => {
    const chunks: Buffer[] = [];
    req.on("data", (c: Buffer) => chunks.push(c));
    req.on("end", () => {
      try {
        const texto = Buffer.concat(chunks).toString();
        resolve(texto ? JSON.parse(texto) : {});
      } catch (e) {
        reject(new Error("JSON inválido"));
      }
    });
    req.on("error", reject);
  });
}

function esNuevo(valor: unknown): valor is UsuarioNuevo {
  if (typeof valor !== "object" || valor === null) return false;
  const v = valor as Record<string, unknown>;
  return typeof v.nombre === "string" && typeof v.email === "string";
}

const usuarios = new Map<number, Usuario>();
let contador = 0;

const servidor = createServer(async (req: IncomingMessage, res: ServerResponse): Promise<void> => {
  const url = new URL(req.url ?? "/", "http://localhost");
  const pathname = url.pathname;
  const metodo = req.method ?? "GET";

  if (pathname === "/usuarios" && metodo === "GET") {
    responderJson(res, 200, [...usuarios.values()]);
    return;
  }

  const match = pathname.match(/^\/usuarios\/(\d+)$/);
  if (match && metodo === "GET") {
    const usuario = usuarios.get(Number(match[1]));
    if (!usuario) {
      responderJson(res, 404, { error: "Usuario no encontrado" });
      return;
    }
    responderJson(res, 200, usuario);
    return;
  }

  if (pathname === "/usuarios" && metodo === "POST") {
    try {
      const cuerpo: unknown = await leerCuerpo(req);
      if (!esNuevo(cuerpo)) {
        responderJson(res, 400, { error: "nombre y email son requeridos" });
        return;
      }
      contador++;
      const usuario: Usuario = { id: contador, ...cuerpo };
      usuarios.set(usuario.id, usuario);
      responderJson(res, 201, usuario);
    } catch (e) {
      responderJson(res, 400, { error: e instanceof Error ? e.message : "cuerpo inválido" });
    }
    return;
  }

  if (match && metodo === "DELETE") {
    const id = Number(match[1]);
    if (!usuarios.delete(id)) {
      responderJson(res, 404, { error: "Usuario no encontrado" });
      return;
    }
    responderJson(res, 200, { ok: true });
    return;
  }

  responderJson(res, 404, { error: "No encontrado" });
});

servidor.listen(3000, () => {
  console.log("API REST escuchando en http://localhost:3000");
});
````

</details>