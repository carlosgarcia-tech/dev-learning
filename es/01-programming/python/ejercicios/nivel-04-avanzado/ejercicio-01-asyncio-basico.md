# Ejercicio 01 — Asyncio básico

- **Nivel:** 4/5
- **Tema:** async def, await, asyncio.run, asyncio.gather, asyncio.sleep
- **Tiempo estimado:** 25 min

## Enunciado

Crea un archivo `asyncio_basico.py` que:

1. Defina `async def tarea(nombre, segundos)` que espere `asyncio.sleep(segundos)` e imprima `"<nombre> terminada"` al terminar.
2. Defina `async def main()` que:
   - Ejecute `tarea("A", 1)` y `tarea("B", 2)` **secuencialmente** con `await` y mida el tiempo total con `time.perf_counter()`.
   - Después ejecute las mismas dos tareas **en paralelo** con `asyncio.gather()` y mida el tiempo total.
   - Imprima `Secuencial: X.XXs` y `Paralelo: X.XXs`.
3. Ejecute `main()` con `asyncio.run(main())`.

Salida esperada (ejemplo):

```
A terminada
B terminada
Secuencial: 3.01s
A terminada
B terminada
Paralelo: 2.01s
```

## Requisitos

- [ ] Definir corrutinas con `async def`.
- [ ] Usar `asyncio.sleep()` (no `time.sleep`).
- [ ] Comparar la ejecución secuencial frente a `asyncio.gather()`.
- [ ] Medir el tiempo con `time.perf_counter()`.
- [ ] Ejecutarlo localmente con `python3 asyncio_basico.py` y verificar que el tiempo paralelo es menor.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- `asyncio.run(main())` arranca el event loop y ejecuta la corrutina principal.
- `await tarea(...)` espera a que termine; `await asyncio.gather(...)` las lanza juntas.
- `asyncio.sleep(2)` no bloquea: cede el control al event loop durante 2 segundos.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````python
import asyncio
import time


async def tarea(nombre, segundos):
    await asyncio.sleep(segundos)
    print(f"{nombre} terminada")


async def main():
    inicio = time.perf_counter()
    await tarea("A", 1)
    await tarea("B", 2)
    print(f"Secuencial: {time.perf_counter() - inicio:.2f}s")

    inicio = time.perf_counter()
    await asyncio.gather(tarea("A", 1), tarea("B", 2))
    print(f"Paralelo: {time.perf_counter() - inicio:.2f}s")


asyncio.run(main())
````

</details>