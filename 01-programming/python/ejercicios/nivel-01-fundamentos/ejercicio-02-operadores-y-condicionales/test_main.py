import unittest

from main import calcular


class TestOperadoresYCondicionales(unittest.TestCase):

    def test_suma(self):
        self.assertEqual(calcular(2, 3, "+"), 5)

    def test_resta(self):
        self.assertEqual(calcular(10, 4, "-"), 6)

    def test_multiplicacion(self):
        self.assertEqual(calcular(3, 4, "*"), 12)

    def test_division(self):
        self.assertAlmostEqual(calcular(10.0, 3.0, "/"), 3.3333333333333335)

    def test_division_entera(self):
        self.assertEqual(calcular(10, 2, "/"), 5.0)

    def test_division_entre_cero_lanza_error(self):
        with self.assertRaises(ZeroDivisionError):
            calcular(10, 0, "/")

    def test_operador_invalido_lanza_error(self):
        with self.assertRaises(ValueError):
            calcular(2, 3, "x")


if __name__ == "__main__":
    unittest.main()