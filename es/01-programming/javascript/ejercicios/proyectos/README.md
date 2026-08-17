# Proyectos integradores

Proyectos completos para poner en práctica todo lo aprendido en los 5 niveles. Cada proyecto tiene **requisitos por fases**: completa una fase antes de pasar a la siguiente. Están ordenados de menor a mayor complejidad.

---

## Proyecto 1 — App CLI de gestión de inventario

**Dificultad:** ⭐⭐ (nivel 02-03)

Una aplicación de consola que gestiona un inventario de productos persistido en `inventario.json`, similar al ejercicio de tareas CLI pero con más funcionalidad.

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

## Proyecto 3 — App full-stack simulada

**Dificultad:** ⭐⭐⭐⭐⭐ (nivel 05)

Una mini aplicación de tareas (todo list) donde un **servidor HTTP** sirve tanto el frontend (HTML + JS del navegador) como la API. Todo con Node puro, sin librerías.

### Fase 1 — Servidor con frontend

- [ ] `GET /` sirve una página HTML con un formulario y una lista.
- [ ] `GET /app.js` sirve el JavaScript del navegador.
- [ ] La página se carga y muestra las tareas existentes.

### Fase 2 — API de tareas

- [ ] `GET /tareas` → lista de tareas (en memoria).
- [ ] `POST /tareas` → crea una tarea desde el formulario.
- [ ] `PUT /tareas/:id/toggle` → marca completada/no completada.
- [ ] El frontend usa `fetch` y actualiza la lista sin recargar.

### Fase 3 — Persistencia y pulido

- [ ] Guardar las tareas en `tareas.json`.
- [ ] Manejar errores de red en el frontend con `.catch`.
- [ ] Estilos CSS básicos para la interfaz.

---

## Consejos

- Ejecuta y prueba cada fase antes de continuar.
- Usa `node --watch` (Node 18+) para recargar automáticamente durante el desarrollo.
- Vuelve a las [guías](../) o a los ejercicios del nivel correspondiente si algo se te atasca.