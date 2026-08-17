# Ejercicio 05 — Streams básicos

- **Nivel:** 3/5
- **Tema:** `stream()`, `filter`, `map`, `sorted`, `collect`, `count`
- **Tiempo estimado:** 25 min

## Enunciado

Crea un archivo `StreamsBasicos.java` que parta de la lista:

```java
List<Integer> numeros = List.of(12, 5, 8, 21, 3, 34, 1, 8);
```

Y realice con streams:

1. Filtrar los números pares, ordenarlos y guardarlos en una lista nueva (imprímela).
2. Contar cuántos números son mayores que 10 con `filter(...).count()`.
3. Transformar cada número a su cuadrado con `map` e imprimir el resultado de cada uno con `forEach`.
4. Obtener los números únicos con `distinct()` y sumarlos con `mapToInt(...).sum()`.
5. Comprobar si **algún** número es mayor que 30 con `anyMatch`.

Salida esperada:

```
Pares ordenados: [8, 8, 12, 34]
Mayores que 10: 3
Cuadrados: 144 25 64 441 9 1156 1 64
Suma de únicos: 84
¿Algún número > 30? true
```

## Requisitos

- [ ] Usar `filter`, `map`, `sorted`, `distinct` y `count`.
- [ ] Recolectar el resultado con `Collectors.toList()`.
- [ ] Usar `mapToInt(...).sum()` para la suma.
- [ ] Usar `anyMatch` para la comprobación booleana.
- [ ] Compilarlo localmente con `javac StreamsBasicos.java` y ejecutarlo con `java StreamsBasicos` para verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `numeros.stream().filter(n -> n % 2 == 0).sorted().collect(Collectors.toList())`.
- Las operaciones intermedias no se ejecutan hasta que hay una terminal (`collect`, `forEach`, `count`).
- `distinct()` elimina duplicados; los únicos `[12,5,8,21,3,34,1]` suman 84.
- `anyMatch` devuelve `boolean` y corta en cuanto encuentra una coincidencia.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````java
import java.util.List;
import java.util.stream.Collectors;

public class StreamsBasicos {
    public static void main(String[] args) {
        List<Integer> numeros = List.of(12, 5, 8, 21, 3, 34, 1, 8);

        List<Integer> paresOrdenados = numeros.stream()
                .filter(n -> n % 2 == 0)
                .sorted()
                .collect(Collectors.toList());
        System.out.println("Pares ordenados: " + paresOrdenados);

        long mayoresQue10 = numeros.stream()
                .filter(n -> n > 10)
                .count();
        System.out.println("Mayores que 10: " + mayoresQue10);

        System.out.print("Cuadrados: ");
        numeros.stream()
                .map(n -> n * n)
                .forEach(n -> System.out.print(n + " "));
        System.out.println();

        int sumaUnicos = numeros.stream()
                .distinct()
                .mapToInt(n -> n)
                .sum();
        System.out.println("Suma de únicos: " + sumaUnicos);

        boolean algunMayorQue30 = numeros.stream().anyMatch(n -> n > 30);
        System.out.println("¿Algún número > 30? " + algunMayorQue30);
    }
}
````

</details>