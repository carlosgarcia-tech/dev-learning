# TODO: Completa el ejercicio siguiendo el enunciado de README.md.
# Sustituye cada raise NotImplementedError por la implementación correcta.

import json
from pathlib import Path
from typing import Generic, TypeVar

from models import Libro, Miembro, Prestamo

T = TypeVar("T", Libro, Miembro, Prestamo)


class RepositorioJSON(Generic[T]):
    """Repositorio genérico que persiste entidades en un archivo JSON.

    - `_clave` es el nombre del campo id de la entidad (p. ej. "id").
    - `_entidad` es la clase (Libro, Miembro o Prestamo).
    - Cada entidad guardada se serializa con `asdict` y se reconstruye con la clase.
    """

    def __init__(self, ruta: Path, entidad, clave: str):
        self.ruta = ruta
        self.entidad = entidad
        self.clave = clave
        self._datos = self._cargar()

    def _cargar(self) -> list:
        # TODO: si self.ruta existe, lee el JSON con json.load y devuelve la lista.
        # Si no existe, devuelve [].
        raise NotImplementedError

    def _guardar(self) -> None:
        # TODO: escribe self._datos en self.ruta con json.dump (con indent=2).
        raise NotImplementedError

    def _nuevo_id(self) -> int:
        # TODO: devuelve el siguiente id libre (max de los ids actuales + 1, o 1 si no hay).
        raise NotImplementedError

    def crear(self, entidad) -> T:
        # TODO: asigna un id a entidad si no tiene, añádela a self._datos,
        # guarda en disco y devuelve la entidad.
        raise NotImplementedError

    def listar(self) -> list:
        # TODO: devuelve una copia de todas las entidades reconstruidas.
        raise NotImplementedError

    def obtener(self, id_entidad: int):
        # TODO: devuelve la entidad con ese id o None si no existe.
        raise NotImplementedError

    def actualizar(self, entidad) -> bool:
        # TODO: reemplaza la entidad con el mismo id en self._datos,
        # guarda en disco y devuelve True. Si el id no existe, devuelve False.
        raise NotImplementedError

    def eliminar(self, id_entidad: int) -> bool:
        # TODO: elimina la entidad con ese id, guarda y devuelve True.
        # Si no existe, devuelve False.
        raise NotImplementedError


class RepositorioLibros(RepositorioJSON):
    def __init__(self, ruta: Path):
        super().__init__(ruta, Libro, "id")


class RepositorioMiembros(RepositorioJSON):
    def __init__(self, ruta: Path):
        super().__init__(ruta, Miembro, "id")


class RepositorioPrestamos(RepositorioJSON):
    def __init__(self, ruta: Path):
        super().__init__(ruta, Prestamo, "id")