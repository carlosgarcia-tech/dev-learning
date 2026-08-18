# Ejercicio 02 — Asyncio avanzado

- **Nivel:** 4/5
- **Tema:** create_task, gather, Semaphore, timeout, asyncio.Event
- **Tiempo estimado:** 30 min

## Enunciado

Completa `main.py` para que implemente:

1. `descargar(nombre, segundos)` — corrutina `async` que espera `asyncio.sleep(segundos)` y devuelve `"<nombre> descargado"`.
2. `descarga_limitada(nombre, semaforo)` — corrutina `async` que toma el semáforo con `async with`, espera `0.5s` y devuelve el resultado.
3. `lanzar_descargas(cantidad=5)` — corrutina `async` que crea `cantidad` tareas con `asyncio.create_task` sobre `descarga_limitada` compartiendo un `asyncio.Semaphore(2)` y las recoge con `asyncio.gather`.
4. `con_timeout()` — corrutina `async` que usa `asyncio.timeout(2)` (o `asyncio.wait_for` si tu versión de Python es anterior a 3.11) para envolver `descargar("lenta", 5)`, captura `TimeoutError` y devuelve `"Tiempo agotado"`.
5. `esperar_evento(event)` — corrutina `async` que espera el evento con `event.wait()` y devuelve `"Evento recibido"`.
6. `disparar_evento(event)` — corrutina `async` que duerme 1s, hace `event.set()` y devuelve `"Evento disparado"`.
7. `main()` — corrutina `async` que imprime la salida esperada: los resultados, `Tiempo agotado` y los mensajes del evento.

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
- [ ] Los tests pasan: `python3 test_main.py`

> **Cómo ejecutar los tests**
>
> Desde la carpeta del ejercicio:
>
> ```bash
> python3 test_main.py
> ```
>
> El runner devuelve `0` si todos los tests pasan y `1` si falla alguno.

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


async def descargar(nombre: str, segundos: float) -> str:
    await asyncio.sleep(segundos)
    return f"{nombre} descargado"


async def descarga_limitada(nombre: str, semaforo: asyncio.Semaphore) -> str:
    async with semaforo:
        await asyncio.sleep(0.5)
        return f"{nombre} descargado"


async def lanzar_descargas(cantidad: int = 5) -> list[str]:
    semaforo = asyncio.Semaphore(2)
    tareas = [
        asyncio.create_task(descarga_limitada(f"t{i}", semaforo))
        for i in range(cantidad)
    ]
    return await asyncio.gather(*tareas)


async def con_timeout() -> str:
    try:
        async with asyncio.timeout(2):
            await descargar("lenta", 5)
    except TimeoutError:
        return "Tiempo agotado"
    return "Completado"


async def esperar_evento(event: asyncio.Event) -> str:
    await event.wait()
    return "Evento recibido"


async def disparar_evento(event: asyncio.Event) -> str:
    await asyncio.sleep(1)
    event.set()
    return "Evento disparado"


async def main() -> None:
    print(await lanzar_descargas())
    print(await con_timeout())

    event = asyncio.Event()
    recibido, disparado = await asyncio.gather(
        esperar_evento(event),
        disparar_evento(event),
    )
    print(disparado)
    print(recibido)


if __name__ == "__main__":
    asyncio.run(main())
````

</details>