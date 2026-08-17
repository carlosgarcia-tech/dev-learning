# Ejercicio 01 — Streams avanzados

- **Nivel:** 4/5
- **Tema:** `groupingBy`, `flatMap`, `reduce`, `Collectors.toMap`, `Optional`
- **Tiempo estimado:** 30 min

## Enunciado

Crea un archivo `StreamsAvanzados.java` que parta de una lista de personas:

```java
List<Persona> personas = List.of(
    new Persona("Ana", 30, "Madrid"),
    new Persona("Luis", 25, "Barcelona"),
    new Persona("Ana", 20, "Barcelona"),
    new Persona("Pepe", 35, "Madrid"));
```

Donde `Persona` tiene `nombre`, `edad` y `ciudad`, con getters.

1. Agrupa las personas por ciudad con `Collectors.groupingBy(Persona::getCiudad)` e imprime cuántas hay en cada ciudad.
2. Con `flatMap`, toma una lista de listas de nombres (`List.of(List.of("a","b"), List.of("c"))`) y aplana a una sola lista de strings en mayúsculas.
3. Calcula la edad media de todas las personas con `mapToInt(Persona::getEdad).average().orElse(0)` (usa `Optional`).
4. Encuentra la persona más joven con `min(Comparator.comparingInt(Persona::getEdad)).orElse(null)`.
5. Agrupa las personas por nombre con `Collectors.toMap` manejando duplicados: `(p1, p2) -> p1` para quedarse con la primera.

Salida esperada:

```
Por ciudad: {Barcelona=2, Madrid=2}
Aplanado: [A, B, C]
Edad media: 27.5
Más joven: Ana (20)
Por nombre: {Pepe=Pepe (35), Luis=Luis (25), Ana=Ana (30)}
```

## Requisitos

- [ ] Usar `groupingBy` y `toMap` con función de fusión.
- [ ] Usar `flatMap` para aplanar listas.
- [ ] Usar `average()` y `min()` que devuelven `Optional`.
- [ ] Compilarlo localmente con `javac StreamsAvanzados.java` y ejecutarlo con `java StreamsAvanzados` para verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `Collectors.groupingBy(Persona::getCiudad)` devuelve `Map<String, List<Persona>>`.
- `flatMap`: primero `.stream()` sobre la lista de listas, luego `List::stream`.
- `average()` devuelve `OptionalDouble`; usa `.orElse(0)` para el `double`.
- `min(Comparator.comparingInt(...))` devuelve `Optional<Persona>`; `.orElse(null)`.
- `toMap(k -> v, (a, b) -> a)` resuelve claves repetidas quedándose con la primera.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````java
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.OptionalDouble;
import java.util.stream.Collectors;

public class StreamsAvanzados {
    static class Persona {
        private final String nombre;
        private final int edad;
        private final String ciudad;

        Persona(String nombre, int edad, String ciudad) {
            this.nombre = nombre;
            this.edad = edad;
            this.ciudad = ciudad;
        }

        public String getNombre() { return nombre; }
        public int getEdad() { return edad; }
        public String getCiudad() { return ciudad; }

        @Override
        public String toString() {
            return nombre + " (" + edad + ")";
        }
    }

    public static void main(String[] args) {
        List<Persona> personas = List.of(
                new Persona("Ana", 30, "Madrid"),
                new Persona("Luis", 25, "Barcelona"),
                new Persona("Ana", 20, "Barcelona"),
                new Persona("Pepe", 35, "Madrid"));

        Map<String, Long> porCiudad = personas.stream()
                .collect(Collectors.groupingBy(Persona::getCiudad,
                        Collectors.counting()));
        System.out.println("Por ciudad: " + porCiudad);

        List<List<String>> listas = List.of(List.of("a", "b"), List.of("c"));
        List<String> aplanado = listas.stream()
                .flatMap(l -> l.stream())
                .map(String::toUpperCase)
                .collect(Collectors.toList());
        System.out.println("Aplanado: " + aplanado);

        OptionalDouble mediaOpt = personas.stream()
                .mapToInt(Persona::getEdad)
                .average();
        System.out.println("Edad media: " + mediaOpt.orElse(0.0));

        Optional<Persona> joven = personas.stream()
                .min(Comparator.comparingInt(Persona::getEdad));
        System.out.println("Más joven: " + joven.orElse(null));

        Map<String, Persona> porNombre = personas.stream()
                .collect(Collectors.toMap(Persona::getNombre,
                        p -> p,
                        (p1, p2) -> p1));
        System.out.println("Por nombre: " + porNombre);
    }
}
````

</details>