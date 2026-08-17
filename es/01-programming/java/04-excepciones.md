# 04 — Excepciones

## Objetivos

- [ ] Distinguir excepciones checked, unchecked y errores.
- [ ] Capturar excepciones con `try/catch` y varios `catch`.
- [ ] Usar `finally` para código que se ejecuta siempre.
- [ ] Lanzar excepciones con `throw` y `throws`.
- [ ] Crear excepciones personalizadas.
- [ ] Usar try-with-resources para cerrar recursos automáticamente.

## Apuntes

### Jerarquía de Throwable

- `Throwable` — raíz de todo lo lanzable.
- `Error` — problemas graves del JVM (p. ej. `OutOfMemoryError`). No se capturan normalmente.
- `Exception` — problemas recuperables. Dos ramas:
  - **Checked** — el compilador **obliga** a capturarlas o declararlas con `throws`. P. ej. `IOException`, `SQLException`, `FileNotFoundException`.
  - **Unchecked** (subclases de `RuntimeException`) — no es obligatorio manejarlas; suelen ser errores de lógica. P. ej. `NullPointerException`, `IllegalArgumentException`, `ArithmeticException`, `IndexOutOfBoundsException`.

```java
// Checked: el compilador exige try/catch o throws
try {
    java.nio.file.Files.readString(java.nio.file.Path.of("datos.txt"));
} catch (java.io.IOException e) {
    System.out.println("No se pudo leer el archivo: " + e.getMessage());
}

// Unchecked: no obligatorio, pero conviene manejarla
int x = 10;
int y = 0;
if (y != 0) {
    System.out.println(x / y);
} else {
    System.out.println("No se puede dividir por cero");
}
```

### try/catch/finally

- `try` — bloque que puede lanzar excepciones.
- `catch` — captura y maneja. Puede haber varios `catch`, del más específico al más general (¡el orden importa!).
- `finally` — se ejecuta **siempre**, ocurra o no excepción. Ideal para liberar recursos (aunque hoy se prefiere try-with-resources).
- `catch (A | B e)` — multi-catch para manejar varios tipos con el mismo código.

```java
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

public class Lector {
    public static void main(String[] args) {
        try {
            String contenido = Files.readString(Path.of("datos.txt"));
            System.out.println(contenido);
        } catch (IOException e) {
            System.out.println("Error de I/O: " + e.getMessage());
        } finally {
            System.out.println("Este bloque siempre se ejecuta");
        }
    }
}
```

### throw y throws

- `throw` **lanza** una excepción (una instancia) en el código.
- `throws` **declara** en la firma del método que puede propagar excepciones checked.

```java
public double raiz(double n) throws IllegalArgumentException {
    if (n < 0) {
        throw new IllegalArgumentException("No existe raíz de un negativo: " + n);
    }
    return Math.sqrt(n);
}
```

### Excepciones personalizadas

Para modelar errores propios del dominio. Deben extender `Exception` (checked) o `RuntimeException` (unchecked).

```java
public class SaldoInsuficienteException extends RuntimeException {
    public SaldoInsuficienteException(String mensaje) {
        super(mensaje);
    }
}
```

### Try-with-resources

Desde Java 7, los recursos que implementan `AutoCloseable` se cierran solos al salir del `try`. No hace falta `finally`.

```java
import java.io.BufferedReader;
import java.nio.file.Files;
import java.nio.file.Path;

public class Lector2 {
    public static void main(String[] args) {
        try (BufferedReader br = Files.newBufferedReader(Path.of("datos.txt"))) {
            br.lines().forEach(System.out::println);
        } catch (java.io.IOException e) {
            System.out.println("Error leyendo: " + e.getMessage());
        }
    }
}
```

## Ejemplos de código

```java
// Validador con excepción personalizada y captura
public class Cuenta {
    private double saldo;

    public void retirar(double monto) {
        if (monto <= 0) {
            throw new IllegalArgumentException("El monto debe ser positivo");
        }
        if (monto > saldo) {
            throw new SaldoInsuficienteException("Saldo insuficiente: tienes " + saldo);
        }
        saldo -= monto;
    }

    public static void main(String[] args) {
        Cuenta c = new Cuenta();
        try {
            c.retirar(500);
        } catch (SaldoInsuficienteException e) {
            System.out.println("Error: " + e.getMessage());
        }
    }
}
```

## Ejercicios relacionados

- [Ejercicios nivel 02 — Básico](../ejercicios/nivel-02-basico/)
- [Ejercicios nivel 04 — Avanzado](../ejercicios/nivel-04-avanzado/)

## Errores comunes

- **Olvidar que el `catch` debe ir antes de `finally`** → error de compilación si los ordenas mal.
- **`catch (Exception e)` antes de `catch (IOException e)`** → el primero ya captura todo; el segundo nunca se alcanza (no compila).
- **Tragarse la excepción** → `catch (Exception e) {}` vacío oculta errores. Al menos imprime `e.getMessage()`.
- **Lanzar checked sin `throws`** → no compila. Declara `throws` en la firma o captúrala.
- **Capturar `Error`** → salvo casos extremos, no se capturan (`OutOfMemoryError` no es recuperable).
- **No usar try-with-resources** → abrir un `BufferedReader` sin cerrarlo puede dejar el archivo bloqueado.
- **Propagar excepciones genéricas** → lanza la más específica posible y no `new Exception()` a secas.

## Recursos

- [Oracle — Exceptions](https://docs.oracle.com/javase/tutorial/essential/exceptions/index.html)
- [Java Throwable API](https://docs.oracle.com/en/java/javase/17/docs/api/java.base/java/lang/Throwable.html)
- [Oracle — The try-with-resources Statement](https://docs.oracle.com/javase/tutorial/essential/exceptions/tryResourceClose.html)
- [Baeldung — Exceptions in Java](https://www.baeldung.com/java-exceptions)