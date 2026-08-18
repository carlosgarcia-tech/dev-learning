# Ejercicios de Go — Índice

30 ejercicios progresivos (6 por nivel) + 3 proyectos integradores + 1 proyecto final. Cada ejercicio contiene:

- `README.md` — enunciado, requisitos, pistas y solución
- `main.go` — stub con `TODO`s para completar
- `main_test.go` — runner de tests con el paquete `testing`
- `go.mod` — módulo Go para ejecutar el ejercicio

## Cómo ejecutar los tests

Desde la carpeta del ejercicio:

```bash
go test -v ./...
```

> El runner usa el paquete `testing` de la biblioteca estándar: no requiere
> dependencias externas. Ejecuta `go run .` para probar la solución.

## Nivel 01 — Fundamentos (1/5)

Variables, tipos, operadores, condicionales, bucles, slices y maps.

| # | Ejercicio | Carpeta |
|---|-----------|---------|
| 01 | Variables y tipos | [`nivel-01-fundamentos/ejercicio-01-variables-y-tipos`](./nivel-01-fundamentos/ejercicio-01-variables-y-tipos/) |
| 02 | Operadores y condicionales | [`nivel-01-fundamentos/ejercicio-02-operadores-y-condicionales`](./nivel-01-fundamentos/ejercicio-02-operadores-y-condicionales/) |
| 03 | Bucles | [`nivel-01-fundamentos/ejercicio-03-bucles`](./nivel-01-fundamentos/ejercicio-03-bucles/) |
| 04 | Funciones básicas | [`nivel-01-fundamentos/ejercicio-04-funciones-basicas`](./nivel-01-fundamentos/ejercicio-04-funciones-basicas/) |
| 05 | Arrays y slices | [`nivel-01-fundamentos/ejercicio-05-arrays-y-slices`](./nivel-01-fundamentos/ejercicio-05-arrays-y-slices/) |
| 06 | Maps | [`nivel-01-fundamentos/ejercicio-06-maps`](./nivel-01-fundamentos/ejercicio-06-maps/) |

## Nivel 02 — Básico (2/5)

Structs, métodos, punteros, funciones variádicas, strings y errores.

| # | Ejercicio | Carpeta |
|---|-----------|---------|
| 01 | Structs | [`nivel-02-basico/ejercicio-01-structs`](./nivel-02-basico/ejercicio-01-structs/) |
| 02 | Métodos | [`nivel-02-basico/ejercicio-02-metodos`](./nivel-02-basico/ejercicio-02-metodos/) |
| 03 | Punteros | [`nivel-02-basico/ejercicio-03-punteros`](./nivel-02-basico/ejercicio-03-punteros/) |
| 04 | Funciones variádicas | [`nivel-02-basico/ejercicio-04-funciones-variadicas`](./nivel-02-basico/ejercicio-04-funciones-variadicas/) |
| 05 | Cadenas | [`nivel-02-basico/ejercicio-05-cadenas`](./nivel-02-basico/ejercicio-05-cadenas/) |
| 06 | Errores básicos | [`nivel-02-basico/ejercicio-06-errores-basicos`](./nivel-02-basico/ejercicio-06-errores-basicos/) |

## Nivel 03 — Intermedio (3/5)

Interfaces, switch, slices avanzados, defer/panic, paquetes y funciones anónimas.

| # | Ejercicio | Carpeta |
|---|-----------|---------|
| 01 | Interfaces | [`nivel-03-intermedio/ejercicio-01-interfaces`](./nivel-03-intermedio/ejercicio-01-interfaces/) |
| 02 | Switch | [`nivel-03-intermedio/ejercicio-02-switch`](./nivel-03-intermedio/ejercicio-02-switch/) |
| 03 | Slices avanzados | [`nivel-03-intermedio/ejercicio-03-slices-avanzados`](./nivel-03-intermedio/ejercicio-03-slices-avanzados/) |
| 04 | Defer y panic | [`nivel-03-intermedio/ejercicio-04-defer-y-panic`](./nivel-03-intermedio/ejercicio-04-defer-y-panic/) |
| 05 | Paquetes y módulos | [`nivel-03-intermedio/ejercicio-05-paquetes-y-modulos`](./nivel-03-intermedio/ejercicio-05-paquetes-y-modulos/) |
| 06 | Funciones anónimas | [`nivel-03-intermedio/ejercicio-06-funciones-anonimas`](./nivel-03-intermedio/ejercicio-06-funciones-anonimas/) |

## Nivel 04 — Avanzado (4/5)

Goroutines, channels, select, channels con buffer, testing y context.

| # | Ejercicio | Carpeta |
|---|-----------|---------|
| 01 | Goroutines | [`nivel-04-avanzado/ejercicio-01-goroutines`](./nivel-04-avanzado/ejercicio-01-goroutines/) |
| 02 | Channels | [`nivel-04-avanzado/ejercicio-02-channels`](./nivel-04-avanzado/ejercicio-02-channels/) |
| 03 | Select | [`nivel-04-avanzado/ejercicio-03-select`](./nivel-04-avanzado/ejercicio-03-select/) |
| 04 | Channels con buffer | [`nivel-04-avanzado/ejercicio-04-channels-con-buffer`](./nivel-04-avanzado/ejercicio-04-channels-con-buffer/) |
| 05 | Testing con go test | [`nivel-04-avanzado/ejercicio-05-testing-con-go-test`](./nivel-04-avanzado/ejercicio-05-testing-con-go-test/) |
| 06 | Context | [`nivel-04-avanzado/ejercicio-06-context`](./nivel-04-avanzado/ejercicio-06-context/) |

## Nivel 05 — Experto (5/5)

CLI con persistencia, servidor HTTP, API REST, caché LRU, worker pool y mini-servicio.

| # | Ejercicio | Carpeta |
|---|-----------|---------|
| 01 | Gestor de tareas CLI | [`nivel-05-experto/ejercicio-01-gestor-de-tareas-cli`](./nivel-05-experto/ejercicio-01-gestor-de-tareas-cli/) |
| 02 | Servidor HTTP | [`nivel-05-experto/ejercicio-02-servidor-http`](./nivel-05-experto/ejercicio-02-servidor-http/) |
| 03 | API REST | [`nivel-05-experto/ejercicio-03-api-rest`](./nivel-05-experto/ejercicio-03-api-rest/) |
| 04 | Caché LRU | [`nivel-05-experto/ejercicio-04-cache-lru`](./nivel-05-experto/ejercicio-04-cache-lru/) |
| 05 | Worker pool | [`nivel-05-experto/ejercicio-05-worker-pool`](./nivel-05-experto/ejercicio-05-worker-pool/) |
| 06 | Mini proyecto | [`nivel-05-experto/ejercicio-06-mini-proyecto`](./nivel-05-experto/ejercicio-06-mini-proyecto/) |

## Proyectos integradores

[Proyectos integradores](proyectos/README.md) — 3 proyectos por fases: CLI de inventario, API REST con archivo y app de tareas completa.

## Proyecto final

[**Sistema de Gestión de Biblioteca**](proyectos/proyecto-final/) — aplicación completa con `Repositorio[T]` genérico, servicios con validaciones y reglas de negocio, reportes y 15 tests de referencia con `go test`.

## Cómo ejecutar

- **Programas de un solo archivo:** `go run main.go` dentro de la carpeta del ejercicio (requiere `package main` y `func main`).
- **Tests:** ejecuta `go test -v ./...` dentro de la carpeta del ejercicio o del proyecto final.
- **Servidores HTTP:** `go run .` en una terminal y prueba con `curl` desde otra.
- **Crear ejercicios nuevos:** usa `scripts/new-exercise-go.sh`.