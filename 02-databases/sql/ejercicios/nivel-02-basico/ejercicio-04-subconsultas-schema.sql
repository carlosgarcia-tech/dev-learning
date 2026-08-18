CREATE TABLE departamentos (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    ciudad TEXT
);

CREATE TABLE empleados (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    dept_id INTEGER,
    salario REAL NOT NULL,
    FOREIGN KEY (dept_id) REFERENCES departamentos(id)
);

INSERT INTO departamentos (id, nombre, ciudad) VALUES
    (1, 'Ventas', 'Madrid'),
    (2, 'Marketing', 'Barcelona'),
    (3, 'TI', 'Madrid');

INSERT INTO empleados (id, nombre, dept_id, salario) VALUES
    (1, 'Ana', 1, 2500),
    (2, 'Luis', 2, 2200),
    (3, 'Marta', 1, 2800),
    (4, 'Carlos', 3, 5000),
    (5, 'Lucia', 3, 3200),
    (6, 'Pedro', 2, 1800);