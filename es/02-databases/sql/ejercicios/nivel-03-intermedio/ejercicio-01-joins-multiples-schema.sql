CREATE TABLE estudiantes (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL
);

CREATE TABLE cursos (
    id INTEGER PRIMARY KEY,
    titulo TEXT NOT NULL
);

CREATE TABLE matriculas (
    estudiante_id INTEGER,
    curso_id INTEGER,
    nota REAL,
    PRIMARY KEY (estudiante_id, curso_id),
    FOREIGN KEY (estudiante_id) REFERENCES estudiantes(id),
    FOREIGN KEY (curso_id) REFERENCES cursos(id)
);

INSERT INTO estudiantes (id, nombre) VALUES
    (1, 'Ana'),
    (2, 'Luis'),
    (3, 'Marta'),
    (4, 'Carlos');

INSERT INTO cursos (id, titulo) VALUES
    (10, 'SQL desde cero'),
    (11, 'Bases de datos'),
    (12, 'Programación');

INSERT INTO matriculas (estudiante_id, curso_id, nota) VALUES
    (1, 10, 8.5),
    (1, 11, 7.0),
    (2, 10, 6.5),
    (3, 11, 9.0),
    (3, 12, 8.0),
    (4, 10, 5.5);