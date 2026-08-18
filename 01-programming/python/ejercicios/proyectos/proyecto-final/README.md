# Proyecto Final: Sistema de Gestión de Biblioteca con FastAPI

## Contexto

Desarrollarás una **API REST completa para la gestión de una biblioteca** utilizando **FastAPI**. El sistema permite gestionar libros, miembros y préstamos con persistencia en JSON, validaciones con Pydantic, manejo de errores con `HTTPException` y una capa de servicios testeada con `unittest`.

## Tecnologías

- **Lenguaje**: Python 3.10+
- **Framework**: FastAPI + uvicorn
- **Validación**: Pydantic (`BaseModel`)
- **Persistencia**: archivos JSON (`json` de la stdlib)
- **Modelo**: dataclasses para el dominio, schemas Pydantic para la API
- **Testing**: `unittest` (stdlib) sobre la capa de servicios y repositorio

## Requisitos Funcionales

### 1. Gestión de Libros
- [ ] `POST /libros` — alta de libro (título, autor, ISBN, año, género)
- [ ] `GET /libros` — listar todos los libros
- [ ] `GET /libros/{id}` — obtener un libro por id (404 si no existe)
- [ ] `GET /libros/buscar?q=<texto>` — buscar por título o autor (sin distinguir mayúsculas)
- [ ] `PUT /libros/{id}` — actualizar libro
- [ ] `DELETE /libros/{id}` — eliminar libro
- [ ] Validar que el título y el autor no estén vacíos

### 2. Gestión de Miembros
- [ ] `POST /miembros` — alta de miembro (nombre, email, teléfono)
- [ ] Email único (error 409 si se repite)
- [ ] `GET /miembros` — listar miembros
- [ ] `GET /miembros/{id}` — obtener un miembro por id
- [ ] `PUT /miembros/{id}` — actualizar miembro
- [ ] `PATCH /miembros/{id}/estado` — activar / desactivar miembro
- [ ] `DELETE /miembros/{id}` — eliminar miembro

### 3. Gestión de Préstamos
- [ ] `POST /prestamos` — crear préstamo (libro + miembro + fechas)
- [ ] Un libro no puede prestarse si no está disponible (error 409)
- [ ] Un miembro inactivo no puede tomar préstamos (error 400)
- [ ] `POST /prestamos/{id}/devolver` — devolver préstamo
- [ ] `GET /prestamos` — listar préstamos
- [ ] `GET /prestamos/vencidos` — listar préstamos vencidos

### 4. Reportes
- [ ] `GET /reportes/resumen` — total de libros, disponibles, prestados, miembros activos, préstamos activos
- [ ] `GET /reportes/top-libros` — top de libros más prestados
- [ ] `GET /reportes/top-miembros` — top de miembros más activos

### 5. Reglas de Negocio
- [ ] Un libro prestado no se presta de nuevo
- [ ] Solo miembros activos pueden pedir prestado
- [ ] Los préstamos vencidos se detectan comparando fechas (duración máxima por defecto: 14 días)
- [ ] El mismo email no puede repetirse entre miembros

## Estructura del Proyecto

```
proyecto-final/
├── README.md
├── starter/                        (andamiaje para arrancar)
│   ├── app.py                      (instancia FastAPI + rutas con TODO)
│   ├── models.py                   (dataclasses de dominio: Libro, Miembro, Prestamo)
│   ├── schemas.py                  (modelos Pydantic para la API)
│   ├── repositories.py             (RepositorioJSON con persistencia en disco)
│   ├── services.py                 (BibliotecaService y ReportesService)
│   ├── requirements.txt            (fastapi, uvicorn)
│   ├── data/                       (archivos JSON generados en ejecución)
│   └── README.md                   (cómo arrancar el starter)
└── tests/                          (tests de referencia sobre servicios)
```

## Fases de Desarrollo

### Fase 1: Modelos y repositorio (1 día)
- Completar las dataclasses (`Libro`, `Miembro`, `Prestamo`) en `models.py`
- Implementar `RepositorioJSON` con `json.dump` / `json.load` en `repositories.py`

### Fase 2: Servicios (1-2 días)
- Implementar `BibliotecaService`: alta, búsqueda, préstamos y devoluciones
- Implementar las excepciones personalizadas (`LibroNoDisponibleError`, `EmailDuplicadoError`, etc.)

### Fase 3: Reportes (1 día)
- Implementar `ReportesService`: resumen, top de libros y top de miembros

### Fase 4: API con FastAPI (1-2 días)
- Crear los schemas Pydantic en `schemas.py`
- Conectar las rutas de `app.py` con los servicios
- Mapear excepciones del servicio a `HTTPException` con códigos correctos

### Fase 5: Testing (1 día)
- Adaptar los tests de referencia y añadir cobertura adicional
- Probar los endpoints con `TestClient` de FastAPI (instalando `httpx`)

## Criterios de Aceptación

1. ✅ La API arranca con `uvicorn app:app --reload`
2. ✅ Se pueden dar de alta libros, miembros y préstamos
3. ✅ Un libro prestado no puede prestarse de nuevo (409)
4. ✅ Un miembro inactivo no puede pedir prestado (400)
5. ✅ Los datos persisten en JSON entre ejecuciones
6. ✅ Los reportes devuelven resultados correctos
7. ✅ Las validaciones devuelven códigos HTTP adecuados (400, 404, 409)
8. ✅ `python3 test_main.py` en `tests/` pasa sin errores
9. ✅ La documentación Swagger está disponible en `/docs`

## Rúbrica de Evaluación

| Criterio | Peso | Descripción |
|----------|------|-------------|
| Funcionalidad | 30% | Todos los endpoints funcionan correctamente |
| Código | 20% | Código limpio, organizado y comentado |
| Validación | 15% | Schemas Pydantic y códigos HTTP correctos |
| Servicios | 15% | Lógica de negocio separada y testeable |
| Tests | 10% | Cobertura de servicios y endpoints |
| Buenas prácticas | 10% | Repositorio, excepciones, `requirements.txt`, `.gitignore` |

## Cómo ejecutar

### Arrancar la API (requiere instalar dependencias)

Desde `starter/`:

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
uvicorn app:app --reload
```

Documentación interactiva en `http://127.0.0.1:8000/docs`.

### Ejecutar los tests de referencia (sin dependencias externas)

Desde `tests/`:

```bash
python3 test_main.py
```

> Los tests de referencia validan los servicios y el repositorio con `unittest` (stdlib), por lo que se ejecutan sin instalar FastAPI. Para probar los endpoints necesitas las dependencias y `httpx` (`pip install httpx`), usando `from fastapi.testclient import TestClient`.

## Recursos

- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [Pydantic Documentation](https://docs.pydantic.dev/)
- [uvicorn](https://www.uvicorn.org/)
- [Documentación de json (stdlib)](https://docs.python.org/3/library/json.html)
- [unittest (stdlib)](https://docs.python.org/3/library/unittest.html)