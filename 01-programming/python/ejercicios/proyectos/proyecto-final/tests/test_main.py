import tempfile
import unittest
from datetime import date, timedelta
from pathlib import Path
import sys

STARTER = Path(__file__).parent.parent / "starter"
sys.path.insert(0, str(STARTER))

from repositories import RepositorioLibros, RepositorioMiembros, RepositorioPrestamos
from services import (
    BibliotecaService,
    EmailDuplicadoError,
    LibroNoDisponibleError,
    MiembroInactivoError,
    ReportesService,
)


class TestBiblioteca(unittest.TestCase):
    """Tests de referencia para el proyecto final (Sistema de Biblioteca).

    Se ejecutan con `python3 test_main.py` y usan `unittest` (stdlib), por lo
    que no requieren instalar FastAPI.
    """

    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        base = Path(self.tmp.name)
        self.repo_libros = RepositorioLibros(base / "libros.json")
        self.repo_miembros = RepositorioMiembros(base / "miembros.json")
        self.repo_prestamos = RepositorioPrestamos(base / "prestamos.json")
        self.servicio = BibliotecaService(
            self.repo_libros, self.repo_miembros, self.repo_prestamos
        )
        self.reportes = ReportesService(self.servicio)

    def tearDown(self):
        self.tmp.cleanup()

    def crear_libro(self):
        return self.servicio.alta_libro(
            "Cien años de soledad", "Gabriel García Márquez", "978-0307", 1967, None
        )

    def crear_miembro(self, email="ana@example.com"):
        return self.servicio.alta_miembro("Ana", email, "555-1234")

    def test_alta_libro(self):
        libro = self.crear_libro()
        self.assertIsNotNone(libro.id)
        self.assertTrue(libro.disponible)
        self.assertEqual(libro.titulo, "Cien años de soledad")

    def test_alta_libro_titulo_vacio_lanza_error(self):
        with self.assertRaises(ValueError):
            self.servicio.alta_libro("", "Autor", "isbn", 2000, None)

    def test_alta_libro_autor_vacio_lanza_error(self):
        with self.assertRaises(ValueError):
            self.servicio.alta_libro("Título", "", "isbn", 2000, None)

    def test_buscar_libros_por_titulo(self):
        self.crear_libro()
        resultados = self.servicio.buscar_libros("cien")
        self.assertEqual(len(resultados), 1)

    def test_buscar_libros_por_autor(self):
        self.crear_libro()
        resultados = self.servicio.buscar_libros("GARCÍA")
        self.assertEqual(len(resultados), 1)

    def test_buscar_libros_sin_resultados(self):
        self.crear_libro()
        resultados = self.servicio.buscar_libros("inexistente")
        self.assertEqual(resultados, [])

    def test_alta_miembro(self):
        miembro = self.crear_miembro()
        self.assertIsNotNone(miembro.id)
        self.assertTrue(miembro.activo)

    def test_alta_miembro_email_duplicado(self):
        self.crear_miembro()
        with self.assertRaises(EmailDuplicadoError):
            self.crear_miembro("ana@example.com")

    def test_alta_miembro_email_diferente_ok(self):
        self.crear_miembro("ana@example.com")
        otro = self.crear_miembro("luis@example.com")
        self.assertEqual(otro.email, "luis@example.com")

    def test_crear_prestamo(self):
        libro = self.crear_libro()
        miembro = self.crear_miembro()
        prestamo = self.servicio.crear_prestamo(libro.id, miembro.id)
        self.assertIsNotNone(prestamo.id)
        self.assertFalse(prestamo.devuelto)
        self.assertEqual(
            prestamo.fecha_devolucion - prestamo.fecha_inicio,
            timedelta(days=BibliotecaService.DIAS_DE_PRESTAMO),
        )

    def test_crear_prestamo_libro_no_disponible(self):
        libro = self.crear_libro()
        miembro = self.crear_miembro()
        self.servicio.crear_prestamo(libro.id, miembro.id)
        with self.assertRaises(LibroNoDisponibleError):
            self.servicio.crear_prestamo(libro.id, miembro.id)

    def test_crear_prestamo_miembro_inactivo(self):
        libro = self.crear_libro()
        miembro = self.crear_miembro()
        miembro.activo = False
        self.repo_miembros.actualizar(miembro)
        with self.assertRaises(MiembroInactivoError):
            self.servicio.crear_prestamo(libro.id, miembro.id)

    def test_devolver_prestamo(self):
        libro = self.crear_libro()
        miembro = self.crear_miembro()
        prestamo = self.servicio.crear_prestamo(libro.id, miembro.id)
        devuelto = self.servicio.devolver_prestamo(prestamo.id)
        self.assertTrue(devuelto.devuelto)

    def test_devolver_prestamo_libera_libro(self):
        libro = self.crear_libro()
        miembro = self.crear_miembro()
        prestamo = self.servicio.crear_prestamo(libro.id, miembro.id)
        self.servicio.devolver_prestamo(prestamo.id)
        libro_actualizado = self.repo_libros.obtener(libro.id)
        self.assertTrue(libro_actualizado.disponible)

    def test_prestamos_vencidos(self):
        libro = self.crear_libro()
        miembro = self.crear_miembro()
        prestamo = self.servicio.crear_prestamo(libro.id, miembro.id)
        vencidos = self.servicio.prestamos_vencidos(
            hoy=prestamo.fecha_devolucion + timedelta(days=1)
        )
        self.assertEqual(len(vencidos), 1)

    def test_prestamos_no_vencidos(self):
        libro = self.crear_libro()
        miembro = self.crear_miembro()
        self.servicio.crear_prestamo(libro.id, miembro.id)
        vencidos = self.servicio.prestamos_vencidos(hoy=date.today())
        self.assertEqual(len(vencidos), 0)

    def test_resumen(self):
        self.crear_libro()
        self.crear_miembro()
        resumen = self.reportes.resumen()
        self.assertEqual(resumen["libros"], 1)
        self.assertEqual(resumen["libros_disponibles"], 1)
        self.assertEqual(resumen["libros_prestados"], 0)
        self.assertEqual(resumen["miembros_activos"], 1)
        self.assertEqual(resumen["prestamos_activos"], 0)

    def test_top_libros(self):
        libro = self.crear_libro()
        miembro = self.crear_miembro()
        prestamo = self.servicio.crear_prestamo(libro.id, miembro.id)
        self.servicio.devolver_prestamo(prestamo.id)
        top = self.reportes.top_libros()
        self.assertEqual(top[0]["titulo"], "Cien años de soledad")
        self.assertEqual(top[0]["prestamos"], 1)

    def test_top_miembros(self):
        libro = self.crear_libro()
        miembro = self.crear_miembro()
        prestamo = self.servicio.crear_prestamo(libro.id, miembro.id)
        self.servicio.devolver_prestamo(prestamo.id)
        top = self.reportes.top_miembros()
        self.assertEqual(top[0]["nombre"], "Ana")
        self.assertEqual(top[0]["prestamos"], 1)


if __name__ == "__main__":
    unittest.main()