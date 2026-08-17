# Ejercicio 04 — Productor-consumidor

- **Nivel:** 5/5
- **Tema:** `BlockingQueue`, `ArrayBlockingQueue`, `ExecutorService`, `Future`
- **Tiempo estimado:** 45 min

## Enunciado

Crea un archivo `ProductorConsumidor.java` que implemente el patrón productor-consumidor:

1. Cree un `ArrayBlockingQueue<Integer>` con capacidad 3.
2. Un productor (`Runnable`) que genere los números del 1 al 10 y los inserte con `queue.put(n)` (bloquea si la cola está llena), imprimiendo `"Producido: <n>"`.
3. Un consumidor (`Runnable`) que retire con `queue.take()` (bloquea si la cola está vacía), imprimiendo `"Consumido: <n>"`, y que se detenga tras 10 elementos.
4. Lance ambos con `ExecutorService` (dos hilos), espere a que terminen con `Future.get()` y cierre el pool.
5. Añada una pausa pequeña (`Thread.sleep(50)`) en el productor para que el consumidor no se adelante todo.

Salida esperada (el orden exacto puede variar por los hilos):

```
Producido: 1
Consumido: 1
Producido: 2
...
Producido: 10
Consumido: 10
Total consumido: 10
```

## Requisitos

- [ ] Usar `ArrayBlockingQueue` con capacidad acotada.
- [ ] `put` y `take` bloquean (no usar `add`/`poll` sin bloqueo).
- [ ] El productor produce exactamente 10 números y el consumidor consume 10.
- [ ] Esperar el fin con `Future.get()` y cerrar con `shutdown()`.
- [ ] Compilarlo localmente con `javac ProductorConsumidor.java` y ejecutarlo con `java ProductorConsumidor` para verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `new ArrayBlockingQueue<Integer>(3)` es la cola compartida.
- El consumidor necesita saber cuándo parar: consume `while (consumidos < 10)`.
- `Thread.sleep(50)` dentro de un try/catch `InterruptedException`.
- Para usar un contador compartido de consumidos, hazlo `AtomicInteger` o sincronizado.
- `Future.get()` lanza `ExecutionException` (checked).

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````java
import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.concurrent.atomic.AtomicInteger;

public class ProductorConsumidor {
    public static void main(String[] args) throws Exception {
        BlockingQueue<Integer> cola = new ArrayBlockingQueue<>(3);
        AtomicInteger consumidos = new AtomicInteger(0);

        Runnable productor = () -> {
            for (int n = 1; n <= 10; n++) {
                try {
                    cola.put(n);
                    System.out.println("Producido: " + n);
                    Thread.sleep(50);
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                    return;
                }
            }
        };

        Runnable consumidor = () -> {
            while (consumidos.get() < 10) {
                try {
                    Integer n = cola.take();
                    consumidos.incrementAndGet();
                    System.out.println("Consumido: " + n);
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                    return;
                }
            }
        };

        ExecutorService pool = Executors.newFixedThreadPool(2);
        Future<?> fProd = pool.submit(productor);
        Future<?> fCons = pool.submit(consumidor);

        fProd.get();
        fCons.get();
        pool.shutdown();

        System.out.println("Total consumido: " + consumidos.get());
    }
}
````

</details>