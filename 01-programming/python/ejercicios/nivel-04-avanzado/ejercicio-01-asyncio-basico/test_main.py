import asyncio
import unittest

from main import ejecutar_paralelo, ejecutar_secuencial, main, tarea


class TestTarea(unittest.IsolatedAsyncioTestCase):

    async def test_tarea_devuelve_mensaje(self):
        self.assertEqual(await tarea("A", 0), "A terminada")

    async def test_tarea_respeta_la_espera(self):
        loop = asyncio.get_running_loop()
        inicio = loop.time()
        await tarea("B", 0.1)
        self.assertGreaterEqual(loop.time() - inicio, 0.1)


class TestEjecuciones(unittest.IsolatedAsyncioTestCase):

    async def test_secuencial_devuelve_resultados_en_orden(self):
        tiempo, resultados = await ejecutar_secuencial()
        self.assertEqual(resultados, ["A terminada", "B terminada"])
        self.assertGreaterEqual(tiempo, 3.0)

    async def test_paralelo_devuelve_resultados_en_orden(self):
        tiempo, resultados = await ejecutar_paralelo()
        self.assertEqual(resultados, ["A terminada", "B terminada"])
        self.assertGreaterEqual(tiempo, 2.0)

    async def test_paralelo_mas_rapido_que_secuencial(self):
        tiempo_s, _ = await ejecutar_secuencial()
        tiempo_p, _ = await ejecutar_paralelo()
        self.assertLess(tiempo_p, tiempo_s)


class TestMain(unittest.IsolatedAsyncioTestCase):

    async def test_main_ejecuta_sin_errores(self):
        await main()


if __name__ == "__main__":
    unittest.main()