# Ejercicio 16 — Generics

- **Nivel:** 3/5
- **Tema:** POO Avanzada
- **Tiempo estimado:** 30 minutos

## Enunciado

Implementa una clase genérica `Caja<T>` que almacene un valor de tipo `T` con métodos `guardar` y `obtener`. Implementa también un método genérico estático `<T> T primerElemento(List<T> lista)`.

## Requisitos

- [ ] El programa compila sin errores (`javac Main.java`)
- [ ] El programa se ejecuta correctamente (`java Main`)
- [ ] La solución cubre todos los puntos del enunciado
- [ ] El código sigue las convenciones de Java (camelCase, indentación, nombres descriptivos)
- [ ] Los tests pasan: `java MainTest`

## Pistas

<details>
<summary>Mostrar pistas</summary>

1. `<T>` es un parámetro de tipo; se sustituye por el tipo real al usar la clase.
2. Los generics permiten seguridad de tipos en tiempo de compilación sin repetir código.
3. Puedes acotar el tipo con `<T extends Number>` si necesitas restringirlo.

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
