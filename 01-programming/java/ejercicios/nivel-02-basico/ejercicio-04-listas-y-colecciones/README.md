# Ejercicio 10 — Listas y Colecciones

- **Nivel:** 2/5
- **Tema:** Colecciones
- **Tiempo estimado:** 25 minutos

## Enunciado

Usando un `ArrayList<String>`, gestiona una lista de tareas pendientes: agregar, eliminar por nombre, marcar como completada (puedes usar un `Map<String, Boolean>`), y listar solo las pendientes.

## Requisitos

- [ ] El programa compila sin errores (`javac Main.java`)
- [ ] El programa se ejecuta correctamente (`java Main`)
- [ ] La solución cubre todos los puntos del enunciado
- [ ] El código sigue las convenciones de Java (camelCase, indentación, nombres descriptivos)
- [ ] Los tests pasan: `java MainTest`

## Pistas

<details>
<summary>Mostrar pistas</summary>

1. `ArrayList` mantiene el orden de inserción y permite duplicados.
2. `Map.getOrDefault` evita `NullPointerException` al consultar claves inexistentes.
3. Usa streams (`filter`) para listar solo las tareas pendientes.

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
