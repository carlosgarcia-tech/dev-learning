CREATE TABLE autores (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL
);

CREATE TABLE libros (
    id INTEGER PRIMARY KEY,
    titulo TEXT NOT NULL,
    autor_id INTEGER,
    FOREIGN KEY (autor_id) REFERENCES autores(id)
);

INSERT INTO autores (id, nombre) VALUES
    (1, 'Gabriel García'),
    (2, 'Isabel Allende'),
    (3, 'Mario Vargas');

INSERT INTO libros (id, titulo, autor_id) VALUES
    (101, 'Cien años de soledad', 1),
    (102, 'El amor en tiempos de cólera', 1),
    (103, 'La casa de los espíritus', 2),
    (104, 'Eva Luna', 2),
    (105, 'La ciudad y los perros', 3);