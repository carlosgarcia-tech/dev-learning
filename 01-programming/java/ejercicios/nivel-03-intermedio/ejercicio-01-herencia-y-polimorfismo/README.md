# Ejercicio 13 — Herencia y Polimorfismo

- **Nivel:** 3/5
- **Tema:** POO Avanzada
- **Tiempo estimado:** 30 minutos

## Enunciado

Crea una jerarquía `Vehiculo` (clase base) con subclases `Coche` y `Motocicleta`. Cada subclase debe sobrescribir un método `describir()`. Crea un array de tipo `Vehiculo[]` con instancias mezcladas y recórrelo demostrando polimorfismo.

## Requisitos

- [ ] El programa compila sin errores (`javac Main.java`)
- [ ] El programa se ejecuta correctamente (`java Main`)
- [ ] La solución cubre todos los puntos del enunciado
- [ ] El código sigue las convenciones de Java (camelCase, indentación, nombres descriptivos)
- [ ] Los tests pasan: `java MainTest`

## Pistas

<details>
<summary>Mostrar pistas</summary>

1. Usa `super(...)` en el constructor de la subclase para invocar al constructor padre.
2. El tipo de la variable puede ser la superclase aunque el objeto sea de la subclase.
3. `@Override` ayuda al compilador a detectar errores de sobrescritura.

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
