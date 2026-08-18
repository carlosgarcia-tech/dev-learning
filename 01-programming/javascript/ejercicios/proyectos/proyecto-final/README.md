# PROYECTO FINAL — API REST de MiTienda

> **Dificultad:** ⭐⭐⭐⭐⭐ (nivel 05, exigente)
> **Tech stack:** Node.js puro, sin librerías externas. `node:http`, `node:fs`, `node:crypto`, `node:test`.
> **Duración estimada:** 12–20 horas repartidas en 4 fases.

---

## 1. Contexto

MiTienda es una tienda pequeña que necesita digitalizar su gestión. Te contratan para construir el **backend completo** de su sistema: una **API REST** en Node.js puro que permita:

- Gestionar un **catálogo de productos** (CRUD completo).
- Registrar **pedidos** de clientes, descontando stock automáticamente.
- Consultar **reportes** de inventario y de ventas.
- **Persistir todos los datos en un archivo JSON** (sin bases de datos externas).
- **Autenticar a los usuarios** con tokens firmados (HMAC con `node:crypto`).

La API se consumirá desde un futuro frontend, así que el contrato de respuestas (códigos de estado y JSON) debe ser consistente y estar documentado.

**Regla de oro:** **cero dependencias.** Solo se permiten módulos nativos de Node. Todo el código debe funcionar con `node server.js`.

---

## 2. Requisitos funcionales

### 2.1 Autenticación (módulo `auth.js`)

- `POST /api/auth/login` con body `{ "usuario": "admin", "clave": "admin123" }`.
  - Credenciales correctas → `200` con `{ "token": "<token>", "usuario": { id, usuario } }`.
  - Credenciales incorrectas → `401` con `{ "error": "Credenciales inválidas" }`.
- El token se construye como `payload.firma`:
  - `payload = base64url(JSON.stringify({ sub, usuario, exp }))`.
  - `firma = HMAC-SHA256(payload)` usando `crypto.createHmac("sha256", secreto)`.
  - `exp` = `Date.now() + expiracionTokenMs` (8 h por defecto).
- Todas las rutas **excepto** `POST /api/auth/login` requieren el header `Authorization: Bearer <token>`.
  - Sin token, token malformado, firma inválida o token expirado → `401` con `{ "error": "No autorizado" }`.
- La verificación debe usar `crypto.timingSafeEqual` para comparar firmas (resistente a timing attacks).

### 2.2 Productos (CRUD + filtros + paginación)

- `GET /api/productos` → lista paginada:
  - Devuelve `{ "total", "pagina", "limite", "productos": [...] }`.
  - Query params: `buscar` (coincidencia en nombre, sin distinguir mayúsculas), `minPrecio`, `maxPrecio`, `orden` (`asc`|`desc` por precio, por defecto `asc`), `pagina` (≥ 1), `limite` (≥ 1, por defecto 10).
- `GET /api/productos/:id` → `200` con el producto o `404` `{ "error": "Producto no encontrado" }`.
- `POST /api/productos` → `201` con el producto creado (id autoincremental). Validaciones:
  - `nombre`: string no vacío (tras `trim`).
  - `precio`: número ≥ 0.
  - `stock`: entero ≥ 0.
  - Si falla → `400` con el mensaje de error correspondiente.
- `PUT /api/productos/:id` → `200` con el producto actualizado; `404` si no existe; `400` si la validación falla.
- `DELETE /api/productos/:id` → `204` sin body; `404` si no existe.
- Cualquier método no soportado → `405` `{ "error": "Método no permitido" }`.

### 2.3 Pedidos

- `POST /api/pedidos` con body:
  ```json
  {
    "cliente": "Ana",
    "productos": [{ "id": 1, "cantidad": 2 }]
  }
  ```
  - Validaciones → `400`:
    - `cliente` obligatorio (string no vacío).
    - `productos` debe ser un array no vacío.
    - Cada línea debe tener `id` numérico y `cantidad` entera > 0.
    - El producto debe existir (`Producto <id> no existe`).
    - Debe haber stock suficiente (`Stock insuficiente de <nombre>`).
  - Al crear:
    - **Descuenta el stock** de cada producto.
    - Calcula `lineas[]` con `{ productoId, nombre, cantidad, precioUnitario, subtotal }`.
    - Calcula `total` redondeado a 2 decimales.
    - Fija `estado: "recibido"` y `fecha` ISO (`new Date().toISOString()`).
  - Responde `201` con el pedido completo.
- `GET /api/pedidos` → `{ "total", "pagina", "limite", "pedidos": [...] }` con filtro opcional `?estado=`.
- `GET /api/pedidos/:id` → `200` o `404` `{ "error": "Pedido no encontrado" }`.

### 2.4 Reportes

- `GET /api/reportes/inventario` → `200` con:
  ```json
  {
    "totalProductos": 3,
    "unidadesTotales": 8,
    "valorInventario": 400,
    "productosSinStock": 1,
    "bajoStock": 2
  }
  ```
  (`bajoStock` = stock entre 1 y 5.)
- `GET /api/reportes/ventas` → `200` con:
  ```json
  {
    "totalPedidos": 2,
    "ingresosTotales": 350,
    "pedidosPorEstado": { "recibido": 2 }
  }
  ```
- Reporte inexistente → `404`; método no GET → `405`.

### 2.5 Rutas genéricas

- Ruta que no empiece por `/api` → `404` `{ "error": "Ruta no encontrada" }`.
- Body JSON inválido en cualquier POST/PUT → `400` (se debe devolver `{ "error": "Datos inválidos" }` o el mensaje de validación correspondiente).
- Todas las respuestas con body usan `Content-Type: application/json; charset=utf-8` y `Content-Length`.

---

## 3. Requisitos no funcionales

- **Cero dependencias**: solo módulos nativos (`node:http`, `node:fs`, `node:path`, `node:crypto`, `node:test`).
- **Persistencia real**: cada mutación escribe en el archivo JSON de forma síncrona y legible (`JSON.stringify(datos, null, 2)`).
- **Código modular y organizado**: separar `db`, `auth`, `server` y handlers.
- **Asincronía**: lectura del body y ciclo de vida del servidor con promesas/async-await.
- **Manejo de errores**: validaciones explícitas, códigos de estado correctos y mensajes de error en español y consistentes.
- **Seguridad**: firma HMAC verificada con `timingSafeEqual`; nunca devolver el secreto; tokens con expiración.
- **Estructura limpia**: nombres en español, funciones pequeñas y con responsabilidad única.
- **Testeable**: `server.js` debe exponer `crearServidor(config)` para poder levantar el servidor en un puerto efímero (0) durante los tests.
- **Documentación**: este README + comentarios breves en el código donde aporten valor.

---

## 4. Fases de implementación

### Fase 1 — Base y persistencia (`db.js` + `server.js`)

- [ ] Implementar `crearDb(archivo, datosIniciales)` que crea el archivo si no existe, lo carga y expone `productos()`, `pedidos()`, `usuarios()`, `guardar()` y `siguienteId(lista)`.
- [ ] Implementar `responder(res, codigo, dato)` y `leerBody(req)` en `server.js`.
- [ ] Implementar `crearServidor(config)` con el router `/api` y la respuesta 404 para rutas no-API.
- [ ] Arrancar con `node server.js` en el puerto 3000.

### Fase 2 — Autenticación (`auth.js` + `handlers/auth.js`)

- [ ] Implementar `generarToken` y `verificarToken` con `node:crypto`.
- [ ] Implementar `POST /api/auth/login`.
- [ ] Aplicar el middleware de token a todas las rutas excepto login (401 si es inválido).

### Fase 3 — Productos, pedidos y reportes (handlers)

- [ ] CRUD completo de productos con validaciones, búsqueda, filtros, orden y paginación.
- [ ] Creación de pedidos con descuento de stock y cálculo de totales; listado y detalle.
- [ ] Reportes de inventario y ventas.

### Fase 4 — Tests y pulido

- [ ] Que **todos** los tests de `tests/` pasen con `node --test`.
- [ ] Revisar códigos de estado, `Content-Type`, persistencia y manejo de errores.
- [ ] Probar manualmente con `curl` todos los endpoints.

---

## 5. Criterios de aceptación

> La suite de tests está en `tests/` y debe ejecutarse con `node --test tests/` (o `node --test` desde `proyecto-final/`). Debe pasar el 100% de las aserciones cuando el proyecto esté completo.

- [ ] 1. `POST /api/auth/login` con credenciales válidas devuelve `200` y un token con formato `payload.firma`.
- [ ] 2. `POST /api/auth/login` con clave incorrecta devuelve `401`.
- [ ] 3. `POST /api/auth/login` con usuario inexistente devuelve `401`.
- [ ] 4. `POST /api/auth/login` con body inválido devuelve `401`.
- [ ] 5. Acceso a un recurso protegido **sin** token devuelve `401`.
- [ ] 6. Acceso con un token **manipulado** devuelve `401` (la firma no debe validar).
- [ ] 7. Acceso con un token **expirado** devuelve `401`.
- [ ] 8. El token expira: la expiración se comprueba frente a `Date.now()`.
- [ ] 9. `POST /api/productos` con datos válidos devuelve `201` con el producto y un `id` autoincremental.
- [ ] 10. `POST /api/productos` sin `nombre` devuelve `400`.
- [ ] 11. `POST /api/productos` con `precio` negativo devuelve `400`.
- [ ] 12. `POST /api/productos` con `stock` no entero devuelve `400`.
- [ ] 13. `POST /api/productos` con JSON inválido devuelve `400`.
- [ ] 14. `GET /api/productos` devuelve `200` con `{ total, pagina, limite, productos }`.
- [ ] 15. `GET /api/productos/:id` devuelve `200` con el producto.
- [ ] 16. `GET /api/productos/999` devuelve `404`.
- [ ] 17. `PUT /api/productos/:id` actualiza y devuelve `200`.
- [ ] 18. `PUT /api/productos/:id` con datos inválidos devuelve `400`.
- [ ] 19. `PUT` sobre un producto inexistente devuelve `404`.
- [ ] 20. `DELETE /api/productos/:id` devuelve `204` y el producto deja de aparecer.
- [ ] 21. `DELETE` de un producto inexistente devuelve `404`.
- [ ] 22. `GET /api/productos?buscar=laptop` filtra por nombre (sin distinguir mayúsculas).
- [ ] 23. `GET /api/productos?minPrecio=40&maxPrecio=100` filtra por rango de precio.
- [ ] 24. `GET /api/productos?orden=desc` ordena de mayor a menor precio.
- [ ] 25. `GET /api/productos?pagina=2&limite=2` devuelve solo la página pedida manteniendo `total`.
- [ ] 26. `POST /api/pedidos` válido devuelve `201`, calcula el `total` y registra las `lineas`.
- [ ] 27. Crear un pedido **descuenta el stock** de los productos.
- [ ] 28. `POST /api/pedidos` con stock insuficiente devuelve `400` con mensaje `Stock insuficiente`.
- [ ] 29. `POST /api/pedidos` con un producto inexistente devuelve `400`.
- [ ] 30. `POST /api/pedidos` con array de `productos` vacío devuelve `400`.
- [ ] 31. `POST /api/pedidos` con `cantidad` inválida devuelve `400`.
- [ ] 32. `POST /api/pedidos` sin `cliente` devuelve `400`.
- [ ] 33. `GET /api/pedidos` devuelve `200` con `{ total, pagina, limite, pedidos }`.
- [ ] 34. `GET /api/pedidos/:id` devuelve `200` con el pedido.
- [ ] 35. `GET /api/pedidos/999` devuelve `404`.
- [ ] 36. `GET /api/pedidos?estado=recibido` filtra por estado.
- [ ] 37. `GET /api/reportes/inventario` devuelve `200` con los totales correctos (ceros sin datos).
- [ ] 38. `GET /api/reportes/inventario` refleja productos, unidades, valor y sin stock.
- [ ] 39. `GET /api/reportes/ventas` devuelve `200` con ceros sin pedidos.
- [ ] 40. `GET /api/reportes/ventas` acumula pedidos, ingresos y el desglose por estado.
- [ ] 41. Un reporte inexistente devuelve `404`.
- [ ] 42. Un método no soportado en recursos devuelve `405`.
- [ ] 43. Una ruta que no empieza por `/api` devuelve `404`.
- [ ] 44. Todas las mutaciones persisten en el archivo JSON (re-iniciar el servidor conserva los datos).
- [ ] 45. Cero dependencias externas: `package.json` sin `dependencies` (o ausente) y solo módulos `node:`.

---

## 6. Rúbrica de evaluación

| Área | Puntos | Descripción |
|---|---|---|
| **Autenticación** | 20 | Login correcto, token bien formado, rechazo de tokens inválidos/ manipulados/expirados, uso de `timingSafeEqual`. |
| **CRUD de productos** | 20 | Endpoints completos, validaciones, códigos de estado correctos (200/201/204/400/404/405). |
| **Filtros y paginación** | 10 | `buscar`, `minPrecio`, `maxPrecio`, `orden` y paginación funcionando y sin romper `total`. |
| **Pedidos** | 20 | Validaciones, descuento de stock, cálculo de totales/líneas, listado, detalle y filtro por estado. |
| **Reportes** | 10 | Inventario y ventas correctos y consistentes con los datos. |
| **Persistencia** | 10 | Escritura del JSON en cada mutación; carga al arrancar; datos legibles. |
| **Tests** | 10 | `node --test` pasa el 100% de la suite de `tests/`. |

**Nota:** pasa de fase solo cuando la anterior cumple todos sus criterios. Un proyecto que solo funciona con `curl` pero no pasa los tests de `tests/` se considera incompleto.

---

## 7. Estructura de la solución

```
proyecto-final/
├── README.md            # esta especificación
├── starter/             # punto de partida con TODOs
│   ├── config.js        # puerto, secreto, datos iniciales
│   ├── db.js            # persistencia JSON (TODO)
│   ├── auth.js          # tokens HMAC con node:crypto (TODO)
│   ├── server.js        # servidor http + router + middleware (TODO)
│   ├── handlers/
│   │   ├── auth.js      # login (TODO)
│   │   ├── productos.js # CRUD + filtros (TODO)
│   │   ├── pedidos.js   # creación y consulta (TODO)
│   │   └── reportes.js  # inventario y ventas (TODO)
│   └── data/
│       └── database.json
└── tests/               # suite que solo pasa con el proyecto completo
    ├── helpers.js
    ├── auth.test.js
    ├── productos.test.js
    ├── pedidos.test.js
    └── reportes.test.js
```

## 8. Cómo ejecutar

```bash
# Arrancar el servidor (desde starter/)
node server.js

# Ejecutar los tests (desde proyecto-final/)
node --test
```

## 9. Referencia de implementación

Existe una **implementación de referencia** (solución completa y testeada) que se generó para validar la suite. Su código vive fuera del repositorio en `/tmp/opencode/referencia-proyecto-final/` (solo como referencia durante la corrección; **no es la entrega**). La entrega esperada es el `starter/` completado con los TODOs.
