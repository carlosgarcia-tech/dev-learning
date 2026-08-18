import os
import tempfile
import unittest
from unittest.mock import patch

from main import ExtractorEnlaces, analizar_archivo, analizar_html, scrapear_url

HTML_SAMPLE = """
<html><body>
  <h1>Inicio</h1>
  <h2>Artículos</h2>
  <a href="https://python.org">Python</a>
  <a href="#seccion">Sección</a>
  <a href="mailto:x@y.com">Contacto</a>
</body></html>
"""


class FakeRespuesta:
    def __enter__(self):
        return self

    def __exit__(self, *args):
        return False

    def read(self):
        return HTML_SAMPLE.encode("utf-8")


class TestExtractorEnlaces(unittest.TestCase):

    def test_extrae_titulos_y_enlaces(self):
        parser = ExtractorEnlaces()
        parser.feed(HTML_SAMPLE)
        self.assertEqual(parser.titulos, ["Inicio", "Artículos"])
        self.assertEqual(parser.enlaces, ["https://python.org", "#seccion", "mailto:x@y.com"])

    def test_html_sin_contenido(self):
        parser = ExtractorEnlaces()
        parser.feed("<html></html>")
        self.assertEqual(parser.titulos, [])
        self.assertEqual(parser.enlaces, [])


class TestAnalizarHtml(unittest.TestCase):

    def test_analizar_html(self):
        resultado = analizar_html(HTML_SAMPLE)
        self.assertEqual(resultado["titulos"], ["Inicio", "Artículos"])
        self.assertEqual(resultado["enlaces"], ["https://python.org", "#seccion", "mailto:x@y.com"])

    def test_analizar_html_ignora_texto_fuera_de_titulos(self):
        resultado = analizar_html("<p>párrafo</p><h1>Hola</h1>")
        self.assertEqual(resultado["titulos"], ["Hola"])
        self.assertEqual(resultado["enlaces"], [])


class TestAnalizarArchivo(unittest.TestCase):

    def test_analizar_archivo(self):
        with tempfile.TemporaryDirectory() as dir:
            ruta = os.path.join(dir, "pagina.html")
            with open(ruta, "w", encoding="utf-8") as f:
                f.write(HTML_SAMPLE)
            resultado = analizar_archivo(ruta)
            self.assertEqual(resultado["titulos"], ["Inicio", "Artículos"])
            self.assertEqual(len(resultado["enlaces"]), 3)


class TestScrapearUrl(unittest.TestCase):

    @patch("urllib.request.urlopen", return_value=FakeRespuesta())
    def test_scrapear_url(self, mock_urlopen):
        resultado = scrapear_url("https://python.org")
        mock_urlopen.assert_called_once()
        self.assertEqual(resultado["titulos"], ["Inicio", "Artículos"])
        self.assertEqual(len(resultado["enlaces"]), 3)

    @patch("urllib.request.urlopen", side_effect=Exception("sin red"))
    def test_scrapear_url_error_devuelve_vacio(self, mock_urlopen):
        resultado = scrapear_url("https://python.org")
        self.assertEqual(resultado, {"titulos": [], "enlaces": []})


if __name__ == "__main__":
    unittest.main()