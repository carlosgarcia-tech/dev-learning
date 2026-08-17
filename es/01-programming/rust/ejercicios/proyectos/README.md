# Proyectos integradores

Proyectos completos para poner en práctica todo lo aprendido en los 5 niveles. Cada proyecto tiene **requisitos por fases**: completa una fase antes de pasar a la siguiente. Están ordenados de menor a mayor complejidad.

Todos usan **Rust 2021 edition** y solo la biblioteca estándar. Crea cada proyecto con `cargo new <nombre> --bin` y ejecuta con `cargo run`.

---

## Proyecto 1 — Agenda de contactos CLI

**Dificultad:** ⭐⭐⭐ (nivel 03-04)

Una aplicación de consola que gestiona contactos (`nombre|teléfono`) y los persiste en un archivo `agenda.txt` usando `std::fs`.

### Fase 1 — CRUD en memoria

- [ ] `struct Contacto { nombre: String, telefono: String }`.
- [ ] Comandos `agregar <nombre> <teléfono>`, `listar`, `buscar <texto>` y `salir`.
- [ ] Bucle `loop` leyendo comandos de `stdin` con `match`.

### Fase 2 — Persistencia en archivo

- [ ] Guardar los contactos en `agenda.txt` con `std::fs::write` en formato `nombre|telefono`.
- [ ] Cargar los contactos al arrancar con `std::fs::read_to_string` y `lines()`.
- [ ] Sobrescribir el archivo en cada modificación (agregar/eliminar).
- [ ] Manejar el error de "archivo no existe" con `match` sobre el `Result`.

### Fase 3 — Validación y reportes

- [ ] Validar que el teléfono solo contenga dígitos, espacios y `+`.
- [ ] Comando `eliminar <nombre>` y `actualizar <nombre> <teléfono>`.
- [ ] Comando `resumen` que muestre cuántos contactos hay y cuántos nombres empiezan por cada letra.

---

## Proyecto 2 — Servidor TCP de eco con estadísticas

**Dificultad:** ⭐⭐⭐⭐ (nivel 04-05)

Un servidor TCP con `std::net::TcpListener` que responde lo que el cliente envía (eco) y lleva estadísticas: número de conexiones y bytes recibidos. Pruébalo con `nc 127.0.0.1 8080` o `telnet`.

### Fase 1 — Eco básico

- [ ] Escuchar en `127.0.0.1:8080` con `TcpListener::bind`.
- [ ] Aceptar conexiones con `for stream in listener.incoming()`.
- [ ] Leer líneas con `BufReader` y devolverlas (`write_all`) con prefijo `eco: `.

### Fase 2 — Múltiples clientes y estadísticas

- [ ] Mantener un `Arc<Mutex<Estadisticas>>` compartido con `conexiones` y `bytes`.
- [ ] Incrementar los contadores en cada conexión y mensaje.
- [ ] El comando `stats` devuelve las estadísticas acumuladas.
- [ ] Comando `salir` cierra la conexión del cliente.

### Fase 3 — Robustez y cierre

- [ ] Manejar clientes con `?` o `match` para no detener el servidor ante un error.
- [ ] Responder `HTTP/1.1 200 OK` mínimo para `GET /stats` (formato `text/plain`).
- [ ] Soportar el cierre elegante con Ctrl+C y mensaje final de estadísticas.

---

## Proyecto 3 — Mini base de datos concurrente

**Dificultad:** ⭐⭐⭐⭐⭐ (nivel 05)

Una "base de datos" en memoria con un **worker pool**: los comandos entran por un canal, un conjunto de trabajadores los procesan contra un `HashMap` compartido y devuelven la respuesta por otro canal. Combina threads, channels, `Arc`/`Mutex` y `Result`.

### Fase 1 — Canal de comandos y respuestas

- [ ] `enum Comando { Insertar(String, i32), Obtener(String), Borrar(String), Listar }`.
- [ ] `enum Respuesta { Valor(Option<i32>), Ok, Error(String), Datos(Vec<(String, i32)>) }`.
- [ ] Un único hilo worker procesa los comandos con `match` sobre un `HashMap<String, i32>`.

### Fase 2 — Worker pool

- [ ] Extender a `N` trabajadores con `Arc<Mutex<Receiver<Comando>>>`.
- [ ] El canal de respuestas es `mpsc::Sender<Respuesta>` clonado a cada worker.
- [ ] La base de datos se comparte con `Arc<Mutex<HashMap<String, i32>>>`.
- [ ] El hilo principal envía comandos y recibe respuestas hasta el comando `Salir`.

### Fase 3 — Persistencia y robustez

- [ ] Comando `Guardar` que escriba el `HashMap` en `db.txt` con `std::fs::write`.
- [ ] Cargar `db.txt` al arrancar.
- [ ] Manejar comandos desconocidos con `Respuesta::Error` sin detener el pool.
- [ ] Al final, `drop` de los remitentes, unir los hilos y mostrar las estadísticas de operaciones.

---

## Consejos

- Ejecuta y prueba cada fase antes de continuar con la siguiente.
- Usa `cargo check` para validar la compilación rápido, y `cargo run` para ejecutar.
- `cargo run` necesita un `Cargo.toml` con `edition = "2021"`.
- Vuelve a las [guías](../) o a los ejercicios del nivel correspondiente si algo se te atasca.