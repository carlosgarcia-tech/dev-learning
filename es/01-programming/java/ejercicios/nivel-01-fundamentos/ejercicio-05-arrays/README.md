# Ejercicio 05 — Arrays

- **Nivel:** 1/5
- **Tema:** Fundamentos de Java
- **Tiempo estimado:** 20 minutos

## Enunciado

Crea un array de 10 enteros, llénalo con valores aleatorios entre 1 y 100, y escribe métodos para: encontrar el máximo, encontrar el mínimo, calcular el promedio y ordenarlo (puedes usar `Arrays.sort` o implementar burbuja manualmente). Crea también una matriz 3x3 y calcula la suma de su diagonal principal.

## Requisitos

- [ ] El programa compila sin errores (`javac Main.java`)
- [ ] El programa se ejecuta correctamente (`java Main`)
- [ ] La solución cubre todos los puntos del enunciado
- [ ] El código sigue las convenciones de Java (camelCase, indentación, nombres descriptivos)
- [ ] Los tests pasan: `java MainTest`

## Pistas

<details>
<summary>Mostrar pistas</summary>

1. `java.util.Arrays` tiene utilidades como `sort`, `toString` y `copyOf`.
2. Recorre la matriz con dos bucles anidados: `matriz[i][i]` es la diagonal principal.
3. `java.util.Random` sirve para generar los valores aleatorios.

</details>

## Solución

<details>
<summary>Mostrar solución de referencia</summary>

Este ejercicio no tiene una única solución correcta. Antes de mirar cualquier solución
de referencia externa, intenta:

1. Releer la guía relacionada: [`01-fundamentos.md`](../../../01-fundamentos.md).
2. Escribir primero los `TODO` de `Main.java` con una implementación simple que funcione.
3. Ejecutar `MainTest.java` para verificar tu progreso y refinar el código.

</details>
