# Proyectos integradores

Proyectos completos para poner en práctica todo lo aprendido en los 5 niveles. Cada proyecto tiene **requisitos por fases**: completa una fase antes de pasar a la siguiente. Están ordenados de menor a mayor complejidad.

Todos los proyectos usan únicamente la **biblioteca estándar de Go** (`fmt`, `encoding/json`, `net/http`, `os`).

---

## Proyecto 1 — App CLI de gestión de inventario

**Dificultad:** ⭐⭐ (nivel 02-03)

Una aplicación de consola que gestiona un inventario de productos persistido en `inventario.json`, similar al ejercicio de tareas CLI pero con más funcionalidad.

### Fase 1 — CRUD básico

- [ ] Comandos `agregar <nombre> <cantidad> <precio>`, `listar`, `eliminar <id>` y `buscar <texto>`.
- [ ] Persistir en `inventario.json` con `os.ReadFile`/`os.WriteFile` y `encoding/json`.
- [ ] Cada producto: `{ Id, Nombre, Cantidad, Precio }`. Carga al inicio y guarda tras cada mutación.

### Fase 2 — Validación y contabilidad

- [ ] No permitir cantidades o precios negativos (devuelve un `error` con `fmt.Errorf`).
- [ ] Comando `resumen` que muestre total de productos, unidades y valor del inventario (suma `Cantidad * Precio`).
- [ ] Comando `ajustar <id> <cantidad>` para sumar/restar stock, comprobando que no quede negativo.

### Fase 3 — Reportes

- [ ] Comando `bajo_stock <minimo>` que liste productos con `Cantidad < minimo`.
- [ ] Comando `exportar` que genere un segundo archivo `reporte.txt` con el resumen formateado usando `fmt.Sprintf`.

---

## Proyecto 2 — API REST con archivo

**Dificultad:** ⭐⭐⭐⭐ (nivel 04-05)

Una API REST en Go puro (`net/http`) para gestionar usuarios, con datos persistidos en un archivo JSON.

### Fase 1 — CRUD de usuarios

- [ ] `GET /usuarios` → lista todos.
- [ ] `GET /usuarios/{id}` → uno por id (`404` si no existe).
- [ ] `POST /usuarios` → crea uno validando `nombre` y `email`.
- [ ] `PUT /usuarios/{id}` → actualiza campos (responde `404` si el id no existe).
- [ ] `DELETE /usuarios/{id}` → elimina.

### Fase 2 — Persistencia y validación

- [ ] Leer/escribir `usuarios.json` al arrancar y en cada mutación.
- [ ] Validar que el `email` contenga `@` (con `strings.Contains`) y que no esté duplicado.
- [ ] Responder `400` con `{"error":"..."}` cuando la validación falle.

### Fase 3 — Búsqueda y filtros

- [ ] `GET /usuarios?buscar=<texto>` filtra por nombre o email.
- [ ] Ordenar resultados con `?orden=asc|desc` (usa `sort.Slice`).
- [ ] Añadir paginación `?pagina=1&limite=10` (recorre el slice con `[desde:hasta]`).

---

## Proyecto 3 — App de tareas completa

**Dificultad:** ⭐⭐⭐⭐⭐ (nivel 05)

Una mini aplicación de tareas (todo list) donde un **servidor HTTP** sirve tanto el frontend (HTML + CSS) como la API. Añade concurrencia con goroutines para el manejo de peticiones.

### Fase 1 — Servidor con frontend

- [ ] `GET /` sirve una página HTML con un formulario y una lista.
- [ ] `GET /estilos.css` sirve los estilos.
- [ ] La página se carga y muestra las tareas existentes cargadas desde `tareas.json`.

### Fase 2 — API de tareas

- [ ] `GET /tareas` → lista de tareas (en memoria).
- [ ] `POST /tareas` → crea una tarea desde el formulario.
- [ ] `PUT /tareas/{id}/toggle` → marca completada/no completada.
- [ ] Protege el estado compartido con `sync.Mutex` (acceso concurrente seguro).

### Fase 3 — Persistencia y pulido

- [ ] Guardar las tareas en `tareas.json` tras cada mutación.
- [ ] Responder `404` para ids inexistentes y `400` para peticiones malformadas.
- [ ] Añadir una goroutine que escriba un log de peticiones en `access.log` sin bloquear las respuestas.

---

## Consejos

- Ejecuta y prueba cada fase antes de continuar.
- Usa `go run main.go` para probar; para los servidores usa `curl` en otra terminal.
- Usa `go vet` y `gofmt` para mantener el código limpio.
- Vuelve a las [guías](../) o a los ejercicios del nivel correspondiente si algo se te atasca.