# Ejercicio 05 — Arrays básicos

- **Nivel:** 1/5
- **Tema:** declaración de arrays, índices, `for-each`, `Arrays`
- **Tiempo estimado:** 15 min

## Enunciado

Crea un archivo `ArraysBasicos.java` que:

1. Declare un array de enteros con los valores `{5, 8, 2, 10, 3}`.
2. Imprima la longitud del array y el primer y el último elemento.
3. Imprima todos los elementos con un bucle `for` usando el índice.
4. Imprima todos los elementos con un bucle `for-each`.
5. Calcule la suma y el valor máximo del array (puedes usar `java.util.Arrays` para el orden o hacerlo a mano).

Salida esperada:

```
Longitud: 5
Primero: 5, Último: 3
Con for: 5 8 2 10 3
Con for-each: 5 8 2 10 3
Suma: 28, Máximo: 10
```

## Requisitos

- [ ] Declarar el array con la sintaxis `int[] numeros = { ... };`.
- [ ] Acceder a elementos por índice con `numeros[0]` y `numeros[numeros.length - 1]`.
- [ ] Recorrer con `for` y con `for-each`.
- [ ] Calcular suma y máximo sin usar métodos predefinidos (con bucles).
- [ ] Compilarlo localmente con `javac ArraysBasicos.java` y ejecutarlo con `java ArraysBasicos` para verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `array.length` da el número de elementos (sin paréntesis: no es un método).
- El último índice es `array.length - 1`.
- Para el máximo: parte de `Integer.MIN_VALUE` o del primer elemento y compara.
- El for-each es: `for (int n : numeros) { ... }`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````java
public class ArraysBasicos {
    public static void main(String[] args) {
        int[] numeros = {5, 8, 2, 10, 3};

        System.out.println("Longitud: " + numeros.length);
        System.out.println("Primero: " + numeros[0]
                + ", Último: " + numeros[numeros.length - 1]);

        System.out.print("Con for: ");
        for (int i = 0; i < numeros.length; i++) {
            System.out.print(numeros[i] + " ");
        }
        System.out.println();

        System.out.print("Con for-each: ");
        for (int n : numeros) {
            System.out.print(n + " ");
        }
        System.out.println();

        int suma = 0;
        int maximo = numeros[0];
        for (int n : numeros) {
            suma += n;
            if (n > maximo) {
                maximo = n;
            }
        }
        System.out.println("Suma: " + suma + ", Máximo: " + maximo);
    }
}
````

</details>