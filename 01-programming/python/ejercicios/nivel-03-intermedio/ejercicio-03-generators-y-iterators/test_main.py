import unittest

from main import contador_descendente, fibonacci, pares_impares


class TestGeneratorsYIterators(unittest.TestCase):

    def test_contador_descendente(self):
        self.assertEqual(list(contador_descendente(5)), [5, 4, 3, 2, 1, 0])

    def test_contador_descendente_cero(self):
        self.assertEqual(list(contador_descendente(0)), [0])

    def test_contador_descendente_negativo(self):
        self.assertEqual(list(contador_descendente(-1)), [])

    def test_fibonacci(self):
        self.assertEqual(list(fibonacci(50)), [0, 1, 1, 2, 3, 5, 8, 13, 21, 34])

    def test_fibonacci_next(self):
        gen = fibonacci(50)
        self.assertEqual(next(gen), 0)
        self.assertEqual(next(gen), 1)
        self.assertEqual(next(gen), 1)

    def test_pares_impares(self):
        self.assertEqual(
            list(pares_impares(3)),
            [("par", 0), ("impar", 1), ("par", 2), ("impar", 3)],
        )

    def test_pares_impares_cero(self):
        self.assertEqual(list(pares_impares(0)), [("par", 0)])


if __name__ == "__main__":
    unittest.main()