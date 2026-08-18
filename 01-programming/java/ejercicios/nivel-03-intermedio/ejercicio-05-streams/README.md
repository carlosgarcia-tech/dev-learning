# Ejercicio 17 — Streams

- **Nivel:** 3/5
- **Tema:** Colecciones
- **Tiempo estimado:** 30 minutos

## Enunciado

Dada una `List<Integer>` de al menos 20 números, usa Streams para: filtrar los pares, elevarlos al cuadrado, ordenarlos de mayor a menor, y calcular su suma total, todo en una sola cadena de operaciones.

## Requisitos

- [ ] El programa compila sin errores (`javac Main.java`)
- [ ] El programa se ejecuta correctamente (`java Main`)
- [ ] La solución cubre todos los puntos del enunciado
- [ ] El código sigue las convenciones de Java (camelCase, indentación, nombres descriptivos)
- [ ] Los tests pasan: `java MainTest`

## Pistas

<details>
<summary>Mostrar pistas</summary>

1. Encadena `.stream().filter(...).map(...).sorted(...)`.
2. `Collectors.toList()` o `.toList()` (Java 16+) materializan el resultado.
3. `IntStream.sum()` o `Stream.reduce` sirven para totalizar.

</details>

## Solución

<details>
<summary>Mostrar solución de referencia</summary>

Este ejercicio no tiene una única solución correcta. Antes de mirar cualquier solución
de referencia externa, intenta:

1. Releer la guía relacionada: [`03-colecciones.md`](../../../03-colecciones.md).
2. Escribir primero los `TODO` de `Main.java` con una implementación simple que funcione.
3. Ejecutar `MainTest.java` para verificar tu progreso y refinar el código.

</details>
