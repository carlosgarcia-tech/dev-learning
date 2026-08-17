# Proyectos integradores — TypeScript

Proyectos completos para poner en práctica todo lo aprendido en los 5 niveles: tipos, genéricos, async, `node:http` y `tsconfig`. Cada proyecto tiene **requisitos por fases**: completa una fase antes de pasar a la siguiente. Están ordenados de menor a mayor complejidad.

Todos requieren `@types/node` como dependencia de desarrollo (para los tipos de `node:*`) y un `tsconfig.json` con `strict: true`.

---

## Proyecto 1 — Gestor de finanzas CLI

**Dificultad:** ⭐⭐⭐ (nivel 03-04)

Una aplicación de consola que gestiona ingresos y gastos, con modelos tipados, validación y persistencia en `finanzas.json`.

### Fase 1 — Modelos y CRUD

- [ ] Definir `interface Movimiento { id: number; tipo: "ingreso" | "gasto"; concepto: string; importe: number; fecha: string }`.
- [ ] Definir `type MovimientoNuevo = Omit<Movimiento, "id">`.
- [ ] Implementar `GestorFinanzas` con `registrar(datos: MovimientoNuevo): Resultado<Movimiento>`, `listar(): Movimiento[]` y `eliminar(id: number): Resultado<Movimiento>`.
- [ ] Usar el patrón `Resultado<T> = { ok: true; valor: T } | { ok: false; error: string }` para operaciones que pueden fallar.

### Fase 2 — Reglas y resumen

- [ ] Validar que `importe > 0` y que `tipo` esté en la unión de literales (400/`{ ok: false }`).
- [ ] Comando `resumen` que calcule total de ingresos, total de gastos y saldo.
- [ ] Comando `por_categoria` que agrupe movimientos por `tipo` usando `Record<tipo, number>`.

### Fase 3 — Persistencia

- [ ] Guardar los movimientos en `finanzas.json` con `node:fs/promises` (leer al arrancar, escribir en cada mutación).
- [ ] Parsear el archivo con `JSON.parse` y validar la forma con una guard type (`esMovimiento(valor: unknown): valor is Movimiento`).
- [ ] Añadir un comando `listar_json` que imprima los datos como `JSON.stringify` formateado.

---

## Proyecto 2 — API REST tipada con archivo

**Dificultad:** ⭐⭐⭐⭐⭐ (nivel 04-05)

Una API REST en `node:http` para gestionar **tareas**, con tipos de dominio y persistencia en `tareas.json`.

### Fase 1 — CRUD de tareas

- [ ] `GET /tareas` → lista todas.
- [ ] `GET /tareas/:id` → una por id (404 si no existe).
- [ ] `POST /tareas` → crea validando `titulo` y `prioridad` (400 si falta algo).
- [ ] `PUT /tareas/:id` → actualiza campos parciales (usa `Partial<Tarea>`).
- [ ] `DELETE /tareas/:id` → elimina.

### Fase 2 — Persistencia y validación

- [ ] Leer `tareas.json` al arrancar y escribir en cada mutación con `node:fs/promises`.
- [ ] Guard type `esTarea` para validar los datos cargados del disco.
- [ ] Responder `400` con `{ error: "..." }` cuando la validación falle.

### Fase 3 — Filtros y tipos avanzados

- [ ] `GET /tareas?estado=pendiente|completada` filtra con un `type EstadoTarea`.
- [ ] `GET /tareas?prioridad=alta` ordena por prioridad usando un `Record` de pesos.
- [ ] Devolver resumen `GET /tareas/resumen` con conteos por estado, tipado como `Record<EstadoTarea, number>`.

---

## Proyecto 3 — App full-stack tipada

**Dificultad:** ⭐⭐⭐⭐⭐ (nivel 05)

Una mini app de notas donde un **servidor HTTP** sirve el frontend (HTML + JS del navegador) y una API. Todo en Node puro, con la **capa de tipos compartida**.

### Fase 1 — Servidor con frontend

- [ ] `GET /` sirve una página HTML con formulario y lista de notas.
- [ ] `GET /app.js` sirve el JavaScript del navegador.
- [ ] La página carga y muestra las notas existentes vía `fetch`.

### Fase 2 — API de notas tipada

- [ ] `GET /notas` → lista; `POST /notas` → crea; `PUT /notas/:id` → edita; `DELETE /notas/:id` → elimina.
- [ ] Definir `interface Nota` y `type NotaNueva = Omit<Nota, "id" | "creada">` y usarlas en las rutas.
- [ ] El frontend actualiza la lista sin recargar usando `fetch` + `async/await`.

### Fase 3 — Persistencia, errores y pulido

- [ ] Guardar las notas en `notas.json` (leer al arrancar, escribir en cada mutación).
- [ ] En el frontend, manejar errores de red con `.catch` y mostrar un mensaje.
- [ ] Estilos CSS básicos y validación del formulario (deshabilitar enviar si el texto está vacío).

---

## Consejos

- Ejecuta y prueba cada fase antes de continuar; usa `npx tsc --noEmit --watch` para verificar tipos en caliente.
- Usa `node --watch dist/<archivo>.js` (Node 18+) para recargar el servidor automáticamente.
- Mantén el patrón `Resultado<T>` en las operaciones que pueden fallar y resérvate los `throw` para errores de programación.
- Vuelve a las [guías](../) o a los ejercicios del nivel correspondiente si algo se te atasca.