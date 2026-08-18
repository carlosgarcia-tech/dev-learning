import unittest

from main import factorial, fibonacci, suma_lista


class TestRecursion(unittest.TestCase):

    def test_factorial_cinco(self):
        self.assertEqual(factorial(5), 120)

    def test_factorial_cero(self):
        self.assertEqual(factorial(0), 1)

    def test_factorial_uno(self):
        self.assertEqual(factorial(1), 1)

    def test_fibonacci_diez(self):
        self.assertEqual(fibonacci(10), 55)

    def test_fibonacci_cero(self):
        self.assertEqual(fibonacci(0), 0)

    def test_fibonacci_uno(self):
        self.assertEqual(fibonacci(1), 1)

    def test_fibonacci_dos(self):
        self.assertEqual(fibonacci(2), 1)

    def test_suma_lista(self):
        self.assertEqual(suma_lista([1, 2, 3, 4, 5]), 15)

    def test_suma_lista_vacia(self):
        self.assertEqual(suma_lista([]), 0)

    def test_suma_lista_un_elemento(self):
        self.assertEqual(suma_lista([7]), 7)


if __name__ == "__main__":
    unittest.main()