# Ejercicios — PHP

30 ejercicios en 5 niveles de dificultad. Cada ejercicio tiene **enunciado, requisitos, pistas y solución** (plegable), más un archivo de implementación (*stub* con `TODO`) y un script de tests con aserciones propias (`exit(0)` si pasan, `exit(1)` si no).

> **Importante:** PHP no está instalado en este entorno de aprendizaje. Los comandos de test (`php ejercicio-0N-slug_test.php`) deben ejecutarse en tu máquina con PHP 8 o superior.

## Nivel 01 — Fundamentos (1/5)

Variables, tipos, operadores, bucles, arrays, strings y funciones.

| # | Ejercicio | Enlace |
|---|---|---|
| 01 | Variables y tipos | [ejercicio-01-variables-y-tipos.md](nivel-01-fundamentos/ejercicio-01-variables-y-tipos.md) |
| 02 | Operadores y condicionales | [ejercicio-02-operadores-y-condicionales.md](nivel-01-fundamentos/ejercicio-02-operadores-y-condicionales.md) |
| 03 | Bucles | [ejercicio-03-bucles.md](nivel-01-fundamentos/ejercicio-03-bucles.md) |
| 04 | Arrays básicos | [ejercicio-04-arrays-basicos.md](nivel-01-fundamentos/ejercicio-04-arrays-basicos.md) |
| 05 | Strings | [ejercicio-05-strings.md](nivel-01-fundamentos/ejercicio-05-strings.md) |
| 06 | Funciones básicas | [ejercicio-06-funciones-basicas.md](nivel-01-fundamentos/ejercicio-06-funciones-basicas.md) |

## Nivel 02 — Básico (2/5)

Funciones avanzadas, arrays asociativos, archivos, excepciones, clases e include/require.

| # | Ejercicio | Enlace |
|---|---|---|
| 01 | Funciones avanzadas | [ejercicio-01-funciones-avanzadas.md](nivel-02-basico/ejercicio-01-funciones-avanzadas.md) |
| 02 | Arrays asociativos | [ejercicio-02-arrays-asociativos.md](nivel-02-basico/ejercicio-02-arrays-asociativos.md) |
| 03 | Manejo de archivos | [ejercicio-03-manejo-de-archivos.md](nivel-02-basico/ejercicio-03-manejo-de-archivos.md) |
| 04 | Errores y excepciones | [ejercicio-04-errores-y-excepciones.md](nivel-02-basico/ejercicio-04-errores-y-excepciones.md) |
| 05 | Clases básicas | [ejercicio-05-clases-basicas.md](nivel-02-basico/ejercicio-05-clases-basicas.md) |
| 06 | Include y require | [ejercicio-06-include-require.md](nivel-02-basico/ejercicio-06-include-require.md) |

## Nivel 03 — Intermedio (3/5)

Herencia, interfaces, traits, closures, namespaces y Composer.

| # | Ejercicio | Enlace |
|---|---|---|
| 01 | OOP: herencia | [ejercicio-01-oop-herencia.md](nivel-03-intermedio/ejercicio-01-oop-herencia.md) |
| 02 | Interfaces | [ejercicio-02-interfaces.md](nivel-03-intermedio/ejercicio-02-interfaces.md) |
| 03 | Traits | [ejercicio-03-traits.md](nivel-03-intermedio/ejercicio-03-traits.md) |
| 04 | Closures | [ejercicio-04-closures.md](nivel-03-intermedio/ejercicio-04-closures.md) |
| 05 | Namespaces | [ejercicio-05-namespaces.md](nivel-03-intermedio/ejercicio-05-namespaces.md) |
| 06 | Composer y autoload | [ejercicio-06-composer.md](nivel-03-intermedio/ejercicio-06-composer.md) |

## Nivel 04 — Avanzado (4/5)

PDO, transacciones, sesiones, API REST, testing y patrones de diseño.

| # | Ejercicio | Enlace |
|---|---|---|
| 01 | PDO básico | [ejercicio-01-pdo-basico.md](nivel-04-avanzado/ejercicio-01-pdo-basico.md) |
| 02 | PDO avanzado | [ejercicio-02-pdo-avanzado.md](nivel-04-avanzado/ejercicio-02-pdo-avanzado.md) |
| 03 | Sesiones | [ejercicio-03-sesiones.md](nivel-04-avanzado/ejercicio-03-sesiones.md) |
| 04 | API REST mínima | [ejercicio-04-api-rest-minima.md](nivel-04-avanzado/ejercicio-04-api-rest-minima.md) |
| 05 | Testing con aserciones | [ejercicio-05-testing.md](nivel-04-avanzado/ejercicio-05-testing.md) |
| 06 | Patrones de diseño | [ejercicio-06-patrones.md](nivel-04-avanzado/ejercicio-06-patrones.md) |

## Nivel 05 — Experto (5/5)

Mini aplicaciones: gestor de tareas CLI, blog con PDO, caché LRU, MVC, sistema de archivos y cliente de API REST.

| # | Ejercicio | Enlace |
|---|---|---|
| 01 | Gestor de tareas CLI | [ejercicio-01-gestor-de-tareas-cli.md](nivel-05-experto/ejercicio-01-gestor-de-tareas-cli.md) |
| 02 | Blog con PDO | [ejercicio-02-blog-con-pdo.md](nivel-05-experto/ejercicio-02-blog-con-pdo.md) |
| 03 | Caché LRU | [ejercicio-03-cache-lru.md](nivel-05-experto/ejercicio-03-cache-lru.md) |
| 04 | Mini proyecto: MVC básico | [ejercicio-04-mini-proyecto-mvc-basico.md](nivel-05-experto/ejercicio-04-mini-proyecto-mvc-basico.md) |
| 05 | Sistema de archivos | [ejercicio-05-sistema-de-archivos.md](nivel-05-experto/ejercicio-05-sistema-de-archivos.md) |
| 06 | Cliente de API REST | [ejercicio-06-api-cliente.md](nivel-05-experto/ejercicio-06-api-cliente.md) |

## Proyectos integradores

[Proyectos integradores](proyectos/README.md) — 3 proyectos por fases: gestor de tareas CLI, mini blog con PDO y el **[PROYECTO FINAL: Blog de gestión de artículos](proyectos/proyecto-final/README.md)** (PHP puro, persistencia, autenticación por sesión, validaciones y tests).

## Cómo funciona un ejercicio

Cada ejercicio tiene 3 archivos con el mismo slug:

```
ejercicio-0N-slug.md          # enunciado, requisitos, pistas y solución
ejercicio-0N-slug.php         # stub: funciones con TODO que debes completar
ejercicio-0N-slug_test.php    # tests CLI con aserciones
```

Al terminar la implementación, todos los tests deben pasar:

```bash
php ejercicio-0N-slug_test.php   # OK + exit(0) si pasan; mensajes + exit(1) si no
```