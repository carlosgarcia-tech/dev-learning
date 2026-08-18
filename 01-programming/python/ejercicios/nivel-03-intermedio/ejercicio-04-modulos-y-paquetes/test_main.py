import unittest

from main import dividir, multiplicar, restar, sumar


class TestModulosYPaquetes(unittest.TestCase):

    def test_sumar(self):
        self.assertEqual(sumar(4, 5), 9)

    def test_sumar_negativos(self):
        self.assertEqual(sumar(-1, 1), 0)

    def test_restar(self):
        self.assertEqual(restar(10, 3), 7)

    def test_multiplicar(self):
        self.assertEqual(multiplicar(3, 4), 12)

    def test_multiplicar_por_cero(self):
        self.assertEqual(multiplicar(5, 0), 0)

    def test_dividir(self):
        self.assertEqual(dividir(10, 2), 5.0)

    def test_dividir_entre_cero(self):
        with self.assertRaises(ZeroDivisionError):
            dividir(1, 0)

    def test_dividir_decimal(self):
        self.assertEqual(dividir(1, 4), 0.25)


if __name__ == "__main__":
    unittest.main()