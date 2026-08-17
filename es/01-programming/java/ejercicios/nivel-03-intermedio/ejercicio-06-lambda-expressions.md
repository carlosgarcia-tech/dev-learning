# Ejercicio 06 — Lambda expressions

- **Nivel:** 3/5
- **Tema:** interfaces funcionales, lambdas, `Predicate`, `Consumer`, `Function`
- **Tiempo estimado:** 25 min

## Enunciado

Crea un archivo `Lambdas.java` que:

1. Defina una interfaz funcional `Operacion` con el método `int calcular(int a, int b);`.
2. Cree tres lambdas con ella: `suma`, `resta` y `multiplicacion`.
3. Use la interfaz `java.util.function.Predicate<Integer>` para crear un predicado `esPar` y otro `esMayorQue10`, y aplíquelos a varios números imprimiendo los resultados.
4. Use `java.util.function.Function<String, Integer>` para crear `longitud` (devuelve `String::length`) y aplíquelo a `"Java"`.
5. Use `java.util.function.Consumer<String>` con una lambda que imprima `"-> " + s` y aplíquelo a dos nombres.
6. Llame a un método `aplicar(Operacion op, int a, int b)` que imprima el resultado de aplicar la operación.

Salida esperada:

```
Suma: 8, Resta: 2, Multiplicación: 15
¿4 es par? true, ¿7 es par? false
¿11 mayor que 10? true
Longitud de "Java": 4
-> Ana
-> Luis
Aplicar: 8
Aplicar: 15
```

## Requisitos

- [ ] Definir y usar una interfaz funcional propia (`Operacion`).
- [ ] Usar `Predicate`, `Function` y `Consumer` de `java.util.function`.
- [ ] Pasar lambdas como argumento a un método (`aplicar`).
- [ ] Compilarlo localmente con `javac Lambdas.java` y ejecutarlo con `java Lambdas` para verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Una interfaz funcional tiene **un solo** método abstracto.
- Lambda: `(a, b) -> a + b`.
- `Predicate<Integer>`: `n -> n % 2 == 0`, se usa con `.test(n)`.
- `Function<String, Integer>`: `s -> s.length()`, se usa con `.apply(s)`.
- `Consumer<String>`: `s -> System.out.println("-> " + s)`, se usa con `.accept(s)`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````java
import java.util.function.Consumer;
import java.util.function.Function;
import java.util.function.Predicate;

public class Lambdas {
    interface Operacion {
        int calcular(int a, int b);
    }

    public static void aplicar(Operacion op, int a, int b) {
        System.out.println("Aplicar: " + op.calcular(a, b));
    }

    public static void main(String[] args) {
        Operacion suma = (a, b) -> a + b;
        Operacion resta = (a, b) -> a - b;
        Operacion multiplicacion = (a, b) -> a * b;

        System.out.println("Suma: " + suma.calcular(5, 3)
                + ", Resta: " + resta.calcular(5, 3)
                + ", Multiplicación: " + multiplicacion.calcular(5, 3));

        Predicate<Integer> esPar = n -> n % 2 == 0;
        Predicate<Integer> esMayorQue10 = n -> n > 10;
        System.out.println("¿4 es par? " + esPar.test(4)
                + ", ¿7 es par? " + esPar.test(7));
        System.out.println("¿11 mayor que 10? " + esMayorQue10.test(11));

        Function<String, Integer> longitud = s -> s.length();
        System.out.println("Longitud de \"Java\": " + longitud.apply("Java"));

        Consumer<String> mostrar = s -> System.out.println("-> " + s);
        mostrar.accept("Ana");
        mostrar.accept("Luis");

        aplicar(suma, 5, 3);
        aplicar(multiplicacion, 5, 3);
    }
}
````

</details>