# Ejercicio 24 — Patrón Builder

- **Nivel:** 4/5
- **Tema:** POO Avanzada
- **Tiempo estimado:** 25 minutos

## Enunciado

Implementa el patrón Builder para una clase `Pizza` con atributos obligatorios (`tamano`) y opcionales (`queso`, `pepperoni`, `champinones`, cada uno boolean). El `Builder` debe permitir encadenar llamadas (`.queso(true).pepperoni(true).build()`).

## Requisitos

- [ ] El programa compila sin errores (`javac Main.java`)
- [ ] El programa se ejecuta correctamente (`java Main`)
- [ ] La solución cubre todos los puntos del enunciado
- [ ] El código sigue las convenciones de Java (camelCase, indentación, nombres descriptivos)
- [ ] Los tests pasan: `java MainTest`

## Pistas

<details>
<summary>Mostrar pistas</summary>

1. El constructor de la clase principal debe ser privado, accesible solo desde el `Builder`.
2. Cada método del Builder debe devolver `this` para permitir el encadenamiento (method chaining).
3. Los valores opcionales deben tener un valor por defecto razonable.

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
