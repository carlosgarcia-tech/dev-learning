-- ============================================================
-- Datos de ejemplo — Sistema de Gestión de Biblioteca
-- ============================================================
-- Fechas fijas (deterministas): no dependen de la fecha actual.
--
-- Préstamo 1 (activo):   fecha_prestamo = '2024-07-01',
--                        fecha_limite   = '2024-07-15' (futuro, plazo de 14 días).
-- Préstamo 2 (retrasado): fecha_prestamo = '2024-06-15',
--                        fecha_limite   = '2024-07-09' (claramente pasada,
--                        multa calculable al devolver).
--
-- El stock (cantidad_disponible) lo actualizan automáticamente los
-- triggers definidos en triggers/actualizar-stock.sql.

INSERT INTO autores (nombre, biografia, nacionalidad, fecha_nacimiento) VALUES
    ('Gabriel García Márquez', 'Escritor colombiano, premio Nobel de Literatura 1982.', 'Colombia', '1927-03-06'),
    ('Isabel Allende', 'Escritora chilena de renombre internacional.', 'Chile', '1942-08-02'),
    ('Jorge Luis Borges', 'Escritor argentino, referente del cuento y el ensayo.', 'Argentina', '1899-08-24'),
    ('J.K. Rowling', 'Autora británica, creadora de la saga Harry Potter.', 'Reino Unido', '1965-07-31');

INSERT INTO usuarios (nombre, email, telefono) VALUES
    ('Lucía Fernández', 'lucia@email.com', '600111222'),
    ('Marcos Torres', 'marcos@email.com', '600333444'),
    ('Elena Castro', 'elena@email.com', '600555666');

INSERT INTO libros (titulo, isbn, anio, autor_id, genero, cantidad_total, cantidad_disponible) VALUES
    ('Cien años de soledad', '978-0307474728', 1967, 1, 'Realismo mágico', 3, 3),
    ('El amor en los tiempos del cólera', '978-0307389732', 1985, 1, 'Novela', 2, 2),
    ('La casa de los espíritus', '978-8401341577', 1982, 2, 'Novela', 2, 2),
    ('Ficciones', '978-8420633084', 1944, 3, 'Cuento', 2, 2),
    ('Harry Potter y la piedra filosofal', '978-8478884452', 1997, 4, 'Fantasía', 4, 4);

-- Préstamo activo dentro de plazo
INSERT INTO prestamos (libro_id, usuario_id, fecha_prestamo, fecha_limite, estado)
VALUES (1, 1, '2024-07-01', '2024-07-15', 'activo');

-- Préstamo retrasado (para probar el cálculo de multa)
INSERT INTO prestamos (libro_id, usuario_id, fecha_prestamo, fecha_limite, estado)
VALUES (5, 2, '2024-06-15', '2024-07-09', 'retrasado');