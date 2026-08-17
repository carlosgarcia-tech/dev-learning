# Ejercicio 04 — Bucles

- **Nivel:** 1/5
- **Tema:** `for`, `while`, `do...while`, `break` y `continue`
- **Tiempo estimado:** 15 min

## Enunciado

Crea un archivo `Bucles.java` que:

1. Imprima los números del 1 al 10 con un bucle `for`.
2. Calcule la suma de los primeros 100 números naturales con `for` e imprima el resultado.
3. Use `while` para imprimir los múltiplos de 3 desde 3 hasta 30.
4. Use `do...while` para imprimir "Intento N" al menos una vez, incluso si la condición ya es falsa.
5. Con un `for` del 1 al 20, imprima los números pares usando `continue` para saltar los impares.

Salida esperada (resumen):

```
1 2 3 4 5 6 7 8 9 10
Suma 1..100 = 5050
3 6 9 12 15 18 21 24 27 30
Intento 1
2 4 6 8 10 12 14 16 18 20
```

## Requisitos

- [ ] Usar los tres tipos de bucle (`for`, `while`, `do...while`).
- [ ] Usar `continue` para saltar iteraciones en un bucle.
- [ ] La suma de 1..100 debe dar exactamente 5050.
- [ ] Compilarlo localmente con `javac Bucles.java` y ejecutarlo con `java Bucles` para verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `System.out.print(valor + " ")` imprime en la misma línea; añade `System.out.println()` para saltar.
- `while` comprueba la condición **antes**; `do...while` la comprueba **después**.
- Para los pares: `if (n % 2 != 0) continue;` salta los impares.
- En el `do...while`, usa una variable inicializada en `false` o `0` para demostrar que entra al menos una vez.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````java
public class Bucles {
    public static void main(String[] args) {
        for (int i = 1; i <= 10; i++) {
            System.out.print(i + " ");
        }
        System.out.println();

        int suma = 0;
        for (int i = 1; i <= 100; i++) {
            suma += i;
        }
        System.out.println("Suma 1..100 = " + suma);

        int n = 3;
        while (n <= 30) {
            System.out.print(n + " ");
            n += 3;
        }
        System.out.println();

        int intento = 0;
        do {
            System.out.println("Intento " + (intento + 1));
            intento++;
        } while (intento < 0); // condición falsa: entra igualmente una vez

        for (int i = 1; i <= 20; i++) {
            if (i % 2 != 0) {
                continue; // salta los impares
            }
            System.out.print(i + " ");
        }
        System.out.println();
    }
}
````

</details>