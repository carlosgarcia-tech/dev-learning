# Ejercicio 09 — Encapsulamiento

- **Nivel:** 2/5
- **Tema:** Programación Orientada a Objetos
- **Tiempo estimado:** 25 minutos

## Enunciado

Implementa una clase `CuentaBancaria` con el atributo `saldo` privado, métodos `depositar` y `retirar` que validen montos negativos y saldo insuficiente, y un getter de solo lectura para el saldo (sin setter directo).

## Requisitos

- [ ] El programa compila sin errores (`javac Main.java`)
- [ ] El programa se ejecuta correctamente (`java Main`)
- [ ] La solución cubre todos los puntos del enunciado
- [ ] El código sigue las convenciones de Java (camelCase, indentación, nombres descriptivos)
- [ ] Los tests pasan: `java MainTest`

## Pistas

<details>
<summary>Mostrar pistas</summary>

1. Nunca expongas atributos con `public` directamente; usa getters/setters o métodos de negocio.
2. Lanza `IllegalArgumentException` para montos inválidos.
3. Un getter sin setter logra que el atributo sea de solo lectura desde fuera.

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
