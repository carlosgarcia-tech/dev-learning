CREATE TABLE autores (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    nacionalidad VARCHAR(50),
    fecha_nacimiento DATE
);

CREATE TABLE libros (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    autor_id INT NOT NULL REFERENCES autores(id) ON DELETE CASCADE,
    anio INT CHECK (anio >= 1450 AND anio <= EXTRACT(YEAR FROM CURRENT_DATE)),
    isbn VARCHAR(20) UNIQUE NOT NULL,
    genero VARCHAR(50),
    cantidad INT DEFAULT 1 CHECK (cantidad >= 0)
);

CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE prestamos (
    id SERIAL PRIMARY KEY,
    libro_id INT NOT NULL REFERENCES libros(id) ON DELETE CASCADE,
    usuario_id INT NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    fecha_prestamo TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_devolucion DATE,
    CHECK (fecha_devolucion IS NULL OR fecha_devolucion >= fecha_prestamo::DATE)
);

CREATE TABLE auditoria (
    id BIGSERIAL PRIMARY KEY,
    tabla VARCHAR(50) NOT NULL,
    operacion VARCHAR(10) NOT NULL,
    registro_id INT NOT NULL,
    datos_viejos JSONB,
    datos_nuevos JSONB,
    usuario VARCHAR(50) NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_usuarios_email ON usuarios(email);
CREATE INDEX idx_libros_isbn ON libros(isbn);
CREATE INDEX idx_prestamos_usuario_fecha ON prestamos(usuario_id, fecha_prestamo);
CREATE INDEX idx_auditoria_tabla_registro ON auditoria(tabla, registro_id);
