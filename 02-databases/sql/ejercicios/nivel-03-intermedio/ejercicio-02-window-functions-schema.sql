CREATE TABLE empleados (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    dept_id INTEGER,
    salario REAL NOT NULL
);

INSERT INTO empleados (id, nombre, dept_id, salario) VALUES
    (1, 'Ana', 1, 2500),
    (2, 'Luis', 1, 3000),
    (3, 'Marta', 2, 2800),
    (4, 'Carlos', 1, 3000),
    (5, 'Lucia', 2, 3200),
    (6, 'Pedro', 2, 2200);