import unittest

from main import (
    contar_a,
    invertida,
    mayusculas,
    minusculas,
    n_caracteres,
    n_palabras,
    titulo,
)


class TestStrings(unittest.TestCase):

    def test_mayusculas(self):
        self.assertEqual(mayusculas("Hola mundo"), "HOLA MUNDO")

    def test_minusculas(self):
        self.assertEqual(minusculas("Hola Mundo"), "hola mundo")

    def test_titulo(self):
        self.assertEqual(titulo("hola mundo"), "Hola Mundo")

    def test_n_caracteres(self):
        self.assertEqual(n_caracteres("Hola mundo"), 10)

    def test_n_caracteres_vacio(self):
        self.assertEqual(n_caracteres(""), 0)

    def test_n_palabras(self):
        self.assertEqual(n_palabras("Hola mundo"), 2)

    def test_invertida(self):
        self.assertEqual(invertida("Hola mundo"), "odnum aloH")

    def test_contar_a(self):
        self.assertEqual(contar_a("Hola mundo"), 1)

    def test_contar_a_sin_letra(self):
        self.assertEqual(contar_a("Tres tristes tigres"), 0)


if __name__ == "__main__":
    unittest.main()