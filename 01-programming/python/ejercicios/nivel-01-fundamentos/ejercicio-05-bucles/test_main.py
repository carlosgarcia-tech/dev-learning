import unittest

from main import (
    numeros_1_al_10,
    numeros_pares,
    primer_multiplo_de,
    suma_hasta,
    tabla_multiplicar,
)


class TestBucles(unittest.TestCase):

    def test_numeros_1_al_10(self):
        self.assertEqual(
            numeros_1_al_10(), "1, 2, 3, 4, 5, 6, 7, 8, 9, 10"
        )

    def test_tabla_multiplicar_longitud(self):
        self.assertEqual(len(tabla_multiplicar(7, 10)), 10)

    def test_tabla_multiplicar_primer_fila(self):
        self.assertEqual(tabla_multiplicar(7, 10)[0], "7 x 1 = 7")

    def test_tabla_multiplicar_ultima_fila(self):
        self.assertEqual(tabla_multiplicar(7, 10)[-1], "7 x 10 = 70")

    def test_suma_hasta_100(self):
        self.assertEqual(suma_hasta(100), 5050)

    def test_suma_hasta_1(self):
        self.assertEqual(suma_hasta(1), 1)

    def test_suma_hasta_0(self):
        self.assertEqual(suma_hasta(0), 0)

    def test_numeros_pares(self):
        self.assertEqual(numeros_pares([3, 7, 12, 5, 8, 15]), [12, 8])

    def test_primer_multiplo_de_21(self):
        self.assertEqual(primer_multiplo_de(21), 21)

    def test_primer_multiplo_de_7(self):
        self.assertEqual(primer_multiplo_de(7), 7)


if __name__ == "__main__":
    unittest.main()