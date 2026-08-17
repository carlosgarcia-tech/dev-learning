# Ejercicio 02 — Interfaces

- **Nivel:** 3/5
- **Tema:** `interface`, `implements`, métodos abstractos y `default`
- **Tiempo estimado:** 25 min

## Enunciado

Crea un archivo `Pagos.java` que:

1. Defina una interfaz `Pagable` con:
   - Método `void procesarPago(double monto);`
   - Método `double getComision();`
   - Método `default void mostrarResumen(double monto)` que imprima `"Pago de <monto> procesado con comisión <comision>%"`.
2. Defina `TarjetaCredito` y `PayPal` que **implementen** `Pagable`:
   - `TarjetaCredito`: comisión 2.5%, imprime `"Tarjeta: pagado " + monto`.
   - `PayPal`: comisión 1.0%, imprime `"PayPal: pagado " + monto`.
3. En `main`, crea una lista de pagables, procesa cada pago con `procesarPago(100)` y llama a `mostrarResumen(100)` (el método `default`).

Salida esperada:

```
Tarjeta: pagado 100.0
Pago de 100.0 procesado con comisión 2.5%
PayPal: pagado 100.0
Pago de 100.0 procesado con comisión 1.0%
```

## Requisitos

- [ ] La interfaz `Pagable` declara métodos abstractos y un método `default`.
- [ ] Ambas clases la implementan con `implements`.
- [ ] La comisión se devuelve desde `getComision()`.
- [ ] El método `default` se usa sin sobrescribirlo.
- [ ] Compilarlo localmente con `javac Pagos.java` y ejecutarlo con `java Pagos` para verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- En una interfaz los métodos sin cuerpo son abstractos: `void procesarPago(double monto);`.
- Un método `default` tiene cuerpo y puede usarse tal cual.
- `implements` solo va en la clase, y debe implementar todos los abstractos.
- Declara la lista como `List<Pagable>` para aprovechar el polimorfismo.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````java
import java.util.List;

public class Pagos {
    interface Pagable {
        void procesarPago(double monto);

        double getComision();

        default void mostrarResumen(double monto) {
            System.out.println("Pago de " + monto
                    + " procesado con comisión " + getComision() + "%");
        }
    }

    static class TarjetaCredito implements Pagable {
        @Override
        public void procesarPago(double monto) {
            System.out.println("Tarjeta: pagado " + monto);
        }

        @Override
        public double getComision() {
            return 2.5;
        }
    }

    static class PayPal implements Pagable {
        @Override
        public void procesarPago(double monto) {
            System.out.println("PayPal: pagado " + monto);
        }

        @Override
        public double getComision() {
            return 1.0;
        }
    }

    public static void main(String[] args) {
        List<Pagable> pagos = List.of(new TarjetaCredito(), new PayPal());
        for (Pagable p : pagos) {
            p.procesarPago(100);
            p.mostrarResumen(100);
        }
    }
}
````

</details>