# Ejercicio 19 — Threads

- **Nivel:** 4/5
- **Tema:** Concurrencia
- **Tiempo estimado:** 30 minutos

## Enunciado

Crea dos hilos: uno que imprima los números pares del 1 al 20 y otro los impares, ambos con una pequeña pausa (`Thread.sleep`) entre iteraciones. Usa `Thread.join()` en el hilo principal para esperar a que ambos terminen antes de imprimir un mensaje final.

## Requisitos

- [ ] El programa compila sin errores (`javac Main.java`)
- [ ] El programa se ejecuta correctamente (`java Main`)
- [ ] La solución cubre todos los puntos del enunciado
- [ ] El código sigue las convenciones de Java (camelCase, indentación, nombres descriptivos)
- [ ] Los tests pasan: `java MainTest`

## Pistas

<details>
<summary>Mostrar pistas</summary>

1. Implementa `Runnable` en vez de extender `Thread` cuando sea posible.
2. `start()` inicia un hilo nuevo; `run()` ejecuta en el hilo actual (no lo uses directamente).
3. `join()` bloquea el hilo llamador hasta que el hilo referenciado termine.

</details>

## Solución

<details>
<summary>Mostrar solución de referencia</summary>

Este ejercicio no tiene una única solución correcta. Antes de mirar cualquier solución
de referencia externa, intenta:

1. Releer la guía relacionada: [`05-concurrencia.md`](../../../05-concurrencia.md).
2. Escribir primero los `TODO` de `Main.java` con una implementación simple que funcione.
3. Ejecutar `MainTest.java` para verificar tu progreso y refinar el código.

</details>
