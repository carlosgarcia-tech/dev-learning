# Ejercicio 07 — Métodos

- **Nivel:** 2/5
- **Tema:** Programación Orientada a Objetos
- **Tiempo estimado:** 20 minutos

## Enunciado

Crea una clase `Calculadora` con métodos sobrecargados `sumar` que acepten 2 enteros, 2 dobles y un número variable de enteros (varargs). Agrega un método `esPrimo(int n)` que determine si un número es primo.

## Requisitos

- [ ] El programa compila sin errores (`javac Main.java`)
- [ ] El programa se ejecuta correctamente (`java Main`)
- [ ] La solución cubre todos los puntos del enunciado
- [ ] El código sigue las convenciones de Java (camelCase, indentación, nombres descriptivos)
- [ ] Los tests pasan: `java MainTest`

## Pistas

<details>
<summary>Mostrar pistas</summary>

1. La sobrecarga se distingue por el tipo y cantidad de parámetros, no por el nombre.
2. Para varargs usa `int... numeros`.
3. Un número primo solo es divisible por 1 y por sí mismo; basta comprobar hasta su raíz cuadrada.

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
