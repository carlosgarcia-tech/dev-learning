# Proyectos integradores

Proyectos completos para poner en práctica todo lo aprendido en los 5 niveles. Cada proyecto tiene **requisitos por fases**: completa una fase antes de pasar a la siguiente. Están ordenados de menor a mayor complejidad.

---

## Proyecto 1 — Gestor de tareas CLI

**Dificultad:** ⭐⭐ (nivel 02-03)

Una aplicación de consola que gestiona tareas persistidas en `tareas.json`, con subcomandos, validación y reportes.

### Fase 1 — CRUD básico

- [ ] Comandos `agregar "descripción"`, `listar`, `completar <id>` y `eliminar <id>` con `argparse`.
- [ ] Persistir en `tareas.json` con `json.dump` / `json.load`.
- [ ] Cada tarea: `{ id, descripcion, estado, creada }` donde `creada` es una fecha ISO.

### Fase 2 — Validación y filtros

- [ ] Rechazar descripciones vacías con `parser.error`.
- [ ] Comando `pendientes` que liste solo las no completadas.
- [ ] Comando `buscar <texto>` que filtre por descripción (insensible a mayúsculas).
- [ ] No permitir `completar`/`eliminar` un id inexistente.

### Fase 3 — Reportes

- [ ] Comando `resumen` que muestre totales: pendientes, completadas y porcentaje.
- [ ] Comando `exportar` que genere `reporte.txt` con el resumen formateado.
- [ ] Refactorizar a módulos: `modelo.py` (CRUD) y `cli.py` (interfaz).

---

## Proyecto 2 — API REST con archivo

**Dificultad:** ⭐⭐⭐⭐ (nivel 04-05)

Una API REST en Python puro (`http.server`) para gestionar usuarios, con datos persistidos en un archivo JSON.

### Fase 1 — CRUD de usuarios

- [ ] `GET /usuarios` → lista todos.
- [ ] `GET /usuarios/<id>` → uno por id (404 si no existe).
- [ ] `POST /usuarios` → crea uno validando `nombre` y `email`.
- [ ] `PUT /usuarios/<id>` → actualiza campos.
- [ ] `DELETE /usuarios/<id>` → elimina (204 sin cuerpo).

### Fase 2 — Persistencia y validación

- [ ] Leer/escribir `usuarios.json` al arrancar y en cada mutación.
- [ ] Validar que el `email` contenga `@` y que no esté duplicado.
- [ ] Responder `400` con `{"error": "..."}` cuando la validación falle.

### Fase 3 — Búsqueda y filtros

- [ ] `GET /usuarios?buscar=<texto>` filtra por nombre o email.
- [ ] Ordenar resultados con `?orden=asc|desc`.
- [ ] Añadir paginación `?pagina=1&limite=10` con `parse_qs`.

---

## Proyecto 3 — Automatización con asyncio

**Dificultad:** ⭐⭐⭐⭐⭐ (nivel 05)

Una herramienta que descarga de forma **concurrente** un conjunto de URLs con `aiohttp`, guarda los contenidos en disco y genera un reporte. Si no tienes internet, puedes simular las descargas con `asyncio.sleep` y datos locales.

### Fase 1 — Descargas concurrentes

- [ ] Función `descargar(url)` que use `aiohttp.ClientSession` y devuelva el status y la longitud del cuerpo.
- [ ] Ejecutar N descargas con `asyncio.gather` + `asyncio.create_task`.
- [ ] Medir el tiempo total y mostrar el ahorro frente a una versión secuencial.

### Fase 2 — Límites y manejo de errores

- [ ] Limitar la concurrencia con `asyncio.Semaphore`.
- [ ] Reintentos (2 intentos) con `asyncio.sleep` entre ellos.
- [ ] Capturar errores de red por URL y registrarlos en una lista de fallos.
- [ ] Timeout por petición con `asyncio.timeout`.

### Fase 3 — Persistencia y reporte

- [ ] Guardar cada respuesta en `descargas/<slug>.txt` con `aiofiles` o `open` estándar.
- [ ] Generar `reporte.json` con resumen: total, éxitos, fallos, bytes descargados y tiempo.
- [ ] Añadir un argumento `--urls archivo.txt` con `argparse` para leer la lista de URLs.

---

## Consejos

- Ejecuta y prueba cada fase antes de continuar.
- Usa `python3 -m py_compile` para detectar errores de sintaxis y `python3 archivo.py` para probar.
- Para el servidor HTTP, usa `curl` o `httpie` para probar los endpoints.
- Vuelve a las [guías](../) o a los ejercicios del nivel correspondiente si algo se te atasca.