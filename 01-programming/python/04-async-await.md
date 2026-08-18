# 04 — Async/Await en Python

## Objetivos

- [ ] Entender la diferencia entre concurrencia y paralelismo.
- [ ] Escribir corrutinas con `async def` y ejecutarlas con `asyncio.run()`.
- [ ] Usar `await` para pausar y esperar operaciones asíncronas.
- [ ] Crear y gestionar tareas con `asyncio.create_task()` y `asyncio.gather()`.
- [ ] Controlar tiempos de espera con `asyncio.timeout()` y `asyncio.sleep()`.
- [ ] Hacer peticiones HTTP concurrentes con `aiohttp`.

## Apuntes

### Programación asíncrona

La programación asíncrona permite que un programa **espere operaciones de I/O** (red, disco, bases de datos) sin bloquear el hilo, mientras otras tareas avanzan. No es paralelismo real: es **concurrencia** cooperativa gestionada por un event loop.

- **Bloqueante:** una operación de red detiene el programa hasta que termina.
- **No bloqueante:** se cede el control y se retoma cuando la operación termina.

### Corrutinas y async/await

Una corrutina se define con `async def`. Al llamarla **no se ejecuta**: devuelve un objeto corrutina que hay que ejecutar dentro del event loop, normalmente con `asyncio.run()`.

`await` se usa dentro de una corrutina para esperar otra corrutina o tarea, cediendo el control al event loop mientras tanto.

```python
import asyncio

async def saludar(nombre):
    await asyncio.sleep(1)          # simula una operación lenta
    return f"Hola, {nombre}"

async def main():
    mensaje = await saludar("Ana")
    print(mensaje)

asyncio.run(main())                 # Hola, Ana
```

### Tareas con asyncio.create_task

Para que varias corrutinas se ejecuten **simultáneamente**, hay que programarlas como tareas con `asyncio.create_task()`. Sin eso, los `await` secuenciales simplemente se ejecutan uno detrás de otro.

```python
import asyncio

async def contar(nombre, demora):
    for i in range(3):
        await asyncio.sleep(demora)
        print(f"{nombre}: {i}")

async def main():
    tarea1 = asyncio.create_task(contar("A", 0.5))
    tarea2 = asyncio.create_task(contar("B", 0.3))
    await tarea1
    await tarea2

asyncio.run(main())
```

### asyncio.gather

`asyncio.gather(*corrutinas)` ejecuta varias corrutinas/tareas a la vez y devuelve una **lista de resultados** en orden. Si una falla, por defecto propaga la excepción y cancela las demás.

```python
import asyncio

async def descargar(nombre, segundos):
    await asyncio.sleep(segundos)
    return f"{nombre} descargado"

async def main():
    resultados = await asyncio.gather(
        descargar("a.txt", 1),
        descargar("b.txt", 2),
        descargar("c.txt", 0.5),
    )
    print(resultados)

asyncio.run(main())
```

### Tiempos de espera y cancelación

- `asyncio.sleep()` espera sin bloquear.
- `asyncio.timeout()` (Python 3.11+) limita el tiempo máximo de un bloque. Antes de 3.11 se usaba `asyncio.wait_for()`.
- `.cancel()` cancela una tarea; la corrutina debe manejar `asyncio.CancelledError`.

```python
import asyncio

async def lento():
    await asyncio.sleep(10)

async def main():
    try:
        async with asyncio.timeout(1):
            await lento()
    except TimeoutError:
        print("Se agotó el tiempo")

asyncio.run(main())
```

### aiohttp para HTTP concurrente

`aiohttp` es la librería asíncrona de referencia para peticiones HTTP. `aiohttp.ClientSession` reutiliza conexiones; las peticiones con `await` no bloquean el event loop.

```python
import asyncio
import aiohttp

async def obtener(session, url):
    async with session.get(url) as resp:
        return resp.status, url

async def main():
    urls = [
        "https://httpbin.org/get",
        "https://httpbin.org/get",
        "https://httpbin.org/get",
    ]
    async with aiohttp.ClientSession() as session:
        resultados = await asyncio.gather(
            *(obtener(session, u) for u in urls)
        )
    print(resultados)

asyncio.run(main())
```

Instalación: `pip install aiohttp`.

## Ejemplos de código

```python
# Descarga concurrente con semáforo (límite de concurrencia)
import asyncio

async def tarea(nombre, semaforo):
    async with semaforo:
        await asyncio.sleep(0.5)
        print(f"Completada {nombre}")

async def main():
    semaforo = asyncio.Semaphore(2)   # máximo 2 a la vez
    tareas = [tarea(f"t{i}", semaforo) for i in range(6)]
    await asyncio.gather(*tareas)

asyncio.run(main())
```

```python
# Cronómetro de dos tareas corriendo en paralelo
import asyncio

async def tarea(nombre, demora):
    await asyncio.sleep(demora)
    return f"{nombre} terminada en {demora}s"

async def main():
    inicio = asyncio.get_event_loop().time()
    resultados = await asyncio.gather(
        tarea("rápida", 1), tarea("lenta", 2)
    )
    print(resultados)
    print(f"Total: {asyncio.get_event_loop().time() - inicio:.1f}s")

asyncio.run(main())
```

## Ejercicios relacionados

- [Ejercicios nivel 04 — Avanzado](../ejercicios/nivel-04-avanzado/)
- [Ejercicios nivel 05 — Experto](../ejercicios/nivel-05-experto/)

## Errores comunes

- **Llamar `async def` sin `await`** → advertencia "coroutine was never awaited" y la corrutina nunca se ejecuta.
- **Usar `await` fuera de una corrutina** → `SyntaxError: 'await' outside function` o `RuntimeError`.
- **Bloquear el event loop** → usar `time.sleep()` en vez de `asyncio.sleep()` bloquea todo el programa.
- **Llamar `async with` sobre un recurso síncrono** → solo funciona con objetos diseñados para asíncrono.
- **Creer que `asyncio.gather` garantiza paralelismo** → las tareas CPU-intensivas bloquean igual; para eso usa `asyncio.to_thread()` o multiprocessing.
- **No cerrar la sesión de `aiohttp`** → fugas de conexiones. Usa `async with aiohttp.ClientSession()`.

## Recursos

- [Python.org — asyncio](https://docs.python.org/es/3/library/asyncio.html)
- [Python.org — Tutorial de corrutinas y tareas](https://docs.python.org/es/3/library/asyncio-task.html)
- [Real Python — Async IO](https://realpython.com/async-io-python/)
- [aiohttp — Documentación](https://docs.aiohttp.org/)