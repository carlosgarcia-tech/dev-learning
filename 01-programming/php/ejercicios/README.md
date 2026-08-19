# Ejercicios — PHP

30 ejercicios en 5 niveles de dificultad. Cada ejercicio es una carpeta con **enunciado, requisitos, pistas y solución** (`README.md`), el **esqueleto** (`index.php` con funciones `TODO`) y un **script de tests** (`index_test.php` con aserciones propias: `exit(0)` si pasan, `exit(1)` si no).

## Nivel 01 — Fundamentos (1/5)

Variables, tipos, operadores, bucles, arrays, strings y funciones.

| # | Ejercicio | Enlace |
|---|---|---|
| 01 | Variables y tipos | [ejercicio-01-variables-y-tipos](nivel-01-fundamentos/ejercicio-01-variables-y-tipos/) |
| 02 | Operadores y condicionales | [ejercicio-02-operadores-y-condicionales](nivel-01-fundamentos/ejercicio-02-operadores-y-condicionales/) |
| 03 | Bucles | [ejercicio-03-bucles](nivel-01-fundamentos/ejercicio-03-bucles/) |
| 04 | Arrays básicos | [ejercicio-04-arrays-basicos](nivel-01-fundamentos/ejercicio-04-arrays-basicos/) |
| 05 | Strings | [ejercicio-05-strings](nivel-01-fundamentos/ejercicio-05-strings/) |
| 06 | Funciones básicas | [ejercicio-06-funciones-basicas](nivel-01-fundamentos/ejercicio-06-funciones-basicas/) |

## Nivel 02 — Básico (2/5)

Funciones avanzadas, arrays asociativos, archivos, excepciones, clases e include/require.

| # | Ejercicio | Enlace |
|---|---|---|
| 01 | Funciones avanzadas | [ejercicio-01-funciones-avanzadas](nivel-02-basico/ejercicio-01-funciones-avanzadas/) |
| 02 | Arrays asociativos | [ejercicio-02-arrays-asociativos](nivel-02-basico/ejercicio-02-arrays-asociativos/) |
| 03 | Manejo de archivos | [ejercicio-03-manejo-de-archivos](nivel-02-basico/ejercicio-03-manejo-de-archivos/) |
| 04 | Errores y excepciones | [ejercicio-04-errores-y-excepciones](nivel-02-basico/ejercicio-04-errores-y-excepciones/) |
| 05 | Clases básicas | [ejercicio-05-clases-basicas](nivel-02-basico/ejercicio-05-clases-basicas/) |
| 06 | Include y require | [ejercicio-06-include-require](nivel-02-basico/ejercicio-06-include-require/) |

## Nivel 03 — Intermedio (3/5)

Herencia, interfaces, traits, closures, namespaces y Composer.

| # | Ejercicio | Enlace |
|---|---|---|
| 01 | OOP: herencia | [ejercicio-01-oop-herencia](nivel-03-intermedio/ejercicio-01-oop-herencia/) |
| 02 | Interfaces | [ejercicio-02-interfaces](nivel-03-intermedio/ejercicio-02-interfaces/) |
| 03 | Traits | [ejercicio-03-traits](nivel-03-intermedio/ejercicio-03-traits/) |
| 04 | Closures | [ejercicio-04-closures](nivel-03-intermedio/ejercicio-04-closures/) |
| 05 | Namespaces | [ejercicio-05-namespaces](nivel-03-intermedio/ejercicio-05-namespaces/) |
| 06 | Composer y autoload | [ejercicio-06-composer](nivel-03-intermedio/ejercicio-06-composer/) |

## Nivel 04 — Avanzado (4/5)

PDO, transacciones, sesiones, API REST, testing y patrones de diseño.

| # | Ejercicio | Enlace |
|---|---|---|
| 01 | PDO básico | [ejercicio-01-pdo-basico](nivel-04-avanzado/ejercicio-01-pdo-basico/) |
| 02 | PDO avanzado | [ejercicio-02-pdo-avanzado](nivel-04-avanzado/ejercicio-02-pdo-avanzado/) |
| 03 | Sesiones | [ejercicio-03-sesiones](nivel-04-avanzado/ejercicio-03-sesiones/) |
| 04 | API REST mínima | [ejercicio-04-api-rest-minima](nivel-04-avanzado/ejercicio-04-api-rest-minima/) |
| 05 | Testing con aserciones | [ejercicio-05-testing](nivel-04-avanzado/ejercicio-05-testing/) |
| 06 | Patrones de diseño | [ejercicio-06-patrones](nivel-04-avanzado/ejercicio-06-patrones/) |

## Nivel 05 — Experto (5/5)

Mini aplicaciones: gestor de tareas CLI, blog con PDO, caché LRU, MVC, sistema de archivos y cliente de API REST.

| # | Ejercicio | Enlace |
|---|---|---|
| 01 | Gestor de tareas CLI | [ejercicio-01-gestor-de-tareas-cli](nivel-05-experto/ejercicio-01-gestor-de-tareas-cli/) |
| 02 | Blog con PDO | [ejercicio-02-blog-con-pdo](nivel-05-experto/ejercicio-02-blog-con-pdo/) |
| 03 | Caché LRU | [ejercicio-03-cache-lru](nivel-05-experto/ejercicio-03-cache-lru/) |
| 04 | Mini proyecto: MVC básico | [ejercicio-04-mini-proyecto-mvc-basico](nivel-05-experto/ejercicio-04-mini-proyecto-mvc-basico/) |
| 05 | Sistema de archivos | [ejercicio-05-sistema-de-archivos](nivel-05-experto/ejercicio-05-sistema-de-archivos/) |
| 06 | Cliente de API REST | [ejercicio-06-api-cliente](nivel-05-experto/ejercicio-06-api-cliente/) |

## Proyectos integradores

[Proyectos integradores](proyectos/README.md) — 3 proyectos por fases: gestor de tareas CLI, mini blog con PDO y el **[PROYECTO FINAL: Blog de gestión de artículos](proyectos/proyecto-final/README.md)** (PHP puro, persistencia, autenticación por sesión, validaciones y tests).

## Cómo funciona un ejercicio

Cada ejercicio es una carpeta con 3 archivos:

```
ejercicio-0N-slug/
├── README.md          # enunciado, requisitos, pistas y solución
├── index.php          # stub: funciones con TODO que debes completar
└── index_test.php     # tests CLI con aserciones
```

Al terminar la implementación, todos los tests deben pasar desde la carpeta del ejercicio:

```bash
php index_test.php   # OK + exit(0) si pasan; mensajes + exit(1) si no
```