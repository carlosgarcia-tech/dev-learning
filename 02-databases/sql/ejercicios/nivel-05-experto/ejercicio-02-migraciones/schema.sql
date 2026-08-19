-- Estado inicial del ejercicio de migraciones.
-- En un sistema real las migraciones parten de una base vacía; aquí la única
-- tabla previa es la de control. Cada versión se registra a medida que se
-- aplica (en este dataset se pre-registran las 6 migraciones del ejercicio).

CREATE TABLE migraciones (
    id INTEGER PRIMARY KEY,
    version TEXT UNIQUE NOT NULL,
    fecha TEXT
);

INSERT INTO migraciones (version, fecha) VALUES
    ('001', '2024-01-01'),
    ('002', '2024-01-02'),
    ('003', '2024-01-03'),
    ('004', '2024-01-04'),
    ('005', '2024-01-05'),
    ('006', '2024-01-06');