import asyncio
import unittest

from main import (
    con_timeout,
    descargar,
    descarga_limitada,
    disparar_evento,
    esperar_evento,
    lanzar_descargas,
)


class TestDescargas(unittest.IsolatedAsyncioTestCase):

    async def test_descargar_devuelve_mensaje(self):
        self.assertEqual(await descargar("x", 0), "x descargado")

    async def test_descarga_limitada(self):
        semaforo = asyncio.Semaphore(1)
        self.assertEqual(await descarga_limitada("t0", semaforo), "t0 descargado")

    async def test_lanzar_descargas_devuelve_cinco(self):
        resultados = await lanzar_descargas()
        self.assertEqual(len(resultados), 5)
        self.assertEqual(resultados[0], "t0 descargado")
        self.assertEqual(resultados[4], "t4 descargado")

    async def test_lanzar_descargas_respeta_limite_concurrencia(self):
        loop = asyncio.get_running_loop()
        inicio = loop.time()
        await lanzar_descargas(5)
        transcurrido = loop.time() - inicio
        # 5 tareas de 0.5s con límite 2 => 3 tandas: entre 1.2s y 2.5s
        self.assertGreaterEqual(transcurrido, 1.2)
        self.assertLess(transcurrido, 2.5)


class TestTimeout(unittest.IsolatedAsyncioTestCase):

    async def test_con_timeout_devuelve_tiempo_agotado(self):
        self.assertEqual(await con_timeout(), "Tiempo agotado")

    async def test_con_timeout_no_excede_el_limite(self):
        loop = asyncio.get_running_loop()
        inicio = loop.time()
        await con_timeout()
        self.assertLess(loop.time() - inicio, 4.0)


class TestEvento(unittest.IsolatedAsyncioTestCase):

    async def test_evento_sincroniza_dos_tareas(self):
        event = asyncio.Event()
        recibido, disparado = await asyncio.gather(
            esperar_evento(event),
            disparar_evento(event),
        )
        self.assertEqual(recibido, "Evento recibido")
        self.assertEqual(disparado, "Evento disparado")
        self.assertTrue(event.is_set())


if __name__ == "__main__":
    unittest.main()