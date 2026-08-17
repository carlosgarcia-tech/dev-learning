# Ejercicio 02 — Variables y tipos

- **Nivel:** 1/5
- **Tema:** tipos primitivos, `String`, `final`, `System.out.printf`
- **Tiempo estimado:** 15 min

## Enunciado

Crea un archivo `Variables.java` que:

1. Declare con `final` (constante) tu nombre (String) y tu ciudad de nacimiento.
2. Declare tu edad con `int` y un booleano que indique si estudias programación.
3. Declare tu estatura en metros con `double`.
4. Imprima una línea con `System.out.printf` que muestre: nombre, edad, ciudad, estatura y el booleano.

Salida esperada (ejemplo):

```
Ana, 30 años, de Lima, mide 1.72 m, estudia programación: true
```

## Requisitos

- [ ] Usar `final` para nombre y ciudad (no deben cambiar).
- [ ] Usar los tipos `int`, `double` y `boolean` correctamente.
- [ ] Imprimir con `System.out.printf` y los formatos `%s`, `%d`, `%.2f` y `%b`.
- [ ] Compilarlo localmente con `javac Variables.java` y ejecutarlo con `java Variables` para verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Sintaxis: `final String nombre = "Ana";` y `int edad = 30;`.
- `System.out.printf("...", valor1, valor2);` sustituye cada formato por un valor.
- `%s` para texto, `%d` para enteros, `%.2f` para decimales con 2 cifras, `%b` para booleanos.
- Recuerda añadir `\n` al final si quieres saltar de línea.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````java
public class Variables {
    public static void main(String[] args) {
        final String nombre = "Ana";
        final String ciudad = "Lima";
        int edad = 30;
        boolean estudiaProgramacion = true;
        double estatura = 1.72;

        System.out.printf(
            "%s, %d años, de %s, mide %.2f m, estudia programación: %b%n",
            nombre, edad, ciudad, estatura, estudiaProgramacion
        );
    }
}
````

</details>