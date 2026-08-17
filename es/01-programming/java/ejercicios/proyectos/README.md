# Proyectos integradores

Proyectos completos para poner en práctica todo lo aprendido en los 5 niveles. Cada proyecto tiene **requisitos por fases**: completa una fase antes de pasar a la siguiente. Están ordenados de menor a mayor complejidad. Todo se construye con Java 17+ y solo la librería estándar del JDK.

---

## Proyecto 1 — Gestor de biblioteca CLI

**Dificultad:** ⭐⭐ (nivel 02-03)

Una aplicación de consola que gestiona libros de una biblioteca persistidos en `biblioteca.txt`, similar al ejercicio del gestor de tareas pero con más funcionalidad.

### Fase 1 — CRUD básico

- [ ] Comandos `agregar`, `listar`, `buscar <texto>` y `eliminar <id>`.
- [ ] Persistir en `biblioteca.txt` con `java.nio.file.Files`.
- [ ] Cada libro: `id`, `titulo`, `autor`, `anio` (separados por `|`).

### Fase 2 — Validación y encapsulación

- [ ] Clase `Libro` encapsulada con getters y validaciones (`titulo` no vacío, `anio` razonable).
- [ ] No permitir agregar un libro sin título ni con año negativo (usa `throw` + try/catch).
- [ ] Comando `resumen` que muestre total de libros y el más antiguo.

### Fase 3 — Búsqueda y reportes

- [ ] `buscar` filtra por título o autor sin distinguir mayúsculas (`toLowerCase` + `contains`).
- [ ] `exportar` que genere un segundo archivo `reporte.txt` con el resumen formateado.
- [ ] `eliminar` pide el `id` y borra la línea correspondiente del archivo.

---

## Proyecto 2 — API REST con el JDK

**Dificultad:** ⭐⭐⭐⭐ (nivel 04-05)

Una API REST en Java puro usando `com.sun.net.httpserver` (servidor HTTP integrado en el JDK) para gestionar usuarios, con datos en memoria y persistidos en un archivo JSON.

### Fase 1 — CRUD de usuarios

- [ ] `GET /usuarios` → lista todos.
- [ ] `GET /usuarios?id=<id>` → uno por id (`404` si no existe).
- [ ] `POST /usuarios` → crea uno validando `nombre` y `email`.
- [ ] `DELETE /usuarios?id=<id>` → elimina.
- [ ] El JSON se construye a mano (concatenación de strings) o con una clase simple.

### Fase 2 — Persistencia y validación

- [ ] Leer/escribir `usuarios.txt` (o `usuarios.json` manual) al arrancar y en cada mutación.
- [ ] Validar que el `email` contenga `@` y que no esté duplicado.
- [ ] Responder `400` con `{"error":"..."}` cuando la validación falle.

### Fase 3 — Concurrencia y refuerzo

- [ ] Atender peticiones en paralelo con `server.setExecutor(Executors.newCachedThreadPool())`.
- [ ] Proteger la lista de usuarios con `synchronized` o `CopyOnWriteArrayList`.
- [ ] Añadir `GET /usuarios?buscar=<texto>` que filtre por nombre o email.

---

## Proyecto 3 — Chat por sockets

**Dificultad:** ⭐⭐⭐⭐⭐ (nivel 05)

Un servidor de chat TCP donde varios clientes se conectan, envían mensajes y el servidor los difunde al resto. Todo con `ServerSocket`, `Socket` y hilos.

### Fase 1 — Servidor con eco

- [ ] `ServidorChat` con `ServerSocket` en el puerto `8080` que acepta conexiones en bucle.
- [ ] Cada cliente se atiende en su propio hilo (`new Thread` o `ExecutorService`).
- [ ] El servidor repite cada mensaje al mismo cliente (`Eco: <mensaje>`).

### Fase 2 — Difusión de mensajes

- [ ] Mantener una lista concurrente de clientes conectados (`CopyOnWriteArrayList<Socket>` o similar).
- [ ] Al recibir un mensaje, reenviarlo a **todos** los clientes excepto al emisor.
- [ ] `broadcast("<nombre>: <mensaje>")` como método sincronizado.
- [ ] El servidor pide el nombre al cliente en el primer mensaje (`/nombre <nick>`).

### Fase 3 — Pulido y robustez

- [ ] `ClienteChat` con un hilo lector y otro escritor (puedes usar `Scanner` para escribir).
- [ ] Notificar a todos cuando un cliente entra o sale.
- [ ] Limpiar los sockets cerrados de la lista para evitar envíos a clientes caídos.

---

## Consejos

- Ejecuta y prueba cada fase antes de continuar.
- Para los proyectos de red, abre varias terminales: servidor en una y clientes en las demás.
- Vuelve a las [guías](../../) o a los ejercicios del nivel correspondiente si algo se te atasca.