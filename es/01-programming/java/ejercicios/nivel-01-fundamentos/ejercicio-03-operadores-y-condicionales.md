# Ejercicio 03 — Operadores y condicionales

- **Nivel:** 1/5
- **Tema:** operadores aritméticos, comparación, lógicos, `if/else`, ternario
- **Tiempo estimado:** 15 min

## Enunciado

Crea un archivo `Clasificador.java` que:

1. Declare tres variables `int a`, `b` y `c` con valores fijos (p. ej. 10, 20 y 30).
2. Imprima el resultado de `a + b`, `a * c`, `c / b` y `c % b`.
3. Compruebe si `a` es par o impar e imprima el resultado.
4. Imprima cuál de los tres números es el mayor, usando operadores lógicos `&&` para comparar.
5. Use un ternario para imprimir si la suma de `a` y `b` es mayor que `c`.

Salida esperada (con a=10, b=20, c=30):

```
a + b = 30
a * c = 300
c / b = 1
c % b = 10
10 es par
El mayor es 30
La suma de a y b (30) no es mayor que c (30)
```

## Requisitos

- [ ] Usar al menos una vez los operadores `+`, `*`, `/` y `%`.
- [ ] Determinar paridad con el operador `%`.
- [ ] Encontrar el mayor con `if/else` y operadores lógicos.
- [ ] Usar un operador ternario en el último punto.
- [ ] Compilarlo localmente con `javac Clasificador.java` y ejecutarlo con `java Clasificador` para verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- La división entera trunca: `30 / 20` da `1`.
- `a % 2 == 0` indica que `a` es par.
- Para el mayor: `if (a >= b && a >= c) { ... }`.
- Ternario: `String mensaje = condicion ? "opción A" : "opción B";`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````java
public class Clasificador {
    public static void main(String[] args) {
        int a = 10;
        int b = 20;
        int c = 30;

        System.out.println("a + b = " + (a + b));
        System.out.println("a * c = " + (a * c));
        System.out.println("c / b = " + (c / b));
        System.out.println("c % b = " + (c % b));

        if (a % 2 == 0) {
            System.out.println(a + " es par");
        } else {
            System.out.println(a + " es impar");
        }

        if (a >= b && a >= c) {
            System.out.println("El mayor es " + a);
        } else if (b >= a && b >= c) {
            System.out.println("El mayor es " + b);
        } else {
            System.out.println("El mayor es " + c);
        }

        String mensaje = (a + b > c) ? "La suma de a y b es mayor que c"
                                     : "La suma de a y b (" + (a + b) + ") no es mayor que c (" + c + ")";
        System.out.println(mensaje);
    }
}
````

</details>