# Ejercicio 29 — API REST

- **Nivel:** 5/5
- **Tema:** Spring Boot
- **Tiempo estimado:** 60 minutos

## Enunciado

Usando Spring Boot, crea una API REST mínima para gestionar `Tarea` (id, descripcion, completada) con endpoints `GET /api/tareas`, `POST /api/tareas`, `PUT /api/tareas/{id}` y `DELETE /api/tareas/{id}`, persistiendo en una base H2 en memoria mediante Spring Data JPA.

## Requisitos

- [ ] El programa compila sin errores (`javac Main.java`)
- [ ] El programa se ejecuta correctamente (`java Main`)
- [ ] La solución cubre todos los puntos del enunciado
- [ ] El código sigue las convenciones de Java (camelCase, indentación, nombres descriptivos)
- [ ] Los tests pasan: `java MainTest`

## Pistas

<details>
<summary>Mostrar pistas</summary>

1. Sigue la arquitectura Controller → Service → Repository descrita en la guía 06.
2. Usa DTOs de entrada/salida en vez de exponer la entidad JPA directamente.
3. Prueba los endpoints con `curl`, Postman o el propio Swagger UI.

</details>

## Solución

<details>
<summary>Mostrar solución de referencia</summary>

Este ejercicio no tiene una única solución correcta. Antes de mirar cualquier solución
de referencia externa, intenta:

1. Releer la guía relacionada: [`06-spring-boot.md`](../../../06-spring-boot.md).
2. Escribir primero los `TODO` de `Main.java` con una implementación simple que funcione.
3. Ejecutar `MainTest.java` para verificar tu progreso y refinar el código.

</details>
