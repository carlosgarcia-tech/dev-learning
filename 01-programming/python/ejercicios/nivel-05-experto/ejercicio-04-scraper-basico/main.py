# TODO: Completa el ejercicio siguiendo el enunciado de README.md.
# Sustituye cada raise NotImplementedError por la implementación correcta.

from html.parser import HTMLParser
import urllib.request


class ExtractorEnlaces(HTMLParser):
    def __init__(self):
        # TODO: super().__init__(convert_charrefs=True)
        # e inicializa enlaces, titulos y titulo_actual
        raise NotImplementedError

    def handle_starttag(self, tag, attrs):
        # TODO: guarda href de <a> y marca h1/h2 como titulo_actual
        raise NotImplementedError

    def handle_endtag(self, tag):
        # TODO: resetea titulo_actual al cerrar el tag
        raise NotImplementedError

    def handle_data(self, data):
        # TODO: acumula el texto de los títulos
        raise NotImplementedError


def analizar_html(html):
    # TODO: devuelve {"titulos": [...], "enlaces": [...]}
    raise NotImplementedError


def analizar_archivo(ruta):
    # TODO: lee el archivo y lo analiza con analizar_html
    raise NotImplementedError


def scrapear_url(url):
    # TODO: usa urllib.request.urlopen; ante error, {"titulos": [], "enlaces": []}
    raise NotImplementedError


if __name__ == "__main__":
    html_prueba = """
    <html><body>
      <h1>Inicio</h1>
      <h2>Artículos</h2>
      <a href="https://python.org">Python</a>
      <a href="#seccion">Sección</a>
      <a href="mailto:x@y.com">Contacto</a>
    </body></html>
    """
    with open("pagina.html", "w", encoding="utf-8") as f:
        f.write(html_prueba)

    resultado = analizar_archivo("pagina.html")
    print(f"Títulos: {resultado['titulos']}")
    print(f"Enlaces: {resultado['enlaces']}")