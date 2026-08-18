import unittest

from main import (
    dobles,
    primero,
    ultimo,
    ordenada,
    invertida,
    suma,
    minimo,
    maximo,
)


class TestListasBasicas(unittest.TestCase):

    def setUp(self):
        self.numeros = [5, 2, 9, 1, 7, 3]

    def test_primero(self):
        self.assertEqual(primero(self.numeros), 5)

    def test_ultimo(self):
        self.assertEqual(ultimo(self.numeros), 3)

    def test_ordenada(self):
        self.assertEqual(ordenada(self.numeros), [1, 2, 3, 5, 7, 9])

    def test_ordenada_no_modifica_original(self):
        ordenada(self.numeros)
        self.assertEqual(self.numeros, [5, 2, 9, 1, 7, 3])

    def test_invertida(self):
        self.assertEqual(invertida(self.numeros), [3, 7, 1, 9, 2, 5])

    def test_suma(self):
        self.assertEqual(suma(self.numeros), 27)

    def test_minimo(self):
        self.assertEqual(minimo(self.numeros), 1)

    def test_maximo(self):
        self.assertEqual(maximo(self.numeros), 9)

    def test_dobles(self):
        self.assertEqual(dobles(self.numeros), [10, 4, 18, 2, 14, 6])


if __name__ == "__main__":
    unittest.main()