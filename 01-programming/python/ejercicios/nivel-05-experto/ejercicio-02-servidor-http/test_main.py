import io
import json
import unittest

from main import MiHandler, respuesta_para_ruta


def instanciar_handler(ruta, metodo="GET", cuerpo=b""):
    handler = MiHandler.__new__(MiHandler)
    handler.client_address = ("127.0.0.1", 12345)
    handler.command = metodo
    handler.path = ruta
    handler.rfile = io.BytesIO(cuerpo)
    handler.wfile = io.BytesIO()
    handler.headers = {}
    handler.requestline = f"{metodo} {ruta} HTTP/1.1"
    handler.request_version = "HTTP/1.1"
    handler.log_message = lambda *a, **k: None
    return handler


def leer_respuesta(handler):
    datos = handler.wfile.getvalue()
    partes = datos.split(b"\r\n\r\n", 1)
    cabecera = partes[0]
    cuerpo = partes[1] if len(partes) > 1 else b""
    codigo = int(cabecera.split(b"\r\n")[0].split()[1])
    return codigo, cuerpo.decode("utf-8")


class TestRespuestaParaRuta(unittest.TestCase):

    def test_ruta_raiz(self):
        codigo, contenido, tipo = respuesta_para_ruta("/")
        self.assertEqual(codigo, 200)
        self.assertEqual(contenido, "<h1>Servidor Python</h1><p>Hola desde http.server</p>")
        self.assertIn("text/html", tipo)

    def test_saludo_con_nombre(self):
        codigo, contenido, tipo = respuesta_para_ruta("/saludo?nombre=Ana")
        self.assertEqual(codigo, 200)
        self.assertEqual(contenido, "Hola, Ana!")
        self.assertIn("text/plain", tipo)

    def test_saludo_sin_nombre(self):
        codigo, contenido, _ = respuesta_para_ruta("/saludo")
        self.assertEqual(contenido, "Hola, mundo!")

    def test_estado_json(self):
        codigo, contenido, tipo = respuesta_para_ruta("/estado")
        self.assertEqual(codigo, 200)
        self.assertEqual(json.loads(contenido), {"estado": "ok", "version": "1.0"})
        self.assertIn("application/json", tipo)

    def test_ruta_no_encontrada(self):
        codigo, contenido, _ = respuesta_para_ruta("/404")
        self.assertEqual(codigo, 404)
        self.assertEqual(contenido, "No encontrado")


class TestMiHandler(unittest.TestCase):

    def test_do_get_raiz(self):
        handler = instanciar_handler("/")
        handler.do_GET()
        codigo, cuerpo = leer_respuesta(handler)
        self.assertEqual(codigo, 200)
        self.assertIn("Servidor Python", cuerpo)

    def test_do_get_saludo(self):
        handler = instanciar_handler("/saludo?nombre=Ana")
        handler.do_GET()
        codigo, cuerpo = leer_respuesta(handler)
        self.assertEqual(codigo, 200)
        self.assertEqual(cuerpo, "Hola, Ana!")

    def test_do_get_404(self):
        handler = instanciar_handler("/no-existe")
        handler.do_GET()
        codigo, cuerpo = leer_respuesta(handler)
        self.assertEqual(codigo, 404)
        self.assertEqual(cuerpo, "No encontrado")

    def test_do_post_405(self):
        handler = instanciar_handler("/", metodo="POST")
        handler.do_POST()
        codigo, cuerpo = leer_respuesta(handler)
        self.assertEqual(codigo, 405)
        self.assertEqual(cuerpo, "Método no permitido")


if __name__ == "__main__":
    unittest.main()