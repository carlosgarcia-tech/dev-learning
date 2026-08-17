# Ejercicio 06 — Mini-proyecto: sistema bancario

- **Nivel:** 5/5
- **Tema:** diseño de clases, encapsulación, interfaces, excepciones, menú CLI
- **Tiempo estimado:** 60 min

## Enunciado

Crea un archivo `Banco.java` que implemente un **sistema bancario simple** con menú por consola:

1. Clase `Cuenta` encapsulada con `titular` (String), `saldo` (double), constructor y métodos `depositar` y `retirar` que validen montos y lancen `IllegalArgumentException`/`SaldoInsuficienteException`.
2. Excepción personalizada `SaldoInsuficienteException extends RuntimeException` con mensaje.
3. Clase `Banco` que guarda las cuentas en un `HashMap<String, Cuenta>` (clave: número de cuenta) y ofrece `crearCuenta`, `buscarCuenta`, `depositar`, `retirar` y `listar`.
4. Menú en `main` con `Scanner`:
   - `1. Crear cuenta` (pide titular y saldo inicial, genera número tipo `"C-001"`).
   - `2. Depositar` (pide número y monto).
   - `3. Retirar` (pide número y monto, captura `SaldoInsuficienteException`).
   - `4. Ver cuentas` (lista número, titular y saldo).
   - `5. Salir`.

Ejemplo de interacción:

```
=== SISTEMA BANCARIO ===
1. Crear cuenta
...
Elige una opción: 1
Titular: Ana
Saldo inicial: 1000
Cuenta creada: C-001 (Ana)
```

## Requisitos

- [ ] Clase `Cuenta` totalmente encapsulada (atributos `private`).
- [ ] Excepción propia `SaldoInsuficienteException`.
- [ ] `Banco` gestiona las cuentas con `HashMap`.
- [ ] Menú con las 5 opciones usando `switch`.
- [ ] Compilarlo localmente con `javac Banco.java` y ejecutarlo con `java Banco` para probar: crear cuenta, depositar, retirar más de lo disponible (debe mostrar el error) y listar.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Número de cuenta: `String.format("C-%03d", contador)`.
- `retirar` debe lanzar `SaldoInsuficienteException` si `monto > saldo`.
- Captura la excepción en el menú y muestra `e.getMessage()`.
- `scanner.nextInt()` deja el `\n` en el buffer: llama a `scanner.nextLine()` después.
- Guarda la referencia al `Scanner` como parámetro de los métodos del menú.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````java
import java.util.HashMap;
import java.util.Map;
import java.util.Scanner;

public class Banco {

    static class SaldoInsuficienteException extends RuntimeException {
        public SaldoInsuficienteException(String mensaje) {
            super(mensaje);
        }
    }

    static class Cuenta {
        private final String numero;
        private final String titular;
        private double saldo;

        public Cuenta(String numero, String titular, double saldoInicial) {
            this.numero = numero;
            this.titular = titular;
            this.saldo = saldoInicial;
        }

        public String getNumero() {
            return numero;
        }

        public String getTitular() {
            return titular;
        }

        public double getSaldo() {
            return saldo;
        }

        public void depositar(double monto) {
            if (monto <= 0) {
                throw new IllegalArgumentException("El monto debe ser positivo");
            }
            saldo += monto;
        }

        public void retirar(double monto) {
            if (monto <= 0) {
                throw new IllegalArgumentException("El monto debe ser positivo");
            }
            if (monto > saldo) {
                throw new SaldoInsuficienteException(
                        "Saldo insuficiente: disponible " + saldo);
            }
            saldo -= monto;
        }
    }

    private final Map<String, Cuenta> cuentas = new HashMap<>();
    private int contador = 0;

    public Cuenta crearCuenta(String titular, double saldoInicial) {
        contador++;
        String numero = String.format("C-%03d", contador);
        Cuenta cuenta = new Cuenta(numero, titular, saldoInicial);
        cuentas.put(numero, cuenta);
        return cuenta;
    }

    public void depositar(String numero, double monto) {
        Cuenta c = cuentas.get(numero);
        if (c == null) {
            throw new IllegalArgumentException("Cuenta no encontrada: " + numero);
        }
        c.depositar(monto);
    }

    public void retirar(String numero, double monto) {
        Cuenta c = cuentas.get(numero);
        if (c == null) {
            throw new IllegalArgumentException("Cuenta no encontrada: " + numero);
        }
        c.retirar(monto);
    }

    public void listar() {
        if (cuentas.isEmpty()) {
            System.out.println("No hay cuentas.");
            return;
        }
        for (Cuenta c : cuentas.values()) {
            System.out.println(c.getNumero() + " | " + c.getTitular()
                    + " | " + c.getSaldo());
        }
    }

    public static void main(String[] args) {
        Banco banco = new Banco();
        Scanner sc = new Scanner(System.in);
        int opcion;

        do {
            System.out.println("\n=== SISTEMA BANCARIO ===");
            System.out.println("1. Crear cuenta");
            System.out.println("2. Depositar");
            System.out.println("3. Retirar");
            System.out.println("4. Ver cuentas");
            System.out.println("5. Salir");
            System.out.print("Elige una opción: ");
            opcion = sc.nextInt();
            sc.nextLine();

            switch (opcion) {
                case 1 -> {
                    System.out.print("Titular: ");
                    String titular = sc.nextLine();
                    System.out.print("Saldo inicial: ");
                    double saldo = sc.nextDouble();
                    sc.nextLine();
                    Cuenta c = banco.crearCuenta(titular, saldo);
                    System.out.println("Cuenta creada: " + c.getNumero()
                            + " (" + c.getTitular() + ")");
                }
                case 2 -> {
                    System.out.print("Número: ");
                    String num = sc.nextLine();
                    System.out.print("Monto: ");
                    double monto = sc.nextDouble();
                    sc.nextLine();
                    try {
                        banco.depositar(num, monto);
                        System.out.println("Depositado.");
                    } catch (IllegalArgumentException e) {
                        System.out.println("Error: " + e.getMessage());
                    }
                }
                case 3 -> {
                    System.out.print("Número: ");
                    String num = sc.nextLine();
                    System.out.print("Monto: ");
                    double monto = sc.nextDouble();
                    sc.nextLine();
                    try {
                        banco.retirar(num, monto);
                        System.out.println("Retirado.");
                    } catch (SaldoInsuficienteException e) {
                        System.out.println("Error: " + e.getMessage());
                    } catch (IllegalArgumentException e) {
                        System.out.println("Error: " + e.getMessage());
                    }
                }
                case 4 -> banco.listar();
                case 5 -> System.out.println("¡Hasta luego!");
                default -> System.out.println("Opción no válida.");
            }
        } while (opcion != 5);

        sc.close();
    }
}
````

</details>