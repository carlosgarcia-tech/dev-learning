# Ejercicio 25 — Gestor de Tareas CLI

- **Nivel:** 5/5
- **Tema:** Proyecto Integrador
- **Tiempo estimado:** 45 minutos

## Enunciado

Construye una aplicación de consola que permita, mediante un menú con `Scanner`, agregar, listar, completar y eliminar tareas (almacenadas en memoria con una `List`). El programa debe correr en un bucle hasta que el usuario elija salir.

## Requisitos

- [ ] El programa compila sin errores (`javac Main.java`)
- [ ] El programa se ejecuta correctamente (`java Main`)
- [ ] La solución cubre todos los puntos del enunciado
- [ ] El código sigue las convenciones de Java (camelCase, indentación, nombres descriptivos)
- [ ] Los tests pasan: `java MainTest`

## Pistas

<details>
<summary>Mostrar pistas</summary>

1. Usa un `switch` sobre la opción del menú para dirigir el flujo.
2. Encapsula las tareas en una clase `Tarea` con `descripcion` y `completada`.
3. Valida siempre la entrada del usuario antes de usarla (índices fuera de rango, etc.).

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
