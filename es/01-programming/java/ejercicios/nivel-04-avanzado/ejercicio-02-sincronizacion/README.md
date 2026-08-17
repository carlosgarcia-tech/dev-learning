# Ejercicio 20 — Sincronización

- **Nivel:** 4/5
- **Tema:** Concurrencia
- **Tiempo estimado:** 30 minutos

## Enunciado

Implementa un `ContadorCompartido` con un método `incrementar()` sin sincronizar y demuestra (lanzando varios hilos que lo incrementen muchas veces) que el resultado final es incorrecto. Luego corrígelo usando `synchronized` o `AtomicInteger` y demuestra que el resultado ahora es correcto.

## Requisitos

- [ ] El programa compila sin errores (`javac Main.java`)
- [ ] El programa se ejecuta correctamente (`java Main`)
- [ ] La solución cubre todos los puntos del enunciado
- [ ] El código sigue las convenciones de Java (camelCase, indentación, nombres descriptivos)
- [ ] Los tests pasan: `java MainTest`

## Pistas

<details>
<summary>Mostrar pistas</summary>

1. Lanza al menos 10 hilos que incrementen el contador 1000 veces cada uno.
2. Compara el resultado esperado (10000) contra el resultado real sin sincronizar.
3. `AtomicInteger.incrementAndGet()` es una alternativa sin bloqueos explícitos.

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
