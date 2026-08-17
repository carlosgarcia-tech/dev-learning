# Ejercicio 18 — Lambdas

- **Nivel:** 3/5
- **Tema:** POO Avanzada
- **Tiempo estimado:** 25 minutos

## Enunciado

Define una interfaz funcional `Operacion` con un método `aplicar(int a, int b)`. Crea distintas implementaciones usando expresiones lambda (suma, resta, multiplicación) y pásalas como argumento a un método `calcular(int a, int b, Operacion op)`.

## Requisitos

- [ ] El programa compila sin errores (`javac Main.java`)
- [ ] El programa se ejecuta correctamente (`java Main`)
- [ ] La solución cubre todos los puntos del enunciado
- [ ] El código sigue las convenciones de Java (camelCase, indentación, nombres descriptivos)
- [ ] Los tests pasan: `java MainTest`

## Pistas

<details>
<summary>Mostrar pistas</summary>

1. Marca la interfaz con `@FunctionalInterface` (opcional pero recomendable).
2. Una lambda `(a, b) -> a + b` implementa el único método abstracto de la interfaz.
3. Las lambdas pueden almacenarse en variables de tipo interfaz funcional.

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
