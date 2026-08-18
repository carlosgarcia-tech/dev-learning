import contextlib
import io
import unittest

from main import crear_contador, repetir, tiempo_ejecucion


class TestClosuresYDecoradores(unittest.TestCase):

    def test_contador_acumula(self):
        incrementar = crear_contador()
        self.assertEqual(incrementar(), 1)
        self.assertEqual(incrementar(), 2)
        self.assertEqual(incrementar(), 3)

    def test_contadores_independientes(self):
        c1 = crear_contador()
        c2 = crear_contador()
        self.assertEqual(c1(), 1)
        self.assertEqual(c1(), 2)
        self.assertEqual(c1(), 3)
        self.assertEqual(c2(), 1)

    def test_tiempo_ejecucion_devuelve_resultado(self):
        def suma(a, b):
            return a + b

        envuelta = tiempo_ejecucion(suma)
        bufer = io.StringIO()
        with contextlib.redirect_stdout(bufer):
            self.assertEqual(envuelta(2, 3), 5)

    def test_tiempo_ejecucion_preserva_nombre(self):
        def mi_funcion():
            return "ok"

        envuelta = tiempo_ejecucion(mi_funcion)
        self.assertEqual(envuelta.__name__, "mi_funcion")

    def test_tiempo_ejecucion_imprime_tiempo(self):
        def mi_funcion():
            return "ok"

        envuelta = tiempo_ejecucion(mi_funcion)
        bufer = io.StringIO()
        with contextlib.redirect_stdout(bufer):
            envuelta()
        self.assertIn("mi_funcion tardó", bufer.getvalue())

    def test_repetir_llama_varias_veces(self):
        llamadas = []

        def contar(x):
            llamadas.append(x)
            return x

        repetida = repetir(3)(contar)
        self.assertEqual(repetida("hola"), "hola")
        self.assertEqual(len(llamadas), 3)

    def test_repetir_devuelve_ultimo_resultado(self):
        valores = iter([1, 2, 3])

        def siguiente():
            return next(valores)

        repetida = repetir(3)(siguiente)
        self.assertEqual(repetida(), 3)


if __name__ == "__main__":
    unittest.main()