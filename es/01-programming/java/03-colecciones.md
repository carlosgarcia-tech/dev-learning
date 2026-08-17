# 03 — Colecciones y Streams

## Objetivos

- [ ] Usar `ArrayList<E>` para listas dinámicas.
- [ ] Usar `HashMap<K, V>` para mapas clave-valor.
- [ ] Usar `HashSet<E>` para conjuntos sin duplicados.
- [ ] Recorrer colecciones con bucles y con el bucle for-each.
- [ ] Comprender las interfaces `List`, `Map`, `Set` y sus implementaciones.
- [ ] Aplicar streams para filtrar, transformar y reducir datos.

## Apuntes

### La interfaz Collection

Las colecciones de Java agrupan elementos en estructuras dinámicas. Las tres interfaces más importantes:

- `List<E>` — secuencia ordenada, permite duplicados. Implementaciones: `ArrayList`, `LinkedList`.
- `Set<E>` — no admite duplicados. Implementaciones: `HashSet`, `LinkedHashSet`, `TreeSet`.
- `Map<K, V>` — asociaciones clave→valor (no extiende `Collection`). Implementaciones: `HashMap`, `LinkedHashMap`, `TreeMap`.

Todas usan **genéricos**: `<Tipo>` indica qué tipo de objetos guardan.

### ArrayList

Lista redimensionable: crece automáticamente. Acceso por índice en O(1).

```java
import java.util.ArrayList;
import java.util.List;

List<String> frutas = new ArrayList<>();
frutas.add("manzana");
frutas.add("pera");
frutas.add("uva");
frutas.add(1, "mango");        // inserta en la posición 1

System.out.println(frutas.size());    // 4
System.out.println(frutas.get(0));    // manzana
System.out.println(frutas.contains("uva")); // true
frutas.remove("pera");
frutas.remove(0);                     // por índice

for (String fruta : frutas) {
    System.out.println(fruta);
}
```

- `List.of(...)` crea una lista **inmutable** (Java 9+): no puedes `add` ni `remove`.
- Prefiere declarar el tipo como `List<String>` (la interfaz) y asignar `new ArrayList<>()`. Así puedes cambiar la implementación sin tocar el resto.

### HashMap

Guarda pares clave→valor. Las claves son únicas (si repites clave, sobrescribes el valor).

```java
import java.util.HashMap;
import java.util.Map;

Map<String, Integer> edades = new HashMap<>();
edades.put("Ana", 30);
edades.put("Luis", 25);
edades.put("Ana", 31);        // sobrescribe: Ana ahora vale 31

System.out.println(edades.get("Ana"));        // 31
System.out.println(edades.containsKey("Luis")); // true
System.out.println(edades.getOrDefault("Pepe", 0)); // 0 (no existe)

for (String nombre : edades.keySet()) {
    System.out.println(nombre + " -> " + edades.get(nombre));
}

for (Map.Entry<String, Integer> e : edades.entrySet()) {
    System.out.println(e.getKey() + " -> " + e.getValue());
}
```

### HashSet

Conjunto sin duplicados. No garantiza orden. Rápido para comprobar pertenencia.

```java
import java.util.HashSet;
import java.util.Set;

Set<String> tags = new HashSet<>();
tags.add("java");
tags.add("streams");
tags.add("java");            // ignorado: ya existe

System.out.println(tags.size());          // 2
System.out.println(tags.contains("java")); // true
```

Para que un objeto propio se comporte bien en `HashSet`/`HashMap` necesita `equals()` y `hashCode()` consistentes (lo ves en la guía de excepciones/ejercicios).

### Streams

Un **stream** es una secuencia de operaciones sobre datos (Java 8+). No modifica la colección original: produce un resultado nuevo. Pipe de operaciones:

1. **Fuente:** `lista.stream()`.
2. **Operaciones intermedias:** `filter`, `map`, `sorted`, `distinct` — devuelven otro stream, son *lazy*.
3. **Operación terminal:** `collect`, `forEach`, `count`, `reduce` — dispara la ejecución.

```java
import java.util.List;

List<Integer> numeros = List.of(5, 3, 8, 1, 3, 9);

List<Integer> paresOrdenados = numeros.stream()
        .filter(n -> n % 2 == 0)          // 8
        .sorted()
        .collect(java.util.stream.Collectors.toList());

long cantidadPares = numeros.stream()
        .filter(n -> n % 2 == 0)
        .count();                          // 1 (solo el 8)

int suma = numeros.stream().mapToInt(n -> n).sum(); // 29

numeros.stream().distinct().forEach(System.out::println);
```

- `map` transforma cada elemento: `nombres.stream().map(String::toUpperCase)`.
- `reduce` combina todos los elementos en uno: `numeros.stream().reduce(0, (a, b) -> a + b)`.

## Ejemplos de código

```java
// Filtrar y transformar una lista de personas
import java.util.List;
import java.util.stream.Collectors;

public class Persona {
    private String nombre;
    private int edad;

    public Persona(String nombre, int edad) {
        this.nombre = nombre;
        this.edad = edad;
    }

    public String getNombre() { return nombre; }
    public int getEdad() { return edad; }

    public static void main(String[] args) {
        List<Persona> personas = List.of(
                new Persona("Ana", 30),
                new Persona("Luis", 17),
                new Persona("Pepe", 25));

        List<String> adultos = personas.stream()
                .filter(p -> p.getEdad() >= 18)
                .map(Persona::getNombre)
                .collect(Collectors.toList());

        System.out.println(adultos); // [Ana, Pepe]
    }
}
```

## Ejercicios relacionados

- [Ejercicios nivel 03 — Intermedio](../ejercicios/nivel-03-intermedio/)

## Errores comunes

- **`List.of` y luego `add`** → lanza `UnsupportedOperationException` porque la lista es inmutable.
- **Recorrer un `HashMap` y modificar su tamaño** → `ConcurrentModificationException`. Recoge antes lo que necesites o usa el stream.
- **Suponer que `HashSet` mantiene orden** → no lo hace. Usa `LinkedHashSet` (orden de inserción) o `TreeSet` (orden natural).
- **Duplicados en `HashMap`** → reinsertar una clave sobrescribe el valor; si esperabas conservarlo, revisa la lógica.
- **Olvidar los genéricos** → `List lista = new ArrayList();` compila con warning y pierde seguridad de tipos.
- **Usar `==` con elementos de colecciones** → para objetos (strings incluidos) usa `equals()`.

## Recursos

- [Oracle — Collections Overview](https://docs.oracle.com/javase/tutorial/collections/intro/index.html)
- [Java ArrayList API](https://docs.oracle.com/en/java/javase/17/docs/api/java.base/java/util/ArrayList.html)
- [Java Stream API](https://docs.oracle.com/en/java/javase/17/docs/api/java.base/java/util/stream/Stream.html)
- [Baeldung — Guide to Java Streams](https://www.baeldung.com/java-8-streams)