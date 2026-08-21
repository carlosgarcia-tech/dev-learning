"""
Backend de TiendaGalaxia — API de productos en Python/Flask.

Endpoints:
  GET  /health          -> health check (liveness)
  GET  /ready           -> readiness check (verifica conexión a la BD)
  GET  /api/productos   -> lista de productos (desde BD o catálogo por defecto)

Variables de entorno esperadas (inyectadas por ConfigMap/Secret):
  BACKEND_HOST, BACKEND_PORT, FLASK_ENV,
  POSTGRES_HOST, POSTGRES_PORT, POSTGRES_DB, POSTGRES_USER, POSTGRES_PASSWORD
"""

import os
import time
import logging

from flask import Flask, jsonify

# Intentamos importar psycopg2; si no está disponible, el backend usa un catálogo en memoria.
try:
    import psycopg2  # type: ignore
    HAS_PSICOPG2 = True
except ImportError:  # pragma: no cover
    HAS_PSICOPG2 = False


# --------------------------------------------------------------------------- #
# Configuración
# --------------------------------------------------------------------------- #
HOST = os.getenv("BACKEND_HOST", "0.0.0.0")
PORT = int(os.getenv("BACKEND_PORT", "5000"))
ENV = os.getenv("FLASK_ENV", "production")

DB_HOST = os.getenv("POSTGRES_HOST", "postgres")
DB_PORT = os.getenv("POSTGRES_PORT", "5432")
DB_NAME = os.getenv("POSTGRES_DB", "tienda")
DB_USER = os.getenv("POSTGRES_USER", "tienda")
DB_PASSWORD = os.getenv("POSTGRES_PASSWORD", "tienda")

# Catálogo por defecto (se usa si no hay BD disponible, para que la app funcione siempre).
CATALOGO = [
    {"id": 1, "nombre": "Auriculares Galaxia",  "precio": 49.99, "stock": 25},
    {"id": 2, "nombre": "Teclado Nebula",         "precio": 29.99, "stock": 40},
    {"id": 3, "nombre": "Ratón Estelar",          "precio": 19.99, "stock": 60},
    {"id": 4, "nombre": "Monitor Cósmico 27\"",   "precio": 199.99, "stock": 10},
    {"id": 5, "nombre": "Webcam Orbita",          "precio": 39.99, "stock": 30},
]

app = Flask(__name__)
log = logging.getLogger("tienda.backend")
logging.basicConfig(level=logging.INFO, format="%(asctime)s [%(levelname)s] %(message)s")

# Estado de conexión a la BD (se comprueba en /ready).
_db_ok = False


def _db_conn_str() -> str:
    return (
        f"host={DB_HOST} port={DB_PORT} dbname={DB_NAME} "
        f"user={DB_USER} password={DB_PASSWORD}"
    )


def _probar_bd() -> bool:
    """Intenta conectar a PostgreSQL; devuelve True si tuvo éxito."""
    global _db_ok
    if not HAS_PSICOPG2:
        _db_ok = False
        return False
    try:
        conn = psycopg2.connect(_db_conn_str(), connect_timeout=3)
        conn.close()
        _db_ok = True
        return True
    except Exception as exc:  # noqa: BLE001
        log.warning("No se pudo conectar a la BD: %s", exc)
        _db_ok = False
        return False


def _obtener_productos() -> list:
    """Devuelve los productos desde la BD si está disponible; si no, del catálogo por defecto."""
    if not HAS_PSICOPG2 or not _probar_bd():
        return CATALOGO
    try:
        conn = psycopg2.connect(_db_conn_str(), connect_timeout=3)
        cur = conn.cursor()
        # Si existe la tabla, la usamos; si no, creamos y llenamos.
        cur.execute(
            "CREATE TABLE IF NOT EXISTS productos ("
            "  id SERIAL PRIMARY KEY, nombre TEXT, precio NUMERIC, stock INTEGER"
            ")"
        )
        cur.execute("SELECT COUNT(*) FROM productos")
        # Tabla vacía: la llenamos con el catálogo por defecto.
        if cur.fetchone()[0] == 0:
            for p in CATALOGO:
                cur.execute(
                    "INSERT INTO productos (id, nombre, precio, stock) "
                    "VALUES (%s, %s, %s, %s)",
                    (p["id"], p["nombre"], p["precio"], p["stock"]),
                )
        cur.execute("SELECT id, nombre, precio, stock FROM productos ORDER BY id")
        filas = cur.fetchall()
        conn.commit()
        cur.close()
        conn.close()
        return [
            {"id": f[0], "nombre": f[1], "precio": float(f[2]), "stock": f[3]}
            for f in filas
        ]
    except Exception as exc:  # noqa: BLE001
        log.warning("Error leyendo la BD, uso catálogo por defecto: %s", exc)
        return CATALOGO


# --------------------------------------------------------------------------- #
# Rutas
# --------------------------------------------------------------------------- #
@app.route("/health", methods=["GET"])
def health():
    """Liveness probe: la app responde."""
    return jsonify({"status": "ok", "component": "backend"}), 200


@app.route("/ready", methods=["GET"])
def ready():
    """Readiness probe: intenta verificar la BD (pero no falla si no hay driver)."""
    _probar_bd()
    # Está listo aunque no haya BD (usa catálogo por defecto); reporta el estado.
    return jsonify({"status": "ready", "db": _db_ok, "psycopg2": HAS_PSICOPG2}), 200


@app.route("/api/productos", methods=["GET"])
def productos():
    """Endpoint principal de la API: lista de productos."""
    productos = _obtener_productos()
    return jsonify({"productos": productos, "count": len(productos)}), 200


@app.route("/", methods=["GET"])
def root():
    """Redirección amigable."""
    return jsonify({
        "app": "TiendaGalaxia Backend",
        "endpoints": ["/health", "/ready", "/api/productos"],
    }), 200


if __name__ == "__main__":
    log.info("Arrancando TiendaGalaxia Backend en %s:%s (env=%s)", HOST, PORT, ENV)
    # Comprobación inicial de la BD (sin bloquear el arranque).
    _probar_bd()
    # Flask en modo producción.
    app.run(host=HOST, port=PORT)
