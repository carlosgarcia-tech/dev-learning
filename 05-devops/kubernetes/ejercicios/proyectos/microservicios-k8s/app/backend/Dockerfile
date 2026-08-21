# Backend de TiendaGalaxia — imagen Python/Flask
FROM python:3.11-slim

# Evitar buffering de logs y crear un usuario sin privilegios.
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1

WORKDIR /app

# Instalar dependencias.
# psycopg2-binary permite conectar a PostgreSQL; Flask es el framework web.
RUN pip install flask==3.0.0 psycopg2-binary==2.9.9

# Copiar el código de la aplicación.
COPY server.py /app/server.py

# Crear un usuario no root por seguridad.
RUN useradd -m tienda
USER tienda

EXPOSE 5000

# healthcheck del contenedor (coherente con la livenessProbe de K8s).
HEALTHCHECK --interval=10s --timeout=5s --start-period=20s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:5000/health')" || exit 1

CMD ["python", "server.py"]
