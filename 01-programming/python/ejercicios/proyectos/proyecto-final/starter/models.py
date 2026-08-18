from dataclasses import dataclass, field
from datetime import date
from enum import Enum
from typing import Optional


class GeneroLibro(str, Enum):
    FICCION = "ficcion"
    NO_FICCION = "no_ficcion"
    CIENCIA = "ciencia"
    TECNOLOGIA = "tecnologia"
    HISTORIA = "historia"
    OTRO = "otro"


@dataclass
class Libro:
    titulo: str
    autor: str
    isbn: str
    anio: int
    genero: GeneroLibro = GeneroLibro.OTRO
    disponible: bool = True
    id: Optional[int] = None


@dataclass
class Miembro:
    nombre: str
    email: str
    telefono: str
    activo: bool = True
    id: Optional[int] = None


@dataclass
class Prestamo:
    id_libro: int
    id_miembro: int
    fecha_inicio: date
    fecha_devolucion: date
    id: Optional[int] = None
    devuelto: bool = False