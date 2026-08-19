-- ============================================================
-- Sistema de Gestión de Biblioteca — Esquema (SQLite)
-- ============================================================

-- SQLite solo aplica claves foráneas si la pragma está activa en
-- la conexión que ejecuta los scripts.
PRAGMA foreign_keys = ON;

DROP VIEW IF EXISTS vista_disponibilidad_genero;
DROP TABLE IF EXISTS auditoria_prestamos;
DROP TABLE IF EXISTS prestamos;
DROP TABLE IF EXISTS libros;
DROP TABLE IF EXISTS autores;
DROP TABLE IF EXISTS usuarios;

-- Autores
CREATE TABLE autores (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    biografia TEXT,
    nacionalidad TEXT,
    fecha_nacimiento TEXT
);

-- Usuarios de la biblioteca
CREATE TABLE usuarios (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    telefono TEXT,
    fecha_registro TEXT DEFAULT '2024-07-10 10:00:00'
);

-- Libros
CREATE TABLE libros (
    id INTEGER PRIMARY KEY,
    titulo TEXT NOT NULL,
    isbn TEXT UNIQUE NOT NULL,
    anio INT CHECK (anio > 0),
    autor_id INT REFERENCES autores(id),
    genero TEXT,
    cantidad_total INT NOT NULL DEFAULT 1 CHECK (cantidad_total >= 0),
    cantidad_disponible INT NOT NULL DEFAULT 1 CHECK (cantidad_disponible >= 0)
);

-- Préstamos
CREATE TABLE prestamos (
    id INTEGER PRIMARY KEY,
    libro_id INT NOT NULL REFERENCES libros(id),
    usuario_id INT NOT NULL REFERENCES usuarios(id),
    fecha_prestamo TEXT NOT NULL DEFAULT '2024-07-01',
    fecha_limite TEXT NOT NULL,
    fecha_devolucion TEXT,
    multa REAL DEFAULT 0 CHECK (multa >= 0),
    estado TEXT DEFAULT 'activo' CHECK (estado IN ('activo', 'devuelto', 'retrasado'))
);

-- Auditoría de préstamos
CREATE TABLE auditoria_prestamos (
    id INTEGER PRIMARY KEY,
    prestamo_id INT,
    accion TEXT,
    datos TEXT,
    fecha TEXT DEFAULT '2024-07-10 10:00:00'
);

-- Índices
CREATE INDEX idx_libros_titulo ON libros(titulo);
CREATE INDEX idx_libros_autor ON libros(autor_id);
CREATE INDEX idx_libros_genero ON libros(genero);
CREATE INDEX idx_prestamos_usuario ON prestamos(usuario_id);
CREATE INDEX idx_prestamos_estado ON prestamos(estado);
CREATE UNIQUE INDEX idx_usuarios_email ON usuarios(email);

-- Vista de disponibilidad por género
DROP VIEW IF EXISTS vista_disponibilidad_genero;
CREATE VIEW vista_disponibilidad_genero AS
SELECT
    genero,
    COUNT(*) AS total_titulos,
    SUM(cantidad_total) AS ejemplares_totales,
    SUM(cantidad_disponible) AS ejemplares_disponibles
FROM libros
GROUP BY genero;