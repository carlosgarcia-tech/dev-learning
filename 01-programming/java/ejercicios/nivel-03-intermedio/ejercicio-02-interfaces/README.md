# Ejercicio 14 — Interfaces

- **Nivel:** 3/5
- **Tema:** POO Avanzada
- **Tiempo estimado:** 25 minutos

## Enunciado

Define una interfaz `Pagable` con el método `procesarPago(double monto)`. Implementa `PagoTarjeta` y `PagoEfectivo`. Agrega un método `default` en la interfaz que imprima un recibo genérico.

## Requisitos

- [ ] El programa compila sin errores (`javac Main.java`)
- [ ] El programa se ejecuta correctamente (`java Main`)
- [ ] La solución cubre todos los puntos del enunciado
- [ ] El código sigue las convenciones de Java (camelCase, indentación, nombres descriptivos)
- [ ] Los tests pasan: `java MainTest`

## Pistas

<details>
<summary>Mostrar pistas</summary>

1. Una clase puede implementar varias interfaces separadas por comas.
2. Los métodos `default` tienen cuerpo y son heredados si no se sobrescriben.
3. Usa una `List<Pagable>` para procesar pagos de forma polimórfica.

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
