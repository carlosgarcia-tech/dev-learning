import unittest

from main import (
    ciudad,
    edad,
    estudia_programacion,
    formatear_descripcion,
    nombre,
    tipo_de,
)


class TestVariablesYTipos(unittest.TestCase):

    def test_nombre_devuelve_str(self):
        self.assertIsInstance(nombre(), str)
        self.assertTrue(len(nombre()) > 0)

    def test_ciudad_devuelve_str(self):
        self.assertIsInstance(ciudad(), str)
        self.assertTrue(len(ciudad()) > 0)

    def test_edad_devuelve_int_positivo(self):
        self.assertIsInstance(edad(), int)
        self.assertGreater(edad(), 0)

    def test_estudia_programacion_devuelve_true(self):
        self.assertTrue(estudia_programacion())

    def test_tipo_de_str(self):
        self.assertEqual(tipo_de("hola"), "str")

    def test_tipo_de_int(self):
        self.assertEqual(tipo_de(42), "int")

    def test_tipo_de_bool(self):
        self.assertEqual(tipo_de(True), "bool")

    def test_formatear_descripcion(self):
        texto = formatear_descripcion("Ana", "Lima", 30, True)
        self.assertIn("Ana", texto)
        self.assertIn("30", texto)
        self.assertIn("Lima", texto)
        self.assertIn("True", texto)
        self.assertIn("programación", texto)

    def test_formatear_descripcion_con_false(self):
        texto = formatear_descripcion("Ana", "Lima", 30, False)
        self.assertIn("False", texto)


if __name__ == "__main__":
    unittest.main()