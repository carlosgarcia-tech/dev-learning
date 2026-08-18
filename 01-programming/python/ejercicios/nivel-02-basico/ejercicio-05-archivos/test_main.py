import os
import tempfile
import unittest

from main import (
    agregar_linea,
    escribir_datos,
    leer_completo,
    leer_limpiadas,
    leer_lineas,
)


class TestArchivos(unittest.TestCase):

    def setUp(self):
        self.directorio = tempfile.mkdtemp()
        self.ruta = os.path.join(self.directorio, "datos.txt")

    def tearDown(self):
        for archivo in os.listdir(self.directorio):
            os.remove(os.path.join(self.directorio, archivo))
        os.rmdir(self.directorio)

    def test_escribir_y_leer_completo(self):
        escribir_datos(self.ruta)
        self.assertEqual(leer_completo(self.ruta), "uno\ndos\ntres\n")

    def test_leer_lineas(self):
        escribir_datos(self.ruta)
        self.assertEqual(leer_lineas(self.ruta), ["uno\n", "dos\n", "tres\n"])

    def test_leer_limpiadas(self):
        escribir_datos(self.ruta)
        self.assertEqual(leer_limpiadas(self.ruta), ["uno", "dos", "tres"])

    def test_agregar_linea(self):
        escribir_datos(self.ruta)
        agregar_linea(self.ruta, "cuatro")
        self.assertEqual(
            leer_limpiadas(self.ruta), ["uno", "dos", "tres", "cuatro"]
        )

    def test_agregar_linea_no_borra_lo_anterior(self):
        escribir_datos(self.ruta)
        agregar_linea(self.ruta, "cuatro")
        contenido = leer_completo(self.ruta)
        self.assertIn("uno", contenido)
        self.assertIn("cuatro", contenido)

    def test_escribir_datos_sobrescribe(self):
        escribir_datos(self.ruta)
        escribir_datos(self.ruta)
        self.assertEqual(leer_completo(self.ruta), "uno\ndos\ntres\n")


if __name__ == "__main__":
    unittest.main()