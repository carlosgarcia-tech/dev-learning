# Ejercicio 01 — Gestor de tareas CLI

- **Nivel:** 5/5
- **Tema:** `Scanner`, `File`, lectura/escritura de texto, menú CLI
- **Tiempo estimado:** 45 min

## Enunciado

Crea un archivo `GestorTareas.java` que implemente un gestor de tareas por consola:

1. Un menú con las opciones: `1. Agregar`, `2. Listar`, `3. Eliminar`, `4. Salir`.
2. Las tareas se guardan en un archivo `tareas.txt`, una por línea (se leen al arrancar y se reescriben al modificar).
3. `Agregar` pide el texto de la tarea y la añade al archivo.
4. `Listar` numera e imprime las tareas leídas del archivo (o `No hay tareas` si está vacío).
5. `Eliminar` pide un número y borra esa tarea del archivo.
6. `Salir` termina el programa.

Ejemplo de interacción:

```
=== GESTOR DE TAREAS ===
1. Agregar
2. Listar
3. Eliminar
4. Salir
Elige una opción: 1
Tarea: Comprar pan
Tarea agregada.
...
Elige una opción: 2
1. Comprar pan
```

## Requisitos

- [ ] Usar `Scanner` para leer la entrada del usuario.
- [ ] Leer y escribir `tareas.txt` con `Files.readAllLines` y `Files.write`.
- [ ] El menú repite hasta elegir `Salir` (bucle `while`).
- [ ] `Listar` muestra las tareas numeradas; `Eliminar` borra por número.
- [ ] Compilarlo localmente con `javac GestorTareas.java` y ejecutarlo con `java GestorTareas` para verificar el flujo completo.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `Files.readAllLines(Path.of("tareas.txt"))` devuelve `List<String>`.
- `Files.write(path, lista, StandardOpenOption.CREATE)` escribe todas las líneas.
- Usa `ArrayList<String>` para manipular la lista (eliminar por índice).
- Cierra el `Scanner` con `scanner.close()` antes de salir.
- La lectura/escritura lanza `IOException` (checked): captúrala o declara `throws`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````java
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardOpenOption;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class GestorTareas {
    private static final Path ARCHIVO = Path.of("tareas.txt");

    public static void main(String[] args) throws IOException {
        Scanner sc = new Scanner(System.in);
        int opcion;

        do {
            System.out.println("\n=== GESTOR DE TAREAS ===");
            System.out.println("1. Agregar");
            System.out.println("2. Listar");
            System.out.println("3. Eliminar");
            System.out.println("4. Salir");
            System.out.print("Elige una opción: ");
            opcion = sc.nextInt();
            sc.nextLine(); // consume el salto de línea

            switch (opcion) {
                case 1 -> agregar(sc);
                case 2 -> listar();
                case 3 -> eliminar(sc);
                case 4 -> System.out.println("¡Hasta luego!");
                default -> System.out.println("Opción no válida.");
            }
        } while (opcion != 4);

        sc.close();
    }

    private static List<String> leer() throws IOException {
        if (!Files.exists(ARCHIVO)) {
            return new ArrayList<>();
        }
        return new ArrayList<>(Files.readAllLines(ARCHIVO));
    }

    private static void guardar(List<String> tareas) throws IOException {
        Files.write(ARCHIVO, tareas, StandardOpenOption.CREATE,
                StandardOpenOption.TRUNCATE_EXISTING);
    }

    private static void agregar(Scanner sc) throws IOException {
        System.out.print("Tarea: ");
        String tarea = sc.nextLine();
        List<String> tareas = leer();
        tareas.add(tarea);
        guardar(tareas);
        System.out.println("Tarea agregada.");
    }

    private static void listar() throws IOException {
        List<String> tareas = leer();
        if (tareas.isEmpty()) {
            System.out.println("No hay tareas.");
        } else {
            for (int i = 0; i < tareas.size(); i++) {
                System.out.println((i + 1) + ". " + tareas.get(i));
            }
        }
    }

    private static void eliminar(Scanner sc) throws IOException {
        listar();
        System.out.print("Número de la tarea a eliminar: ");
        int numero = sc.nextInt();
        sc.nextLine();
        List<String> tareas = leer();
        if (numero < 1 || numero > tareas.size()) {
            System.out.println("Número no válido.");
            return;
        }
        tareas.remove(numero - 1);
        guardar(tareas);
        System.out.println("Tarea eliminada.");
    }
}
````

</details>