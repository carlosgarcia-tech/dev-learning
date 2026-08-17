CREATE TABLE estudiantes (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    email TEXT,
    edad INTEGER,
    curso TEXT
);

INSERT INTO estudiantes (id, nombre, email, edad, curso) VALUES
    (1, 'Elena', 'elena@example.com', 20, 'DAW'),
    (2, 'Hugo', 'hugo@example.com', 22, 'DAM');