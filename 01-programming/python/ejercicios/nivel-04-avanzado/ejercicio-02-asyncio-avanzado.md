# Ejercicio 02 — Asyncio avanzado

- **Nivel:** 4/5
- **Tema:** create_task, gather, Semaphore, timeout, asyncio.Event
- **Tiempo estimado:** 30 min

## Enunciado

Crea un archivo `asyncio_avanzado.py` que:

1. Defina `async def descargar(nombre, segundos)` que espere `asyncio.sleep(segundos)` y devuelva `"<nombre> descargado"`.
2. Use `asyncio.Semaphore(2)` para limitar a 2 descargas simultáneas: la corrutina toma el semáforo con `async with`, espera `0.5s` y devuelve el resultado.
3. Lance 5 descargas con `asyncio.gather` (usando `create_task`) y recoja los resultados.
4. Use `asyncio.timeout(2)` (o `asyncio.wait_for` si tu versión de Python es anterior a 3.11) para envolver una tarea que duerme 5 segundos y capture `TimeoutError`, imprimiendo `Tiempo agotado`.
5. Use `asyncio.Event()` para sincronizar dos tareas: `esperar_evento()` espera el evento e imprime `Evento recibido`; `disparar_evento()` duerme 1s, hace `event.set()` e imprime `Evento disparado`.

Salida esperada (ejemplo):

```
['t0 descargado', 't1 descargado', 't2 descargado', 't3 descargado', 't4 descargado']
Tiempo agotado
Evento disparado
Evento recibido
```

## Requisitos

- [ ] Usar `asyncio.create_task` y `asyncio.gather`.
- [ ] Limitar concurrencia con `asyncio.Semaphore`.
- [ ] Implementar un timeout con `asyncio.timeout` o `asyncio.wait_for`.
- [ ] Sincronizar con `asyncio.Event`.
- [ ] Ejecutarlo localmente con `python3 asyncio_avanzado.py` y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `async with semaforo:` adquiere y libera el semáforo automáticamente.
- `asyncio.timeout(2)` es un context manager que lanza `TimeoutError` al pasarse del tiempo (Python 3.11+).
- En Python < 3.11 usa `await asyncio.wait_for(tarea, timeout=2)`.
- `event.wait()` bloquea la corrutina hasta que otra haga `event.set()`.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````python
import asyncio


async def descargar(nombre, segundos):
    await asyncio.sleep(segundos)
    return f"{nombre} descargado"


async def descarga_limitada(nombre, semaforo):
    async with semaforo:
        await asyncio.sleep(0.5)
        return f"{nombre} descargado"


async def esperar_evento(event):
    await event.wait()
    print("Evento recibido")


async def disparar_evento(event):
    await asyncio.sleep(1)
    event.set()
    print("Evento disparado")


async def main():
    semaforo = asyncio.Semaphore(2)
    tareas = [asyncio.create_task(descarga_limitada(f"t{i}", semaforo))
              for i in range(5)]
    resultados = await asyncio.gather(*tareas)
    print(resultados)

    try:
        async with asyncio.timeout(2):
            await descargar("lenta", 5)
    except TimeoutError:
        print("Tiempo agotado")

    event = asyncio.Event()
    await asyncio.gather(
        esperar_evento(event),
        disparar_evento(event),
    )


asyncio.run(main())
````

</details>