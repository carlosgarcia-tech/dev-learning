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

INSERT INTO autores (nombre, nacionalidad, fecha_nacimiento) VALUES
    ('Gabriel Garcia Marquez', 'Colombiana', '1927-03-06'),
    ('J.K. Rowling', 'Britanica', '1965-07-31'),
    ('George R.R. Martin', 'Estadounidense', '1948-09-20');

INSERT INTO libros (titulo, autor_id, anio, isbn, genero, cantidad) VALUES
    ('Cien anios de soledad', 1, 1967, '978-0-06-088328-7', 'Realismo magico', 5),
    ('El amor en los tiempos del colera', 1, 1985, '978-0-14-102716-4', 'Romance', 3),
    ('Harry Potter y la piedra filosofal', 2, 1997, '978-0-7475-3269-9', 'Fantasia', 10),
    ('Harry Potter y la camara secreta', 2, 1998, '978-0-7475-3849-3', 'Fantasia', 8),
    ('Juego de tronos', 3, 1996, '978-0-553-10354-0', 'Fantasia epica', 6);

INSERT INTO usuarios (nombre, email, telefono) VALUES
    ('Ana Perez', 'ana@email.com', '123456789'),
    ('Juan Garcia', 'juan@email.com', '987654321'),
    ('Maria Lopez', 'maria@email.com', '456789123');

INSERT INTO prestamos (libro_id, usuario_id, fecha_prestamo, fecha_devolucion) VALUES
    (1, 1, '2024-01-15', '2024-01-29'),
    (3, 2, '2024-01-20', NULL),
    (5, 3, '2024-01-22', '2024-02-05'),
    (2, 1, '2024-02-01', NULL);

-- Tabla adicional para el ejercicio de jerarquia recursiva
CREATE TABLE generos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    padre_id INT REFERENCES generos(id)
);

INSERT INTO generos (nombre, padre_id) VALUES
    ('Ficcion', NULL),
    ('Fantasia', 1),
    ('Fantasia epica', 2),
    ('No ficcion', NULL);
