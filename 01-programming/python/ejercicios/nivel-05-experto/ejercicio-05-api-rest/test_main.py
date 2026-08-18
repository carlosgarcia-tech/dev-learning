import io
import json
import os
import tempfile
import unittest
from unittest.mock import patch

from main import (
    ApiHandler,
    actualizar_libro,
    cargar,
    crear_libro,
    eliminar_libro,
    guardar,
    listar_libros,
    obtener_libro,
)


class TestLogicaLibros(unittest.TestCase):

    def setUp(self):
        self.libros = [{"id": 1, "titulo": "Python", "autor": "Van Rossum"}]

    def test_listar_libros(self):
        codigo, cuerpo = listar_libros(self.libros)
        self.assertEqual(codigo, 200)
        self.assertEqual(cuerpo, self.libros)

    def test_obtener_libro(self):
        codigo, libro = obtener_libro(self.libros, 1)
        self.assertEqual(codigo, 200)
        self.assertEqual(libro["titulo"], "Python")

    def test_obtener_libro_no_encontrado(self):
        codigo, cuerpo = obtener_libro(self.libros, 99)
        self.assertEqual(codigo, 404)
        self.assertEqual(cuerpo, {"error": "no encontrado"})

    def test_crear_libro(self):
        codigo, libro = crear_libro(self.libros, {"titulo": "Python 3", "autor": "Van Rossum"})
        self.assertEqual(codigo, 201)
        self.assertEqual(libro["id"], 2)
        self.assertEqual(len(self.libros), 2)

    def test_crear_libro_sin_autor(self):
        codigo, libro = crear_libro(self.libros, {"titulo": "Solo titulo"})
        self.assertEqual(codigo, 201)
        self.assertEqual(libro["autor"], "")

    def test_crear_libro_sin_titulo(self):
        codigo, cuerpo = crear_libro(self.libros, {"autor": "X"})
        self.assertEqual(codigo, 400)
        self.assertEqual(cuerpo, {"error": "titulo requerido"})
        self.assertEqual(len(self.libros), 1)

    def test_actualizar_libro(self):
        codigo, libro = actualizar_libro(self.libros, 1, {"titulo": "Python 3"})
        self.assertEqual(codigo, 200)
        self.assertEqual(libro["titulo"], "Python 3")
        self.assertEqual(libro["autor"], "Van Rossum")

    def test_actualizar_libro_no_encontrado(self):
        codigo, cuerpo = actualizar_libro(self.libros, 99, {"titulo": "X"})
        self.assertEqual(codigo, 404)
        self.assertEqual(cuerpo, {"error": "no encontrado"})

    def test_eliminar_libro(self):
        codigo, cuerpo = eliminar_libro(self.libros, 1)
        self.assertEqual(codigo, 204)
        self.assertEqual(cuerpo, None)
        self.assertEqual(len(self.libros), 0)

    def test_eliminar_libro_no_encontrado(self):
        codigo, cuerpo = eliminar_libro(self.libros, 99)
        self.assertEqual(codigo, 404)
        self.assertEqual(len(self.libros), 1)


class TestPersistencia(unittest.TestCase):

    def setUp(self):
        self.dir = tempfile.TemporaryDirectory()
        self.ruta = os.path.join(self.dir.name, "libros.json")

    def tearDown(self):
        self.dir.cleanup()

    def test_cargar_sin_archivo(self):
        self.assertEqual(cargar(self.ruta), [])

    def test_guardar_y_cargar(self):
        libros = [{"id": 1, "titulo": "Python", "autor": "Van Rossum"}]
        guardar(self.ruta, libros)
        self.assertTrue(os.path.exists(self.ruta))
        self.assertEqual(cargar(self.ruta), libros)


class TestApiHandler(unittest.TestCase):

    def _instanciar(self, ruta, metodo="GET", cuerpo=b"", headers=None):
        handler = ApiHandler.__new__(ApiHandler)
        handler.client_address = ("127.0.0.1", 12345)
        handler.command = metodo
        handler.path = ruta
        handler.rfile = io.BytesIO(cuerpo)
        handler.wfile = io.BytesIO()
        handler.headers = headers or {}
        handler.requestline = f"{metodo} {ruta} HTTP/1.1"
        handler.request_version = "HTTP/1.1"
        handler.log_message = lambda *a, **k: None
        return handler

    def _leer(self, handler):
        datos = handler.wfile.getvalue()
        partes = datos.split(b"\r\n\r\n", 1)
        cabecera = partes[0]
        cuerpo = partes[1] if len(partes) > 1 else b""
        codigo = int(cabecera.split(b"\r\n")[0].split()[1])
        return codigo, cuerpo

    @patch("main.cargar")
    def test_get_libros(self, mock_cargar):
        mock_cargar.return_value = [{"id": 1, "titulo": "Python", "autor": "Van Rossum"}]
        handler = self._instanciar("/libros")
        handler.do_GET()
        codigo, cuerpo = self._leer(handler)
        self.assertEqual(codigo, 200)
        self.assertEqual(json.loads(cuerpo), [{"id": 1, "titulo": "Python", "autor": "Van Rossum"}])

    @patch("main.cargar")
    def test_get_libro(self, mock_cargar):
        mock_cargar.return_value = [{"id": 1, "titulo": "Python", "autor": "Van Rossum"}]
        handler = self._instanciar("/libros/1")
        handler.do_GET()
        codigo, cuerpo = self._leer(handler)
        self.assertEqual(codigo, 200)
        self.assertEqual(json.loads(cuerpo)["id"], 1)

    @patch("main.cargar")
    def test_get_libro_no_encontrado(self, mock_cargar):
        mock_cargar.return_value = []
        handler = self._instanciar("/libros/5")
        handler.do_GET()
        codigo, cuerpo = self._leer(handler)
        self.assertEqual(codigo, 404)
        self.assertEqual(json.loads(cuerpo), {"error": "no encontrado"})

    @patch("main.cargar")
    def test_get_ruta_invalida(self, mock_cargar):
        handler = self._instanciar("/otros")
        handler.do_GET()
        codigo, cuerpo = self._leer(handler)
        self.assertEqual(codigo, 404)

    @patch("main.cargar")
    @patch("main.guardar")
    def test_post_crea_libro(self, mock_guardar, mock_cargar):
        mock_cargar.return_value = []
        cuerpo_json = json.dumps({"titulo": "Python", "autor": "Van Rossum"}).encode()
        handler = self._instanciar("/libros", "POST", cuerpo_json, {"Content-Length": str(len(cuerpo_json))})
        handler.do_POST()
        codigo, cuerpo = self._leer(handler)
        self.assertEqual(codigo, 201)
        self.assertEqual(json.loads(cuerpo), {"id": 1, "titulo": "Python", "autor": "Van Rossum"})
        mock_guardar.assert_called_once()

    @patch("main.cargar")
    @patch("main.guardar")
    def test_post_sin_titulo(self, mock_guardar, mock_cargar):
        mock_cargar.return_value = []
        cuerpo_json = json.dumps({"autor": "X"}).encode()
        handler = self._instanciar("/libros", "POST", cuerpo_json, {"Content-Length": str(len(cuerpo_json))})
        handler.do_POST()
        codigo, cuerpo = self._leer(handler)
        self.assertEqual(codigo, 400)
        self.assertEqual(json.loads(cuerpo), {"error": "titulo requerido"})
        mock_guardar.assert_not_called()

    @patch("main.cargar")
    @patch("main.guardar")
    def test_put_actualiza(self, mock_guardar, mock_cargar):
        mock_cargar.return_value = [{"id": 1, "titulo": "Python", "autor": "Van Rossum"}]
        cuerpo_json = json.dumps({"titulo": "Python 3"}).encode()
        handler = self._instanciar("/libros/1", "PUT", cuerpo_json, {"Content-Length": str(len(cuerpo_json))})
        handler.do_PUT()
        codigo, cuerpo = self._leer(handler)
        self.assertEqual(codigo, 200)
        self.assertEqual(json.loads(cuerpo)["titulo"], "Python 3")
        mock_guardar.assert_called_once()

    @patch("main.cargar")
    @patch("main.guardar")
    def test_delete(self, mock_guardar, mock_cargar):
        mock_cargar.return_value = [{"id": 1, "titulo": "Python", "autor": "Van Rossum"}]
        handler = self._instanciar("/libros/1", "DELETE")
        handler.do_DELETE()
        codigo, cuerpo = self._leer(handler)
        self.assertEqual(codigo, 204)
        self.assertEqual(cuerpo, b"")
        mock_guardar.assert_called_once()

    @patch("main.cargar")
    @patch("main.guardar")
    def test_delete_no_encontrado(self, mock_guardar, mock_cargar):
        mock_cargar.return_value = []
        handler = self._instanciar("/libros/99", "DELETE")
        handler.do_DELETE()
        codigo, cuerpo = self._leer(handler)
        self.assertEqual(codigo, 404)
        mock_guardar.assert_not_called()


if __name__ == "__main__":
    unittest.main()