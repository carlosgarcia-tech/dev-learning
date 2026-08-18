import unittest

from main import dividir


class TestManejoDeErrores(unittest.TestCase):

    def test_dividir_valido(self):
        self.assertEqual(dividir("10", "2"), "Resultado: 5.0")

    def test_dividir_enteros(self):
        self.assertEqual(dividir(10, 2), "Resultado: 5.0")

    def test_dividir_no_entera(self):
        self.assertEqual(dividir("1", "4"), "Resultado: 0.25")

    def test_dividir_negativos(self):
        self.assertEqual(dividir("-6", "3"), "Resultado: -2.0")

    def test_division_entre_cero(self):
        self.assertEqual(dividir("10", "0"), "Error: división entre cero")

    def test_conversion_invalida(self):
        self.assertEqual(dividir("abc", "2"), "Error: no son números válidos")

    def test_conversion_invalida_denominador(self):
        self.assertEqual(dividir("10", "xyz"), "Error: no son números válidos")


if __name__ == "__main__":
    unittest.main()