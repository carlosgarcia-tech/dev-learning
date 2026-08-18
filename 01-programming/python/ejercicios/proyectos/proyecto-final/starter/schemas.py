# TODO: Completa el ejercicio siguiendo el enunciado de README.md.
#
# NOTA: este archivo usa Pydantic (dependencia de FastAPI). Instala las
# dependencias desde requirements.txt antes de usar la API:
#   pip install -r requirements.txt

from datetime import date
from typing import Literal, Optional

from pydantic import BaseModel, EmailStr, Field

from models import GeneroLibro


class LibroCreate(BaseModel):
    # TODO: define los campos que acepta POST /libros:
    # titulo (str, mínimo 1 carácter), autor (str, mínimo 1),
    # isbn (str), anio (int >= 0) y genero (GeneroLibro con default OTRO).
    raise NotImplementedError


class LibroUpdate(BaseModel):
    # TODO: define los campos opcionales para PUT /libros/{id}
    # (misma forma que LibroCreate pero todos opcionales).
    raise NotImplementedError


class LibroOut(BaseModel):
    # TODO: define la respuesta de un libro: id, titulo, autor, isbn, anio,
    # genero y disponible. Activa el modo config de Pydantic v2:
    # model_config = {"from_attributes": True}
    raise NotImplementedError


class MiembroCreate(BaseModel):
    nombre: str = Field(min_length=1)
    email: EmailStr
    telefono: str = ""


class MiembroOut(BaseModel):
    id: int
    nombre: str
    email: str
    telefono: str
    activo: bool

    model_config = {"from_attributes": True}


class EstadoMiembro(BaseModel):
    activo: bool


class PrestamoCreate(BaseModel):
    id_libro: int
    id_miembro: int


class PrestamoOut(BaseModel):
    id: int
    id_libro: int
    id_miembro: int
    fecha_inicio: date
    fecha_devolucion: date
    devuelto: bool

    model_config = {"from_attributes": True}