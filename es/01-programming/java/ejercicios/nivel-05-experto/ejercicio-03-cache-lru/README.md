# Ejercicio 27 — Cache LRU

- **Nivel:** 5/5
- **Tema:** Estructuras de Datos
- **Tiempo estimado:** 40 minutos

## Enunciado

Implementa una caché LRU (Least Recently Used) de capacidad fija usando `LinkedHashMap` con `accessOrder = true`, sobrescribiendo `removeEldestEntry` para expulsar automáticamente la entrada menos usada al superar la capacidad.

## Requisitos

- [ ] El programa compila sin errores (`javac Main.java`)
- [ ] El programa se ejecuta correctamente (`java Main`)
- [ ] La solución cubre todos los puntos del enunciado
- [ ] El código sigue las convenciones de Java (camelCase, indentación, nombres descriptivos)
- [ ] Los tests pasan: `java MainTest`

## Pistas

<details>
<summary>Mostrar pistas</summary>

1. `new LinkedHashMap<>(capacidadInicial, factorCarga, true)` habilita el orden por acceso.
2. `removeEldestEntry(Map.Entry eldest)` decide si se elimina la entrada más antigua.
3. Prueba insertando más elementos que la capacidad y verifica cuál se expulsa.

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
