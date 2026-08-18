# Tests del Proyecto Final

Tests de referencia para el **Sistema de Gestión de Biblioteca con FastAPI**.
Cubren la capa de servicios y repositorios usando `unittest` (stdlib), por lo
que se ejecutan **sin instalar FastAPI**.

## Cómo ejecutar

Desde esta carpeta:

```bash
python3 test_main.py
```

El runner devuelve `0` si todos los tests pasan y `1` si falla alguno.

## Qué cubren

- Alta de libros (y validación de título/autor vacíos)
- Búsqueda de libros por título y autor (insensible a mayúsculas)
- Alta de miembros (email duplicado lanza `EmailDuplicadoError`)
- Préstamos: libro disponible, miembro activo, devolución y liberación del libro
- Préstamos vencidos por fecha
- Reportes: resumen, top de libros y top de miembros

## Para validar también los endpoints

Si tienes las dependencias instaladas (`pip install -r ../starter/requirements.txt`
más `httpx`), puedes probar la API con `TestClient` de FastAPI desde `starter/`:

```python
from fastapi.testclient import TestClient
from app import app

client = TestClient(app)
resp = client.post("/libros", json={"titulo": "Dune", "autor": "F. Herbert", "isbn": "1", "anio": 1965})
assert resp.status_code == 201
```