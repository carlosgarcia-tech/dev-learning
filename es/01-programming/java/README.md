# Java — Curso Completo desde Cero hasta Experto con Spring Boot

Curso completo de Java en español: fundamentos, POO, colecciones, excepciones,
concurrencia y Spring Boot, con 30 ejercicios progresivos y un proyecto final.

## Estructura

```
es/01-programming/java/
├── README.md                     (este archivo)
├── 01-fundamentos.md
├── 02-oop.md
├── 03-colecciones.md
├── 04-excepciones.md
├── 05-concurrencia.md
├── 06-spring-boot.md
├── ejercicios/
│   ├── README.md
│   ├── nivel-01-fundamentos/     (6 ejercicios)
│   ├── nivel-02-basico/          (6 ejercicios)
│   ├── nivel-03-intermedio/      (6 ejercicios)
│   ├── nivel-04-avanzado/        (6 ejercicios)
│   ├── nivel-05-experto/         (6 ejercicios)
│   └── proyectos/
│       └── proyecto-final/       (Sistema de Biblioteca con Spring Boot)
└── resources/
```

## Guías de estudio

| # | Guía | Contenido |
|---|------|-----------|
| 1 | [Fundamentos](./01-fundamentos.md) | JVM, variables, tipos, operadores, control de flujo, arrays, strings |
| 2 | [POO](./02-oop.md) | Clases, encapsulamiento, herencia, polimorfismo, interfaces, Builder |
| 3 | [Colecciones](./03-colecciones.md) | List, Set, Map, Streams, Comparator |
| 4 | [Excepciones](./04-excepciones.md) | try-catch, excepciones personalizadas, try-with-resources |
| 5 | [Concurrencia](./05-concurrencia.md) | Threads, synchronized, ExecutorService, productor-consumidor |
| 6 | [Spring Boot](./06-spring-boot.md) | REST controllers, JPA, DTOs, seguridad con JWT |

## Ejercicios (30 en total, 6 por nivel)

Ver el índice completo en [`ejercicios/README.md`](./ejercicios/README.md).

| Nivel | Carpeta | Tema |
|-------|---------|------|
| 1 — Fundamentos | `ejercicios/nivel-01-fundamentos/` | Sintaxis básica |
| 2 — Básico | `ejercicios/nivel-02-basico/` | Métodos, clases, colecciones |
| 3 — Intermedio | `ejercicios/nivel-03-intermedio/` | Herencia, interfaces, streams |
| 4 — Avanzado | `ejercicios/nivel-04-avanzado/` | Concurrencia, anotaciones, testing |
| 5 — Experto | `ejercicios/nivel-05-experto/` | Proyectos integradores |

Cada ejercicio incluye:
- `README.md` — enunciado, requisitos, pistas y solución
- `Main.java` — stub con `TODO`s para completar
- `MainTest.java` — suite de tests ejecutable con `java`

## Proyecto final

[Sistema de Gestión de Biblioteca con Spring Boot](./ejercicios/proyectos/proyecto-final/README.md) —
API REST completa con autores, libros, usuarios y préstamos, JWT, JPA y tests.

## Scripts

`../../../scripts/new-exercise-java.sh` — genera el andamiaje (README + stub + test) para un nuevo ejercicio.

## Al terminar el curso serás capaz de

1. Programar en Java con confianza
2. Aplicar POO en proyectos reales
3. Manejar colecciones, excepciones y concurrencia
4. Desarrollar APIs REST con Spring Boot
5. Escribir tests para garantizar la calidad del código
6. Entender el ecosistema Java en profundidad