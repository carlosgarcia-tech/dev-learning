# 03 — Colecciones en Java

## Objetivos

- [ ] Entender el Java Collections Framework
- [ ] Usar `List` (`ArrayList`, `LinkedList`)
- [ ] Usar `Set` (`HashSet`, `LinkedHashSet`, `TreeSet`)
- [ ] Usar `Map` (`HashMap`, `LinkedHashMap`, `TreeMap`)
- [ ] Ordenar colecciones con `Comparator` y `Comparable`
- [ ] Usar la Stream API para procesar colecciones
- [ ] Conocer las diferencias de rendimiento entre implementaciones

## Apuntes

### El Java Collections Framework

Todas las colecciones implementan interfaces comunes: `Collection`, `List`, `Set`, `Queue`, `Map`
(este último no extiende `Collection`, pero se considera parte del framework).

```
Collection
├── List   (orden, permite duplicados)      → ArrayList, LinkedList, Vector
├── Set    (sin duplicados)                 → HashSet, LinkedHashSet, TreeSet
└── Queue  (FIFO / prioridad)                → LinkedList, PriorityQueue, ArrayDeque

Map (clave-valor, sin duplicados de clave)  → HashMap, LinkedHashMap, TreeMap
```

### List

```java
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

List<String> nombres = new ArrayList<>();
nombres.add("Ana");
nombres.add("Juan");
nombres.add(1, "María"); // inserta en posición 1

nombres.get(0);              // "Ana"
nombres.set(0, "Andrea");    // reemplaza
nombres.remove("Juan");      // elimina por valor
nombres.remove(0);           // elimina por índice
nombres.contains("María");   // true
nombres.size();              // tamaño actual
nombres.isEmpty();

// LinkedList: mejor para inserciones/eliminaciones frecuentes en los extremos
LinkedList<Integer> lista = new LinkedList<>();
lista.addFirst(1);
lista.addLast(2);
lista.removeFirst();

// Recorrido
for (String n : nombres) {
    System.out.println(n);
}
nombres.forEach(System.out::println);
```

### Set

```java
import java.util.HashSet;
import java.util.LinkedHashSet;
import java.util.TreeSet;
import java.util.Set;

Set<String> colores = new HashSet<>();       // sin orden garantizado
colores.add("rojo");
colores.add("rojo"); // ignorado, ya existe
colores.add("azul");

Set<String> ordenPorInsercion = new LinkedHashSet<>(); // mantiene orden de inserción
Set<Integer> ordenNatural = new TreeSet<>();            // ordenado (requiere Comparable)
ordenNatural.add(5);
ordenNatural.add(1);
ordenNatural.add(3); // resultado: [1, 3, 5]
```

### Map

```java
import java.util.HashMap;
import java.util.Map;
import java.util.TreeMap;

Map<String, Integer> edades = new HashMap<>();
edades.put("Ana", 25);
edades.put("Juan", 30);
edades.put("Ana", 26); // sobrescribe el valor anterior

int edad = edades.get("Ana");                 // 26
int edadDefault = edades.getOrDefault("Luis", 0); // 0, no existe "Luis"
boolean tieneJuan = edades.containsKey("Juan");
edades.remove("Juan");

// Recorrido
for (Map.Entry<String, Integer> entry : edades.entrySet()) {
    System.out.println(entry.getKey() + " -> " + entry.getValue());
}
edades.forEach((nombre, e) -> System.out.println(nombre + ": " + e));

// TreeMap: mantiene las claves ordenadas
Map<String, Integer> ordenado = new TreeMap<>(edades);
```

### Comparable y Comparator

```java
// Comparable: orden "natural" definido dentro de la propia clase
public class Persona implements Comparable<Persona> {
    private String nombre;
    private int edad;

    // constructor, getters...

    @Override
    public int compareTo(Persona otra) {
        return Integer.compare(this.edad, otra.edad); // orden por edad ascendente
    }
}

// Comparator: orden externo, tantos como se necesiten
import java.util.Comparator;
import java.util.List;

List<Persona> personas = ...;
personas.sort(Comparator.comparing(Persona::getNombre));
personas.sort(Comparator.comparingInt(Persona::getEdad).reversed());
personas.sort(
    Comparator.comparing(Persona::getNombre)
              .thenComparingInt(Persona::getEdad)
);
```

### Stream API

Los streams permiten procesar colecciones de forma declarativa (filtrar, transformar, reducir).

```java
import java.util.List;
import java.util.stream.Collectors;

List<Integer> numeros = List.of(1, 2, 3, 4, 5, 6, 7, 8, 9, 10);

// filter + map + collect
List<Integer> paresAlCuadrado = numeros.stream()
    .filter(n -> n % 2 == 0)
    .map(n -> n * n)
    .collect(Collectors.toList());
// [4, 16, 36, 64, 100]

// reduce
int suma = numeros.stream().reduce(0, Integer::sum);

// sorted, distinct, limit
List<Integer> top3 = numeros.stream()
    .sorted(Comparator.reverseOrder())
    .distinct()
    .limit(3)
    .collect(Collectors.toList());

// count, anyMatch, allMatch
long cantidadPares = numeros.stream().filter(n -> n % 2 == 0).count();
boolean hayMayorA5 = numeros.stream().anyMatch(n -> n > 5);

// agrupar
Map<Boolean, List<Integer>> agrupados = numeros.stream()
    .collect(Collectors.partitioningBy(n -> n % 2 == 0));

// convertir a Map
Map<Integer, Integer> cuadrados = numeros.stream()
    .collect(Collectors.toMap(n -> n, n -> n * n));
```

### Elección de la colección adecuada

| Necesito... | Usa |
|-------------|-----|
| Acceso rápido por índice, orden de inserción | `ArrayList` |
| Inserciones/eliminaciones frecuentes en extremos | `LinkedList` |
| Elementos únicos, sin importar orden | `HashSet` |
| Elementos únicos, orden de inserción | `LinkedHashSet` |
| Elementos únicos, ordenados | `TreeSet` |
| Pares clave-valor, acceso O(1) | `HashMap` |
| Pares clave-valor, ordenados por clave | `TreeMap` |
| Cola FIFO / con prioridad | `ArrayDeque` / `PriorityQueue` |

### Errores Comunes

| Error | Causa | Solución |
|-------|-------|----------|
| `ConcurrentModificationException` | Modificar una colección mientras se itera con `for-each` | Usar `Iterator.remove()` o `removeIf()` |
| `UnsupportedOperationException` | Modificar una lista inmutable (`List.of(...)`) | Crear una copia mutable con `new ArrayList<>(lista)` |
| `NullPointerException` en `HashMap` | Autoboxing de `null` al usar tipos primitivos envueltos | Verificar existencia con `containsKey`/`getOrDefault` |
| Orden inesperado al iterar un `HashMap`/`HashSet` | No garantizan orden | Usar `LinkedHashMap`/`LinkedHashSet` o `TreeMap`/`TreeSet` |

## Ejemplo de Código: Inventario con Streams

```java
package com.ejemplo;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public record Producto(String nombre, String categoria, double precio, int stock) {}

public class Inventario {
    public static void main(String[] args) {
        List<Producto> productos = List.of(
            new Producto("Laptop", "Electrónica", 899.99, 5),
            new Producto("Mouse", "Electrónica", 19.99, 50),
            new Producto("Escritorio", "Muebles", 149.99, 8),
            new Producto("Silla", "Muebles", 89.99, 12)
        );

        // Valor total del inventario
        double valorTotal = productos.stream()
            .mapToDouble(p -> p.precio() * p.stock())
            .sum();
        System.out.printf("Valor total: %.2f%n", valorTotal);

        // Agrupar por categoría
        Map<String, List<Producto>> porCategoria = productos.stream()
            .collect(Collectors.groupingBy(Producto::categoria));
        porCategoria.forEach((cat, lista) ->
            System.out.println(cat + ": " + lista.size() + " productos"));

        // Producto más caro
        productos.stream()
            .max((a, b) -> Double.compare(a.precio(), b.precio()))
            .ifPresent(p -> System.out.println("Más caro: " + p.nombre()));
    }
}
```

## Ejercicios Relacionados

- [Ejercicio 10: Listas y Colecciones](./ejercicios/nivel-02-basico/ejercicio-04-listas-y-colecciones/)
- [Ejercicio 17: Streams](./ejercicios/nivel-03-intermedio/ejercicio-05-streams/)
- [Ejercicio 18: Lambdas](./ejercicios/nivel-03-intermedio/ejercicio-06-lambdas/)

## Recursos

- [Java Collections Framework (Oracle)](https://docs.oracle.com/javase/tutorial/collections/)
- [Stream API (Oracle Docs)](https://docs.oracle.com/en/java/javase/17/docs/api/java.base/java/util/stream/Stream.html)