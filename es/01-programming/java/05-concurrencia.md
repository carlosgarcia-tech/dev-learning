# 05 — Concurrencia

## Objetivos

- [ ] Crear hilos extendiendo `Thread` o implementando `Runnable`.
- [ ] Usar `ExecutorService` para gestionar pools de hilos.
- [ ] Sincronizar acceso a recursos compartidos con `synchronized`.
- [ ] Comprender la palabra clave `volatile`.
- [ ] Evitar condiciones de carrera y *deadlocks*.
- [ ] Usar `Future` para obtener resultados de tareas asíncronas.

## Apuntes

### Threads

Un **hilo (thread)** es una unidad de ejecución independiente que corre en paralelo dentro del mismo proceso. Dos formas de crear uno:

1. Extender `Thread` y sobrescribir `run()`.
2. Implementar `Runnable` y pasarlo a un `Thread` (preferible: separa la tarea del hilo).

`start()` lanza el hilo (¡no llames a `run()` directamente, lo ejecutarías en el mismo hilo!); `join()` espera a que termine.

```java
// Opción 1: extender Thread
class MiHilo extends Thread {
    @Override
    public void run() {
        System.out.println("Soy un hilo: " + getName());
    }
}

// Opción 2: implementar Runnable (recomendada)
Runnable tarea = () -> System.out.println("Tarea en hilo: " + Thread.currentThread().getName());

public class Demo {
    public static void main(String[] args) throws InterruptedException {
        MiHilo h1 = new MiHilo();
        Thread h2 = new Thread(tarea);
        h1.start();
        h2.start();
        h1.join();  // espera a que h1 termine
        h2.join();
        System.out.println("Fin del programa");
    }
}
```

### ExecutorService

Crear hilos a mano por cada tarea es caro. Un `ExecutorService` gestiona un **pool** de hilos reutilizables:

- `Executors.newFixedThreadPool(n)` — pool fijo de `n` hilos.
- `Executors.newCachedThreadPool()` — crea hilos según la demanda.
- `submit(Callable)` / `submit(Runnable)` — devuelve un `Future` con el resultado.
- `invokeAll(...)` — ejecuta muchas tareas y espera a todas.
- `shutdown()` — termina el pool tras completar las tareas en cola.

```java
import java.util.concurrent.*;

public class DemoPool {
    public static void main(String[] args) throws Exception {
        ExecutorService pool = Executors.newFixedThreadPool(4);

        Future<Integer> fut1 = pool.submit(() -> 2 + 3);
        Future<Integer> fut2 = pool.submit(() -> 10 * 10);

        System.out.println("fut1 = " + fut1.get()); // 5 (bloquea hasta el resultado)
        System.out.println("fut2 = " + fut2.get()); // 100

        pool.shutdown();
    }
}
```

### synchronized

Cuando varios hilos tocan el mismo dato a la vez se produce una **condición de carrera**. La palabra clave `synchronized` garantiza que un solo hilo entre al bloque a la vez (cada objeto tiene un *monitor*).

- Método `synchronized` — bloquea el objeto completo durante la ejecución.
- Bloque `synchronized (objeto) { ... }` — bloquea solo una sección.
- Aplica a **métodos estáticos** bloquea la clase.

```java
public class Contador {
    private int valor = 0;

    public synchronized void incrementar() {
        valor++;
    }

    public synchronized int getValor() {
        return valor;
    }
}
```

`volatile` garantiza visibilidad entre hilos (que un hilo vea al instante el cambio de otro) pero no exclusión mutua: sirve para flags, no para incrementos.

### Riesgos: deadlock y carreras

- **Deadlock:** dos hilos esperan un recurso que el otro tiene, y ninguno avanza. Se evita con un **orden fijo de adquisición de locks**.
- **Condición de carrera:** el resultado depende del orden de ejecución. `i++` no es atómico (lee, suma, escribe).
- **Problemas de visibilidad:** un hilo puede no ver cambios hechos por otro sin `synchronized`/`volatile`.

### Patrones útiles

- `BlockingQueue` (p. ej. `ArrayBlockingQueue`) — cola segura para productor-consumidor: `put` y `take` bloquean.
- `CountDownLatch` — espera a que `n` operaciones terminen.
- `CompletableFuture` (Java 8+) — composición de tareas asíncronas al estilo moderno.

## Ejemplos de código

```java
// Suma paralela con ExecutorService
import java.util.concurrent.*;

public class SumaParalela {
    public static void main(String[] args) throws Exception {
        ExecutorService pool = Executors.newFixedThreadPool(4);
        int[] numeros = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};

        // Dividimos la suma en dos tareas
        Future<Integer> mitad1 = pool.submit(() -> {
            int s = 0;
            for (int i = 0; i < 5; i++) s += numeros[i];
            return s;
        });
        Future<Integer> mitad2 = pool.submit(() -> {
            int s = 0;
            for (int i = 5; i < 10; i++) s += numeros[i];
            return s;
        });

        int total = mitad1.get() + mitad2.get();
        System.out.println("Suma total: " + total); // 55

        pool.shutdown();
    }
}
```

```java
// Contador sincronizado con varios hilos
public class ContadorSeguro {
    private int valor = 0;

    public synchronized void incrementar() {
        valor++;
    }

    public synchronized int getValor() {
        return valor;
    }

    public static void main(String[] args) throws InterruptedException {
        ContadorSeguro c = new ContadorSeguro();
        Thread[] hilos = new Thread[10];
        for (int i = 0; i < 10; i++) {
            hilos[i] = new Thread(() -> {
                for (int j = 0; j < 1000; j++) {
                    c.incrementar();
                }
            });
            hilos[i].start();
        }
        for (Thread t : hilos) {
            t.join();
        }
        System.out.println("Valor final: " + c.getValor()); // 10000
    }
}
```

## Ejercicios relacionados

- [Ejercicios nivel 04 — Avanzado](../ejercicios/nivel-04-avanzado/)
- [Ejercicios nivel 05 — Experto](../ejercicios/nivel-05-experto/)

## Errores comunes

- **Llamar a `run()` en vez de `start()`** → ejecuta la tarea en el hilo actual, sin paralelismo.
- **No usar `join()` y esperar que el hilo haya terminado** → el `main` puede terminar antes que los hilos.
- **Compartir estado sin `synchronized`** → condiciones de carrera: el resultado varía entre ejecuciones.
- **Incrementar un `volatile` contando con seguridad** → `volatile` no hace atómico `i++`.
- **Crear un hilo nuevo por cada tarea** → caro y difícil de escalar. Usa `ExecutorService`.
- **Olvidar `shutdown()`** → el proceso puede quedar colgado sin terminar.
- **`get()` sin manejar excepciones** → `Future.get()` lanza `InterruptedException` y `ExecutionException` (checked).

## Recursos

- [Oracle — Concurrency](https://docs.oracle.com/javase/tutorial/essential/concurrency/index.html)
- [Java ExecutorService API](https://docs.oracle.com/en/java/javase/17/docs/api/java.base/java/util/concurrent/ExecutorService.html)
- [Java synchronized tutorial](https://docs.oracle.com/javase/tutorial/essential/concurrency/sync.html)
- [Baeldung — ExecutorService Guide](https://www.baeldung.com/java-executor-service-tutorial)
- [Baeldung — Java Concurrency](https://www.baeldung.com/java-concurrency)