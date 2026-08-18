# Ejercicio 04 — Scraper básico

- **Nivel:** 5/5
- **Tema:** html.parser, urllib.request, scraping, extracción de enlaces
- **Tiempo estimado:** 40 min

## Enunciado

Crea un archivo `scraper.py` que:

1. Defina la clase `ExtractorEnlaces(HTMLParser)` que acumule en `self.enlaces` todos los valores del atributo `href` de las etiquetas `<a>` y en `self.titulos` los textos de los `<h1>` y `<h2>`.
2. Defina `analizar_html(html)` que reciba un string HTML, lo parseé y devuelva un diccionario `{"titulos": [...], "enlaces": [...]}`.
3. Defina `analizar_archivo(ruta)` que lea el contenido de un archivo HTML local y lo analice con `analizar_html`.
4. Defina `scrapear_url(url)` que use `urllib.request.urlopen` para descargar una página real y la analice (devuelve el mismo diccionario). Nota: este caso requiere acceso a internet.

En `__main__`:
- Cree un archivo `pagina.html` de prueba con un `<h1>Inicio</h1>`, un `<h2>Artículos</h2>` y tres enlaces (`https://python.org`, `#seccion`, `mailto:x@y.com`).
- Llame a `analizar_archivo("pagina.html")` e imprima los títulos y enlaces.

Salida esperada:

```
Títulos: ['Inicio', 'Artículos']
Enlaces: ['https://python.org', '#seccion', 'mailto:x@y.com']
```

## Requisitos

- [ ] Subclasificar `HTMLParser` y sobrescribir `handle_starttag` y `handle_data`.
- [ ] Extraer `href` de `<a>` y textos de `<h1>`/`<h2>`.
- [ ] Leer y analizar un archivo HTML local.
- [ ] Implementar la función `scrapear_url` con `urllib.request` para uso real.
- [ ] Ejecutar el `__main__` localmente con `python3 scraper.py` y verificar la salida.

## Pistas

<details>
<summary>Mostrar pistas</summary>

- En `handle_starttag`, `attrs` es una lista de tuplas `(atributo, valor)`; busca `href` con `dict(attrs).get("href")`.
- Guarda en `self.titulo_actual` el tag para saber en `handle_data` si el texto pertenece a `h1`/`h2`.
- `HTMLParser(convert_charrefs=True)` ya decodifica entidades como `&amp;`.
- `scrapear_url` puede fallar sin internet: maneja el error y devuelve un diccionario vacío.

</details>

## Solución

<details>
<summary>Mostrar solución</summary>

````python
from html.parser import HTMLParser
import urllib.request


class ExtractorEnlaces(HTMLParser):
    def __init__(self):
        super().__init__(convert_charrefs=True)
        self.enlaces = []
        self.titulos = []
        self.titulo_actual = None

    def handle_starttag(self, tag, attrs):
        atributos = dict(attrs)
        if tag == "a":
            href = atributos.get("href")
            if href:
                self.enlaces.append(href)
        elif tag in ("h1", "h2"):
            self.titulo_actual = tag

    def handle_endtag(self, tag):
        if tag == self.titulo_actual:
            self.titulo_actual = None

    def handle_data(self, data):
        if self.titulo_actual and data.strip():
            self.titulos.append(data.strip())


def analizar_html(html):
    parser = ExtractorEnlaces()
    parser.feed(html)
    return {"titulos": parser.titulos, "enlaces": parser.enlaces}


def analizar_archivo(ruta):
    with open(ruta, "r", encoding="utf-8") as f:
        return analizar_html(f.read())


def scrapear_url(url):
    try:
        with urllib.request.urlopen(url, timeout=10) as resp:
            return analizar_html(resp.read().decode("utf-8", errors="ignore"))
    except Exception as e:
        print(f"Error al scrapear {url}: {e}")
        return {"titulos": [], "enlaces": []}


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
````

</details>