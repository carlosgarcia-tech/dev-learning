# Ejercicio 03 — Colecciones: Map y Set

- **Nivel:** 3/5
- **Tema:** `HashMap`, `HashSet`, `TreeMap`, `entrySet`, `keySet`
- **Tiempo estimado:** 25 min

## Enunciado

Crea un archivo `Inventario.java` que:

1. Cree un `HashMap<String, Integer>` de productos → stock, con: `{"manzana": 10, "pera": 5, "uva": 8, "mango": 0}`.
2. Imprima el stock de `"pera"` usando `getOrDefault` para un producto inexistente (p. ej. `"kiwi"` → 0).
3. Añada `"kiwi"` con stock 3 y actualice `"manzana"` a 12 (con `put`).
4. Imprima el mapa ordenado alfabéticamente: copia a un `TreeMap` y recórrelo con `entrySet()`.
5. Con un `HashSet<String>`, guarde todos los nombres de producto sin duplicados e imprima cuántos hay.
6. Imprima los productos agotados (stock == 0) recorriendo `entrySet()`.

Salida esperada:

```
Stock de pera: 5, Stock de kiwi (por defecto): 0
Ordenado: kiwi=3, mango=0, manzana=12, pera=5, uva=8
Productos distintos: 5
Agotados: mango
```

## Requisitos

- [ ] Usar `HashMap`, `TreeMap` y `HashSet`.
- [ ] Usar `getOrDefault`, `put`, `keySet` o `entrySet`.
- [ ] Ordenar alfabéticamente con `TreeMap`.
- [ ] Evitar duplicados con `HashSet`.
- [ ] Compilarlo localmente con `javac Inventario.java` y ejecutarlo con `java Inventario` para verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `new TreeMap<>(mapa)` copia y ordena por clave.
- `entrySet()` devuelve pares con `getKey()` y `getValue()`.
- `mapa.put("manzana", 12)` sobrescribe el valor existente.
- Para los agotados: `if (entrada.getValue() == 0)`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````java
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;

public class Inventario {
    public static void main(String[] args) {
        Map<String, Integer> stock = new HashMap<>();
        stock.put("manzana", 10);
        stock.put("pera", 5);
        stock.put("uva", 8);
        stock.put("mango", 0);

        System.out.println("Stock de pera: " + stock.get("pera")
                + ", Stock de kiwi (por defecto): " + stock.getOrDefault("kiwi", 0));

        stock.put("kiwi", 3);
        stock.put("manzana", 12);

        TreeMap<String, Integer> ordenado = new TreeMap<>(stock);
        System.out.print("Ordenado: ");
        for (Map.Entry<String, Integer> e : ordenado.entrySet()) {
            System.out.print(e.getKey() + "=" + e.getValue() + ", ");
        }
        System.out.println();

        Set<String> productos = new HashSet<>(stock.keySet());
        System.out.println("Productos distintos: " + productos.size());

        System.out.print("Agotados: ");
        for (Map.Entry<String, Integer> e : stock.entrySet()) {
            if (e.getValue() == 0) {
                System.out.print(e.getKey() + " ");
            }
        }
        System.out.println();
    }
}
````

</details>