import io
import unittest
from contextlib import redirect_stdout

from main import a_celsius, convertir, desde_celsius, formatear_salida, main


class TestACelsius(unittest.TestCase):

    def test_celsius_se_mantiene(self):
        self.assertEqual(a_celsius(100, "celsius"), 100)

    def test_fahrenheit_a_celsius(self):
        self.assertAlmostEqual(a_celsius(32, "fahrenheit"), 0)

    def test_kelvin_a_celsius(self):
        self.assertAlmostEqual(a_celsius(273.15, "kelvin"), 0)

    def test_escala_desconocida_lanza_value_error(self):
        with self.assertRaises(ValueError):
            a_celsius(100, "rankine")


class TestDesdeCelsius(unittest.TestCase):

    def test_celsius_se_mantiene(self):
        self.assertEqual(desde_celsius(0, "celsius"), 0)

    def test_celsius_a_fahrenheit(self):
        self.assertAlmostEqual(desde_celsius(100, "fahrenheit"), 212)

    def test_celsius_a_kelvin(self):
        self.assertAlmostEqual(desde_celsius(0, "kelvin"), 273.15)

    def test_destino_desconocido_lanza_value_error(self):
        with self.assertRaises(ValueError):
            desde_celsius(0, "rankine")


class TestConvertir(unittest.TestCase):

    def test_celsius_a_fahrenheit(self):
        self.assertAlmostEqual(convertir(100, "celsius", "fahrenheit"), 212)

    def test_celsius_a_kelvin(self):
        self.assertAlmostEqual(convertir(0, "celsius", "kelvin"), 273.15)

    def test_fahrenheit_a_celsius(self):
        self.assertAlmostEqual(convertir(32, "fahrenheit", "celsius"), 0)

    def test_kelvin_a_celsius(self):
        self.assertAlmostEqual(convertir(300, "kelvin", "celsius"), 26.85)


class TestFormatearSalida(unittest.TestCase):

    def test_formatea_con_dos_decimales(self):
        self.assertEqual(
            formatear_salida(100, "celsius", "fahrenheit", 212.0),
            "100.00 °celsius = 212.00 °fahrenheit",
        )


class TestMain(unittest.TestCase):

    def test_cli_ejemplo_celsius_a_fahrenheit(self):
        salida = io.StringIO()
        with redirect_stdout(salida):
            main(["100", "--escala", "celsius", "--destino", "fahrenheit"])
        self.assertEqual(
            salida.getvalue().strip(),
            "100.00 °celsius = 212.00 °fahrenheit",
        )

    def test_cli_valores_por_defecto(self):
        salida = io.StringIO()
        with redirect_stdout(salida):
            main(["100"])
        self.assertEqual(
            salida.getvalue().strip(),
            "100.00 °celsius = 212.00 °fahrenheit",
        )


if __name__ == "__main__":
    unittest.main()