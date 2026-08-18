import unittest
from io import StringIO
from unittest.mock import patch

from main import Temporizador, ignorar, sumar_uno_a_millon


class TestTemporizador(unittest.TestCase):

    def test_al_salir_establece_transcurrido(self):
        with Temporizador() as t:
            pass
        self.assertIsInstance(t.transcurrido, float)
        self.assertGreaterEqual(t.transcurrido, 0.0)

    def test_enter_devuelve_la_instancia(self):
        t = Temporizador()
        self.assertIs(t.__enter__(), t)

    def test_exit_devuelve_false(self):
        with Temporizador() as t:
            pass
        self.assertFalse(t.__exit__(None, None, None))

    def test_no_suprime_excepciones(self):
        with self.assertRaises(ValueError):
            with Temporizador():
                raise ValueError("boom")

    def test_sumar_uno_a_millon(self):
        self.assertEqual(sumar_uno_a_millon(), 500000500000)


class TestIgnorar(unittest.TestCase):

    def test_ignora_la_excepcion_indicada(self):
        with ignorar(ValueError):
            int("no es número")

    def test_ignorar_imprime_el_tipo(self):
        salida = StringIO()
        with patch("sys.stdout", salida):
            with ignorar(ValueError):
                int("no es número")
        self.assertIn("Excepción ignorada: <class 'ValueError'>", salida.getvalue())

    def test_no_captura_otras_excepciones(self):
        with self.assertRaises(TypeError):
            with ignorar(ValueError):
                len(42)


if __name__ == "__main__":
    unittest.main()