# Ejercicio 22 — Anotaciones

- **Nivel:** 4/5
- **Tema:** POO Avanzada
- **Tiempo estimado:** 25 minutos

## Enunciado

Define una anotación personalizada `@Autor` (con `RetentionPolicy.RUNTIME`) que reciba `nombre` y `fecha`. Anótala sobre una clase y usa reflexión (`Class.getAnnotation`) para leer e imprimir sus valores en tiempo de ejecución.

## Requisitos

- [ ] El programa compila sin errores (`javac Main.java`)
- [ ] El programa se ejecuta correctamente (`java Main`)
- [ ] La solución cubre todos los puntos del enunciado
- [ ] El código sigue las convenciones de Java (camelCase, indentación, nombres descriptivos)
- [ ] Los tests pasan: `java MainTest`

## Pistas

<details>
<summary>Mostrar pistas</summary>

1. `@Retention(RetentionPolicy.RUNTIME)` es necesaria para poder leer la anotación por reflexión.
2. `@Target(ElementType.TYPE)` limita la anotación a clases/interfaces.
3. `clase.getAnnotation(Autor.class)` obtiene la instancia de la anotación.

</details>

## Solución

<details>
<summary>Mostrar solución de referencia</summary>

Este ejercicio no tiene una única solución correcta. Antes de mirar cualquier solución
de referencia externa, intenta:

1. Releer la guía relacionada: [`02-oop.md`](../../../02-oop.md).
2. Escribir primero los `TODO` de `Main.java` con una implementación simple que funcione.
3. Ejecutar `MainTest.java` para verificar tu progreso y refinar el código.

</details>
