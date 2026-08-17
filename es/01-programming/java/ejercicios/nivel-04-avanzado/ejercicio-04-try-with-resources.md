# Ejercicio 04 — Try-with-resources

- **Nivel:** 4/5
- **Tema:** `try-with-resources`, `AutoCloseable`, `BufferedWriter`
- **Tiempo estimado:** 30 min

## Enunciado

Crea un archivo `Recursos.java` que:

1. Defina una clase `Recurso` que implemente `AutoCloseable`, con constructor que imprima `"Abriendo recurso"` y método `close()` que imprima `"Cerrando recurso"`.
2. En `main`, use **try-with-resources** para crear dos recursos (`Recurso r1 = new Recurso(); Recurso r2 = new Recurso();`) dentro del mismo `try`, y lance `RuntimeException` dentro del cuerpo.
3. Imprima el mensaje de la excepción en un `catch`.
4. Además, escriba un archivo `datos.txt` con `Files.newBufferedWriter` dentro de try-with-resources, escriba `"hola mundo"` y compruebe que el cierre ocurre (el archivo queda guardado y legible). Luego imprima su contenido con `Files.readString`.

Salida esperada:

```
Abriendo recurso
Abriendo recurso
Cerrando recurso
Cerrando recurso
Error: fallo provocado
Archivo escrito y leído: hola mundo
```

> Los `close()` se llaman automáticamente en orden inverso a la apertura, aunque haya excepción.

## Requisitos

- [ ] La clase `Recurso` implementa `AutoCloseable` y define `close()`.
- [ ] Usar try-with-resources con dos recursos y una excepción lanzada.
- [ ] Escribir y leer un archivo con `Files` dentro de try-with-resources.
- [ ] Compilarlo localmente con `javac Recursos.java` y ejecutarlo con `java Recursos` para verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `try (Recurso r1 = new Recurso(); Recurso r2 = new Recurso()) { ... }`.
- `AutoCloseable` solo exige `close()` (que puede lanzar `Exception`).
- El recurso se cierra aunque el cuerpo lance una excepción; la excepción del cuerpo se propaga al `catch`.
- Escribir: `try (BufferedWriter w = Files.newBufferedWriter(Path.of("datos.txt"))) { w.write("hola mundo"); }`.
- `Files.readString(Path.of("datos.txt"))` lee el archivo completo.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````java
import java.io.BufferedWriter;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

public class Recursos {
    static class Recurso implements AutoCloseable {
        public Recurso() {
            System.out.println("Abriendo recurso");
        }

        @Override
        public void close() {
            System.out.println("Cerrando recurso");
        }
    }

    public static void main(String[] args) {
        try (Recurso r1 = new Recurso();
             Recurso r2 = new Recurso()) {
            throw new RuntimeException("fallo provocado");
        } catch (RuntimeException e) {
            System.out.println("Error: " + e.getMessage());
        }

        try (BufferedWriter w = Files.newBufferedWriter(Path.of("datos.txt"))) {
            w.write("hola mundo");
        } catch (IOException e) {
            System.out.println("Error de escritura: " + e.getMessage());
        }

        try {
            String contenido = Files.readString(Path.of("datos.txt"));
            System.out.println("Archivo escrito y leído: " + contenido);
        } catch (IOException e) {
            System.out.println("Error de lectura: " + e.getMessage());
        }
    }
}
````

</details>