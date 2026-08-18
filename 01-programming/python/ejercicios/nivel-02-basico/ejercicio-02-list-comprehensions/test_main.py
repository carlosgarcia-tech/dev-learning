import unittest

from main import (
    cuadrados,
    divididos,
    etiquetas,
    multiplos_de_3,
    numeros,
    pares,
)


class TestComprehensions(unittest.TestCase):

    def test_numeros(self):
        self.assertEqual(numeros(), list(range(1, 21)))
        self.assertEqual(len(numeros()), 20)

    def test_cuadrados(self):
        self.assertEqual(cuadrados([1, 2, 3]), [1, 4, 9])

    def test_cuadrados_base(self):
        resultado = cuadrados(numeros())
        self.assertEqual(resultado[0], 1)
        self.assertEqual(resultado[-1], 400)

    def test_pares(self):
        self.assertEqual(pares([1, 2, 3, 4, 5, 6]), [2, 4, 6])

    def test_pares_base(self):
        self.assertEqual(pares(numeros()), list(range(2, 21, 2)))

    def test_multiplos_de_3(self):
        self.assertEqual(multiplos_de_3([1, 2, 3, 4, 5, 6, 9]), [3, 6, 9])

    def test_multiplos_de_3_base(self):
        self.assertEqual(multiplos_de_3(numeros()), [3, 6, 9, 12, 15, 18])

    def test_etiquetas(self):
        self.assertEqual(etiquetas([1, 2, 3]), ["impar", "par", "impar"])

    def test_etiquetas_base(self):
        etiquetado = etiquetas(numeros())
        self.assertEqual(etiquetado[0], "impar")
        self.assertEqual(etiquetado[1], "par")
        self.assertEqual(len(etiquetado), 20)

    def test_divididos(self):
        self.assertEqual(divididos([1, 2, 3]), [0.5, 1.0, 1.5])

    def test_divididos_base(self):
        self.assertEqual(divididos(numeros())[0], 0.5)
        self.assertIsInstance(divididos([2])[0], float)


if __name__ == "__main__":
    unittest.main()