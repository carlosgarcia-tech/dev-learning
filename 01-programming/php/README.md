# PHP

> Ruta de aprendizaje completa de PHP 8 en español: guías de estudio, 30 ejercicios por niveles con tests y proyectos integradores.

PHP impulsa más del 75% de los sitios web del mundo (WordPress, Laravel, Symfony). Este lenguaje vive en el servidor: recibe peticiones HTTP, se conecta a bases de datos, genera HTML o JSON y entrega la respuesta. Dominarlo te abre las puertas al desarrollo web backend clásico y a frameworks modernos.

Esta ruta asume que sabes lo básico de programación pero parte desde cero en PHP. Cada guía introduce la teoría con ejemplos ejecutables y enlaza a los ejercicios que la refuerzan.

## Guías de estudio

| Guía | Contenido |
|---|---|
| [01 — Fundamentos](01-fundamentos.md) | Variables, tipos, operadores, condicionales, bucles y arrays |
| [02 — Funciones y arrays](02-funciones-y-arrays.md) | Funciones, ámbito, closures y arrays indexados/asociativos |
| [03 — OOP](03-oop.md) | Clases, herencia, interfaces, traits, namespaces y enums |
| [04 — PDO y bases de datos](04-pdo-y-bases-de-datos.md) | Conexiones PDO, SQL seguro, consultas y transacciones |
| [05 — Errores y Composer](05-errores-y-composer.md) | Excepciones, manejo de errores, Composer y PHPUnit |
| [06 — Laravel](06-laravel.md) | Framework web, rutas, controladores, Eloquent, Blade y API |

## Ejercicios por nivel

Cada ejercicio es una carpeta con **enunciado, requisitos, pistas y solución** (`README.md`), el **esqueleto** (`index.php` con `TODO`) y un **script de tests** (`index_test.php` con aserciones: `exit(0)` si pasan). Ejecuta los tests desde la carpeta del ejercicio con `php index_test.php`.

| Nivel | Dificultad | Ejercicios |
|---|---|---|
| [Nivel 01 — Fundamentos](ejercicios/nivel-01-fundamentos/) | ⭐ 1/5 | Variables, operadores, bucles, arrays, strings y funciones |
| [Nivel 02 — Básico](ejercicios/nivel-02-basico/) | ⭐⭐ 2/5 | Funciones avanzadas, arrays asociativos, archivos, excepciones, clases e include |
| [Nivel 03 — Intermedio](ejercicios/nivel-03-intermedio/) | ⭐⭐⭐ 3/5 | Herencia, interfaces, traits, closures, namespaces y Composer |
| [Nivel 04 — Avanzado](ejercicios/nivel-04-avanzado/) | ⭐⭐⭐⭐ 4/5 | PDO, transacciones, sesiones, API REST, testing y patrones |
| [Nivel 05 — Experto](ejercicios/nivel-05-experto/) | ⭐⭐⭐⭐⭐ 5/5 | Gestor de tareas CLI, blog con PDO, caché LRU, MVC, sistema de archivos y cliente de API REST |

Índice completo: [ejercicios/README.md](ejercicios/README.md)

## Proyectos

Al terminar los niveles, integra todo lo aprendido con los [3 proyectos integradores](ejercicios/proyectos/README.md):

1. **Gestor de tareas CLI** — aplicación de consola persistente en JSON.
2. **Mini blog con PDO** — aplicación web con base de datos y sesiones.
3. **[PROYECTO FINAL: Blog de gestión de artículos](ejercicios/proyectos/proyecto-final/)** — PHP puro, persistencia en archivo, autenticación por sesión, validaciones y tests.

## Cómo ejecutar los tests

Cada ejercicio se verifica desde su propia carpeta:

```bash
cd ejercicios/nivel-01-fundamentos/ejercicio-01-variables-y-tipos
php index_test.php   # "OK: todas las aserciones pasaron." + exit(0)
```