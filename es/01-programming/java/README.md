# Java

> Ruta de aprendizaje completa de Java (17+) en español: guías de estudio, ejercicios por niveles y proyectos integradores.

Java es uno de los lenguajes más usados del mundo: potencia aplicaciones empresariales, Android, sistemas backend y big data. Es un lenguaje **tipado estáticamente** y **orientado a objetos**, con una JVM (Máquina Virtual de Java) que garantiza portabilidad: *escribe una vez, ejecuta en cualquier lugar*.

Esta ruta parte desde cero en Java. Cada guía introduce la teoría con ejemplos ejecutables y enlaza a los ejercicios que la refuerzan. Todo el código usa **Java 17+** y solo la librería estándar (JDK).

## Guías de estudio

| Guía | Contenido |
|---|---|
| [01 — Fundamentos](01-fundamentos.md) | El método `main`, tipos, variables, operadores, condicionales y bucles |
| [02 — POO](02-oop.md) | Clases, objetos, encapsulación, constructores y métodos |
| [03 — Colecciones](03-colecciones.md) | `ArrayList`, `HashMap`, `HashSet` y streams |
| [04 — Excepciones](04-excepciones.md) | `try/catch/finally`, `throw`, excepciones checked y unchecked |
| [05 — Concurrencia](05-concurrencia.md) | Threads, `ExecutorService` y `synchronized` |

## Ejercicios por nivel

Cada ejercicio incluye enunciado, requisitos, pistas y solución. Compila y ejecuta cada solución con:

```bash
javac Ejercicio.java
java Ejercicio
```

| Nivel | Dificultad | Ejercicios |
|---|---|---|
| [Nivel 01 — Fundamentos](ejercicios/nivel-01-fundamentos/) | ⭐ 1/5 | Hola mundo, variables y tipos, operadores, bucles, arrays y strings |
| [Nivel 02 — Básico](ejercicios/nivel-02-basico/) | ⭐⭐ 2/5 | Métodos, clases y objetos, encapsulación, `ArrayList`, excepciones y enums |
| [Nivel 03 — Intermedio](ejercicios/nivel-03-intermedio/) | ⭐⭐⭐ 3/5 | Herencia y polimorfismo, interfaces, colecciones, genéricos, streams y lambdas |
| [Nivel 04 — Avanzado](ejercicios/nivel-04-avanzado/) | ⭐⭐⭐⭐ 4/5 | Streams avanzados, threads, `synchronized`, try-with-resources, anotaciones y testing |
| [Nivel 05 — Experto](ejercicios/nivel-05-experto/) | ⭐⭐⭐⭐⭐ 5/5 | CLI, servidor socket, caché LRU, productor-consumidor, API REST y mini-proyecto |

Índice completo con los 30 ejercicios: [ejercicios/README.md](ejercicios/README.md)

## Proyectos

Al terminar los niveles, integra todo lo aprendido con los [3 proyectos integradores](ejercicios/proyectos/README.md):

1. **Gestor de biblioteca CLI** — aplicación de consola con persistencia en archivo.
2. **API REST con el JDK** — servidor HTTP usando `com.sun.net.httpserver` con datos en memoria y en disco.
3. **Sistema de chat por sockets** — servidor y clientes concurrentes comunicándose por TCP.

## Requisitos

- **JDK 17 o superior** (recomendado JDK 21 LTS). Descárgalo en [Adoptium](https://adoptium.net/) o usa un gestor como SDKMAN.
- Verifica tu instalación con `java -version` y `javac -version`.
- Cualquier editor de texto sirve; los IDEs (IntelliJ, Eclipse, VS Code) añaden autocompletado y depuración.