# Ejercicio 23 — Testing

- **Nivel:** 4/5
- **Tema:** Buenas Prácticas
- **Tiempo estimado:** 25 minutos

## Enunciado

Escribe una clase `Validador` con métodos `esEmailValido(String email)` y `esMayorDeEdad(int edad)`. Escribe una suite de tests manual (sin JUnit, usando el mismo patrón `MainTest` del curso) que cubra casos válidos, inválidos y límite para ambos métodos.

## Requisitos

- [ ] El programa compila sin errores (`javac Main.java`)
- [ ] El programa se ejecuta correctamente (`java Main`)
- [ ] La solución cubre todos los puntos del enunciado
- [ ] El código sigue las convenciones de Java (camelCase, indentación, nombres descriptivos)
- [ ] Los tests pasan: `java MainTest`

## Pistas

<details>
<summary>Mostrar pistas</summary>

1. Piensa en casos límite: edad exactamente 18, email sin '@', email vacío.
2. Un buen test es determinista: siempre da el mismo resultado con la misma entrada.
3. Si usas JUnit en tu propio entorno, la estructura de los tests es equivalente (Arrange-Act-Assert).

</details>

## Solución

<details>
<summary>Mostrar solución de referencia</summary>

Este ejercicio no tiene una única solución correcta. Antes de mirar cualquier solución
de referencia externa, intenta:

1. Releer la guía relacionada: [`04-excepciones.md`](../../../04-excepciones.md).
2. Escribir primero los `TODO` de `Main.java` con una implementación simple que funcione.
3. Ejecutar `MainTest.java` para verificar tu progreso y refinar el código.

</details>
