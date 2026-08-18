# Ejercicio 11 — Excepciones

- **Nivel:** 2/5
- **Tema:** Excepciones
- **Tiempo estimado:** 20 minutos

## Enunciado

Implementa un método `dividir(int a, int b)` que lance una excepción personalizada `DivisionPorCeroException` (checked) si `b` es 0. Captura la excepción en `main` y muestra un mensaje claro sin detener el programa.

## Requisitos

- [ ] El programa compila sin errores (`javac Main.java`)
- [ ] El programa se ejecuta correctamente (`java Main`)
- [ ] La solución cubre todos los puntos del enunciado
- [ ] El código sigue las convenciones de Java (camelCase, indentación, nombres descriptivos)
- [ ] Los tests pasan: `java MainTest`

## Pistas

<details>
<summary>Mostrar pistas</summary>

1. Una excepción checked extiende `Exception`, no `RuntimeException`.
2. El método que lanza una excepción checked debe declararla con `throws`.
3. Prueba también con un array para provocar y capturar `ArrayIndexOutOfBoundsException`.

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
