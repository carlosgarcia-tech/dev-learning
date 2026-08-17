# Ejercicio 28 — Productor-Consumidor

- **Nivel:** 5/5
- **Tema:** Concurrencia
- **Tiempo estimado:** 40 minutos

## Enunciado

Implementa el patrón productor-consumidor usando `BlockingQueue`: un hilo productor genera números y los coloca en la cola; un hilo consumidor los toma y los procesa (por ejemplo, los suma). Al finalizar, imprime el total procesado.

## Requisitos

- [ ] El programa compila sin errores (`javac Main.java`)
- [ ] El programa se ejecuta correctamente (`java Main`)
- [ ] La solución cubre todos los puntos del enunciado
- [ ] El código sigue las convenciones de Java (camelCase, indentación, nombres descriptivos)
- [ ] Los tests pasan: `java MainTest`

## Pistas

<details>
<summary>Mostrar pistas</summary>

1. `LinkedBlockingQueue` bloquea automáticamente si está llena (`put`) o vacía (`take`).
2. Usa un valor centinela (por ejemplo `-1`) para indicarle al consumidor que termine.
3. Maneja `InterruptedException` restaurando el estado de interrupción del hilo.

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
