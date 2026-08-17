CREATE TABLE departamentos (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL
);

CREATE TABLE empleados (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    dept_id INTEGER,
    FOREIGN KEY (dept_id) REFERENCES departamentos(id)
);

INSERT INTO departamentos (id, nombre) VALUES
    (1, 'Ventas'),
    (2, 'Marketing'),
    (3, 'RRHH'),
    (4, 'TI');

INSERT INTO empleados (id, nombre, dept_id) VALUES
    (1, 'Ana', 1),
    (2, 'Luis', 1),
    (3, 'Marta', 2),
    (4, 'Carlos', 4),
    (5, 'Lucia', 4),
    (6, 'Pedro', NULL);