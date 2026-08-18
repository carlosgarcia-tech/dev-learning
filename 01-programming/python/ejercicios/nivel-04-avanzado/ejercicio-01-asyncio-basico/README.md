# Ejercicio 01 — Asyncio básico

- **Nivel:** 4/5
- **Tema:** async def, await, asyncio.run, asyncio.gather, asyncio.sleep
- **Tiempo estimado:** 25 min

## Enunciado

Completa `main.py` para que implemente:

1. `tarea(nombre, segundos)` — corrutina `async` que espera `asyncio.sleep(segundos)` y devuelve `"<nombre> terminada"`.
2. `ejecutar_secuencial()` — corrutina `async` que ejecuta `tarea("A", 1)` y `tarea("B", 2)` **secuencialmente** con `await`, mide el tiempo con `time.perf_counter()` y devuelve `(tiempo, [resultados])`.
3. `ejecutar_paralelo()` — corrutina `async` que ejecuta las mismas dos tareas **en paralelo** con `asyncio.gather()`, mide el tiempo con `time.perf_counter()` y devuelve `(tiempo, [resultados])`.
4. `main()` — corrutina `async` que imprime `Secuencial: X.XXs` y `Paralelo: X.XXs`.

Salida esperada (ejemplo):

```
Secuencial: 3.01s
Paralelo: 2.01s
```

## Requisitos

- [ ] Definir corrutinas con `async def`.
- [ ] `tarea` usa `asyncio.sleep()` (no `time.sleep`).
- [ ] `ejecutar_secuencial` ejecuta las tareas una tras otra con `await`.
- [ ] `ejecutar_paralelo` usa `asyncio.gather()`.
- [ ] Medir el tiempo con `time.perf_counter()`.
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

- `asyncio.run(main())` arranca el event loop y ejecuta la corrutina principal.
- `await tarea(...)` espera a que termine; `await asyncio.gather(...)` las lanza juntas.
- `asyncio.sleep(2)` no bloquea: cede el control al event loop durante 2 segundos.
- `time.perf_counter()` mide el tiempo real transcurrido.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````python
import asyncio
import time


async def tarea(nombre: str, segundos: float) -> str:
    await asyncio.sleep(segundos)
    return f"{nombre} terminada"


async def ejecutar_secuencial() -> tuple[float, list[str]]:
    inicio = time.perf_counter()
    r1 = await tarea("A", 1)
    r2 = await tarea("B", 2)
    return time.perf_counter() - inicio, [r1, r2]


async def ejecutar_paralelo() -> tuple[float, list[str]]:
    inicio = time.perf_counter()
    r1, r2 = await asyncio.gather(tarea("A", 1), tarea("B", 2))
    return time.perf_counter() - inicio, [r1, r2]


async def main() -> None:
    tiempo_s, _ = await ejecutar_secuencial()
    print(f"Secuencial: {tiempo_s:.2f}s")
    tiempo_p, _ = await ejecutar_paralelo()
    print(f"Paralelo: {tiempo_p:.2f}s")


if __name__ == "__main__":
    asyncio.run(main())
````

</details>
