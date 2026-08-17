# Ejercicio 01 — Hola Mundo

- **Nivel:** 1/5
- **Tema:** Fundamentos de Java
- **Tiempo estimado:** 10 minutos

## Enunciado

Crea un programa en Java que:

1. Declare un paquete llamado `com.ejercicio.holamundo`.
2. Cree una clase llamada `Main`.
3. Implemente el método `main`.
4. Muestre por consola "¡Hola, mundo!".
5. Muestre también un saludo personalizado que incluya tu nombre.

## Requisitos

- [ ] El programa compila sin errores (`javac Main.java`)
- [ ] El programa se ejecuta correctamente (`java Main`)
- [ ] La salida incluye "¡Hola, mundo!"
- [ ] La salida incluye un saludo personalizado con tu nombre
- [ ] Se utiliza `System.out.println` correctamente
- [ ] Los tests pasan: `java MainTest`

## Pistas

<details>
<summary>Mostrar pistas</summary>

1. El método `main` tiene una firma específica: `public static void main(String[] args)`
2. `System.out.println()` imprime un mensaje y salta de línea
3. Puedes concatenar strings con el operador `+`
4. No olvides el punto y coma `;` al final de cada sentencia
5. El nombre del archivo debe coincidir con el nombre de la clase

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

```java
package com.ejercicio.holamundo;

public class Main {
    public static void main(String[] args) {
        System.out.println("¡Hola, mundo!");
        System.out.println("Mi nombre es [Tu nombre]");
    }
}
```

</details>
