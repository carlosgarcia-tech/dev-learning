# TODO: Completa el ejercicio siguiendo el enunciado de README.md.
# Sustituye cada raise NotImplementedError por la implementación correcta.

from dataclasses import asdict, dataclass
from datetime import date, timedelta

from models import Libro, Miembro, Prestamo


@dataclass
class ExcepcionBiblioteca(Exception):
    mensaje: str

    def __str__(self):
        return self.mensaje


class LibroNoDisponibleError(ExcepcionBiblioteca):
    pass


class MiembroInactivoError(ExcepcionBiblioteca):
    pass


class EmailDuplicadoError(ExcepcionBiblioteca):
    pass


class EntidadNoEncontradaError(ExcepcionBiblioteca):
    pass


class BibliotecaService:
    DIAS_DE_PRESTAMO = 14

    def __init__(self, repo_libros, repo_miembros, repo_prestamos):
        self.repo_libros = repo_libros
        self.repo_miembros = repo_miembros
        self.repo_prestamos = repo_prestamos

    # ---- Libros ----

    def alta_libro(self, titulo: str, autor: str, isbn: str, anio: int, genero) -> Libro:
        # TODO: valida que titulo y autor no estén vacíos (lanza ValueError).
        # Crea el Libro y lo da de alta en el repositorio.
        raise NotImplementedError

    def buscar_libros(self, texto: str) -> list:
        # TODO: devuelve los libros cuyo título o autor contengan texto
        # (sin distinguir mayúsculas).
        raise NotImplementedError

    # ---- Miembros ----

    def alta_miembro(self, nombre: str, email: str, telefono: str) -> Miembro:
        # TODO: valida que el email no esté duplicado (lanza EmailDuplicadoError)
        # y que nombre/email no estén vacíos (ValueError). Crea el miembro.
        raise NotImplementedError

    # ---- Préstamos ----

    def crear_prestamo(self, id_libro: int, id_miembro: int) -> Prestamo:
        # TODO: comprueba que el libro existe y está disponible (si no, lanza
        # LibroNoDisponibleError) y que el miembro existe y está activo
        # (MiembroInactivoError). Crea el préstamo de DIAS_DE_PRESTAMO días,
        # marca el libro como prestado y lo guarda.
        raise NotImplementedError

    def devolver_prestamo(self, id_prestamo: int) -> Prestamo:
        # TODO: marca el préstamo como devuelto, pone la fecha de devolución
        # a hoy, devuelve el libro a disponible y guarda los cambios.
        raise NotImplementedError

    def prestamos_vencidos(self, hoy: date | None = None) -> list:
        # TODO: devuelve los préstamos activos (no devueltos) cuya
        # fecha_devolucion es anterior a hoy.
        raise NotImplementedError


class ReportesService:
    def __init__(self, biblioteca: BibliotecaService):
        self.biblioteca = biblioteca

    def resumen(self) -> dict:
        # TODO: devuelve un dict con:
        # - "libros": total de libros
        # - "libros_disponibles": libros disponibles
        # - "libros_prestados": libros no disponibles
        # - "miembros_activos": miembros activos
        # - "prestamos_activos": préstamos no devueltos
        raise NotImplementedError

    def top_libros(self, n: int = 5) -> list:
        # TODO: devuelve los n libros más prestados (por número de préstamos),
        # como lista de dicts {"titulo": ..., "prestamos": ...} ordenados
        # de mayor a menor.
        raise NotImplementedError

    def top_miembros(self, n: int = 5) -> list:
        # TODO: devuelve los n miembros más activos (por número de préstamos),
        # como lista de dicts {"nombre": ..., "prestamos": ...} ordenados
        # de mayor a menor.
        raise NotImplementedError