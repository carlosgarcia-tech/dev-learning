import unittest

from main import (
    longitudes,
    maximo,
    mayores_que,
    negativos,
    numeros,
    ordenar_por_longitud,
    palabras,
)


class TestNegativos(unittest.TestCase):

    def test_negativos(self):
        self.assertEqual(negativos(numeros), [-5, -12, -7, -18, -3, -21, -9])

    def test_negativos_lista_vacia(self):
        self.assertEqual(negativos([]), [])


class TestMayoresQue(unittest.TestCase):

    def test_mayores_que_10_por_defecto(self):
        self.assertEqual(mayores_que(numeros), [12, 18, 21])

    def test_mayores_que_limite_personalizado(self):
        self.assertEqual(mayores_que(numeros, 6), [12, 7, 18, 21, 9])


class TestLongitudes(unittest.TestCase):

    def test_longitudes(self):
        self.assertEqual(longitudes(palabras), [6, 2, 6, 4, 5])


class TestOrdenarPorLongitud(unittest.TestCase):

    def test_ordenar_por_longitud(self):
        self.assertEqual(
            ordenar_por_longitud(palabras),
            ["es", "para", "datos", "python", "genial"],
        )


class TestMaximo(unittest.TestCase):

    def test_maximo(self):
        self.assertEqual(maximo(numeros), 21)

    def test_maximo_negativos(self):
        self.assertEqual(maximo([-3, -1, -2]), -1)

    def test_maximo_lista_vacia(self):
        with self.assertRaises(TypeError):
            maximo([])


if __name__ == "__main__":
    unittest.main()