# Ejercicio 06 — Testing con asserts propios

- **Nivel:** 4/5
- **Tema:** pruebas unitarias caseras, `assert`, mini-framework de test
- **Tiempo estimado:** 35 min

## Enunciado

Crea un archivo `Testing.java` que implemente un **minúsculo framework de testing sin JUnit**:

1. Defina una clase `Calculadora` con métodos estáticos `sumar(a, b)` y `esPar(int n)`.
2. Defina una clase `Asserts` con un contador estático de fallos y métodos estáticos:
   - `assertEquals(int esperado, int actual)` — imprime `OK` o `FALLO: esperado X pero fue Y` e incrementa fallos.
   - `assertTrue(boolean condicion, String mensaje)` — similar.
3. Un método `testSuma()` que compruebe `sumar(2, 3) == 5`, `sumar(-1, 1) == 0` y `sumar(0, 0) == 0`.
4. Un método `testEsPar()` que compruebe `esPar(4)` true, `esPar(3)` false.
5. En `main`, ejecute ambos tests, imprima el número de fallos y finalice con `System.exit(fallos == 0 ? 0 : 1)` para que el exit code indique si pasaron.

Salida esperada:

```
OK: sumar(2,3)=5
OK: sumar(-1,1)=0
OK: sumar(0,0)=0
OK: esPar(4)
OK: esPar(3)=false
Fallos: 0
```

## Requisitos

- [ ] No usar JUnit ni ninguna librería: asserts propios.
- [ ] Los asserts cuentan y reportan fallos.
- [ ] Al menos 5 comprobaciones entre los dos tests.
- [ ] `System.exit(0)` si no hay fallos, `System.exit(1)` si los hay.
- [ ] Compilarlo localmente con `javac Testing.java` y ejecutarlo con `java Testing` para verificar la salida y el exit code.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `assertEquals` recibe lo esperado y lo actual, y los compara con `==`.
- Guarda los fallos en `static int fallos`.
- Cada método de test llama a los asserts y termina imprimiendo su resultado.
- `System.exit(0)` indica éxito al shell; `echo $?` tras ejecutar `java Testing` muestra 0.
- En terminal Linux/Mac: `java Testing; echo "Exit code: $?"`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````java
public class Testing {
    static class Calculadora {
        static int sumar(int a, int b) {
            return a + b;
        }

        static boolean esPar(int n) {
            return n % 2 == 0;
        }
    }

    static class Asserts {
        static int fallos = 0;

        static void assertEquals(int esperado, int actual) {
            if (esperado == actual) {
                System.out.println("OK: esperado " + esperado + " = actual " + actual);
            } else {
                System.out.println("FALLO: esperado " + esperado + " pero fue " + actual);
                fallos++;
            }
        }

        static void assertTrue(boolean condicion, String mensaje) {
            if (condicion) {
                System.out.println("OK: " + mensaje);
            } else {
                System.out.println("FALLO: " + mensaje);
                fallos++;
            }
        }
    }

    static void testSuma() {
        Asserts.assertEquals(5, Calculadora.sumar(2, 3));
        Asserts.assertEquals(0, Calculadora.sumar(-1, 1));
        Asserts.assertEquals(0, Calculadora.sumar(0, 0));
    }

    static void testEsPar() {
        Asserts.assertTrue(Calculadora.esPar(4), "esPar(4)");
        Asserts.assertTrue(!Calculadora.esPar(3), "esPar(3)=false");
    }

    public static void main(String[] args) {
        testSuma();
        testEsPar();

        System.out.println("Fallos: " + Asserts.fallos);
        System.exit(Asserts.fallos == 0 ? 0 : 1);
    }
}
````

</details>