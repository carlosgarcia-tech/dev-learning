# 06 — Frameworks Web: FastAPI, Django y Flask

## Objetivos

- [ ] Entender qué es un framework web y qué resuelve frente a `http.server` puro.
- [ ] Conocer los tres frameworks principales de Python y cuándo elegir cada uno.
- [ ] Crear una API REST mínima con **FastAPI** (rutas, validación con Pydantic, documentación automática).
- [ ] Crear una aplicación web completa con **Django** (proyecto, app, modelos, admin).
- [ ] Crear una aplicación mínima con **Flask** (rutas, plantillas, JSON).
- [ ] Comparar los tres frameworks en una tabla (curva de aprendizaje, rendimiento, estructura, ecosistema).
- [ ] Aplicar buenas prácticas: entornos virtuales, `requirements.txt`, servidores de desarrollo y producción.
- [ ] Preparar la base para el [proyecto final](../ejercicios/proyectos/proyecto-final/README.md).

## Apuntes

### ¿Qué es un framework web?

Un **framework web** es una biblioteca que te da la infraestructura para construir aplicaciones y APIs HTTP sin reinventar la rueda: enrutamiento, peticiones/respuestas, serialización, validación, plantillas, seguridad y servidor de desarrollo.

En la ruta ya viste cómo crear una API con `http.server` puro (nivel 05). Eso te mostró *cómo funciona HTTP por debajo*. Un framework automatiza ese trabajo:

| Tarea | `http.server` puro | Framework web |
|---|---|---|
| Definir rutas | `if ruta == "/..."` manual | Decoradores (`@app.get`, `@app.route`) |
| Parsear el body | `json.loads` manual | Automático (Pydantic, request) |
| Validar datos | A mano | Schemas/Modelos con mensajes claros |
| Documentar la API | A mano | Swagger/OpenAPI automático (FastAPI) |
| Servidor de desarrollo | Manual | Integrado (uvicorn, runserver, flask run) |
| Seguridad | A mano | Middleware, CSRF, auth integrada |

### Entorno virtual y dependencias

Antes de usar cualquier framework, crea un entorno virtual para no contaminar el Python del sistema:

```bash
python3 -m venv .venv
source .venv/bin/activate          # Linux/macOS
# .venv\Scripts\activate           # Windows
pip install fastapi uvicorn        # o django, flask...
```

Guarda las dependencias en `requirements.txt`:

```bash
pip freeze > requirements.txt
```

> En esta máquina los paquetes (`fastapi`, `django`, `flask`) **no están instalados**. Los ejemplos son correctos pero requieren `pip install` antes de ejecutarlos.

### FastAPI — APIs modernas y validadas

**FastAPI** es un framework moderno para construir APIs REST de alto rendimiento. Está construido sobre **Starlette** (servidor web asíncrono) y **Pydantic** (validación de datos). Es la opción recomendada para APIs nuevas: sintaxis declarativa, validación automática, documentación OpenAPI/Swagger gratuita y soporte nativo de `async`/`await` (que ya aprendiste en la guía 04).

#### Instalación

```bash
pip install fastapi uvicorn
```

#### Mínima API

```python
from fastapi import FastAPI

app = FastAPI(title="Mi API")


@app.get("/")
def inicio():
    return {"mensaje": "Hola mundo"}


@app.get("/saludo/{nombre}")
def saludo(nombre: str):
    return {"mensaje": f"Hola {nombre}"}
```

Se ejecuta con:

```bash
uvicorn main:app --reload
```

- `main` = nombre del archivo (`main.py`).
- `app` = la instancia de `FastAPI()`.
- `--reload` recarga el servidor al guardar (solo desarrollo).

Abre `http://127.0.0.1:8000/docs` y verás la **documentación Swagger** generada automáticamente.

#### Parámetros y validación con Pydantic

FastAPI valida los datos automáticamente usando los type hints y modelos Pydantic:

```python
from fastapi import FastAPI, HTTPException, Query
from pydantic import BaseModel

app = FastAPI()

libros = []


class Libro(BaseModel):
    titulo: str
    autor: str
    anio: int


@app.get("/libros")
def listar_libros():
    return libros


@app.post("/libros", status_code=201)
def crear_libro(libro: Libro):
    libros.append(libro.model_dump())
    return libro.model_dump()


@app.get("/libros/{indice}")
def obtener_libro(indice: int = Query(ge=0)):
    if indice >= len(libros):
        raise HTTPException(status_code=404, detail="Libro no encontrado")
    return libros[indice]
```

Características que ves aquí:

- **`Libro(BaseModel)`** — el body se valida contra el modelo. Si falta `titulo` o `anio` no es `int`, FastAPI devuelve `422 Unprocessable Entity` con el detalle del error.
- **`status_code=201`** — define el código de respuesta de creación.
- **`HTTPException`** — manejo de errores con su código y mensaje.
- **`Query(ge=0)`** — validación de parámetros de ruta/query (mayor o igual a 0).
- **`model_dump()`** — convierte el objeto Pydantic a diccionario.

#### Operaciones CRUD con rutas

FastAPI usa métodos HTTP explícitos:

| Operación | Método | Ruta típica |
|---|---|---|
| Crear | `POST` | `/libros` |
| Listar | `GET` | `/libros` |
| Obtener uno | `GET` | `/libros/{id}` |
| Actualizar | `PUT` / `PATCH` | `/libros/{id}` |
| Eliminar | `DELETE` | `/libros/{id}` |

#### Async

Como ya sabes de la guía 04, las rutas pueden ser `async def` para I/O no bloqueante:

```python
@app.get("/tareas")
async def listar_tareas():
    # await consultar_db()   # por ejemplo
    return {"tareas": []}
```

#### Cuándo usar FastAPI

- APIs REST nuevas, desde cero.
- Necesitas validación y documentación automática.
- Quieres aprovechar `async`/`await`.
- Frontends modernos que consumen JSON (React, Vue, etc.).

### Django — el framework completo

**Django** es un framework "baterías incluidas": trae ORM, admin, autenticación, plantillas, migraciones, formularios y más. Es la opción más completa y con más estructura, ideal para aplicaciones web full-stack, CRMs, paneles de administración y proyectos a largo plazo.

#### Instalación y creación

```bash
pip install django
django-admin startproject mi_proyecto
cd mi_proyecto
python manage.py startapp libros
```

Estructura generada:

```
mi_proyecto/
├── manage.py                  # utilidad de línea de comandos
├── mi_proyecto/
│   ├── settings.py            # configuración global
│   ├── urls.py                # rutas del proyecto
│   ├── wsgi.py / asgi.py      # puntos de entrada para servidores
│   └── __init__.py
└── libros/                    # tu app
    ├── models.py              # modelos de datos (ORM)
    ├── views.py               # lógica de cada página/endpoint
    ├── urls.py                # rutas de la app (lo creas tú)
    ├── admin.py               # registro en el admin
    └── migrations/            # migraciones de la base de datos
```

Ejecuta el servidor de desarrollo:

```bash
python manage.py runserver
```

#### Modelos (ORM)

Un modelo es una clase Python que Django mapea a una tabla de la base de datos:

```python
# libros/models.py
from django.db import models


class Libro(models.Model):
    titulo = models.CharField(max_length=200)
    autor = models.CharField(max_length=100)
    anio = models.IntegerField()

    def __str__(self):
        return self.titulo
```

Cada campo (`CharField`, `IntegerField`, `DateTimeField`, `ForeignKey`...) define una columna y su validación. Después de definir modelos:

```bash
python manage.py makemigrations   # genera la migración
python manage.py migrate          # aplica los cambios a la BD
```

#### Admin automático

Registra el modelo en `admin.py` y obtienes un panel de gestión completo:

```python
# libros/admin.py
from django.contrib import admin
from .models import Libro

admin.site.register(Libro)
```

Con `python manage.py createsuperuser` y entrando a `http://127.0.0.1:8000/admin/` puedes crear, editar y eliminar libros desde el navegador, sin escribir una sola vista.

#### Vistas y URLs

En Django las rutas se declaran en `urls.py` y la lógica en `views.py`:

```python
# libros/views.py
from django.http import JsonResponse
from .models import Libro


def listar_libros(request):
    libros = Libro.objects.all().values("titulo", "autor", "anio")
    return JsonResponse(list(libros), safe=False)


def crear_libro(request):
    if request.method == "POST":
        libro = Libro.objects.create(
            titulo=request.POST["titulo"],
            autor=request.POST["autor"],
            anio=int(request.POST["anio"]),
        )
        return JsonResponse({"id": libro.id, "titulo": libro.titulo}, status=201)
    return JsonResponse({"error": "Método no permitido"}, status=405)
```

```python
# libros/urls.py
from django.urls import path
from . import views

urlpatterns = [
    path("libros/", views.listar_libros),
    path("libros/crear/", views.crear_libro),
]
```

Y se conectan al `urls.py` del proyecto:

```python
# mi_proyecto/urls.py
from django.urls import include, path

urlpatterns = [
    path("api/", include("libros.urls")),
]
```

#### Cuándo usar Django

- Aplicaciones web completas con interfaz, usuarios y admin.
- Necesitas autenticación, ORM y seguridad de serie.
- Proyectos grandes con muchos modelos relacionados.
- Paneles de administración y CRUDs empresariales.

### Flask — mínimo y flexible

**Flask** es un microframework: te da lo esencial (rutas, request/response, plantillas) y deja el resto a tu elección. Es la opción más ligera y flexible, ideal para APIs pequeñas, prototipos y microservicios donde no necesitas el peso de Django.

#### Instalación y mínima app

```bash
pip install flask
```

```python
from flask import Flask, jsonify, request

app = Flask(__name__)


@app.route("/")
def inicio():
    return jsonify(mensaje="Hola mundo")


@app.route("/saludo/<nombre>")
def saludo(nombre):
    return jsonify(mensaje=f"Hola {nombre}")
```

Ejecutar:

```bash
flask run
# o: python app.py
```

> Por convención, Flask busca la app en `app.py` o en la variable de entorno `FLASK_APP`.

#### CRUD con Flask

Flask usa `@app.route` con un decorador y el método se indica con `methods`:

```python
from flask import Flask, jsonify, request

app = Flask(__name__)

libros = []


@app.route("/libros", methods=["GET"])
def listar_libros():
    return jsonify(libros)


@app.route("/libros", methods=["POST"])
def crear_libro():
    datos = request.get_json()
    libro = {
        "titulo": datos["titulo"],
        "autor": datos["autor"],
        "anio": datos["anio"],
    }
    libros.append(libro)
    return jsonify(libro), 201


@app.route("/libros/<int:indice>", methods=["GET"])
def obtener_libro(indice):
    if indice >= len(libros):
        return jsonify(error="Libro no encontrado"), 404
    return jsonify(libros[indice])
```

Diferencias clave frente a FastAPI:

- **Validación manual**: tienes que comprobar `datos["titulo"]` tú mismo (FastAPI lo hace con Pydantic).
- **Sin documentación automática**: no genera Swagger (aunque puede añadirse con Flask-RESTX).
- **`jsonify`** convierte dicts a respuestas JSON.
- **`request.get_json()`** lee el body manualmente.

#### Plantillas (HTML)

Flask viene con el motor de plantillas **Jinja2**:

```python
from flask import Flask, render_template

app = Flask(__name__)


@app.route("/")
def inicio():
    return render_template("index.html", nombre="Ana")
```

```html
<!-- templates/index.html -->
<h1>Hola {{ nombre }}</h1>
```

#### Cuándo usar Flask

- APIs y prototipos pequeños.
- Microservicios y servicios mínimos.
- Aprender los fundamentos web sin magia.
- Proyectos donde quieres elegir cada pieza.

### Comparativa de los tres frameworks

| Aspecto | FastAPI | Django | Flask |
|---|---|---|---|
| Estilo | API-first (JSON) | Full-stack | Micro |
| Rendimiento | Muy alto (asyncio) | Medio | Medio |
| Curva de aprendizaje | Baja | Alta | Muy baja |
| Validación de datos | Automática (Pydantic) | Formularios/serializers | Manual |
| Documentación API | Swagger/OpenAPI auto | Opcional (DRF) | Manual |
| ORM | Opcional (SQLAlchemy) | Integrado | Opcional |
| Admin | No | Sí (integrado) | No |
| Plantillas | No (sirve JSON) | Sí (Django templates) | Sí (Jinja2) |
| Async | Nativo | Parcial (3.1+) | Vía extensiones |
| Estructura impuesta | Libre | Rígida (proyecto+apps) | Libre |
| Uso típico | APIs REST modernas | Web completa + admin | Prototipos, microservicios |

#### ¿Cuál elegir?

- **API pura para un frontend o móvil → FastAPI** (además es el que usa el proyecto final de esta ruta).
- **Aplicación completa con admin, usuarios y BD → Django**.
- **Algo mínimo y didáctico → Flask**.

### Buenas prácticas

1. **Entorno virtual siempre** — `python3 -m venv .venv` y actívalo antes de instalar nada.
2. **`requirements.txt`** — documenta dependencias; regenera con `pip freeze > requirements.txt`.
3. **`.gitignore`** — ignora `.venv/`, `__pycache__/`, `*.pyc` y archivos de BD (`*.sqlite3`, `db.sqlite3`).
4. **Servidor de desarrollo ≠ producción** — `uvicorn main:app`, `runserver` y `flask run` son para desarrollo. En producción se usan servidores WSGI/ASGI (gunicorn, uvicorn) detrás de un proxy.
5. **No guardes secretos en el código** — usa variables de entorno (claves, tokens, URLs de BD).
6. **Valida siempre la entrada** — FastAPI lo hace por ti; en Flask/Django, valida manualmente.

### Cómo se relaciona con el proyecto final

Esta guía te prepara para el [proyecto final](../ejercicios/proyectos/proyecto-final/README.md): un **Sistema de Gestión de Biblioteca con FastAPI**. Allí aplicarás rutas, modelos Pydantic, persistencia, manejo de errores y tests, todo lo que has practicado en esta ruta.