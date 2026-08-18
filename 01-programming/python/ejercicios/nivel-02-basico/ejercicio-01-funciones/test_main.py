import unittest

from main import area_rectangulo, dividir, es_par, potencia, saludar


class TestFunciones(unittest.TestCase):

    def test_saludar(self):
        self.assertEqual(saludar("Ana"), "Hola, Ana!")

    def test_saludar_otro_nombre(self):
        self.assertEqual(saludar("Luis"), "Hola, Luis!")

    def test_area_rectangulo(self):
        self.assertEqual(area_rectangulo(4, 5), 20)

    def test_area_rectangulo_cero(self):
        self.assertEqual(area_rectangulo(0, 5), 0)

    def test_potencia_por_defecto(self):
        self.assertEqual(potencia(3), 9)

    def test_potencia_explicita(self):
        self.assertEqual(potencia(2, 3), 8)

    def test_potencia_exponente_cero(self):
        self.assertEqual(potencia(5, 0), 1)

    def test_es_par_true(self):
        self.assertTrue(es_par(4))

    def test_es_par_false(self):
        self.assertFalse(es_par(7))

    def test_dividir(self):
        self.assertEqual(dividir(10, 3), (3, 1))

    def test_dividir_exacta(self):
        self.assertEqual(dividir(10, 2), (5, 0))


if __name__ == "__main__":
    unittest.main()