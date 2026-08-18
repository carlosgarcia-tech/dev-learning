# Ejercicio 26 — Servidor Socket

- **Nivel:** 5/5
- **Tema:** Redes y Concurrencia
- **Tiempo estimado:** 45 minutos

## Enunciado

Implementa un servidor TCP simple con `ServerSocket` que reciba un mensaje de un cliente y responda con el mismo mensaje en mayúsculas ("echo" transformado). Implementa también un cliente `Socket` de prueba.

## Requisitos

- [ ] El programa compila sin errores (`javac Main.java`)
- [ ] El programa se ejecuta correctamente (`java Main`)
- [ ] La solución cubre todos los puntos del enunciado
- [ ] El código sigue las convenciones de Java (camelCase, indentación, nombres descriptivos)
- [ ] Los tests pasan: `java MainTest`

## Pistas

<details>
<summary>Mostrar pistas</summary>

1. `ServerSocket.accept()` bloquea hasta que llega una conexión.
2. Usa `BufferedReader`/`PrintWriter` sobre los streams del socket para leer/escribir texto línea a línea.
3. Cierra siempre los sockets con `try-with-resources`.

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
