# TODO: Completa el ejercicio siguiendo el enunciado de README.md.
# Sustituye cada raise NotImplementedError por la implementación correcta.

import asyncio


async def descargar(nombre: str, segundos: float) -> str:
    # TODO: espera asyncio.sleep(segundos) y devuelve f"{nombre} descargado"
    raise NotImplementedError


async def descarga_limitada(nombre: str, semaforo: asyncio.Semaphore) -> str:
    # TODO: con "async with semaforo:", espera 0.5s y devuelve f"{nombre} descargado"
    raise NotImplementedError


async def lanzar_descargas(cantidad: int = 5) -> list[str]:
    # TODO: crea cantidad tareas con asyncio.create_task sobre descarga_limitada
    # compartiendo un asyncio.Semaphore(2) y recógelas con asyncio.gather
    raise NotImplementedError


async def con_timeout() -> str:
    # TODO: envuelve descargar("lenta", 5) en asyncio.timeout(2) (o wait_for)
    # y devuelve "Tiempo agotado" si se captura TimeoutError
    raise NotImplementedError


async def esperar_evento(event: asyncio.Event) -> str:
    # TODO: espera event.wait() y devuelve "Evento recibido"
    raise NotImplementedError


async def disparar_evento(event: asyncio.Event) -> str:
    # TODO: duerme 1s, hace event.set() y devuelve "Evento disparado"
    raise NotImplementedError


async def main() -> None:
    # TODO: imprime la salida esperada (resultados, "Tiempo agotado" y eventos)
    raise NotImplementedError


if __name__ == "__main__":
    asyncio.run(main())