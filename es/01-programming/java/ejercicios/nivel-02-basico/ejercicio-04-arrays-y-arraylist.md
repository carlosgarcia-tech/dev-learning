# Ejercicio 04 — Arrays y ArrayList

- **Nivel:** 2/5
- **Tema:** `ArrayList`, `List`, autoboxing, diferencias con arrays
- **Tiempo estimado:** 20 min

## Enunciado

Crea un archivo `ListaNumeros.java` que:

1. Cree un `ArrayList<Integer>` con los números `{7, 3, 9, 1, 3}`.
2. Añada el número `5` al final y `10` al principio (índice 0).
3. Imprima el tamaño de la lista.
4. Elimine la primera aparición del número `3`.
5. Calcule la suma y el valor máximo de la lista.
6. Copie la lista a un array con `toArray()` e imprímalo con `java.util.Arrays.toString`.
7. Cree una lista inmutable con `List.of(...)` e intente `add` capturando la excepción `UnsupportedOperationException`.

Salida esperada:

```
Tamaño: 7
Lista: [10, 7, 3, 9, 1, 3, 5]
Después de eliminar un 3: [10, 7, 9, 1, 3, 5]
Suma: 35, Máximo: 10
Array: [10, 7, 9, 1, 3, 5]
Error al añadir a List.of: UnsupportedOperationException
```

## Requisitos

- [ ] Usar `ArrayList<Integer>` con tipos genéricos.
- [ ] Usar `add`, `add(indice, valor)`, `remove`, `size`.
- [ ] Convertir a array con `toArray`.
- [ ] Crear una lista inmutable con `List.of` y capturar `UnsupportedOperationException`.
- [ ] Compilarlo localmente con `javac ListaNumeros.java` y ejecutarlo con `java ListaNumeros` para verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `new ArrayList<>(List.of(7, 3, 9, 1, 3))` crea una lista mutable copiando los elementos.
- `remove((Integer) 3)` elimina el valor 3; `remove(0)` elimina por índice.
- `toArray(new Integer[0])` devuelve un `Integer[]`.
- `List.of(...)` devuelve una lista inmutable: `add` lanza `UnsupportedOperationException`.
- Para el máximo puedes usar un bucle manual o `Collections.max(lista)`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````java
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

public class ListaNumeros {
    public static void main(String[] args) {
        ArrayList<Integer> lista = new ArrayList<>(List.of(7, 3, 9, 1, 3));
        lista.add(5);
        lista.add(0, 10);
        System.out.println("Tamaño: " + lista.size());
        System.out.println("Lista: " + lista);

        lista.remove((Integer) 3); // elimina por valor, no por índice
        System.out.println("Después de eliminar un 3: " + lista);

        int suma = 0;
        for (Integer n : lista) {
            suma += n;
        }
        int maximo = Collections.max(lista);
        System.out.println("Suma: " + suma + ", Máximo: " + maximo);

        Integer[] array = lista.toArray(new Integer[0]);
        System.out.println("Array: " + Arrays.toString(array));

        List<Integer> inmutable = List.of(1, 2, 3);
        try {
            inmutable.add(4);
        } catch (UnsupportedOperationException e) {
            System.out.println("Error al añadir a List.of: "
                    + e.getClass().getSimpleName());
        }
    }
}
````

</details>