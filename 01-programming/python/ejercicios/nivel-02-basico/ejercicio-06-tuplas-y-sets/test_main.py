import unittest

from main import (
    desempaquetar,
    diferencia,
    es_inmutable,
    interseccion,
    sin_duplicados,
    union,
)


class TestTuplasYSets(unittest.TestCase):

    def test_desempaquetar(self):
        self.assertEqual(desempaquetar((3, 5)), (3, 5))

    def test_desempaquetar_otros(self):
        x, y = desempaquetar((3, 5))
        self.assertEqual(x, 3)
        self.assertEqual(y, 5)

    def test_es_inmutable(self):
        self.assertTrue(es_inmutable((3, 5)))

    def test_union(self):
        a = {"ana", "luis", "maria"}
        b = {"luis", "carlos", "pablo"}
        self.assertEqual(union(a, b), {"ana", "luis", "maria", "carlos", "pablo"})

    def test_interseccion(self):
        a = {"ana", "luis", "maria"}
        b = {"luis", "carlos", "pablo"}
        self.assertEqual(interseccion(a, b), {"luis"})

    def test_diferencia(self):
        a = {"ana", "luis", "maria"}
        b = {"luis", "carlos", "pablo"}
        self.assertEqual(diferencia(a, b), {"ana", "maria"})

    def test_diferencia_vacia(self):
        self.assertEqual(diferencia({1, 2}, {1, 2}), set())

    def test_sin_duplicados(self):
        self.assertEqual(sin_duplicados([1, 2, 2, 3, 3, 3, 4]), [1, 2, 3, 4])

    def test_sin_duplicados_ordenado(self):
        self.assertEqual(sin_duplicados([3, 1, 3, 2, 1]), [1, 2, 3])

    def test_sin_duplicados_strings(self):
        self.assertEqual(sin_duplicados(["b", "a", "b", "c"]), ["a", "b", "c"])


if __name__ == "__main__":
    unittest.main()