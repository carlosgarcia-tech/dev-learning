# Ejercicio 03 — Encapsulación

- **Nivel:** 2/5
- **Tema:** atributos `private`, getters/setters, validación, `IllegalArgumentException`
- **Tiempo estimado:** 20 min

## Enunciado

Crea un archivo `CuentaBancaria.java` que modele una cuenta con saldo encapsulado:

1. El atributo `saldo` es **privado** (`private double saldo`).
2. `getSaldo()` devuelve el saldo.
3. `depositar(double monto)` suma al saldo solo si `monto > 0`; si no, lanza `IllegalArgumentException`.
4. `retirar(double monto)` resta solo si `monto > 0` **y** `monto <= saldo`; si no, lanza `IllegalArgumentException`.
5. En `main`, crea una cuenta con saldo inicial 1000, deposita 500, intenta retirar 2000 (captura la excepción), retira 300 e imprime el saldo final.

Salida esperada:

```
Saldo inicial: 1000.0
Después de depositar 500: 1500.0
Error: No se puede retirar 2000.0, saldo disponible: 1500.0
Después de retirar 300: 1200.0
```

## Requisitos

- [ ] El atributo `saldo` es `private` (nada de acceso directo desde `main`).
- [ ] Getters y setters/métodos públicos para acceder.
- [ ] Validar montos con `throw new IllegalArgumentException(...)`.
- [ ] Capturar la excepción en `main` con `try/catch`.
- [ ] Compilarlo localmente con `javac CuentaBancaria.java` y ejecutarlo con `java CuentaBancaria` para verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- Los atributos privados solo se tocan dentro de la clase.
- `throw` lanza una excepción; en `main` envuelve la llamada en `try { ... } catch (IllegalArgumentException e) { ... }`.
- `e.getMessage()` devuelve el mensaje que pasaste al constructor.
- Usa `Math.round` si quieres formatear, o deja los decimales como salen.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````java
public class CuentaBancaria {
    private double saldo;

    public CuentaBancaria(double saldoInicial) {
        this.saldo = saldoInicial;
    }

    public double getSaldo() {
        return saldo;
    }

    public void depositar(double monto) {
        if (monto <= 0) {
            throw new IllegalArgumentException("El monto a depositar debe ser positivo");
        }
        saldo += monto;
    }

    public void retirar(double monto) {
        if (monto <= 0) {
            throw new IllegalArgumentException("El monto a retirar debe ser positivo");
        }
        if (monto > saldo) {
            throw new IllegalArgumentException(
                    "No se puede retirar " + monto + ", saldo disponible: " + saldo);
        }
        saldo -= monto;
    }

    public static void main(String[] args) {
        CuentaBancaria cuenta = new CuentaBancaria(1000);
        System.out.println("Saldo inicial: " + cuenta.getSaldo());

        cuenta.depositar(500);
        System.out.println("Después de depositar 500: " + cuenta.getSaldo());

        try {
            cuenta.retirar(2000);
        } catch (IllegalArgumentException e) {
            System.out.println("Error: " + e.getMessage());
        }

        cuenta.retirar(300);
        System.out.println("Después de retirar 300: " + cuenta.getSaldo());
    }
}
````

</details>