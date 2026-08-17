# Ejercicio 02 — Threads básicos

- **Nivel:** 4/5
- **Tema:** `Thread`, `Runnable`, `start()`, `join()`, `ExecutorService`
- **Tiempo estimado:** 30 min

## Enunciado

Crea un archivo `Threads.java` que:

1. Cree 3 hilos implementando `Runnable` con una lambda: cada uno imprime `"Hilo <n> trabajando: iteración <i>"` para `i` de 0 a 2.
2. Los lance con `start()` y espere a todos con `join()`.
3. Imprima `"Fin de los hilos manuales"` después de que terminen.
4. Repita la misma tarea con `ExecutorService` (`newFixedThreadPool(3)`), usando `submit` para lanzar y `shutdown()` al final.
5. Ejecute una tarea `Callable<Integer>` que calcule `2 + 2` y obtenga el resultado con `Future.get()`.

Salida esperada (el orden de los hilos puede variar):

```
Hilo 1 trabajando: iteración 0
Hilo 2 trabajando: iteración 0
...
Fin de los hilos manuales
Tareas con pool lanzadas
Resultado del Future: 4
```

## Requisitos

- [ ] Crear hilos con `Runnable` (no extender `Thread`).
- [ ] Usar `start()` y `join()` correctamente.
- [ ] Usar `ExecutorService` con `submit`, `shutdown` y `Future.get()`.
- [ ] Incluir un `Callable<Integer>`.
- [ ] Compilarlo localmente con `javac Threads.java` y ejecutarlo con `java Threads` para verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `new Thread(() -> { ... })` crea el hilo; `t.start()` lo lanza; `t.join()` lo espera.
- `Thread.currentThread().getName()` devuelve el nombre del hilo.
- `Executors.newFixedThreadPool(3)` crea el pool.
- `pool.submit(() -> 2 + 2)` devuelve `Future<Integer>`; `future.get()` bloquea hasta tener el valor.
- `main` debe lanzar `throws InterruptedException` o capturarla.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````java
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

public class Threads {
    public static void main(String[] args) throws Exception {
        Runnable tarea = () -> {
            for (int i = 0; i < 3; i++) {
                System.out.println(Thread.currentThread().getName()
                        + " trabajando: iteración " + i);
            }
        };

        Thread h1 = new Thread(tarea, "Hilo 1");
        Thread h2 = new Thread(tarea, "Hilo 2");
        Thread h3 = new Thread(tarea, "Hilo 3");

        h1.start();
        h2.start();
        h3.start();

        h1.join();
        h2.join();
        h3.join();
        System.out.println("Fin de los hilos manuales");

        ExecutorService pool = Executors.newFixedThreadPool(3);
        for (int i = 0; i < 3; i++) {
            pool.submit(() -> System.out.println("Tarea del pool en "
                    + Thread.currentThread().getName()));
        }
        pool.shutdown();
        System.out.println("Tareas con pool lanzadas");

        Callable<Integer> calcular = () -> 2 + 2;
        ExecutorService pool2 = Executors.newSingleThreadExecutor();
        Future<Integer> futuro = pool2.submit(calcular);
        System.out.println("Resultado del Future: " + futuro.get());
        pool2.shutdown();
    }
}
````

</details>