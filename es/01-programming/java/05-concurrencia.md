# 05 — Concurrencia en Java

## Objetivos

- [ ] Entender qué es un hilo (Thread) y cómo se crea
- [ ] Usar `Runnable` y `Thread`
- [ ] Entender condiciones de carrera y usar `synchronized`
- [ ] Usar `ExecutorService` para gestionar pools de hilos
- [ ] Implementar el patrón Productor-Consumidor
- [ ] Conocer las clases del paquete `java.util.concurrent`

## Apuntes

### Crear hilos

```java
// Opción 1: extender Thread
public class MiHilo extends Thread {
    @Override
    public void run() {
        for (int i = 0; i < 5; i++) {
            System.out.println(Thread.currentThread().getName() + ": " + i);
        }
    }
}

// Opción 2: implementar Runnable (preferido, permite extender otras clases)
public class MiTarea implements Runnable {
    @Override
    public void run() {
        for (int i = 0; i < 5; i++) {
            System.out.println(Thread.currentThread().getName() + ": " + i);
        }
    }
}

public class Main {
    public static void main(String[] args) throws InterruptedException {
        MiHilo hilo1 = new MiHilo();
        hilo1.start(); // NUNCA llamar a run() directamente, eso ejecuta en el mismo hilo

        Thread hilo2 = new Thread(new MiTarea(), "hilo-tarea");
        hilo2.start();

        // Lambda (Runnable es una interfaz funcional)
        Thread hilo3 = new Thread(() -> System.out.println("Hola desde lambda"));
        hilo3.start();

        // Esperar a que terminen
        hilo1.join();
        hilo2.join();
        hilo3.join();

        System.out.println("Todos los hilos terminaron");
    }
}
```

### Condiciones de carrera y `synchronized`

Cuando varios hilos acceden y modifican el mismo estado compartido sin coordinación,
pueden producirse resultados inconsistentes (*race conditions*).

```java
public class ContadorInseguro {
    private int contador = 0;

    public void incrementar() {
        contador++; // NO es atómico: leer + sumar + escribir
    }

    public int getContador() {
        return contador;
    }
}

public class ContadorSeguro {
    private int contador = 0;

    // synchronized asegura que solo un hilo a la vez ejecute este método
    public synchronized void incrementar() {
        contador++;
    }

    public synchronized int getContador() {
        return contador;
    }
}

// Alternativa: bloque synchronized sobre un objeto de bloqueo específico
public class ContadorConLock {
    private int contador = 0;
    private final Object lock = new Object();

    public void incrementar() {
        synchronized (lock) {
            contador++;
        }
    }
}

// Alternativa moderna: AtomicInteger (sin bloqueos explícitos)
import java.util.concurrent.atomic.AtomicInteger;

public class ContadorAtomico {
    private final AtomicInteger contador = new AtomicInteger(0);

    public void incrementar() {
        contador.incrementAndGet();
    }

    public int getContador() {
        return contador.get();
    }
}
```

### ExecutorService (pools de hilos)

Crear un `Thread` por tarea es costoso. `ExecutorService` reutiliza un conjunto de hilos.

```java
import java.util.concurrent.*;

public class EjemploExecutor {
    public static void main(String[] args) throws InterruptedException, ExecutionException {
        ExecutorService executor = Executors.newFixedThreadPool(4);

        // Enviar tareas sin resultado
        for (int i = 0; i < 8; i++) {
            int tareaId = i;
            executor.submit(() -> System.out.println("Ejecutando tarea " + tareaId
                + " en " + Thread.currentThread().getName()));
        }

        // Enviar una tarea con resultado (Callable + Future)
        Future<Integer> resultado = executor.submit(() -> {
            Thread.sleep(100);
            return 42;
        });
        System.out.println("Resultado: " + resultado.get()); // bloquea hasta tener el valor

        executor.shutdown(); // no acepta nuevas tareas
        executor.awaitTermination(5, TimeUnit.SECONDS);
    }
}
```

### Productor-Consumidor con `BlockingQueue`

```java
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.LinkedBlockingQueue;

public class ProductorConsumidor {

    public static void main(String[] args) {
        BlockingQueue<Integer> cola = new LinkedBlockingQueue<>(10);

        Runnable productor = () -> {
            try {
                for (int i = 0; i < 20; i++) {
                    cola.put(i); // bloquea si la cola está llena
                    System.out.println("Produjo: " + i);
                }
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        };

        Runnable consumidor = () -> {
            try {
                for (int i = 0; i < 20; i++) {
                    int valor = cola.take(); // bloquea si la cola está vacía
                    System.out.println("Consumió: " + valor);
                }
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        };

        new Thread(productor, "productor").start();
        new Thread(consumidor, "consumidor").start();
    }
}
```

### `wait()`/`notify()` (versión manual, sin `BlockingQueue`)

```java
public class Buffer {
    private int dato;
    private boolean disponible = false;

    public synchronized void producir(int valor) throws InterruptedException {
        while (disponible) {
            wait(); // espera a que el consumidor libere el buffer
        }
        dato = valor;
        disponible = true;
        notifyAll(); // avisa a los hilos en espera
    }

    public synchronized int consumir() throws InterruptedException {
        while (!disponible) {
            wait();
        }
        disponible = false;
        notifyAll();
        return dato;
    }
}
```

### Otras herramientas útiles de `java.util.concurrent`

| Clase | Uso |
|-------|-----|
| `CountDownLatch` | Esperar a que N tareas terminen antes de continuar |
| `CyclicBarrier` | Sincronizar varios hilos en un punto común, de forma reutilizable |
| `Semaphore` | Limitar el número de hilos que acceden a un recurso simultáneamente |
| `ConcurrentHashMap` | `Map` seguro para acceso concurrente sin bloquear todo el mapa |
| `CompletableFuture` | Composición de tareas asíncronas (`thenApply`, `thenCombine`...) |

### Errores Comunes

| Error | Causa | Solución |
|-------|-------|----------|
| Resultados inconsistentes entre ejecuciones | Condición de carrera (estado compartido sin sincronizar) | `synchronized`, `Atomic*`, o estructuras concurrentes |
| `IllegalMonitorStateException` | Llamar a `wait()`/`notify()` fuera de un bloque `synchronized` | Envolver en `synchronized (objeto)` |
| Deadlock (bloqueo mutuo) | Dos hilos esperan bloqueos que el otro sostiene | Adquirir los locks siempre en el mismo orden |
| Hilos "zombis" que no terminan | No llamar a `executor.shutdown()` | Cerrar siempre el `ExecutorService` |
| `run()` en vez de `start()` | Confusión entre ambos métodos | `start()` crea un hilo nuevo; `run()` ejecuta en el hilo actual |

## Ejemplo de Código: Descarga concurrente simulada

```java
package com.ejemplo;

import java.util.List;
import java.util.concurrent.*;

public class DescargadorConcurrente {

    public static void main(String[] args) throws InterruptedException, ExecutionException {
        List<String> archivos = List.of("archivo1.zip", "archivo2.zip", "archivo3.zip", "archivo4.zip");

        ExecutorService executor = Executors.newFixedThreadPool(2);
        List<Future<String>> resultados = new java.util.ArrayList<>();

        for (String archivo : archivos) {
            resultados.add(executor.submit(() -> descargar(archivo)));
        }

        for (Future<String> resultado : resultados) {
            System.out.println(resultado.get());
        }

        executor.shutdown();
    }

    private static String descargar(String archivo) throws InterruptedException {
        Thread.sleep((long) (Math.random() * 500)); // simula latencia de red
        return archivo + " descargado por " + Thread.currentThread().getName();
    }
}
```

## Ejercicios Relacionados

- [Ejercicio 19: Threads](./ejercicios/nivel-04-avanzado/ejercicio-01-threads/)
- [Ejercicio 20: Sincronización](./ejercicios/nivel-04-avanzado/ejercicio-02-sincronizacion/)
- [Ejercicio 28: Productor-Consumidor](./ejercicios/nivel-05-experto/ejercicio-04-productor-consumidor/)

## Recursos

- [Oracle: Concurrency Tutorial](https://docs.oracle.com/javase/tutorial/essential/concurrency/)
- [java.util.concurrent (Javadoc)](https://docs.oracle.com/en/java/javase/17/docs/api/java.base/java/util/concurrent/package-summary.html)