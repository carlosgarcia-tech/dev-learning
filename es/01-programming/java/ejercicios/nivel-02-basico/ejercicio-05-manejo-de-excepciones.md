# Ejercicio 05 — Manejo de excepciones

- **Nivel:** 2/5
- **Tema:** `try/catch/finally`, excepciones checked y unchecked, `throws`
- **Tiempo estimado:** 20 min

## Enunciado

Crea un archivo `Division.java` que:

1. Defina un método `dividir(int a, int b)` que lance `ArithmeticException` con el mensaje `"No se puede dividir por cero"` si `b == 0`, y devuelva `a / b` en caso contrario.
2. Defina un método `leerArchivo(String ruta)` que lance `IOException` (checked) cuando el archivo no exista. Puedes usar `java.nio.file.Files.readString(Path.of(ruta))` y declarar `throws IOException`.
3. En `main`:
   - Llama a `dividir(10, 0)` dentro de `try/catch` capturando `ArithmeticException`.
   - Llama a `leerArchivo("no-existe.txt")` dentro de `try/catch` capturando `IOException`.
   - Añade un bloque `finally` que imprima `"Bloque finally ejecutado"` en ambos casos.

Salida esperada:

```
Error aritmético: No se puede dividir por cero
Bloque finally ejecutado
Error de archivo: no-existe.txt
Bloque finally ejecutado
```

## Requisitos

- [ ] `dividir` lanza `ArithmeticException` con `throw`.
- [ ] `leerArchivo` usa `throws IOException` (excepción checked).
- [ ] Capturar cada excepción en su propio `try/catch`.
- [ ] Usar `finally` que se ejecute en los dos casos.
- [ ] Compilarlo localmente con `javac Division.java` y ejecutarlo con `java Division` para verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `throw new ArithmeticException("mensaje")` crea y lanza la excepción.
- `IOException` es checked: el compilador exige capturarla o declarar `throws`.
- `e.getMessage()` devuelve el mensaje; `e.getClass().getSimpleName()` el tipo.
- `finally` se ejecuta siempre, haya o no excepción.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````java
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

public class Division {
    public static int dividir(int a, int b) {
        if (b == 0) {
            throw new ArithmeticException("No se puede dividir por cero");
        }
        return a / b;
    }

    public static String leerArchivo(String ruta) throws IOException {
        return Files.readString(Path.of(ruta));
    }

    public static void main(String[] args) {
        try {
            System.out.println(dividir(10, 0));
        } catch (ArithmeticException e) {
            System.out.println("Error aritmético: " + e.getMessage());
        } finally {
            System.out.println("Bloque finally ejecutado");
        }

        try {
            leerArchivo("no-existe.txt");
        } catch (IOException e) {
            System.out.println("Error de archivo: " + e.getMessage());
        } finally {
            System.out.println("Bloque finally ejecutado");
        }
    }
}
````

</details>