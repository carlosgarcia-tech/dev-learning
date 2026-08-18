# TODO: Completa el ejercicio siguiendo el enunciado de README.md.
# Sustituye cada raise NotImplementedError por la implementación correcta.

import asyncio
import time


async def tarea(nombre: str, segundos: float) -> str:
    # TODO: espera asyncio.sleep(segundos) y devuelve f"{nombre} terminada"
    raise NotImplementedError


async def ejecutar_secuencial() -> tuple[float, list[str]]:
    # TODO: ejecuta tarea("A", 1) y tarea("B", 2) una tras otra con await,
    # mide el tiempo con time.perf_counter() y devuelve (tiempo, [r1, r2])
    raise NotImplementedError


async def ejecutar_paralelo() -> tuple[float, list[str]]:
    # TODO: ejecuta tarea("A", 1) y tarea("B", 2) con asyncio.gather,
    # mide el tiempo con time.perf_counter() y devuelve (tiempo, [r1, r2])
    raise NotImplementedError


async def main() -> None:
    # TODO: imprime "Secuencial: X.XXs" y "Paralelo: X.XXs"
    raise NotImplementedError


if __name__ == "__main__":
    asyncio.run(main())