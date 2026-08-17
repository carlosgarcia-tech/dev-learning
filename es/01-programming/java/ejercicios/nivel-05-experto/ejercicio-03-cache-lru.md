# Ejercicio 03 — Caché LRU

- **Nivel:** 5/5
- **Tema:** `LinkedHashMap`, `accessOrder`, `removeEldestEntry`, O(1) de acceso
- **Tiempo estimado:** 40 min

## Enunciado

Crea un archivo `CacheLRU.java` que implemente una caché LRU (**Least Recently Used**):

1. Defina `CacheLRU<K, V>` que extienda `LinkedHashMap<K, V>` con una capacidad máxima.
2. El constructor llame a `super(capacidad, 0.75f, true)` — el `true` activa el **orden de acceso** (accessOrder), clave del algoritmo LRU.
3. Sobrescriba `removeEldestEntry(Map.Entry<K, V> eldest)` para eliminar la entrada más antigua cuando el tamaño supere la capacidad.
4. Añada un método `get` público que use `super.get` (y así "toca" la entrada, actualizando el orden).
5. En `main`:
   - Cree `new CacheLRU<Integer, String>(3)`.
   - Añada `1->"a"`, `2->"b"`, `3->"c"`, acceda a `1`, añada `4->"d"` (la caché debe expulsar `2`, el menos reciente).
   - Imprima la caché completa y si contiene `2` y `1`.

Salida esperada:

```
Caché: {3=c, 1=a, 4=d}
¿Contiene 2? false
¿Contiene 1? true
```

## Requisitos

- [ ] `CacheLRU` extiende `LinkedHashMap` con `accessOrder = true`.
- [ ] Sobrescribir `removeEldestEntry` correctamente.
- [ ] Acceder a `1` antes de insertar `4` para que `2` quede expulsado.
- [ ] Compilarlo localmente con `javac CacheLRU.java` y ejecutarlo con `java CacheLRU` para verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `super(capacidad, 0.75f, true)` en el constructor del padre.
- `protected boolean removeEldestEntry(Map.Entry<K, V> eldest) { return size() > capacidad; }`.
- Con `accessOrder = true`, leer una clave con `get` la mueve al final (la más reciente).
- `2->"b"` es la menos usada cuando accedes a `1` y luego insertas `4`. El orden resultante es `3, 1, 4`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````java
import java.util.LinkedHashMap;
import java.util.Map;

public class CacheLRU<K, V> extends LinkedHashMap<K, V> {
    private final int capacidad;

    public CacheLRU(int capacidad) {
        super(capacidad, 0.75f, true); // accessOrder = true
        this.capacidad = capacidad;
    }

    @Override
    protected boolean removeEldestEntry(Map.Entry<K, V> eldest) {
        return size() > capacidad;
    }

    public static void main(String[] args) {
        CacheLRU<Integer, String> cache = new CacheLRU<>(3);

        cache.put(1, "a");
        cache.put(2, "b");
        cache.put(3, "c");
        cache.get(1);        // "toca" la clave 1: la hace la más reciente
        cache.put(4, "d");   // supera capacidad -> expulsa la menos usada (2)

        System.out.println("Caché: " + cache);
        System.out.println("¿Contiene 2? " + cache.containsKey(2));
        System.out.println("¿Contiene 1? " + cache.containsKey(1));
    }
}
````

</details>