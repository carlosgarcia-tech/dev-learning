# Ejercicios — Go

30 ejercicios en 5 niveles de dificultad. Cada ejercicio tiene **enunciado, requisitos, pistas y solución** (plegable). Ejecuta cada solución con `go run archivo.go`. Para los ejercicios con tests usa `go test`.

## Nivel 01 — Fundamentos (1/5)

Variables, tipos, operadores, condicionales, bucles, slices y maps.

| # | Ejercicio | Enlace |
|---|---|---|
| 01 | Variables y tipos | [ejercicio-01-variables-y-tipos.md](nivel-01-fundamentos/ejercicio-01-variables-y-tipos.md) |
| 02 | Operadores y condicionales | [ejercicio-02-operadores-y-condicionales.md](nivel-01-fundamentos/ejercicio-02-operadores-y-condicionales.md) |
| 03 | Bucles | [ejercicio-03-bucles.md](nivel-01-fundamentos/ejercicio-03-bucles.md) |
| 04 | Funciones básicas | [ejercicio-04-funciones-basicas.md](nivel-01-fundamentos/ejercicio-04-funciones-basicas.md) |
| 05 | Arrays y slices | [ejercicio-05-arrays-y-slices.md](nivel-01-fundamentos/ejercicio-05-arrays-y-slices.md) |
| 06 | Maps | [ejercicio-06-maps.md](nivel-01-fundamentos/ejercicio-06-maps.md) |

## Nivel 02 — Básico (2/5)

Structs, métodos, punteros, funciones variádicas, strings y errores.

| # | Ejercicio | Enlace |
|---|---|---|
| 01 | Structs | [ejercicio-01-structs.md](nivel-02-basico/ejercicio-01-structs.md) |
| 02 | Métodos | [ejercicio-02-metodos.md](nivel-02-basico/ejercicio-02-metodos.md) |
| 03 | Punteros | [ejercicio-03-punteros.md](nivel-02-basico/ejercicio-03-punteros.md) |
| 04 | Funciones variádicas | [ejercicio-04-funciones-variadicas.md](nivel-02-basico/ejercicio-04-funciones-variadicas.md) |
| 05 | Cadenas | [ejercicio-05-cadenas.md](nivel-02-basico/ejercicio-05-cadenas.md) |
| 06 | Errores básicos | [ejercicio-06-errores-basicos.md](nivel-02-basico/ejercicio-06-errores-basicos.md) |

## Nivel 03 — Intermedio (3/5)

Interfaces, switch, slices avanzados, defer/panic, paquetes y funciones anónimas.

| # | Ejercicio | Enlace |
|---|---|---|
| 01 | Interfaces | [ejercicio-01-interfaces.md](nivel-03-intermedio/ejercicio-01-interfaces.md) |
| 02 | Switch | [ejercicio-02-switch.md](nivel-03-intermedio/ejercicio-02-switch.md) |
| 03 | Slices avanzados | [ejercicio-03-slices-avanzados.md](nivel-03-intermedio/ejercicio-03-slices-avanzados.md) |
| 04 | Defer y panic | [ejercicio-04-defer-y-panic.md](nivel-03-intermedio/ejercicio-04-defer-y-panic.md) |
| 05 | Paquetes y módulos | [ejercicio-05-paquetes-y-modulos.md](nivel-03-intermedio/ejercicio-05-paquetes-y-modulos.md) |
| 06 | Funciones anónimas | [ejercicio-06-funciones-anonimas.md](nivel-03-intermedio/ejercicio-06-funciones-anonimas.md) |

## Nivel 04 — Avanzado (4/5)

Goroutines, channels, select, channels con buffer, testing y context.

| # | Ejercicio | Enlace |
|---|---|---|
| 01 | Goroutines | [ejercicio-01-goroutines.md](nivel-04-avanzado/ejercicio-01-goroutines.md) |
| 02 | Channels | [ejercicio-02-channels.md](nivel-04-avanzado/ejercicio-02-channels.md) |
| 03 | Select | [ejercicio-03-select.md](nivel-04-avanzado/ejercicio-03-select.md) |
| 04 | Channels con buffer | [ejercicio-04-channels-con-buffer.md](nivel-04-avanzado/ejercicio-04-channels-con-buffer.md) |
| 05 | Testing con go test | [ejercicio-05-testing-con-go-test.md](nivel-04-avanzado/ejercicio-05-testing-con-go-test.md) |
| 06 | Context | [ejercicio-06-context.md](nivel-04-avanzado/ejercicio-06-context.md) |

## Nivel 05 — Experto (5/5)

CLI con persistencia, servidor HTTP, API REST, caché LRU, worker pool y mini-servicio.

| # | Ejercicio | Enlace |
|---|---|---|
| 01 | Gestor de tareas CLI | [ejercicio-01-gestor-de-tareas-cli.md](nivel-05-experto/ejercicio-01-gestor-de-tareas-cli.md) |
| 02 | Servidor HTTP | [ejercicio-02-servidor-http.md](nivel-05-experto/ejercicio-02-servidor-http.md) |
| 03 | API REST | [ejercicio-03-api-rest.md](nivel-05-experto/ejercicio-03-api-rest.md) |
| 04 | Caché LRU | [ejercicio-04-cache-lru.md](nivel-05-experto/ejercicio-04-cache-lru.md) |
| 05 | Worker pool | [ejercicio-05-worker-pool.md](nivel-05-experto/ejercicio-05-worker-pool.md) |
| 06 | Mini proyecto | [ejercicio-06-mini-proyecto.md](nivel-05-experto/ejercicio-06-mini-proyecto.md) |

## Proyectos integradores

[Proyectos integradores](proyectos/README.md) — 3 proyectos por fases: CLI de inventario, API REST con archivo y app de tareas completa.

## Cómo ejecutar

- **Programas de archivo único:** `go run archivo.go` (requiere `package main` y `func main`).
- **Tests:** crea el módulo con `go mod init nombre` y ejecuta `go test`.
- **Servidores HTTP:** `go run servidor.go` en una terminal y prueba con `curl` desde otra.