# Starter — Sistema de Gestión de Biblioteca con FastAPI

Andamiaje mínimo para arrancar el proyecto final. Incluye:

- `models.py` — dataclasses de dominio (`Libro`, `Miembro`, `Prestamo`) y el enum `GeneroLibro`
- `repositories.py` — `RepositorioJSON` genérico con persistencia en JSON y subclases por entidad
- `services.py` — `BibliotecaService` (alta, búsqueda, préstamos, devoluciones), `ReportesService` y excepciones personalizadas
- `schemas.py` — modelos Pydantic para la API
- `app.py` — instancia de `FastAPI` con las rutas de los endpoints
- `data/` — carpeta donde se persisten los archivos JSON en ejecución

## Cómo usarlo

1. Copia esta carpeta como base de tu proyecto.
2. Instala las dependencias y arranca la API:
   ```bash
   python3 -m venv .venv
   source .venv/bin/activate
   pip install -r requirements.txt
   uvicorn app:app --reload
   ```
3. Completa los métodos con `TODO` de `repositories.py`, `services.py`, `schemas.py` y `app.py`.
4. Sigue las fases del [`README.md`](../README.md) del proyecto para implementar
   libros, miembros, préstamos y reportes.
5. Ejecuta los tests de referencia de la carpeta [`../tests/`](../tests/README.md)
   para validar tu implementación.

> El starter persiste los datos en `data/`. Para empezar limpio, borra el contenido
> de `data/` entre ejecuciones de prueba.
>
> Los tests de referencia (`tests/test_main.py`) no requieren FastAPI: validan
> servicios y repositorios con `unittest` (stdlib).