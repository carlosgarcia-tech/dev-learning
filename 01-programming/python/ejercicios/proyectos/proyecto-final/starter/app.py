# TODO: Completa el ejercicio siguiendo el enunciado de README.md.
#
# NOTA: este archivo usa FastAPI y Pydantic. Instala las dependencias desde
# requirements.txt antes de ejecutar la API:
#   pip install -r requirements.txt
#   uvicorn app:app --reload

from pathlib import Path

from fastapi import FastAPI, HTTPException

from models import GeneroLibro, Libro, Miembro, Prestamo
from repositories import RepositorioLibros, RepositorioMiembros, RepositorioPrestamos
from schemas import (
    EstadoMiembro,
    LibroCreate,
    LibroOut,
    LibroUpdate,
    MiembroCreate,
    MiembroOut,
    PrestamoCreate,
    PrestamoOut,
)
from services import (
    BibliotecaService,
    EmailDuplicadoError,
    EntidadNoEncontradaError,
    LibroNoDisponibleError,
    MiembroInactivoError,
    ReportesService,
)

DATA_DIR = Path(__file__).parent / "data"
DATA_DIR.mkdir(exist_ok=True)

repo_libros = RepositorioLibros(DATA_DIR / "libros.json")
repo_miembros = RepositorioMiembros(DATA_DIR / "miembros.json")
repo_prestamos = RepositorioPrestamos(DATA_DIR / "prestamos.json")

biblioteca = BibliotecaService(repo_libros, repo_miembros, repo_prestamos)
reportes = ReportesService(biblioteca)

app = FastAPI(title="Sistema de Gestión de Biblioteca", version="1.0.0")


# ---- Libros ----

@app.get("/libros", response_model=list[LibroOut])
def listar_libros():
    # TODO: devuelve biblioteca.repo_libros.listar()
    raise NotImplementedError


@app.post("/libros", response_model=LibroOut, status_code=201)
def crear_libro(libro: LibroCreate):
    # TODO: usa biblioteca.alta_libro(...) y devuelve el resultado.
    # Si los datos no son válidos, FastAPI devuelve 422 automáticamente.
    raise NotImplementedError


@app.get("/libros/{id_libro}", response_model=LibroOut)
def obtener_libro(id_libro: int):
    # TODO: obtén el libro por id; si no existe, lanza
    # HTTPException(status_code=404, detail="Libro no encontrado")
    raise NotImplementedError


@app.get("/libros/buscar")
def buscar_libros(q: str):
    # TODO: devuelve biblioteca.buscar_libros(q)
    raise NotImplementedError


@app.put("/libros/{id_libro}", response_model=LibroOut)
def actualizar_libro(id_libro: int, cambios: LibroUpdate):
    # TODO: obtén el libro, aplica los cambios no nulos y guárdalo con
    # repo_libros.actualizar(...). 404 si no existe.
    raise NotImplementedError


@app.delete("/libros/{id_libro}", status_code=204)
def eliminar_libro(id_libro: int):
    # TODO: borra el libro con repo_libros.eliminar(id). Si devuelve False,
    # lanza HTTPException(404).
    raise NotImplementedError


# ---- Miembros ----

@app.get("/miembros", response_model=list[MiembroOut])
def listar_miembros():
    # TODO: devuelve biblioteca.repo_miembros.listar()
    raise NotImplementedError


@app.post("/miembros", response_model=MiembroOut, status_code=201)
def crear_miembro(miembro: MiembroCreate):
    # TODO: usa biblioteca.alta_miembro(...). Captura EmailDuplicadoError y
    # devuelve HTTPException(status_code=409, detail=str(e)).
    raise NotImplementedError


@app.get("/miembros/{id_miembro}", response_model=MiembroOut)
def obtener_miembro(id_miembro: int):
    # TODO: obtén el miembro por id; 404 si no existe.
    raise NotImplementedError


@app.patch("/miembros/{id_miembro}/estado", response_model=MiembroOut)
def cambiar_estado(id_miembro: int, estado: EstadoMiembro):
    # TODO: cambia el campo activo del miembro y guárdalo. 404 si no existe.
    raise NotImplementedError


@app.delete("/miembros/{id_miembro}", status_code=204)
def eliminar_miembro(id_miembro: int):
    # TODO: borra el miembro. 404 si no existe.
    raise NotImplementedError


# ---- Préstamos ----

@app.post("/prestamos", response_model=PrestamoOut, status_code=201)
def crear_prestamo(prestamo: PrestamoCreate):
    # TODO: usa biblioteca.crear_prestamo(id_libro, id_miembro). Captura
    # LibroNoDisponibleError (409), MiembroInactivoError (400) y
    # EntidadNoEncontradaError (404).
    raise NotImplementedError


@app.get("/prestamos", response_model=list[PrestamoOut])
def listar_prestamos():
    # TODO: devuelve biblioteca.repo_prestamos.listar()
    raise NotImplementedError


@app.get("/prestamos/vencidos", response_model=list[PrestamoOut])
def prestamos_vencidos():
    # TODO: devuelve biblioteca.prestamos_vencidos()
    raise NotImplementedError


@app.post("/prestamos/{id_prestamo}/devolver", response_model=PrestamoOut)
def devolver_prestamo(id_prestamo: int):
    # TODO: usa biblioteca.devolver_prestamo(id_prestamo). 404 si no existe.
    raise NotImplementedError


# ---- Reportes ----

@app.get("/reportes/resumen")
def resumen():
    # TODO: devuelve reportes.resumen()
    raise NotImplementedError


@app.get("/reportes/top-libros")
def top_libros(n: int = 5):
    # TODO: devuelve reportes.top_libros(n)
    raise NotImplementedError


@app.get("/reportes/top-miembros")
def top_miembros(n: int = 5):
    # TODO: devuelve reportes.top_miembros(n)
    raise NotImplementedError