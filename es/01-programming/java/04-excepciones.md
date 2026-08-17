# 04 — Manejo de Excepciones en Java

## Objetivos

- [ ] Entender la jerarquía de excepciones en Java
- [ ] Diferenciar excepciones *checked* y *unchecked*
- [ ] Usar `try-catch-finally`
- [ ] Crear excepciones personalizadas
- [ ] Usar `try-with-resources`
- [ ] Aplicar buenas prácticas en el manejo de errores

## Apuntes

### Jerarquía de excepciones

```
Throwable
├── Error                  (errores graves de la JVM, no se capturan normalmente)
│   └── OutOfMemoryError, StackOverflowError...
└── Exception
    ├── RuntimeException (unchecked, no obligan try-catch)
    │   ├── NullPointerException
    │   ├── ArrayIndexOutOfBoundsException
    │   ├── ArithmeticException
    │   ├── ClassCastException
    │   └── IllegalArgumentException
    └── Checked Exceptions (obligan try-catch o throws)
        ├── IOException
        ├── SQLException
        └── ClassNotFoundException
```

- **Checked**: el compilador exige capturarlas o declararlas con `throws`. Representan
  condiciones externas recuperables (archivo no encontrado, fallo de red...).
- **Unchecked** (`RuntimeException` y subclases): normalmente indican errores de
  programación (índice fuera de rango, `null` inesperado...). No es obligatorio capturarlas.

### try-catch-finally

```java
public class EjemploExcepciones {
    public static void main(String[] args) {
        try {
            int resultado = 10 / 0; // lanza ArithmeticException
            System.out.println(resultado);
        } catch (ArithmeticException e) {
            System.out.println("Error: división por cero -> " + e.getMessage());
        } finally {
            System.out.println("Este bloque siempre se ejecuta");
        }

        // Múltiples catch
        try {
            int[] arr = new int[5];
            arr[10] = 1;
        } catch (ArrayIndexOutOfBoundsException e) {
            System.out.println("Índice fuera de rango: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("Otro error: " + e.getMessage());
        }

        // Multi-catch (Java 7+)
        try {
            Object obj = "texto";
            Integer numero = (Integer) obj; // ClassCastException
        } catch (ClassCastException | NullPointerException e) {
            System.out.println("Error de tipo o nulo: " + e.getMessage());
        }
    }
}
```

### Lanzar excepciones con `throw` y `throws`

```java
public class Validador {

    // "throws" declara que el método puede lanzar una excepción checked
    public static void leerArchivo(String ruta) throws java.io.IOException {
        if (ruta == null || ruta.isEmpty()) {
            throw new IllegalArgumentException("La ruta no puede estar vacía");
        }
        // ... lógica que puede lanzar IOException
    }

    public static void validarEdad(int edad) {
        if (edad < 0 || edad > 150) {
            throw new IllegalArgumentException("Edad fuera de rango: " + edad);
        }
    }
}
```

### Excepciones personalizadas

```java
// Excepción checked personalizada
public class SaldoInsuficienteException extends Exception {
    private double saldoActual;
    private double montoSolicitado;

    public SaldoInsuficienteException(double saldoActual, double montoSolicitado) {
        super(String.format("Saldo insuficiente: disponible %.2f, solicitado %.2f",
                             saldoActual, montoSolicitado));
        this.saldoActual = saldoActual;
        this.montoSolicitado = montoSolicitado;
    }

    public double getSaldoActual() { return saldoActual; }
    public double getMontoSolicitado() { return montoSolicitado; }
}

// Excepción unchecked personalizada
public class RecursoNoEncontradoException extends RuntimeException {
    public RecursoNoEncontradoException(String mensaje) {
        super(mensaje);
    }
}

public class CuentaBancaria {
    private double saldo;

    public void retirar(double monto) throws SaldoInsuficienteException {
        if (monto > saldo) {
            throw new SaldoInsuficienteException(saldo, monto);
        }
        saldo -= monto;
    }
}

// Uso
public class Main {
    public static void main(String[] args) {
        CuentaBancaria cuenta = new CuentaBancaria();
        try {
            cuenta.retirar(1000);
        } catch (SaldoInsuficienteException e) {
            System.out.println("No se pudo retirar: " + e.getMessage());
        }
    }
}
```

### try-with-resources

Cierra automáticamente los recursos (`AutoCloseable`) al finalizar el bloque, incluso si
ocurre una excepción. Reemplaza al patrón `try/finally { recurso.close(); }`.

```java
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

public class LectorArchivo {
    public static void leer(String ruta) {
        try (BufferedReader br = new BufferedReader(new FileReader(ruta))) {
            String linea;
            while ((linea = br.readLine()) != null) {
                System.out.println(linea);
            }
        } catch (IOException e) {
            System.out.println("Error al leer el archivo: " + e.getMessage());
        }
        // br.close() se llama automáticamente, sin necesidad de finally
    }
}

// Múltiples recursos
public class CopiaArchivo {
    public static void copiar(String origen, String destino) {
        try (var in = new java.io.FileInputStream(origen);
             var out = new java.io.FileOutputStream(destino)) {
            in.transferTo(out);
        } catch (IOException e) {
            System.out.println("Error al copiar: " + e.getMessage());
        }
    }
}

// Clase propia compatible con try-with-resources
public class ConexionSimulada implements AutoCloseable {
    public void abrir() {
        System.out.println("Conexión abierta");
    }

    @Override
    public void close() {
        System.out.println("Conexión cerrada");
    }
}
```

### Buenas prácticas

1. **No capturar `Exception` genérica sin necesidad**: captura la excepción más específica posible.
2. **No dejar bloques `catch` vacíos**: al menos registra el error (log).
3. **No usar excepciones para control de flujo normal**: son costosas y confunden la lógica.
4. **Incluir información útil en el mensaje**: qué falló y con qué datos.
5. **Preferir excepciones unchecked para errores de programación**, y checked para
   condiciones externas recuperables por quien llama.
6. **Cerrar siempre los recursos**: usa `try-with-resources` en vez de `finally` manual.

### Errores Comunes

| Error | Causa | Solución |
|-------|-------|----------|
| `unreported exception ...; must be caught or declared to be thrown` | Excepción checked sin capturar ni declarar | Envolver en `try-catch` o agregar `throws` |
| Excepción "tragada" silenciosamente | `catch` vacío | Registrar el error o relanzarlo |
| `finally` no libera recursos correctamente | Cierre manual propenso a errores | Usar `try-with-resources` |
| Captura de `Exception` oculta bugs reales | `catch (Exception e)` demasiado amplio | Capturar tipos específicos primero |

## Ejemplo de Código: Validación con Excepciones Personalizadas

```java
package com.ejemplo;

public class FormularioRegistro {

    public static class EdadInvalidaException extends RuntimeException {
        public EdadInvalidaException(String mensaje) { super(mensaje); }
    }

    public static class EmailInvalidoException extends RuntimeException {
        public EmailInvalidoException(String mensaje) { super(mensaje); }
    }

    public static void validar(String nombre, int edad, String email) {
        if (nombre == null || nombre.isBlank()) {
            throw new IllegalArgumentException("El nombre es obligatorio");
        }
        if (edad < 18 || edad > 120) {
            throw new EdadInvalidaException("Edad fuera de rango permitido: " + edad);
        }
        if (email == null || !email.contains("@")) {
            throw new EmailInvalidoException("Email inválido: " + email);
        }
    }

    public static void main(String[] args) {
        String[][] registros = {
            {"Ana", "25", "ana@correo.com"},
            {"Luis", "15", "luis@correo.com"},
            {"Marta", "30", "marta.sin.arroba"}
        };

        for (String[] r : registros) {
            try {
                validar(r[0], Integer.parseInt(r[1]), r[2]);
                System.out.println(r[0] + ": registro válido");
            } catch (EdadInvalidaException | EmailInvalidoException e) {
                System.out.println(r[0] + ": rechazado -> " + e.getMessage());
            }
        }
    }
}
```

## Ejercicios Relacionados

- [Ejercicio 11: Excepciones](./ejercicios/nivel-02-basico/ejercicio-05-excepciones/)
- [Ejercicio 21: Try-with-resources](./ejercicios/nivel-04-avanzado/ejercicio-03-try-with-resources/)

## Recursos

- [Oracle: Exceptions Tutorial](https://docs.oracle.com/javase/tutorial/essential/exceptions/)
- [Effective Java — Ítems sobre excepciones (Joshua Bloch)](https://www.oreilly.com/library/view/effective-java-3rd/9780134686097/)