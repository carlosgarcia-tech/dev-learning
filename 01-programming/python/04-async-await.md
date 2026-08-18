# 04 — Async/Await en Python

## Objetivos

- [ ] Entender la diferencia entre concurrencia y paralelismo.
- [ ] Conocer el GIL y saber cuándo usar `asyncio`, threads o procesos.
- [ ] Comprender qué es el event loop y cómo funciona la ejecución cooperativa.
- [ ] Escribir corrutinas con `async def` y ejecutarlas con `asyncio.run()`.
- [ ] Usar `await` para pausar y esperar operaciones asíncronas sin bloquear el hilo.
- [ ] Programar tareas en segundo plano con `asyncio.create_task()`.
- [ ] Ejecutar varias corrutinas a la vez con `asyncio.gather()` y `asyncio.wait()`.
- [ ] Controlar tiempos de espera con `asyncio.timeout()` / `asyncio.wait_for()`.
- [ ] Cancelar tareas con `task.cancel()` y manejar `asyncio.CancelledError`.
- [ ] Mover I/O bloqueante síncrona a un hilo con `asyncio.to_thread()`.
- [ ] Hacer peticiones HTTP concurrentes con `aiohttp`.
- [ ] Limitar la concurrencia con `asyncio.Semaphore` y manejar excepciones en corrutinas.

## Apuntes

### Concurrencia, paralelismo y el GIL

La **concurrencia** es la capacidad de un programa de **avanzar en varias tareas de forma intercalada**: ninguna espera a que las demás terminen para progresar. El **paralelismo** es ejecutar varias tareas **literalmente al mismo tiempo**, usando varios núcleos de CPU. Son conceptos distintos: se puede tener concurrencia sin paralelismo (y casi siempre en Python es lo que ocurre).

Python tiene una particularidad que condiciona el paralelismo: el **GIL** (*Global Interpreter Lock*). Es un bloqueo que permite que **solo un hilo Python ejecute bytecode a la vez**, por lo que los *threads* no dan paralelismo real para código CPU-intensivo puro. El GIL se libera mientras se espera I/O, así que los threads sí sirven para I/O.

Esto nos deja tres herramientas, cada una con su caso:

| Herramienta | Mecanismo | Ideal para | Limitación |
|-------------|-----------|------------|------------|
| `asyncio` | Event loop de un solo hilo, I/O no bloqueante | Muchas conexiones de red/I/O concurrentes | No acelera CPU puro |
| `threading` | Múltiples hilos del SO | I/O bloqueante con librerías que no tienen versión asíncrona | GIL limita el CPU; gestión de hilos costosa |
| `multiprocessing` | Procesos independientes | Cálculo CPU-intensivo | Más costoso de crear y comunicar |

Regla práctica:

- ¿El cuello de botella es **esperar** (red, disco, APIs)? → `asyncio` (o threads si la librería es bloqueante).
- ¿El cuello de botella es **calcular**? → `multiprocessing` (o librerías como `numpy` que liberan el GIL).

`asyncio` no hace más rápido el código: hace que un programa que **espera** I/O aproveche ese tiempo de espera para avanzar otras tareas.

### Fundamentos: el event loop

El **event loop** es el corazón de `asyncio`: un bucle que repite "¿hay algo que ejecutar o esperar?" y, cuando una operación de I/O termina, retoma la corrutina que la estaba esperando. Todo el código asíncrono vive dentro de este bucle y, salvo que lo cambies explícitamente, hay **un solo event loop por hilo**.

El event loop gestiona una cola de *callbacks* y tareas pendientes. Cuando una corrutina hace `await`, "congela" su estado (las variables locales, el punto donde se quedó) y cede el control al loop. Cuando el resultado llega, el loop **reanuda la corrutina exactamente donde se pausó**. Ese "congelar y ceder" es lo que hace que la asincronía sea **cooperativa**: cada corrutina colabora dejando que otras avancen mientras espera.

### Corrutinas: `async def` y `await`

Una **corrutina** es una función declarada con `async def`. Su característica clave es que **no se ejecuta al llamarla**: llamarla crea y devuelve un *objeto corrutina* que solo se ejecutará dentro del event loop.

```python
async def saludar(nombre):
    await asyncio.sleep(1)          # simula una operación lenta
    return f"Hola, {nombre}"

c = saludar("Ana")                  # NO se ejecuta nada todavía
print(type(c))                      # <class 'coroutine'>
```

`await` solo puede usarse **dentro** de una corrutina, y lo que hay a su derecha debe ser *awaitable*: una corrutina, una `asyncio.Task`, un `asyncio.Future` o un objeto que implemente `__await__`. Al encontrar `await`, la corrutina se pausa y el control vuelve al event loop hasta que el awaitable termina:

```python
import asyncio

async def saludar(nombre):
    await asyncio.sleep(1)          # se pausa aquí, el loop hace otras cosas
    return f"Hola, {nombre}"

async def main():
    mensaje = await saludar("Ana")  # el loop reanuda saludar y espera su resultado
    print(mensaje)

asyncio.run(main())                 # Hola, Ana
```

La regla de oro: **todo lo que haya `await` debe estar dentro de `async def`**, y toda cadena de `await` acaba (eventualmente) en `asyncio.run()`, que es quien arranca el loop.

### `asyncio.run()`: el punto de entrada

`asyncio.run(corrutina)` crea un event loop nuevo, ejecuta la corrutina que recibe, espera a que termine, cierra el loop y limpia los recursos. Es la forma **recomendada y única** de arrancar asyncio en un programa normal:

```python
import asyncio

async def main():
    await asyncio.sleep(1)
    return "Listo"

resultado = asyncio.run(main())     # "Listo"
```

No se debe llamar `asyncio.run()` dentro de un loop que ya está corriendo (por ejemplo, dentro de otra corrutina): lanza `RuntimeError`. Cada programa debería tener **una sola llamada** a `asyncio.run()`, normalmente en el punto de entrada.

### `asyncio.sleep()` y la ejecución cooperativa

`asyncio.sleep(segundos)` es la forma asíncrona de esperar: **no bloquea** el hilo, sino que suspende la corrutina actual y le da al event loop la oportunidad de ejecutar otras tareas. Es la herramienta perfecta para simular I/O lenta en ejemplos.

```python
import asyncio

async def saludar(nombre, demora):
    await asyncio.sleep(demora)
    print(f"Hola, {nombre}")

async def main():
    await saludar("Ana", 2)
    await saludar("Luis", 2)

asyncio.run(main())                 # imprime Ana y 2 s después Luis
```

El ejemplo anterior es **secuencial**: `await saludar("Luis", 2)` no empieza hasta que `saludar("Ana", 2)` termina. Total: 4 s.

### Secuencial vs concurrente: el ejemplo clave

Para que las esperas se **solapen**, las corrutinas deben ejecutarse al mismo tiempo dentro del loop. Compara:

```python
import asyncio
import time

async def tarea(nombre, segundos):
    await asyncio.sleep(segundos)
    return f"{nombre} terminada"

async def secuencial():
    inicio = time.perf_counter()
    r1 = await tarea("A", 1)
    r2 = await tarea("B", 2)
    return time.perf_counter() - inicio, [r1, r2]

async def concurrente():
    inicio = time.perf_counter()
    r1, r2 = await asyncio.gather(tarea("A", 1), tarea("B", 2))
    return time.perf_counter() - inicio, [r1, r2]

async def main():
    t_s, _ = await secuencial()
    print(f"Secuencial: {t_s:.2f}s")      # ~3.00s
    t_c, _ = await concurrente()
    print(f"Concurrente: {t_c:.2f}s")     # ~2.00s

asyncio.run(main())
```

- **Secuencial:** `await tarea("A", 1)` bloquea la corrutina principal hasta que A termina; después empieza B. Tiempo total = 1 + 2 = 3 s.
- **Concurrente:** `gather` arranca A y B a la vez; mientras A duerme 1 s, B ya está avanzando. Tiempo total = 2 s (el mayor de los dos).

La clave: `await` sobre **corrutinas llamadas en línea** siempre es secuencial. Para concurrencia hay que *programar* las corrutinas como tareas o pasarlas a `gather`.

### Tasks: `asyncio.create_task()`

Una **tarea** (`asyncio.Task`) envuelve una corrutina y la programa para que se ejecute **concurrentemente** con el resto del loop, en cuanto este tenga ocasión. Con `create_task()` la corrutina **empieza a correr en segundo plano** inmediatamente, sin esperar un `await`:

```python
import asyncio

async def contar(nombre, demora):
    for i in range(3):
        await asyncio.sleep(demora)
        print(f"{nombre}: {i}")

async def main():
    tarea1 = asyncio.create_task(contar("A", 0.5))
    tarea2 = asyncio.create_task(contar("B", 0.3))
    await tarea1            # esperamos a que termine, pero ambas ya corren
    await tarea2

asyncio.run(main())
```

Dos reglas importantes:

1. **Si creas una tarea, debes esperarla** (`await tarea`) o recoger su resultado en algún momento; si no, al cerrar el loop recibirás la advertencia *"Task was destroyed but it is pending"*.
2. La tarea empieza a ejecutarse **solo cuando el control vuelve al event loop** (en el siguiente `await` o al final de la corrutina actual). Por eso conviene crear todas las tareas **antes** del primer `await`.

### `asyncio.gather()`

`asyncio.gather(*awaitables)` programa varios awaitables para que corran concurrentemente, los espera a todos y devuelve una **lista con sus resultados en el mismo orden** en que se pasaron:

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
    # ['a.txt descargado', 'b.txt descargado', 'c.txt descargado']

asyncio.run(main())
```

Comportamiento destacable:

- Si una corrutina falla, la excepción se propaga en el punto del `gather` y, **por defecto, las demás tareas se cancelan**. Con `return_exceptions=True` las excepciones se devuelven como valores en la lista y no se propagan:

```python
async def main():
    resultados = await asyncio.gather(
        descargar("ok.txt", 1),
        descargar("falla.txt", 0.5),
        return_exceptions=True,
    )
    print(resultados)  # ['ok.txt descargado', TimeoutError / la excepción, ...]
```

- Para pasar una lista dinámica, se usa el desempaquetado `*`:

```python
tareas = [descargar(u, i / 10) for i, u in enumerate(urls)]
resultados = await asyncio.gather(*tareas)
```

`gather` es la opción por defecto cuando el objetivo es "lanza esto a la vez y recoge los resultados".

### `asyncio.wait()`

`asyncio.wait(tareas, ...)` espera un **conjunto de tareas** y devuelve una tupla `(done, pending)` con las que terminaron y las que siguen pendientes. No agrupa resultados por orden; sirve para escenarios más finos, como reaccionar a la primera que termine:

```python
import asyncio

async def main():
    t1 = asyncio.create_task(asyncio.sleep(1, result="rápida"))
    t2 = asyncio.create_task(asyncio.sleep(3, result="lenta"))

    done, pending = await asyncio.wait(
        {t1, t2},
        return_when=asyncio.FIRST_COMPLETED,
    )
    for t in done:
        print(t.result())       # "rápida"
    for t in pending:
        t.cancel()              # cancelamos la que sigue pendiente

asyncio.run(main())
```

Los modos de `return_when`:

| Modo | Espera hasta |
|------|--------------|
| `asyncio.ALL_COMPLETED` | Terminen todas (por defecto) |
| `FIRST_COMPLETED` | Termine la primera |
| `FIRST_EXCEPTION` | La primera que lance una excepción |

> Nota: desde Python 3.11, `asyncio.wait()` acepta timeouts con `timeout=`; para tareas simples con resultados ordenados, `gather` suele ser más directo.

### Timeouts: `asyncio.timeout()` y `asyncio.wait_for()`

A veces una operación no puede esperar indefinidamente. Desde Python 3.11, `asyncio.timeout(segundos)` se usa como *context manager* y lanza `TimeoutError` si el bloque tarda más:

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

Para **reintentar** se envuelve cada intento en su propio bloque con timeout:

```python
async def operacion():
    await asyncio.sleep(3)
    return "ok"

async def intentar_con_timeout():
    for intento in range(3):
        try:
            async with asyncio.timeout(1):
                return await operacion()
        except TimeoutError:
            print(f"Intento {intento + 1} agotado")

print(asyncio.run(intentar_con_timeout()))
```

En Python **anterior a 3.11** se usa `asyncio.wait_for(awaitable, timeout=...)`, que lanza `asyncio.TimeoutError` (subclase de `TimeoutError` desde 3.11, antes era distinta). `wait_for` sigue funcionando en versiones nuevas, así que es la opción más portable:

```python
async def main():
    try:
        await asyncio.wait_for(lento(), timeout=1)
    except TimeoutError:
        print("Se agotó el tiempo")
```

Al expirar, `timeout`/`wait_for` **cancelan la tarea** subyacente en lugar de dejarla corriendo en segundo plano.

### Cancelación de tareas

`task.cancel()` solicita que una tarea se cancele: el loop lanza `asyncio.CancelledError` dentro de la corrutina, en el `await` donde esté pausada. La corrutina puede manejarlo para limpiar recursos, y si decide propagarlo (lo habitual) la tarea termina:

```python
import asyncio

async def tarea_larga():
    try:
        await asyncio.sleep(60)
    except asyncio.CancelledError:
        print("Limpiando recursos...")
        raise                    # si no se propaga, la cancelación no se completa

async def main():
    tarea = asyncio.create_task(tarea_larga())
    await asyncio.sleep(0.1)
    tarea.cancel()               # pedimos la cancelación
    try:
        await tarea
    except asyncio.CancelledError:
        print("Tarea cancelada")

asyncio.run(main())
```

Puntos clave:

- Si la corrutina **no propaga** `CancelledError`, la tarea termina como "cancelada con éxito" pero el estado interno puede quedar inconsistente; la recomendación es `except asyncio.CancelledError: ... ; raise`.
- `await` sobre una tarea cancelada lanza `CancelledError` (o `asyncio.TimeoutError` si fue un timeout).
- No uses `except Exception` "desnudo" alrededor de una tarea cancelable: `CancelledError` hereda de `BaseException` (no de `Exception`) justamente para que los `except Exception` no se lo traguen y rompan la cancelación.

### Tabla comparativa de funciones de `asyncio`

| Función | Qué hace | Cuándo usarla |
|---------|----------|---------------|
| `asyncio.run(corrutina)` | Crea el loop, ejecuta la corrutina y lo cierra | Punto de entrada del programa, una sola vez |
| `asyncio.create_task(corrutina)` | Programa la corrutina para correr en segundo plano | Lanzar tareas independientes que luego esperarás |
| `asyncio.gather(*awaitables)` | Ejecuta varias a la vez y devuelve resultados en orden | Lanzar un grupo y recoger todos los resultados |
| `asyncio.wait(tareas, return_when=...)` | Espera un conjunto de tareas y devuelve `(done, pending)` | Reaccionar a la primera que termine o esperar un subconjunto |
| `asyncio.wait_for(awaitable, timeout=)` | Espera con límite de tiempo (Python < 3.11) | Timeouts portables a cualquier versión |
| `asyncio.timeout(segundos)` | Context manager que lanza `TimeoutError` al expirar | Timeouts legibles (Python 3.11+) |
| `asyncio.to_thread(fn, *args)` | Ejecuta una función síncrona en un hilo del pool | Llamar librerías bloqueantes sin bloquear el loop |
| `asyncio.sleep(segundos)` | Espera sin bloquear el hilo | Simular I/O, dar respiro al loop |
| `asyncio.Semaphore(n)` | Limita cuántas corrutinas entran a la vez | Controlar concurrencia sobre recursos limitados |

### I/O síncrona bloqueante: `asyncio.to_thread()`

Cuando una librería no tiene versión asíncrona (p. ej. `requests`, `time.sleep`, lectura de archivos con `open`, una base de datos), su llamada **bloquea todo el event loop**: mientras dura, ninguna otra corrutina avanza. `asyncio.to_thread(fn, *args)` mueve la llamada a un hilo del pool de asyncio y devuelve un awaitable que se puede esperar con `await`:

```python
import asyncio
import time

def trabajo_sincrono(x):           # función normal, síncrona y bloqueante
    time.sleep(0.5)                # simula I/O bloqueante
    return x * 2

async def main():
    resultado = await asyncio.to_thread(trabajo_sincrono, 21)
    print(resultado)               # 42

asyncio.run(main())
```

Mientras el hilo ejecuta `trabajo_sincrono`, el event loop **sigue libre** y puede atender otras corrutinas. Alternativa equivalente: `loop.run_in_executor(None, fn, *args)`. Regla: si tienes que llamar código síncrono y bloqueante desde asyncio, envuélvelo con `to_thread`.

### `aiohttp`: HTTP concurrente

`aiohttp` es la librería asíncrona de referencia para HTTP. Con ella, cada petición es una corrutina y las esperas de red **no bloquean el loop**, de modo que cientos de peticiones pueden viajar a la vez.

Instalación:

```bash
pip install aiohttp
```

Uso básico con `aiohttp.ClientSession`, que **reutiliza conexiones** (imprescindible para rendimiento, igual que `HttpClient` en C#):

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

Claves:

- **Una sola sesión** para todas las peticiones, creada con `async with` para que se cierre al terminar.
- El `async with session.get(url) as resp:` cierra la respuesta al salir; `resp` se lee con `await resp.text()` o `await resp.json()`.
- Combinado con `gather`, todas las peticiones se lanzan y se esperan de forma concurrente; el tiempo total ≈ la petición más lenta, no la suma.
- Para límites de concurrencia sobre la sesión se puede usar `aiohttp.TCPConnector(limit=n)` o un `asyncio.Semaphore` (ver buenas prácticas).

### Buenas prácticas

**1. No bloquees el event loop.** Todo lo que bloquee el hilo (síncrono y CPU puro) congela TODAS las corrutinas, no solo la tuya. Usa siempre la versión asíncrona si existe (`asyncio.sleep` en vez de `time.sleep`, `aiohttp` en vez de `requests`) y `to_thread`/`multiprocessing` para lo que no tiene versión asíncrona.

**2. Limita la concurrencia con `asyncio.Semaphore`.** Lanzar 10 000 corrutinas contra una API es posible, pero satura al servidor. Un semáforo limita cuántas entran a la vez:

```python
import asyncio

async def tarea(nombre, semaforo):
    async with semaforo:                     # adquiere y libera automáticamente
        await asyncio.sleep(0.5)
        print(f"Completada {nombre}")

async def main():
    semaforo = asyncio.Semaphore(2)          # máximo 2 a la vez
    tareas = [tarea(f"t{i}", semaforo) for i in range(6)]
    await asyncio.gather(*tareas)

asyncio.run(main())
```

**3. Maneja las excepciones donde haces `await`.** Una corrutina fallida solo se nota cuando la esperas. Si no quieres que una falla tire todo el grupo, usa `return_exceptions=True` en `gather` o captura la excepción por tarea:

```python
async def descargar(url):
    if "mal" in url:
        raise ValueError(f"URL inválida: {url}")
    return f"Descargado {url}"

async def main():
    resultados = await asyncio.gather(
        descargar("https://a.com"),
        descargar("https://mal.com"),
        return_exceptions=True,
    )
    for r in resultados:
        if isinstance(r, Exception):
            print("Falló:", r)
        else:
            print(r)

asyncio.run(main())
```

**4. Espera siempre las tareas que creas.** Toda tarea creada con `create_task()` debe tener un `await` (o `gather`/`wait`) que la recoja; si no, se cierra con el loop con una advertencia y su resultado se pierde.

**5. Usa `async with` para recursos.** Sesiones de `aiohttp`, semáforos, locks y timeouts deben cerrarse/liberarse; el context manager asíncrono se encarga aunque haya excepciones.

**6. Prefiere `gather` para "recoger resultados" y `wait`/`FIRST_COMPLETED` para "reaccionar al más rápido".** Con `gather` el orden de los resultados coincide con el orden de entrada; con `wait` gestionas los que quedan pendientes.

## Errores comunes

| Error | Corrección |
|-------|------------|
| **Llamar una corrutina y olvidar `await`** → `RuntimeWarning: coroutine '...' was never awaited`, y la corrutina jamás se ejecuta. | Escribe `await` delante: `resultado = await saludar("Ana")`. |
| **`await` fuera de `async def`** → `SyntaxError: 'await' outside function` (o `RuntimeError`). | Solo se puede `await` dentro de una corrutina; usa `asyncio.run()` para arrancar. |
| **Bloquear el loop con `time.sleep()`** → toda la aplicación se congela, aunque haya otras tareas listas. | Usa `await asyncio.sleep()`. Para librerías bloqueantes, `asyncio.to_thread()`. |
| **Llamar `asyncio.run()` dentro de otra corrutina o del mismo loop** → `RuntimeError: asyncio.run() cannot be called from a running event loop`. | Una sola llamada a `asyncio.run()` en el punto de entrada; dentro del loop usa `await` o `create_task`. |
| **`await` secuencial sobre corrutinas en línea** → las corrutinas no se solapan, el tiempo suma. | Usa `asyncio.gather(*corrutinas)` o crea tareas con `asyncio.create_task()`. |
| **Crear tareas y no esperarlas** → *"Task was destroyed but it is pending"* y resultados perdidos. | Guarda la referencia y haz `await tarea` (o `await asyncio.gather(*tareas)`). |
| **Esperar paralelismo real de `asyncio`** → el código CPU-intensivo bloquea igual: asyncio es de un solo hilo. | Para CPU puro usa `multiprocessing` (o librerías que liberen el GIL). |
| **`except Exception` que se traga `CancelledError`** → la cancelación no se completa y la tarea queda en estado raro. | `CancelledError` es `BaseException`; captúrala explícitamente y haz `raise` después de limpiar. |
| **No cerrar la sesión de `aiohttp`** → fugas de conexiones y sockets agotados. | Usa `async with aiohttp.ClientSession() as session:` y reutiliza una sola sesión. |
| **`asyncio.wait_for` que no cancela la tarea al expirar** → el trabajo sigue en segundo plano. | Confía en el comportamiento por defecto (cancela) o cancela explícitamente las `pending` devueltas por `wait`. |
| **Usar `asyncio.timeout()` en Python < 3.11** → `AttributeError` porque no existe. | Usa `asyncio.wait_for(awaitable, timeout=...)`, disponible en todas las versiones. |

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
import time

async def tarea(nombre, demora):
    await asyncio.sleep(demora)
    return f"{nombre} terminada en {demora}s"

async def main():
    inicio = time.perf_counter()
    resultados = await asyncio.gather(
        tarea("rápida", 1), tarea("lenta", 2)
    )
    print(resultados)
    print(f"Total: {time.perf_counter() - inicio:.1f}s")   # ~2.0s, no 3s

asyncio.run(main())
```

## Ejercicios relacionados

Esta guía enlaza directamente con los ejercicios del nivel 04:

- [Ejercicio 01 — Asyncio básico](../ejercicios/nivel-04-avanzado/ejercicio-01-asyncio-basico/): implementa `async def`, `await`, `asyncio.run`, `asyncio.gather` y `asyncio.sleep`, y compara la ejecución **secuencial vs paralela** midiendo tiempos con `time.perf_counter()`. Es la puesta en práctica de las secciones "Secuencial vs concurrente" y "`asyncio.gather`".
- [Ejercicio 02 — Asyncio avanzado](../ejercicios/nivel-04-avanzado/ejercicio-02-asyncio-avanzado/): combina `create_task`, `gather`, `Semaphore`, `timeout`/`wait_for` y `asyncio.Event`. Aplica las secciones de "Tasks", "Timeouts" y "Buenas prácticas".

Para el asyncio básico necesitas las secciones sobre corrutinas, `await`, `asyncio.sleep` y `gather`; para el avanzado, las de `create_task`, semáforos, cancelación/timeouts y coordinación con `asyncio.Event`. También puedes ampliar con HTTP concurrente (`aiohttp`) en el nivel experto.

## Recursos

- [Python.org — asyncio](https://docs.python.org/es/3/library/asyncio.html)
- [Python.org — Corrutinas y tareas](https://docs.python.org/es/3/library/asyncio-task.html)
- [Real Python — Async IO en Python](https://realpython.com/async-io-python/)
- [aiohttp — Documentación](https://docs.aiohttp.org/)
- [PEP 492 — Corrutinas con async y await](https://peps.python.org/pep-0492/)