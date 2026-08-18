# Ejercicio 21 — Try-with-resources

- **Nivel:** 4/5
- **Tema:** Excepciones
- **Tiempo estimado:** 20 minutos

## Enunciado

Crea una clase `RecursoSimulado` que implemente `AutoCloseable` e imprima mensajes al abrir y cerrar. Úsala dentro de un `try-with-resources`, provocando una excepción a mitad del bloque, y confirma que el recurso se cierra igualmente.

## Requisitos

- [ ] El programa compila sin errores (`javac Main.java`)
- [ ] El programa se ejecuta correctamente (`java Main`)
- [ ] La solución cubre todos los puntos del enunciado
- [ ] El código sigue las convenciones de Java (camelCase, indentación, nombres descriptivos)
- [ ] Los tests pasan: `java MainTest`

## Pistas

<details>
<summary>Mostrar pistas</summary>

1. Implementa el método `close()` de `AutoCloseable`.
2. Puedes declarar varios recursos separados por `;` dentro del mismo `try (...)`.
3. El orden de cierre es inverso al de apertura.

</details>

## Solución

<details>
<summary>Mostrar solución de referencia</summary>

Este ejercicio no tiene una única solución correcta. Antes de mirar cualquier solución
de referencia externa, intenta:

1. Releer la guía relacionada: [`04-excepciones.md`](../../../04-excepciones.md).
2. Escribir primero los `TODO` de `Main.java` con una implementación simple que funcione.
3. Ejecutar `MainTest.java` para verificar tu progreso y refinar el código.

</details>
