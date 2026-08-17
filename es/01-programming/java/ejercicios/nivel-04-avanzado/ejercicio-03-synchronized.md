# Ejercicio 03 — synchronized

- **Nivel:** 4/5
- **Tema:** `synchronized`, condición de carrera, `AtomicInteger`
- **Tiempo estimado:** 30 min

## Enunciado

Crea un archivo `ContadorSeguro.java` que:

1. Defina una clase `Contador` con campo `int valor` privado, método `incrementar()` **sincronizado** y `getValor()` sincronizado.
2. Defina una clase `ContadorNoSeguro` idéntica pero **sin** `synchronized`, para comparar.
3. En `main`:
   - Crea un `ContadorNoSeguro`, lanza 10 hilos que cada uno incremente 1000 veces, espera con `join()` e imprime el valor (probablemente **no** dará 10000 por la condición de carrera).
   - Repite con `Contador` seguro e imprime el valor (debe dar **exactamente 10000**).
4. Muestra además el uso de `AtomicInteger` (`incrementAndGet`) como alternativa sin `synchronized`.

Salida esperada:

```
Contador NO seguro (esperado 10000): 9834
Contador seguro (esperado 10000): 10000
AtomicInteger (esperado 10000): 10000
```

> El valor del contador no seguro variará entre ejecuciones: esa es la condición de carrera.

## Requisitos

- [ ] Método `incrementar()` sincronizado con `synchronized`.
- [ ] 10 hilos × 1000 incrementos cada uno.
- [ ] Esperar a todos con `join()`.
- [ ] El contador seguro y el `AtomicInteger` dan exactamente 10000.
- [ ] Compilarlo localmente con `javac ContadorSeguro.java` y ejecutarlo con `java ContadorSeguro` para verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `public synchronized void incrementar() { valor++; }`.
- `valor++` son tres pasos (leer, sumar, escribir); dos hilos pueden intercalarse → carrera.
- `new AtomicInteger()` con `incrementAndGet()` es atómico sin `synchronized`.
- Lanza hilos con una lambda `() -> { for (int j = 0; j < 1000; j++) contador.incrementar(); }`.
- Guarda las referencias a los hilos en un array para hacer `join()` a todos.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````java
import java.util.concurrent.atomic.AtomicInteger;

public class ContadorSeguro {
    static class ContadorNoSeguro {
        private int valor = 0;

        public void incrementar() { // SIN synchronized
            valor++;
        }

        public int getValor() {
            return valor;
        }
    }

    static class Contador {
        private int valor = 0;

        public synchronized void incrementar() {
            valor++;
        }

        public synchronized int getValor() {
            return valor;
        }
    }

    public static void main(String[] args) throws InterruptedException {
        ContadorNoSeguro noSeguro = new ContadorNoSeguro();
        ejecutar(noSeguro::incrementar);
        System.out.println("Contador NO seguro (esperado 10000): " + noSeguro.getValor());

        Contador seguro = new Contador();
        ejecutar(seguro::incrementar);
        System.out.println("Contador seguro (esperado 10000): " + seguro.getValor());

        AtomicInteger atomico = new AtomicInteger();
        ejecutar(() -> atomico.incrementAndGet());
        System.out.println("AtomicInteger (esperado 10000): " + atomico.get());
    }

    private static void ejecutar(Runnable tarea) throws InterruptedException {
        Thread[] hilos = new Thread[10];
        for (int i = 0; i < 10; i++) {
            hilos[i] = new Thread(() -> {
                for (int j = 0; j < 1000; j++) {
                    tarea.run();
                }
            });
            hilos[i].start();
        }
        for (Thread t : hilos) {
            t.join();
        }
    }
}
````

</details>