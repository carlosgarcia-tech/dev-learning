import unittest

from main import dividir, multiplicar, restar, sumar


class TestCalculadora(unittest.TestCase):

    def setUp(self):
        self.casos_suma = [(2, 3, 5), (10, 20, 30), (-5, 5, 0)]

    def test_sumar(self):
        self.assertEqual(sumar(2, 3), 5)
        self.assertEqual(sumar(-1, 1), 0)

    def test_sumar_parametrizado_con_subtest(self):
        for a, b, esperado in self.casos_suma:
            with self.subTest(a=a, b=b):
                self.assertEqual(sumar(a, b), esperado)

    def test_restar(self):
        self.assertEqual(restar(10, 4), 6)

    def test_restar_negativos(self):
        self.assertEqual(restar(-5, -3), -2)

    def test_multiplicar(self):
        self.assertEqual(multiplicar(4, 3), 12)
        self.assertEqual(multiplicar(0, 5), 0)

    def test_dividir(self):
        self.assertEqual(dividir(10, 2), 5)
        self.assertEqual(dividir(7, 2), 3.5)

    def test_dividir_por_cero(self):
        with self.assertRaises(ZeroDivisionError):
            dividir(1, 0)


if __name__ == "__main__":
    unittest.main()