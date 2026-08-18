# Proyectos integradores

Proyectos completos para poner en práctica todo lo aprendido en los 5 niveles. Están ordenados de menor a mayor complejidad y cada uno tiene **requisitos por fases**: completa una fase antes de pasar a la siguiente.

| # | Proyecto | Dificultad | Conceptos |
|---|---|---|---|
| 1 | App CLI de gestión de inventario | ⭐⭐ | CLI, `node:fs`, JSON, validaciones |
| 2 | API REST con archivo | ⭐⭐⭐⭐ | `node:http`, CRUD, JSON, validaciones |
| 3 | **[PROYECTO FINAL — API REST de MiTienda](proyecto-final/)** | ⭐⭐⭐⭐⭐ | REST, persistencia, auth HMAC, validaciones, asincronía, reportes, tests |

---

## Proyecto 1 — App CLI de gestión de inventario

**Dificultad:** ⭐⭐ (nivel 02-03)

Una aplicación de consola que gestiona un inventario de productos persistido en `inventario.json`.

### Fase 1 — CRUD básico

- [ ] Comandos `agregar`, `listar`, `eliminar` y `buscar <texto>`.
- [ ] Persistir en `inventario.json` con `node:fs`.
- [ ] Cada producto: `{ id, nombre, cantidad, precio }`.

### Fase 2 — Validación y contabilidad

- [ ] No permitir cantidades o precios negativos (usa `throw` + try/catch).
- [ ] Comando `resumen` que muestre total de productos, unidades y valor del inventario.
- [ ] Comando `ajustar <id> <cantidad>` para sumar/restar stock.

### Fase 3 — Reportes

- [ ] Comando `bajo_stock <minimo>` que liste productos con cantidad menor al mínimo.
- [ ] Comando `exportar` que genere un segundo archivo `reporte.txt` con el resumen formateado.

---

## Proyecto 2 — API REST con archivo

**Dificultad:** ⭐⭐⭐⭐ (nivel 04-05)

Una API REST en Node puro (`node:http`) para gestionar usuarios, con datos persistidos en un archivo JSON.

### Fase 1 — CRUD de usuarios

- [ ] `GET /usuarios` → lista todos.
- [ ] `GET /usuarios/:id` → uno por id (404 si no existe).
- [ ] `POST /usuarios` → crea uno validando `nombre` y `email`.
- [ ] `PUT /usuarios/:id` → actualiza campos.
- [ ] `DELETE /usuarios/:id` → elimina.

### Fase 2 — Persistencia y validación

- [ ] Leer/escribir `usuarios.json` al arrancar y en cada mutación.
- [ ] Validar que el `email` contenga `@` y que no esté duplicado.
- [ ] Responder `400` con `{ error: "..." }` cuando la validación falle.

### Fase 3 — Búsqueda y filtros

- [ ] `GET /usuarios?buscar=<texto>` filtra por nombre o email.
- [ ] Ordenar resultados con `?orden=asc|desc`.
- [ ] Añadir paginación `?pagina=1&limite=10`.

---

## Proyecto 3 — PROYECTO FINAL: API REST de MiTienda

**Dificultad:** ⭐⭐⭐⭐⭐ (nivel 05, exigente)

El proyecto que cierra la ruta: una **API REST completa en Node.js puro** para gestionar el catálogo, los pedidos y los reportes de una tienda. Integra **todo** lo aprendido:

- **REST en Node puro** (`node:http`) con códigos de estado correctos y JSON consistente.
- **Persistencia real en JSON** (`node:fs`) cargada al arrancar y guardada en cada mutación.
- **Autenticación básica con tokens HMAC** (`node:crypto`, `timingSafeEqual`).
- **Validaciones** exhaustivas en productos y pedidos.
- **Asincronía** (lectura de body, ciclo de vida del servidor).
- **Reportes** de inventario y ventas.
- **Suite de tests** con `node:test` que solo pasa cuando el proyecto está completo.

### Requisitos clave

- `POST /api/auth/login` emite un token `payload.firma` (HMAC-SHA256); el resto de rutas exigen `Authorization: Bearer <token>` (401 si es inválido/expirado).
- CRUD de `/api/productos` con búsqueda, filtros de precio, orden y paginación.
- `/api/pedidos` que valida stock, lo descuenta y calcula totales.
- `/api/reportes/inventario` y `/api/reportes/ventas`.
- **Cero dependencias**: solo módulos `node:`.

### Entrega

- **Especificación completa** (contexto, requisitos funcionales/no funcionales, fases, **45 criterios de aceptación**, rúbrica): [`proyecto-final/README.md`](proyecto-final/README.md).
- **Punto de partida con TODOs**: [`proyecto-final/starter/`](proyecto-final/starter/).
- **Suite de tests** que debe pasar el 100%: [`proyecto-final/tests/`](proyecto-final/tests/).

```bash
cd proyecto-final
node --test        # debe pasar el 100% cuando el proyecto esté completo
```

---

## Consejos

- Ejecuta y prueba cada fase antes de continuar.
- Usa `node --watch` (Node 18+) para recargar automáticamente durante el desarrollo.
- Vuelve a las [guías](../../../) o a los ejercicios del nivel correspondiente si algo se te atasca.
- En el proyecto final, implementa en este orden: `db.js` → `server.js` → `auth.js` → handlers → tests.